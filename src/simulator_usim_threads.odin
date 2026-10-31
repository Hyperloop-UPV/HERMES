#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package simulator

import "core:os"
import "core:log"
import "core:mem"
import "core:time"
import "core:dynlib"
import "core:thread"
import "core:sync/chan"

import peripherals "sim_peripherals"

import "../usim"

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
