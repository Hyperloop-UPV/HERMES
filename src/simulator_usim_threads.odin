#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package simulator

/* File containing
 *  - dll loading for micro simulators
 *  - thread code for micro simulators
 *
 * Created on: 31 oct. 2026
 *   Author: victor
 */

import "core:os"
import "core:log"
import "core:mem"
import "core:time"
import "core:sync"
import "core:dynlib"
import "core:thread"
import "core:sync/chan"

import peripherals "sim_peripherals"

import "../plugin"

Plugin_Thread_Data :: struct {
  attached_memories: []^peripherals.Memory,
  board_names: []cstring,
  plugin_dll: string,
  plugin_api: plugin.API,
  global_should_quit: ^bool,

  is_stepwise: bool,

  /* `step_time` and `step_barrier` are only used for stepwise plugins */
  step_time: time.Duration,
  /* `step_time` and `step_barrier` are only used for stepwise plugins */
  step_barrier: ^sync.Barrier,
  /* we're using Raw_Chan instead of Chan(plugin.Recv_Event, .Recv)
   * because we're sending it to C api
   */
  channel: ^chan.Raw_Chan,
  plugin_id: plugin.Id,
}

/* --------------------------------------------- */

load_plugin_api :: proc(dllpath: string, is_stepwise: bool) -> plugin.API
{
  plugin_api: plugin.API
  did_load: bool
  plugin_api._library, did_load = dynlib.load_library(dllpath)
  if !did_load {
    log.errorf("Could not load library from %s: %v",
      dllpath, dynlib.last_error())
    os.exit(1)
  }

  load_symbol_or_err(plugin_api._library, dllpath, "Plugin_init", cast(^rawptr)&plugin_api._init)
  if is_stepwise {
    load_symbol_or_err(plugin_api._library, dllpath, "Plugin_step", cast(^rawptr)&plugin_api._step)
  } else {
    load_symbol_or_err(plugin_api._library, dllpath, "Plugin_update", cast(^rawptr)&plugin_api._update)
  }
  load_symbol_or_err(plugin_api._library, dllpath, "Plugin_deinit", cast(^rawptr)&plugin_api._deinit)

  log.infof("loaded symbols correctly from %s", dllpath)
  return plugin_api
}

/* --------------------------------------------- */

Plugin_check_version :: proc "c"(version: cstring) -> bool
{
  return string(version) == plugin.API_VERSION
}

Plugin_subscribe_event :: proc "c"(rawmem: rawptr, id: plugin.Id, kind: plugin.Recv_Event_Kind, variant: plugin.Recv_Event_Variant) -> bool
{
  memory := cast(^peripherals.Memory)rawmem
  context = memory.odin_ctx

  key := peripherals.Plugin_Event_Key {
    kind = kind,
    variant = variant,
  }

  subscribers := memory.subscribed_events[key]
  subscribers |= 1 << u64(id)
  memory.subscribed_events[key] = subscribers

  return true
}

Plugin_poll_event :: proc "c"(channel: plugin.Recv_Channel, event: ^plugin.Recv_Event) -> bool
{
  status: chan.Timeout_Status
  ch := cast(^chan.Raw_Chan)channel

  status = chan.recv_raw_with_timeout(ch, event, time.Duration(0))
  return status == .Ok
}

Plugin_wait_event :: proc "c"(channel: plugin.Recv_Channel, event: ^plugin.Recv_Event) -> bool
{
  ch := cast(^chan.Raw_Chan)channel
  return chan.recv_raw(ch, event)
}

Plugin_add_watch_event :: proc "c"(rawmem: rawptr, id: plugin.Id, kind: plugin.Recv_Event_Kind, variant: plugin.Recv_Event_Variant, callback: plugin.Watch_Event_Proc_Callback, ctx: rawptr) -> bool
{
  memory := cast(^peripherals.Memory)rawmem
  context = memory.odin_ctx

  key := peripherals.Plugin_Event_Key {
    kind = kind,
    variant = variant,
  }

  watch, found := memory.event_watch[key]

  new_watch: []peripherals.Plugin_Event_Watch_Data
  if found {
    new_watch = make([]peripherals.Plugin_Event_Watch_Data, len(watch))
    mem.copy(&new_watch[0], &watch[0], len(watch) * size_of(peripherals.Plugin_Event_Watch_Data))
    delete(watch)
  } else {
    new_watch = make([]peripherals.Plugin_Event_Watch_Data, 1)
  }

  new_watch[len(new_watch)-1].callback = callback
  new_watch[len(new_watch)-1].ctx = ctx

  memory.event_watch[key] = new_watch

  return true
}

/* --------------------------------------------- */

/* Thread procedure for a single plugin */
plugin_thread_proc :: proc(rawdata: rawptr)
{
  data := cast(^Plugin_Thread_Data)rawdata

  data.plugin_api = load_plugin_api(data.plugin_dll, data.is_stepwise)
  data.plugin_api.check_version = Plugin_check_version
  data.plugin_api.subscribe_event = Plugin_subscribe_event
  data.plugin_api.poll_event = Plugin_poll_event
  data.plugin_api.wait_event = Plugin_wait_event
  data.plugin_api.add_watch_event = Plugin_add_watch_event
  data.plugin_api.channel = plugin.Recv_Channel(data.channel)

  ctx: rawptr
  init_ok: bool = true
  for i := 0; i < len(data.attached_memories); i += 1 {
    memory := data.attached_memories[i]
    name := data.board_names[i]
    init_ok = init_ok &&
      data.plugin_api._init(memory, &data.plugin_api, name, data.plugin_id, &ctx)
  }

  if !init_ok {
    data.plugin_api._deinit(ctx)
    dynlib.unload_library(data.plugin_api._library)
    return
  }

  quit: bool
  if data.is_stepwise {
    for !quit && !(data.global_should_quit^) {
      sync.barrier_wait(data.step_barrier)
      quit = data.plugin_api._step(ctx, i64(data.step_time))
      // there is no real need to sleep in the step() callback
      // due to the barrier already forcing a wait, but it can be done
    }
  } else {
    for !quit && !(data.global_should_quit^) {
      quit = data.plugin_api._update(ctx)
      // sleep is expected to be done in update() callback
    }
  }
  data.plugin_api._deinit(ctx)

  dynlib.unload_library(data.plugin_api._library)
  chan.close(data.channel)
}

/* --------------------------------------------- */

launch_plugin :: proc(backing: ^Plugin_Thread_Data, opt: ^Sim_Options, global_should_quit: ^bool, idx: int, channel: chan.Chan(plugin.Recv_Event, .Both), memories: []^peripherals.Memory, step_time: time.Duration, step_barrier: ^sync.Barrier) -> ^thread.Thread
{
  u := &opt.plugin[idx]

  backing.board_names = u.attached_boards
  backing.plugin_dll = u.dll
  backing.global_should_quit = global_should_quit
  backing.plugin_id = plugin.Id(idx)
  backing.channel = chan.as_recv(channel).impl

  backing.is_stepwise = u.is_stepwise
  backing.step_time = step_time
  backing.step_barrier = step_barrier

  backing.attached_memories = make([]^peripherals.Memory, len(u.attached_boards))

  for attached, mem_idx in u.attached_boards {
    board_name := string(attached)
    found := false
    for board, board_idx in opt.board {
      if os.short_stem(board) == board_name {
        backing.attached_memories[mem_idx] = memories[board_idx]
        found = true
      }
    }

    if !found {
      log.errorf("board %s requested by plugin %s was not found in board array", attached, u.dll)
      os.exit(1)
    }
  }

  plugin_thread := thread.create_and_start_with_data(
    backing,
    plugin_thread_proc,
    context,
  )

  return plugin_thread
}
