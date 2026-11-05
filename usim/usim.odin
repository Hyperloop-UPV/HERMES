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

  GPIO = 1,
  SysTick = 2,
  NVIC = 3,
  TIM = 4,

  Count = 5,
}

Event_Variant :: enum u32 {
  /* GPIO event variants */

  // GPIOA pins
  GPIO_PA0  = 0x0,
  GPIO_PA1  = 0x1,
  GPIO_PA2  = 0x2,
  GPIO_PA3  = 0x3,
  GPIO_PA4  = 0x4,
  GPIO_PA5  = 0x5,
  GPIO_PA6  = 0x6,
  GPIO_PA7  = 0x7,
  GPIO_PA8  = 0x8,
  GPIO_PA9  = 0x9,
  GPIO_PA10 = 0xA,
  GPIO_PA11 = 0xB,
  GPIO_PA12 = 0xC,
  GPIO_PA13 = 0xD,
  GPIO_PA14 = 0xE,
  GPIO_PA15 = 0xF,

  // GPIOB pins
  GPIO_PB0  = 0x10,
  GPIO_PB1  = 0x11,
  GPIO_PB2  = 0x12,
  GPIO_PB3  = 0x13,
  GPIO_PB4  = 0x14,
  GPIO_PB5  = 0x15,
  GPIO_PB6  = 0x16,
  GPIO_PB7  = 0x17,
  GPIO_PB8  = 0x18,
  GPIO_PB9  = 0x19,
  GPIO_PB10 = 0x1A,
  GPIO_PB11 = 0x1B,
  GPIO_PB12 = 0x1C,
  GPIO_PB13 = 0x1D,
  GPIO_PB14 = 0x1E,
  GPIO_PB15 = 0x1F,

  // GPIOC pins
  GPIO_PC0  = 0x20,
  GPIO_PC1  = 0x21,
  GPIO_PC2  = 0x22,
  GPIO_PC3  = 0x23,
  GPIO_PC4  = 0x24,
  GPIO_PC5  = 0x25,
  GPIO_PC6  = 0x26,
  GPIO_PC7  = 0x27,
  GPIO_PC8  = 0x28,
  GPIO_PC9  = 0x29,
  GPIO_PC10 = 0x2A,
  GPIO_PC11 = 0x2B,
  GPIO_PC12 = 0x2C,
  GPIO_PC13 = 0x2D,
  GPIO_PC14 = 0x2E,
  GPIO_PC15 = 0x2F,

  // GPIOD pins
  GPIO_PD0  = 0x30,
  GPIO_PD1  = 0x31,
  GPIO_PD2  = 0x32,
  GPIO_PD3  = 0x33,
  GPIO_PD4  = 0x34,
  GPIO_PD5  = 0x35,
  GPIO_PD6  = 0x36,
  GPIO_PD7  = 0x37,
  GPIO_PD8  = 0x38,
  GPIO_PD9  = 0x39,
  GPIO_PD10 = 0x3A,
  GPIO_PD11 = 0x3B,
  GPIO_PD12 = 0x3C,
  GPIO_PD13 = 0x3D,
  GPIO_PD14 = 0x3E,
  GPIO_PD15 = 0x3F,

  // GPIOE pins
  GPIO_PE0  = 0x40,
  GPIO_PE1  = 0x41,
  GPIO_PE2  = 0x42,
  GPIO_PE3  = 0x43,
  GPIO_PE4  = 0x44,
  GPIO_PE5  = 0x45,
  GPIO_PE6  = 0x46,
  GPIO_PE7  = 0x47,
  GPIO_PE8  = 0x48,
  GPIO_PE9  = 0x49,
  GPIO_PE10 = 0x4A,
  GPIO_PE11 = 0x4B,
  GPIO_PE12 = 0x4C,
  GPIO_PE13 = 0x4D,
  GPIO_PE14 = 0x4E,
  GPIO_PE15 = 0x4F,

  // GPIOF pins
  GPIO_PF0  = 0x50,
  GPIO_PF1  = 0x51,
  GPIO_PF2  = 0x52,
  GPIO_PF3  = 0x53,
  GPIO_PF4  = 0x54,
  GPIO_PF5  = 0x55,
  GPIO_PF6  = 0x56,
  GPIO_PF7  = 0x57,
  GPIO_PF8  = 0x58,
  GPIO_PF9  = 0x59,
  GPIO_PF10 = 0x5A,
  GPIO_PF11 = 0x5B,
  GPIO_PF12 = 0x5C,
  GPIO_PF13 = 0x5D,
  GPIO_PF14 = 0x5E,
  GPIO_PF15 = 0x5F,

  // GPIOG pins
  GPIO_PG0  = 0x60,
  GPIO_PG1  = 0x61,
  GPIO_PG2  = 0x62,
  GPIO_PG3  = 0x63,
  GPIO_PG4  = 0x64,
  GPIO_PG5  = 0x65,
  GPIO_PG6  = 0x66,
  GPIO_PG7  = 0x67,
  GPIO_PG8  = 0x68,
  GPIO_PG9  = 0x69,
  GPIO_PG10 = 0x6A,
  GPIO_PG11 = 0x6B,
  GPIO_PG12 = 0x6C,
  GPIO_PG13 = 0x6D,
  GPIO_PG14 = 0x6E,
  GPIO_PG15 = 0x6F,

  // GPIOH pins
  GPIO_PH0  = 0x70,
  GPIO_PH1  = 0x71,
  GPIO_PH2  = 0x72,
  GPIO_PH3  = 0x73,
  GPIO_PH4  = 0x74,
  GPIO_PH5  = 0x75,
  GPIO_PH6  = 0x76,
  GPIO_PH7  = 0x77,
  GPIO_PH8  = 0x78,
  GPIO_PH9  = 0x79,
  GPIO_PH10 = 0x7A,
  GPIO_PH11 = 0x7B,
  GPIO_PH12 = 0x7C,
  GPIO_PH13 = 0x7D,
  GPIO_PH14 = 0x7E,
  GPIO_PH15 = 0x7F,

  // GPIOI pins (there is no GPIOI in stm32h723xx but it is reserved)
  // GPIO_PI0  = 0x80,
  // GPIO_PI1  = 0x81,
  // GPIO_PI2  = 0x82,
  // GPIO_PI3  = 0x83,
  // GPIO_PI4  = 0x84,
  // GPIO_PI5  = 0x85,
  // GPIO_PI6  = 0x86,
  // GPIO_PI7  = 0x87,
  // GPIO_PI8  = 0x88,
  // GPIO_PI9  = 0x89,
  // GPIO_PI10 = 0x8A,
  // GPIO_PI11 = 0x8B,
  // GPIO_PI12 = 0x8C,
  // GPIO_PI13 = 0x8D,
  // GPIO_PI14 = 0x8E,
  // GPIO_PI15 = 0x8F,

  // GPIOJ pins
  GPIO_PJ0  = 0x90,
  GPIO_PJ1  = 0x91,
  GPIO_PJ2  = 0x92,
  GPIO_PJ3  = 0x93,
  GPIO_PJ4  = 0x94,
  GPIO_PJ5  = 0x95,
  GPIO_PJ6  = 0x96,
  GPIO_PJ7  = 0x97,
  GPIO_PJ8  = 0x98,
  GPIO_PJ9  = 0x99,
  GPIO_PJ10 = 0x9A,
  GPIO_PJ11 = 0x9B,
  GPIO_PJ12 = 0x9C,
  GPIO_PJ13 = 0x9D,
  GPIO_PJ14 = 0x9E,
  GPIO_PJ15 = 0x9F,

  // GPIOK pins
  GPIO_PK0  = 0xA0,
  GPIO_PK1  = 0xA1,
  GPIO_PK2  = 0xA2,
  GPIO_PK3  = 0xA3,
  GPIO_PK4  = 0xA4,
  GPIO_PK5  = 0xA5,
  GPIO_PK6  = 0xA6,
  GPIO_PK7  = 0xA7,
  GPIO_PK8  = 0xA8,
  GPIO_PK9  = 0xA9,
  GPIO_PK10 = 0xAA,
  GPIO_PK11 = 0xAB,
  GPIO_PK12 = 0xAC,
  GPIO_PK13 = 0xAD,
  GPIO_PK14 = 0xAE,
  GPIO_PK15 = 0xAF,

  /* SysTick event variants */

  SysTick_Interrupt = 0,

  /* NVIC event variants */

  NVIC_Interrupt = 0,

  /* TIM event variants */

  // some timers don't exist
  TIM1_UP_Interrupt = 1,
  TIM2_UP_Interrupt = 2,
  TIM3_UP_Interrupt = 3,
  TIM4_UP_Interrupt = 4,
  TIM5_UP_Interrupt = 5,
  TIM6_UP_Interrupt = 6,
  TIM7_UP_Interrupt = 7,
  TIM8_UP_Interrupt = 8,
  //TIM9_UP_Interrupt = 9,
  //TIM10_UP_Interrupt = 10,
  //TIM11_UP_Interrupt = 11,
  TIM12_UP_Interrupt = 12,
  TIM13_UP_Interrupt = 13,
  TIM14_UP_Interrupt = 14,
  TIM15_UP_Interrupt = 15,
  TIM16_UP_Interrupt = 16,
  TIM17_UP_Interrupt = 17,
  //TIM18_UP_Interrupt = 18,
  //TIM19_UP_Interrupt = 19,
  //TIM20_UP_Interrupt = 20,
  //TIM21_UP_Interrupt = 21,
  //TIM22_UP_Interrupt = 22,
  TIM23_UP_Interrupt = 23,
  TIM24_UP_Interrupt = 24,
}

GPIO_Event :: struct {
  value: u32,
}

SysTick_Event :: struct {
  /* True when the event was caused by a SysTick interrupt
   * right now, the only event for SysTick
   */
  interrupt_called: bool,
}

NVIC_Event :: struct {
  /* Interrupt index of the interrupt that was called */
  interrupt_idx: u8,
}

TIM_Event :: struct {
  dummy: u8,
}

Event_Info :: struct #raw_union {
  gpio: GPIO_Event,
  systick: SysTick_Event,
  nvic: NVIC_Event,
}

Event :: struct {
  /* This is essentially an Event_Kind but you cannot specify enum size in C, so it must be an u32 */
  kind: u32,
  /* This is essentially an Event_Variant but you cannot specify enum size in C, so it must be an u32 */
  variant: u32,
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
Subscribe_Event_Proc :: #type proc "c"(memory: rawptr, id: Id, kind: Event_Kind, variant: Event_Variant) -> bool

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
Add_Watch_Event_Proc :: #type proc "c"(
  memory: rawptr,
  id: Id,
  kind: Event_Kind,
  variant: Event_Variant,
  callback: Watch_Event_Proc_Callback,
  ctx: rawptr,
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
