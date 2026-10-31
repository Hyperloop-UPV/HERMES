#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package simulator

import "base:runtime"

import "core:os"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:time"
import "core:thread"
import "core:dynlib"
import "core:sync/chan"

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

USim_Thread_Data :: struct {
  attached_memories: []^peripherals.Memory,
  board_names: []cstring,
  usim_dll: string,
  usim_api: usim.API,
  global_should_quit: ^bool,
  /* we're using Raw_Chan instead of Chan(usim.Event, .Recv)
   * because we're sending it to C api
   */
  channel: ^chan.Raw_Chan,
  usim_id: usim.Id,
}

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

load_usim_api :: proc(dllpath: string) -> usim.API
{
  usim_api: usim.API
  did_load: bool
  usim_api._library, did_load = dynlib.load_library(dllpath)
  if !did_load {
    log.errorf("Could not load library from %s: %v",
      dllpath, dynlib.last_error())
    os.exit(1)
  }

  load_symbol_or_err(usim_api._library, dllpath, "USim_init", cast(^rawptr)&usim_api._init)
  load_symbol_or_err(usim_api._library, dllpath, "USim_update", cast(^rawptr)&usim_api._update)
  load_symbol_or_err(usim_api._library, dllpath, "USim_deinit", cast(^rawptr)&usim_api._deinit)

  log.infof("loaded symbols correctly from %s", dllpath)
  return usim_api
}

/* --------------------------------------------- */

USim_subscribe_event :: proc "c"(rawmem: rawptr, kind: usim.Event_Kind, id: usim.Id) -> bool
{
  memory := cast(^peripherals.Memory)rawmem
  context = memory.odin_ctx

  subscribers := memory.subscribed_events[kind]
  subscribers |= 1 << u64(id)
  memory.subscribed_events[kind] = subscribers

  return true
}

USim_poll_event :: proc "c"(channel: usim.Recv_Channel, event: ^usim.Event) -> bool
{
  status: chan.Timeout_Status
  ch := cast(^chan.Raw_Chan)channel

  status = chan.recv_raw_with_timeout(ch, event, time.Duration(0))
  return status == .Ok
}

USim_wait_event :: proc "c"(channel: usim.Recv_Channel, event: ^usim.Event) -> bool
{
  ch := cast(^chan.Raw_Chan)channel
  return chan.recv_raw(ch, event)
}

USim_add_watch_event :: proc "c"(rawmem: rawptr, kind: usim.Event_Kind, id: usim.Id, callback: usim.Watch_Event_Proc_Callback, ctx: rawptr) -> bool
{
  memory := cast(^peripherals.Memory)rawmem
  context = memory.odin_ctx

  watch, found := memory.event_watch[kind]

  new_watch: []peripherals.USim_Event_Watch_Data
  if found {
    new_watch = make([]peripherals.USim_Event_Watch_Data, len(watch))
    mem.copy(&new_watch[0], &watch[0], len(watch) * size_of(peripherals.USim_Event_Watch_Data))
    delete(watch)
  } else {
    new_watch = make([]peripherals.USim_Event_Watch_Data, 1)
  }

  new_watch[len(new_watch)-1].callback = callback
  new_watch[len(new_watch)-1].ctx = ctx

  memory.event_watch[kind] = new_watch

  return true
}

/* --------------------------------------------- */

/* Thread procedure for a single usim */
usim_thread_proc :: proc(rawdata: rawptr)
{
  data := cast(^USim_Thread_Data)rawdata

  data.usim_api = load_usim_api(data.usim_dll)
  data.usim_api.subscribe_event = USim_subscribe_event
  data.usim_api.poll_event = USim_poll_event
  data.usim_api.wait_event = USim_wait_event
  data.usim_api.add_watch_event = USim_add_watch_event
  data.usim_api.channel = usim.Recv_Channel(data.channel)

  ctx: rawptr
  init_ok: bool = true
  for i := 0; i < len(data.attached_memories); i += 1 {
    memory := data.attached_memories[i]
    name := data.board_names[i]
    init_ok = init_ok &&
      data.usim_api._init(memory, &data.usim_api, name, data.usim_id, &ctx)
  }

  if !init_ok {
    data.usim_api._deinit(ctx)
    dynlib.unload_library(data.usim_api._library)
    return
  }

  quit: bool
  for !quit && !(data.global_should_quit^) {
    quit = data.usim_api._update(ctx)
    // sleep is expected to be done in update() callback
  }
  data.usim_api._deinit(ctx)

  dynlib.unload_library(data.usim_api._library)
  chan.close(data.channel)
}

/* --------------------------------------------- */

launch_usim :: proc(backing: ^USim_Thread_Data) -> ^thread.Thread
{
  usim_thread := thread.create_and_start_with_data(
    backing,
    usim_thread_proc,
    context,
  )

  return usim_thread
}

/* --------------------------------------------- */

sim_signal_handler :: proc "contextless"()
{
  // TODO: Join all threads here.
}

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

  /* --------------------------------------------- */

  memories := make([]^peripherals.Memory, len(opt.board))
  defer {
    for m in memories {
      destroy_board(m)
    }
    delete(memories)
  }
  channels := make([]chan.Chan(usim.Event, .Both), len(opt.usim))
  defer {
    for c in channels {
      chan.destroy(c)
    }
    delete(channels)
  }
  usims := make([]USim_Thread_Data, len(opt.usim))
  defer delete(usims)
  usim_threads := make([]^thread.Thread, len(opt.usim))
  defer delete(usim_threads)

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

  global_should_quit: bool
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
  thread_data := make([]FW_Thread_Data, len(opt.board))
  defer delete(thread_data)
  board_threads := make([]^thread.Thread, len(opt.board))
  defer delete(board_threads)

  for mem, idx in memories {
    board_threads[idx] = launch_board(&thread_data[idx], mem, &global_should_quit, opt.max_iterations, step_time)
  }

  /* --------------------------------------------- */

  if opt.max_time > 0 {
    time.sleep(opt.max_time)
    global_should_quit = true
    // wait until board_threads quit 'voluntarily'
    thread.join_multiple(..board_threads[:])
  } else {
    // sleep until all board_threads finish
    thread.join_multiple(..board_threads[:])
  }

  // wait until all usim threads quit 'voluntarily'
  global_should_quit = true
  thread.join_multiple(..usim_threads[:])
}
