#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing General Purpose Input Output simulation for STM32H723xx
 * It is currently unfinished but works for what is being simulated
 *
 * Created on: 11 oct. 2026
 *   Author: victor
 */

import "base:intrinsics"

import "core:time"

import mcu "mcu:stm32h723xx"
import "../../usim"

// TODO: GPIOx_LCKR locking mechanism

@(private="file")
GPIO_Mode :: enum u32 {
  Input  = 0b00,
  Output = 0b01,
  Alt    = 0b10,
  Analog = 0b11,
}

@(private="file")
GPIO_Output_Type :: enum u32 {
  PushPull  = 0,
  OpenDrain = 1,
}

@(private="file")
GPIO_Pull :: enum u32 {
  None     = 0b00,
  PullUp   = 0b01,
  PullDown = 0b10,
  Reserved = 0b11,
}

@(private="file") GPIO_BSRR_BS0 :: 0
@(private="file") GPIO_BSRR_BR0 :: 16

@(private="file")
GPIO_Context :: struct {
  // to distinguish between gpios, so we can use a single handler and step procs
  gpio: ^mcu.GPIO,
  letter: u8,
}

GPIO_handler :: proc(rawctx, this_rawctx: rawptr)
{
  memory := cast(^Memory)rawctx
  rcc := memory.RCC_base
  ctx := cast(^GPIO_Context)this_rawctx

  odr_prev := ctx.gpio.ODR

  if ctx.gpio.BSRR != 0 {
    // set bits from BS
    new_odr := ctx.gpio.ODR | (ctx.gpio.BSRR & 0xFFFF)
    // clear bits from BR
    new_odr = new_odr & ~(ctx.gpio.BSRR >> GPIO_BSRR_BR0)

    ctx.gpio.BSRR = 0
    ctx.gpio.ODR = new_odr
  }

  // TODO: If this bit gets set in RCC, the event needs to be enqueued
  rcc_bit := u32(rcc.AHB4ENR >> u32(ctx.letter - 'A')) & 1
  if odr_prev != ctx.gpio.ODR && rcc_bit == 1 {
    event: usim.Event

    new_bits := odr_prev ~ ctx.gpio.ODR
    for new_bits != 0 {
      idx := intrinsics.count_trailing_zeros(new_bits)
      new_bits &= ~(1 << idx)

      event.as.gpio.value = (ctx.gpio.ODR & (1 << idx)) >> idx
      variant := usim.Event_Variant(
        u32(ctx.letter - 'A')*0x10 + idx,
      )
      enqueue_event(memory, &event, .GPIO, variant)
    }
  }
}

GPIO_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{
  //gpio := cast(^GPIO_Context)this_rawctx
}

GPIOA_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOA_base
  ctx.letter = 'A'

  // reset value for GPIOA MODER (see ref manual)
  ctx.gpio.MODER = 0xABFF_FFFF
  // reset value for GPIOA SPEEDR (see ref manual)
  ctx.gpio.OSPEEDR = 0x0C00_0000
  // reset value for GPIOB PUPDR (see ref manual)
  ctx.gpio.PUPDR = 0x6400_0000

  return GPIO_generic_setup(
    memory, ctx,
    special_moder = true,
    special_speedr = true,
    special_pupdr = true,
  )
}

GPIOB_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOB_base
  ctx.letter = 'B'

  // reset value for GPIOB MODER (see ref manual)
  ctx.gpio.MODER = 0xFFFF_FEBF
  // reset value for GPIOB SPEEDR (see ref manual)
  ctx.gpio.OSPEEDR = 0x0000_00C0
  // reset value for GPIOB PUPDR (see ref manual)
  ctx.gpio.PUPDR = 0x0000_0100

  return GPIO_generic_setup(
    memory, ctx,
    special_moder = true,
    special_speedr = true,
    special_pupdr = true,
  )
}

GPIOC_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOC_base
  ctx.letter = 'C'

  return GPIO_generic_setup(memory, ctx)
}

GPIOD_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOD_base
  ctx.letter = 'D'

  return GPIO_generic_setup(memory, ctx)
}

GPIOE_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOE_base
  ctx.letter = 'E'

  return GPIO_generic_setup(memory, ctx)
}

GPIOF_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOF_base
  ctx.letter = 'F'

  return GPIO_generic_setup(memory, ctx)
}

GPIOG_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOG_base
  ctx.letter = 'G'

  return GPIO_generic_setup(memory, ctx)
}

GPIOH_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOH_base
  ctx.letter = 'H'

  return GPIO_generic_setup(memory, ctx)
}

GPIOJ_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOJ_base
  ctx.letter = 'J'

  // reset value for GPIOJ MODER (see ref manual)
  ctx.gpio.MODER = 0x00FF_0000

  return GPIO_generic_setup(memory, ctx, special_moder = true)
}

GPIOK_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOK_base
  ctx.letter = 'K'

  // reset value for GPIOK MODER (see ref manual)
  ctx.gpio.MODER = 0x0000_003F

  return GPIO_generic_setup(memory, ctx, special_moder = true)
}

GPIO_generic_setup :: proc(memory: ^Memory, ctx: ^GPIO_Context,
  special_moder := false, special_speedr := false, special_pupdr := false) -> rawptr
{
  // any generic setup needed goes here
  if !special_moder {
    // reset value for GPIOx MODER (x not being A,B,J or K)
    ctx.gpio.MODER = 0xFFFF_FFFF
  }
  ctx.gpio.OTYPER = 0x0000_0000
  if !special_speedr {
    ctx.gpio.OSPEEDR = 0x0000_0000
  }
  if !special_pupdr {
    ctx.gpio.PUPDR = 0x0000_0000
  }

  return ctx
}
