#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing Timer simulation for STM32H723xx
 * It is currently unfinished
 *
 * Created on: 4 nov. 2026
 *   Author: victor
 */

import "core:time"

import mcu "mcu:stm32h723xx"
import "../../usim"

@(private="file")
TIM_Context :: struct {
  tim: ^mcu.TIM,
  /* given at init time: 1,2,3,4,5,6,7,8,12,13,14,15,16,17,23 or 24 */
  tim_num: u8,


  //last_val: u32,
  //change_was_internal: bool,
}

TIM_handler :: proc(rawctx, this_rawctx: rawptr)
{
  //memory := cast(^Memory)rawctx
  //rcc := memory.RCC_base


}

TIM_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{

}

TIM1_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM1
  ctx.tim_num = 1

  return TIM_generic_setup(memory, ctx)
}

TIM2_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM2
  ctx.tim_num = 2

  return TIM_generic_setup(memory, ctx)
}

TIM3_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM3
  ctx.tim_num = 3

  return TIM_generic_setup(memory, ctx)
}

TIM4_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM4
  ctx.tim_num = 4

  return TIM_generic_setup(memory, ctx)
}

TIM5_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM5
  ctx.tim_num = 5

  return TIM_generic_setup(memory, ctx)
}

TIM6_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM6
  ctx.tim_num = 6

  return TIM_generic_setup(memory, ctx)
}

TIM7_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM7
  ctx.tim_num = 7

  return TIM_generic_setup(memory, ctx)
}

TIM12_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM12
  ctx.tim_num = 12

  return TIM_generic_setup(memory, ctx)
}

TIM13_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM13
  ctx.tim_num = 13

  return TIM_generic_setup(memory, ctx)
}

TIM14_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM14
  ctx.tim_num = 14

  return TIM_generic_setup(memory, ctx)
}

TIM15_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM15
  ctx.tim_num = 15

  return TIM_generic_setup(memory, ctx)
}

TIM16_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM16
  ctx.tim_num = 16

  return TIM_generic_setup(memory, ctx)
}

TIM17_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM17
  ctx.tim_num = 17

  return TIM_generic_setup(memory, ctx)
}

TIM23_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM23
  ctx.tim_num = 23

  return TIM_generic_setup(memory, ctx)
}

TIM24_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM24
  ctx.tim_num = 24

  return TIM_generic_setup(memory, ctx)
}

TIM_generic_setup :: proc(memory: ^Memory, ctx: ^TIM_Context) -> rawptr
{
  // any generic setup needed goes here

  return ctx
}
