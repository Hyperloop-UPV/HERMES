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

/*
Creates event queue channels
*/
create_channels :: proc(count: int, allocator: runtime.Allocator) -> []chan.Chan(usim.Event, .Both)
{
  channels := make([]chan.Chan(usim.Event, .Both), count, allocator)
  for idx := 0; idx < count; idx += 1 {
    err: runtime.Allocator_Error
    channels[idx], err = chan.create_buffered(
      chan.Chan(usim.Event, .Both),
      usim.QUEUE_MAX_SIZE,
      allocator,
    )

    if err != nil {
      log.errorf("Could not create event queue channel: %v", err)
      os.exit(1)
    }
  }

  return channels
}

/*
Destroy event queue channels

Assumes channels was allocated with an arena allocator,
because it doesn't free `channels`, only destroys each one
*/
destroy_channels :: proc(channels: []chan.Chan(usim.Event, .Both))
{
  for c in channels {
    chan.destroy(c)
  }
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
  channels := create_channels(len(opt.usim), arena_allocator)
  defer {
    for m in memories {
      destroy_board(m)
    }
    destroy_channels(channels)
  }
  usim_backing := make([]USim_Thread_Data, len(opt.usim), arena_allocator)
  usim_threads = make([]^thread.Thread, len(opt.usim), arena_allocator)

  fw_thread_data := make([]FW_Thread_Data, len(opt.board), arena_allocator)
  fw_threads = make([]^thread.Thread, len(opt.board), arena_allocator)

  stepwise_barrier: sync.Barrier
  sync.barrier_init(&stepwise_barrier, len(fw_threads) + opt.stepwise_usim_count)
  step_time := 10 * time.Microsecond

  /* --------------------------------------------- */

  start_tick := time.tick_now()
  for board, board_idx in opt.board {
    memories[board_idx] = create_board(board, channels, start_tick)
  }

  log.infof("Total page count: %v", memories[0].pageCount * len(opt.board))
  log.infof("Total page size: %v", memories[0].totalMem * len(opt.board))
  log.infof("Peripheral count for each board: %v", mcu.PERIPHERAL_COUNT)
  log.infof("Total used memory: %v Bytes",
    (memories[0].arena.total_used + memories[0].totalMem) * len(opt.board),
  )

  spall._buffer_end() // "Startup"
  when spall.PROFILING {
    spall.buffer_flush(&spall.ctx, &spall.buffer)
  }

  /* --------------------------------------------- */

  for usim_idx := 0; usim_idx < len(opt.usim); usim_idx += 1 {
    td := &usim_backing[usim_idx]
    usim_threads[usim_idx] = launch_usim(
      td, &opt, &global_should_quit, usim_idx,
      channels[usim_idx], memories,
      step_time, &stepwise_barrier,
    )
  }

  defer {
    for u in usim_backing {
      delete(u.attached_memories)
    }
  }

  /* --------------------------------------------- */

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
