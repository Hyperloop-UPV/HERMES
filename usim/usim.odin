#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package usim

/* File containing micro simulator API in odin
 * also used to autogenerate usim.h
 *
 * Created on: 24 oct. 2026
 *   Author: victor
 */

import "core:dynlib"

API_VERSION_MAJOR :: "0"
API_VERSION_MINOR :: "1"
API_VERSION_PATCH :: "0"
API_VERSION :: API_VERSION_MAJOR + "." + API_VERSION_MINOR + "." + API_VERSION_PATCH

/*
maximum usims at the same time, limited by a couple of factors
*/
MAX_USIMS :: 64

/*
Maximum elements in the event queue channel
*/
QUEUE_MAX_SIZE :: 256

/* As a bit of a warning: `Sim_add_event_watch` should be used very sparingly
 * since it makes the core simulator call the function ptr
 * instead of just add the event to the queue which is a much faster operation.
 */

/*
Provides a way to distinguish between usims to the core simulator
*/
Id :: distinct u64

Recv_Channel :: distinct rawptr

Event_Kind :: enum u32 {
  /* when the simulator is done, it will enqueue a Quit event */
  Quit = 0,

  GPIO_Modified = 1,
  SysTick = 2,

  Count = 3,
}

GPIO_Mod_Event :: struct {
  gpio_char: u8,
  value: u32,
}

SysTick_Event :: struct {
  /* True when the event was caused by a SysTick interrupt
   * right now, the only event for SysTick
   */
  interrupt_called: bool,
}

Event_Info :: struct #raw_union {
  gpio_mod: GPIO_Mod_Event,
  systick: SysTick_Event,
}

Event :: struct {
  /* This is essentially an Event_Kind but you cannot specify enum size in C, so it must be an u32 */
  kind: u32,
  padding: [4]u8,
  /* the instant when the event was enqueued, in nanoseconds, since the start of the simulation */
  instant: i64,
  board_name: cstring,
  as: Event_Info,
}

/*
Procedure that will be called after starting up peripherals for a specific board.
Will be called once for every board dll which this usim is attached to.

Arguments:
 - `memory`: An already initialized ^peripherals.Memory, should not be written to, only read
 - `api`: The usim api, includes own functions but mostly to access [`Sim_subscribe_event`,`Sim_wait_event`,`Sim_add_event_watch`,`Sim_poll_event`]
 - `board_name`: The board name that was attached to the usim
 - `usim_mem`: A pointer to be filled in with the usim memory given to `Update_Proc` and `Deinit_Proc`, if it is the first call, `usim_mem^` will be nil (`*usim_mem`), else it will be a prevously returned value from Init_Proc
Returns:
 - If initialization succeeded

If this returns false, it won't be called again for any other boards
*/
Init_Proc :: #type proc "c"(memory: rawptr, api: ^API, board_name: cstring, usim_id: Id, usim_mem: ^rawptr) -> bool

/*
Procedure that will be called in a loop until `event.kind == .Quit` is true.

Arguments:
 - `usim_mem`: rawptr (same as void*) to memory recieved from `Init_Proc`
Returns:
 - `end_early`: if end_early is true, `Update_Proc` will stop being called and `Deinit_Proc` will be called once
 */
Update_Proc :: #type proc "c"(usim_mem: rawptr) -> (end_early: bool)

/*
Procedure that will be called in a loop until `event.kind == .Quit` is true.

Be aware that steps are significantly slower since they require a synchronization of all steps in the simulator, so avoid this unless you know what you're doing.

Arguments:
 - `usim_mem`: rawptr (same as void*) to memory recieved from `Init_Proc`
 - `step_time`: the number of nanoseconds to step
Returns:
 - `end_early`: if end_early is true, `Update_Proc` will stop being called and `Deinit_Proc` will be called once
*/
Step_Proc :: #type proc "c"(usim_mem: rawptr, step_time: i64) -> (end_early: bool)

/*
Procedure that will be called after the Quit event is given or after the call to `Update_Proc` with `end_early` == true

Arguments:
 - `usim_mem`: rawptr (same as void*) to memory recieved from `Init_Proc`
*/
Deinit_Proc :: #type proc "c"(usim_mem: rawptr)

/* ----------------------------------------- */
/* WARNING: Unless advised to do otherwise, only call the following procedures from the main thread of the usim */

/*
Checks the usim api version is the same as the one used in the core simulator.

Arguments:
 - `version`: C string to be filled with `USIM_API_VERSION` in C or
              `usim.API_VERSION` in odin
Returns:
 - If the version in the core simulator was the same
*/
Check_Version_Proc :: #type proc "c"(version: cstring) -> bool

/*
Procedure to call in `Init_Proc` to subscribe to an event kind

Arguments:
 - `id`: The usim id given by `Init_Proc`
 - `memory`: The memory given by `Init_Proc`
 - `kind`: the event kind to subscribe to
Returns:
 - if the operation succeeded or not
*/
Subscribe_Event_Proc :: #type proc "c"(memory: rawptr, kind: Event_Kind, id: Id) -> bool

/*
Procedure to call in `Update_Proc` to check for any new events in this usim's event queue

Arguments:
 - `channel`: the channel where to poll events from (found in `api.channel`)
 - `event`: will be filled with the newest event if there was any
Returns:
 - if there was an event
*/
Poll_Event_Proc :: #type proc "c"(channel: Recv_Channel, event: ^Event) -> bool

/*
Procedure to call in `Update_Proc` to wait for the next event in this usim's event queue

Arguments:
 - `channel`: the channel where to wait for events from (found in `api.channel`)
 - `event`: will be filled in with the newest event if there was any
Returns:
 - if there was an error while trying to gather the newest event
*/
Wait_Event_Proc :: #type proc "c"(channel: Recv_Channel, event: ^Event) -> bool

/* callback type for `Add_Watch_Event_Proc` */
Watch_Event_Proc_Callback :: #type proc "c"(event: ^Event, ctx: rawptr)

/*
Procedure to call in `Init_Proc` to handle events of a specific kind in a callback.

WARNING: This callback will be called in a different thread and it is separate from the event queue from `Event_Subscribe_Proc`.
         Use this sparingly because it will interrupt the board's running thread.

Arguments:
 - `id`: The usim id given by `Init_Proc`
 - `memory`: The memory given by `Init_Proc`
 - `kind`: the event kind to be handled in the callback
 - `callback`: the callback that handles this event
 - `ctx`: the context to give to the callback
Returns:
 - if there was an error while trying to add the callback
*/
Add_Watch_Event_Proc :: #type proc "c"( \
  memory: rawptr, \
  kind: Event_Kind, \
  id: Id, \
  callback: Watch_Event_Proc_Callback, \
  ctx: rawptr, \
) -> bool

API :: struct {
  /* api from core sim to usim */

  check_version: Check_Version_Proc,
  subscribe_event: Subscribe_Event_Proc,
  poll_event: Poll_Event_Proc,
  wait_event: Wait_Event_Proc,
  add_watch_event: Add_Watch_Event_Proc,

  /*
  Recieve channel for usim, used internally in `poll_event` and `wait_event`
  will be chan.Chan(Event, .Recv)
  */
  channel: Recv_Channel,

  /* api from usim to core sim (taken from dll) */

  /*
  Either USim_update or USim_step are expected from the dll.
  You may have both but only one will be used at a time depending on
  the configuration in the given cfg.json
  */

  /* USim_init is expected to be found */
  _init:  Init_Proc,
  /* USim_update is expected to be found */
  _update: Update_Proc,
  /* USim_step is expected to be found */
  _step: Step_Proc,
  /* USim_deinit is expected to be found */
  _deinit: Deinit_Proc,

  _library: dynlib.Library,
}
