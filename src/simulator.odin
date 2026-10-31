#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package simulator

/* File containing main program for simulator
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

import "base:runtime"

import "core:os"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:time"
import "core:sync"
import "core:thread"
import "core:dynlib"
import "core:sync/chan"
import "core:c/libc"

import custom_log "logger"
import spall "spall_wrapper"
import platform "sim_platform"
import peripherals "sim_peripherals"

import mcu "mcu:stm32h723xx"
import "../usim"

SIMULATOR_VERSION_MAJOR :: "0"
SIMULATOR_VERSION_MINOR :: "0"
SIMULATOR_VERSION_PATCH :: "0"
SIMULATOR_VERSION :: SIMULATOR_VERSION_MAJOR + "." + SIMULATOR_VERSION_MINOR + "." + SIMULATOR_VERSION_PATCH

EXPECTED_PAGE_SIZE :: 4096

/* --------------------------------------------- */

load_symbol_or_err :: proc(lib: dynlib.Library, dllpath, symbol: string, fn: ^rawptr)
{
  ptr, found := dynlib.symbol_address(lib, symbol)
  if !found {
    log.errorf("Could not load symbol '%s' from %s: %v",
      symbol, dllpath, dynlib.last_error())
    os.exit(1)
  }
  fn^ = ptr
}

/* --------------------------------------------- */

global_should_quit: bool
usim_threads: []^thread.Thread
fw_threads: []^thread.Thread

sim_signal_handler :: proc "contextless"()
{
  libc.printf("recieved signal, closing simulator...\n")
  context = runtime.default_context()

  // we wait for fw threads first because they will likely exit before usim threads

  global_should_quit = true
  // wait until fw_threads quit 'voluntarily'
  thread.join_multiple(..fw_threads[:])
  // wait until usim threads quit 'voluntarily'
  thread.join_multiple(..usim_threads[:])
}

/* --------------------------------------------- */

main :: proc()
{
  platform.setup_signal_handler(sim_signal_handler)

  opt := cmdline_parse()
  defer cmdline_destroy(&opt)

  if !spall.init("trace.spall") {
    fmt.eprint("Could not init profiling")
    os.exit(1)
  }
  defer {
    spall.deinit_thread()
    spall.deinit()
  }

  spall._buffer_begin("Startup")

  context.logger = custom_log.create_logger(opt = {.Level, .Time, .Terminal_Color})
  defer custom_log.destroy_logger(context.logger)

  arena: mem.Dynamic_Arena
  mem.dynamic_arena_init(&arena)
  defer mem.dynamic_arena_destroy(&arena)
  arena_allocator := mem.dynamic_arena_allocator(&arena)

  /* --------------------------------------------- */

  memories := make([]^peripherals.Memory, len(opt.board), arena_allocator)
  channels := make([]chan.Chan(usim.Event, .Both), len(opt.usim), arena_allocator)
  defer {
    for m in memories {
      destroy_board(m)
    }
    for c in channels {
      chan.destroy(c)
    }
  }
  usims := make([]USim_Thread_Data, len(opt.usim), arena_allocator)
  usim_threads = make([]^thread.Thread, len(opt.usim), arena_allocator)

  fw_thread_data := make([]FW_Thread_Data, len(opt.board), arena_allocator)
  fw_threads = make([]^thread.Thread, len(opt.board), arena_allocator)

  stepwise_barrier: sync.Barrier
  // TODO: When stepwise usims are done, this must be len(fw_threads) + opt.stepwise_usim_count
  sync.barrier_init(&stepwise_barrier, len(fw_threads))

  /* --------------------------------------------- */

  for idx := 0; idx < len(channels); idx += 1 {
    chan_err: runtime.Allocator_Error
    channels[idx], chan_err = chan.create_buffered(
      chan.Chan(usim.Event, .Both),
      usim.QUEUE_MAX_SIZE,
      context.allocator,
    )
    if chan_err != nil {
      log.errorf("Could not create event queue channel: %v", chan_err)
      os.exit(1)
    }
  }

  start_tick := time.tick_now()
  for board, board_idx in opt.board {
    memories[board_idx] = create_board(board, channels, start_tick)
  }

  // TODO: This initialization probably should be in simulator_usim_threads.odin...
  for u, usim_idx in opt.usim {
    td := &usims[usim_idx]
    td^ = {
      board_names = u.attached_boards,
      usim_dll = u.dll,
      global_should_quit = &global_should_quit,
      usim_id = usim.Id(usim_idx),
    }
    td.channel = chan.as_recv(channels[usim_idx]).impl

    td.attached_memories = make([]^peripherals.Memory, len(u.attached_boards))
    for attached, mem_idx in u.attached_boards {
      board_name := string(attached)
      found := false
      for board, board_idx in opt.board {
        if os.short_stem(board) == board_name {
          td.attached_memories[mem_idx] = memories[board_idx]
          found = true
        }
      }

      if !found {
        log.errorf("board %s requested by usim %s was not found in board array", attached, u.dll)
        os.exit(1)
      }
    }

    usim_threads[usim_idx] = launch_usim(td)
  }

  defer {
    for u in usims {
      delete(u.attached_memories)
    }
  }

  log.infof("Total page count: %v", memories[0].pageCount * len(opt.board))
  log.infof("Total page size: %v", memories[0].totalMem * len(opt.board))
  log.infof("Peripheral count for each board: %v", mcu.PERIPHERAL_COUNT)
  log.infof("Total used memory: %v Bytes",
    (memories[0].arena.total_used + memories[0].totalMem) * len(opt.board),
  )

  spall._buffer_end() // "Startup"

  /* --------------------------------------------- */

  step_time := 10 * time.Microsecond
  for mem, idx in memories {
    fw_threads[idx] = launch_board(
      &fw_thread_data[idx],
      mem,
      &stepwise_barrier,
      &global_should_quit,
      opt.max_iterations,
      step_time,
    )
  }

  /* --------------------------------------------- */

  if opt.max_time > 0 {
    time.sleep(opt.max_time)
    global_should_quit = true
    // wait until fw_threads quit 'voluntarily'
    thread.join_multiple(..fw_threads[:])
  } else {
    // sleep until all fw_threads finish
    thread.join_multiple(..fw_threads[:])
  }

  // wait until all usim threads quit 'voluntarily'
  global_should_quit = true
  thread.join_multiple(..usim_threads[:])
}
