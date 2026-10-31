#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package simulator

/* File containing
 *  - dll loading for firmware simulation
 *  - thread code for firmware simulation
 *
 * Created on: 31 oct. 2026
 *   Author: victor
 */

import "core:os"
import "core:log"
import "core:mem"
import "core:time"
import "core:dynlib"
import "core:thread"
import "core:reflect"
import "core:strings"
import "core:sync/chan"
import "core:mem/virtual"

import spall "spall_wrapper"
import platform "sim_platform"
import peripherals "sim_peripherals"

import mcu "mcu:stm32h723xx"
import "../usim"

Write_Detect_Thread_Data :: struct {
  memory: ^peripherals.Memory,
  simArray: [^]peripherals.Sim_Data,
  should_quit: b32,
}

/* thread data for a single board, global_should_quit is readonly */
Board_Thread_Data :: struct {
  memory: ^peripherals.Memory,
  global_should_quit: ^bool,
  max_iterations: int,
  step_time: time.Duration,
  wd_thread_should_quit: ^b32,
  wd_thread: ^thread.Thread,
}

FW_Thread_Data :: struct {
  wd: Write_Detect_Thread_Data,
  board: Board_Thread_Data,
}

/* --------------------------------------------- */

/*
Params:
 - `dllpath`: dynamic library file path with extension
*/
load_board_api :: proc(dllpath: string) -> peripherals.Board_API
{
  board_api: peripherals.Board_API
  did_load: bool
  board_api.library, did_load = dynlib.load_library(dllpath)
  if !did_load {
    log.errorf("Could not load library from %s: %v",
      dllpath, dynlib.last_error())
    os.exit(1)
  }

  load_symbol_or_err(board_api.library, dllpath, "Board_init", cast(^rawptr)&board_api.init)
  load_symbol_or_err(board_api.library, dllpath, "Board_update", cast(^rawptr)&board_api.update)

  log.infof("loaded symbols correctly from %s", dllpath)
  return board_api
}

/* --------------------------------------------- */

gather_memory_info :: proc(memory: ^peripherals.Memory)
{
  totalPageCount: u32 = 0

  types := reflect.struct_field_types(mcu.Raw_Memory)
  for type_info in types {
    ptr := type_info.variant.(reflect.Type_Info_Pointer)
    ptr_type := ptr.elem

    pageCount := (u32(ptr_type.size - 1) / u32(mem.PAGE_SIZE)) + 1
    totalPageCount += pageCount
  }

  memory.pageCount = uint(totalPageCount)
  memory.totalMem = uint(int(totalPageCount) * mem.PAGE_SIZE)
}

init_memory :: #force_inline proc(memory: ^peripherals.Memory)
{
  gather_memory_info(memory)
  memory.base = platform.init_memory(memory.totalMem)
  memory.writeWatchRequestMem = make([]rawptr,
    memory.pageCount * peripherals.PLATFORM_REQ_MULTIPLIER,
    memory.arena_allocator,
  )
}

destroy_memory :: proc(memory: ^peripherals.Memory)
{
  platform.destroy_memory(memory.base)
  // virtual.arena_destroy() also deallocates everything that was allocated with it
  arena := memory.arena
  virtual.arena_destroy(&arena)
}

/* --------------------------------------------- */

create_board :: proc(dllpath: string, channels: []chan.Chan(usim.Event, .Both), start_tick: time.Tick) -> ^peripherals.Memory
{
  // setup allocator for peripheral internal memory.
  // 1 GB reserved but not committed size (virtual memory)
  // 1 MB committed size ('physical' memory)
  arena: virtual.Arena
  err := virtual.arena_init_static(&arena)
  if err != nil {
    log.error("Could not allocate virtual arena for board memory")
    os.exit(1)
  }

  memory, _ := virtual.new(&arena, peripherals.Memory)
  memory.arena = arena
  memory.arena_allocator = virtual.arena_allocator(&memory.arena)
  memory.arena_base = memory.arena.curr_block.base

  memory.odin_ctx = context

  init_memory(memory)
  memory.board_api = load_board_api(dllpath)
  memory.board_name = strings.clone_to_cstring(os.short_stem(dllpath))

  simArrayConst := peripherals.SimArray
  memory.simArray = make([]peripherals.Sim_Data, len(simArrayConst))

  // setup peripherals
  types := reflect.struct_field_types(mcu.Raw_Memory)
  mem_current := memory.base
  for type_info, idx in types {
    ptr := type_info.variant.(reflect.Type_Info_Pointer)
    ptr_type := ptr.elem

    pageCount := (u32(ptr_type.size - 1) / u32(mem.PAGE_SIZE)) + 1

    memory.base_addresses[idx] = mem_current
    mem_current = rawptr(uintptr(mem_current) + uintptr(pageCount * u32(mem.PAGE_SIZE)))

    memory.simArray[idx] = simArrayConst[idx]

    if memory.simArray[idx].setup != peripherals.Stub_setup {
      memory.simArray[idx].this_ctx = memory.simArray[idx].setup(memory)
    }

    for pageIdx: u32 = 0; pageIdx < pageCount; pageIdx += 1 {
      append(&memory.handlers, memory.simArray[idx].handler)
      append(&memory.peripheral_contexts, memory.simArray[idx].this_ctx)
    }
  }

  // setup event queue channels
  memory.channels = make([]chan.Chan(usim.Event, .Send), len(channels))
  for c, idx in channels {
    memory.channels[idx] = chan.as_send(c)
  }
  reserve(&memory.subscribed_events, usim.Event_Kind.Count)
  reserve(&memory.event_watch, usim.Event_Kind.Count)

  memory.start_tick = start_tick

  return memory
}

destroy_board :: proc(memory: ^peripherals.Memory)
{
  dynlib.unload_library(memory.board_api.library)

  delete(memory.board_name)
  delete(memory.channels)
  // delete dynamically created USim_Event_Watch_Data slices
  for _, value in memory.event_watch {
    delete(value)
  }
  delete(memory.event_watch)
  delete(memory.subscribed_events)

  /* NOTE: This has to be last because `memory` is part of the arena */
  destroy_memory(memory)
}

/* --------------------------------------------- */

write_detect_thread_proc :: proc(rawdata: rawptr)
{
  data := cast(^Write_Detect_Thread_Data)rawdata
  memory := data.memory

  if !spall.init_thread() {
    log.errorf("Could not init profiling in %s", #procedure)
    os.exit(1)
  }
  defer spall.deinit_thread()

  ITERATION_TIME :: 40*time.Microsecond

  for spall_it := 0;; spall_it = (spall_it + 1) % 1024 {
    dont_skip_spall := spall_it == 0
    start_tick := time.tick_now()

    if data.should_quit {
      break
    }

    pageCount: uint = memory.pageCount
    ok := platform.get_written_pages(
      memory.base,
      &memory.writeWatchRequestMem[0],
      &pageCount,
      memory.totalMem,
    )

    if !ok {
      continue
    }

    if pageCount > 0 {
      if dont_skip_spall {
        spall._buffer_begin("Peripheral handle page writes")
      }

      for idx: uint = 0; idx < pageCount; idx += 1 {
        pageAddr: rawptr = memory.writeWatchRequestMem[idx]
        pageOffset := uintptr(pageAddr) - uintptr(memory.base)
        // NOTE: This will get optimized to a right shift
        pageIdx := u32(pageOffset) / u32(mem.PAGE_SIZE)

        memory.handlers[pageIdx](memory, data.simArray[pageIdx].this_ctx)
      }

      if dont_skip_spall {
        spall._buffer_end() // "Peripheral handle page writes"
      }
    }

    diff := time.tick_diff(start_tick, time.tick_now())
    if diff < ITERATION_TIME {
      time.sleep(ITERATION_TIME - diff)
    }
  }
}

/* thread procedure for a single board */
board_thread_proc :: proc(rawdata: rawptr)
{
  data := cast(^Board_Thread_Data)rawdata
  memory := data.memory

  if !spall.init_thread() {
    log.errorf("Could not init profiling in %s", #procedure)
    os.exit(1)
  }
  defer spall.deinit_thread()

  memory.board_api.init(memory)

  /* step easy version:
  * the stepping is done by calling update() on the simulated board
  */

  ITERATION_TIME :: 20*time.Microsecond

  it := 0
  for spall_it := 0;; spall_it = (spall_it + 1) % 1024 {
    dont_skip_spall := spall_it == 0
    start_tick := time.tick_now()

    if dont_skip_spall {
      spall._buffer_begin("Peripheral update")
    }

    for periph in memory.simArray {
      if periph.step != peripherals.Stub_step {
        //fmt.printfln("Peripheral %v step", periph)
        periph.step(memory, periph.this_ctx, data.step_time)
      }
    }

    if dont_skip_spall {
      spall._buffer_end() // "Peripheral update"
      spall._buffer_begin("Board iteration")
    }

    memory.board_api.update()

    if dont_skip_spall {
      spall._buffer_end() // "Board iteration"
    }

    it += 1
    if (data.max_iterations != 0) && (it > data.max_iterations) {
      break
    }
    if data.global_should_quit^ {
      // core simulator wants to quit for whatever reason
      break
    }

    time.sleep(10*time.Microsecond)
    diff := time.tick_diff(start_tick, time.tick_now())
    if diff < ITERATION_TIME {
      time.sleep(ITERATION_TIME - diff)
    }
  }

  // wait until wd_thread quits 'voluntarily'
  data.wd_thread_should_quit^ = true
  thread.join(data.wd_thread)
}

/* --------------------------------------------- */

/* Launch simulation on the already initialized board `memory.board_api`
 * global_should_quit is readonly
 */
launch_board :: proc(thread_data_backing: ^FW_Thread_Data, memory: ^peripherals.Memory, global_should_quit: ^bool, max_iterations: int, step_time: time.Duration) -> (board_thread: ^thread.Thread)
{
  td := thread_data_backing
  td.wd = Write_Detect_Thread_Data {
    memory = memory,
    simArray = &memory.simArray[0],
  }

  td.board = Board_Thread_Data {
    memory = memory,
    global_should_quit = global_should_quit,
    max_iterations = max_iterations,
    step_time = step_time,
  }

  td.board.wd_thread_should_quit = &td.wd.should_quit
  td.board.wd_thread = thread.create_and_start_with_data(
    &td.wd,
    write_detect_thread_proc,
    context,
  )

  board_thread = thread.create_and_start_with_data(
    &td.board,
    board_thread_proc,
    context,
  )

  return
}
