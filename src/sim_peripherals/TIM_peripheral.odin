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
// will be used for events (soon)
//import "../../usim"

@(private="file") CR1_CEN_Offset :: 0

@(private="file")
TIM_Context :: struct {
  tim: ^mcu.TIM,
  // Irq address for the counter
  irq_addr: ^#type proc "c"(),
  rcc_enabled_reg: ^u32,
  rcc_enabled_bit: u8,
  // Given at init time: 1,2,3,4,5,6,7,8,12,13,14,15,16,17,23 or 24
  tim_num: u8,
  // Irq number for the counter
  irq_num: u8,

  //last_val: u32,
  //change_was_internal: bool,
}

TIM_handler :: proc(rawctx, this_rawctx: rawptr)
{
}

TIM_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{
  memory := cast(^Memory)rawctx
  ctx := cast(^TIM_Context)this_rawctx

  rcc_is_on := (ctx.rcc_enabled_reg^ & (1 << u32(ctx.rcc_enabled_bit))) != 0
  cen_is_on := (ctx.tim.CR1 & (1 << CR1_CEN_Offset)) != 0
  if rcc_is_on && cen_is_on {
    // the counter is on
    // TODO: count down/up or both here!
  }
}

TIM1_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM1EN_Offset :: 0

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM1_base
  ctx.tim_num = 1
  // This is the irq for the CNT
  ctx.irq_num = mcu.TIM1_UP_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM1EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM2_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM2_Offset :: 0

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM2_base
  ctx.tim_num = 2
  ctx.irq_num = mcu.TIM2_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM2EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM3_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM3_Offset :: 1

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM3_base
  ctx.tim_num = 3
  ctx.irq_num = mcu.TIM3_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM3EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM4_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM4_Offset :: 2

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM4_base
  ctx.tim_num = 4
  ctx.irq_num = mcu.TIM4_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM4EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM5_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM5_Offset :: 3

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM5_base
  ctx.tim_num = 5
  ctx.irq_num = mcu.TIM5_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM5EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM6_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM6_Offset :: 4

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM6_base
  ctx.tim_num = 6
  // TIM6 irq is shared with DAC
  ctx.irq_num = mcu.TIM6_DAC_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM6EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM7_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM7_Offset :: 5

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM7_base
  ctx.tim_num = 7
  ctx.irq_num = mcu.TIM7_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM7EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM8_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM8EN_Offset :: 1

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM8_base
  ctx.tim_num = 8
  ctx.irq_num = mcu.TIM8_UP_TIM13_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM8EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM12_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM12_Offset :: 6

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM12_base
  ctx.tim_num = 12
  // TIM12 irq is shared with TIM8 brk irq
  ctx.irq_num = mcu.TIM8_BRK_TIM12_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM12EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM13_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM13_Offset :: 7

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM13_base
  ctx.tim_num = 13
  // TIM13 irq is shared with TIM8 irq
  ctx.irq_num = mcu.TIM8_UP_TIM13_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM13EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM14_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM14_Offset :: 8

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM14_base
  ctx.tim_num = 14
  // TIM14 irq is shared with TIM8 com trigger irq
  ctx.irq_num = mcu.TIM8_TRG_COM_TIM14_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM14EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM15_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM15EN_Offset :: 16

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM15_base
  ctx.tim_num = 15
  ctx.irq_num = mcu.TIM15_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM15EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM16_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM16EN_Offset :: 17

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM16_base
  ctx.tim_num = 16
  ctx.irq_num = mcu.TIM16_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM16EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM17_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM17EN_Offset :: 18

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM17_base
  ctx.tim_num = 17
  ctx.irq_num = mcu.TIM17_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM17EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM23_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1HENR_TIM23EN_Offset :: 24

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM23_base
  ctx.tim_num = 23
  ctx.irq_num = mcu.TIM23_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1HENR
  ctx.rcc_enabled_bit = RCC_APB1HENR_TIM23EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM24_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1HENR_TIM24EN_Offset :: 25

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM24_base
  ctx.tim_num = 24
  ctx.irq_num = mcu.TIM24_IRQn
  ctx.rcc_enabled_register = &memory.RCC_base.APB1HENR
  ctx.rcc_enabled_bit = RCC_APB1HENR_TIM24EN_Offset

  return TIM_generic_setup(memory, ctx)
}

TIM_generic_setup :: proc(memory: ^Memory, ctx: ^TIM_Context) -> rawptr
{
  // we can only do this because SCB_setup is before any TIMx_setup
  scb := memory.SCB_base
  vector_base := uintptr(memory.arena_base) + uintptr(scb.VTOR)
  ctx.irq_addr = cast(^#type proc "c"())(vector_base + uintptr(ctx.irq_num) * size_of(rawptr))

  return ctx
}
