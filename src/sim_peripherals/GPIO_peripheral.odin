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

import "core:time"

import mcu "mcu:stm32h723xx"
import "../../usim"

GPIO_Context :: struct {
  // to distinguish between gpios, so we can use a single handler and step procs
  gpio: ^mcu.GPIO,
  is_pin_on: [16]bool,
  letter: u8,
}

@(private="file")
GPIO_Mode :: enum u32 {
  Input = 0,
  Output = 1,
  Alt = 2,
  Analog = 3,
}

@(private="file") GPIO_BSRR_BS0 :: 0
@(private="file") GPIO_BSRR_BR0 :: 16

GPIO_handler :: proc(rawctx, this_rawctx: rawptr)
{
  memory := cast(^Memory)rawctx
  rcc := memory.RCC_base
  gpio := cast(^GPIO_Context)this_rawctx

  is_pin_on_prev := gpio.is_pin_on

  rcc_bit := u32(rcc.AHB4ENR >> u32(gpio.letter - 'A')) & 1
  if rcc_bit == 1 {
    for pin: u32 = 0; pin < 16; pin += 1 {
      mode := (gpio.gpio.MODER >> (pin * 2)) & 0b11

      if GPIO_Mode(mode) == .Output {
        set_bit := (gpio.gpio.BSRR >> (GPIO_BSRR_BS0 + pin)) & 1
        reset_bit := (gpio.gpio.BSRR >> (GPIO_BSRR_BR0 + pin)) & 1

        if set_bit != 0 {
          gpio.is_pin_on[pin] = true
        }

        if reset_bit != 0 {
          gpio.is_pin_on[pin] = false

          new_bsrr := gpio.gpio.BSRR & ~(1 << (GPIO_BSRR_BS0 + pin))
          new_bsrr = new_bsrr & ~(1 << (GPIO_BSRR_BR0 + pin))

          gpio.gpio.BSRR = new_bsrr
        }
      }
    }
  }

  if is_pin_on_prev != gpio.is_pin_on {
    event: usim.Event
    event.as.gpio_mod.gpio_char = gpio.letter
    event.as.gpio_mod.value = gpio.gpio.BSRR
    enqueue_event(memory, &event, .GPIO_Modified)
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

  return GPIO_generic_setup(memory, ctx)
}

GPIOB_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOB_base
  ctx.letter = 'B'

  return GPIO_generic_setup(memory, ctx)
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

  return GPIO_generic_setup(memory, ctx)
}

GPIOK_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  ctx := new(GPIO_Context, memory.arena_allocator)
  ctx.gpio = memory.GPIOK_base
  ctx.letter = 'K'

  return GPIO_generic_setup(memory, ctx)
}

GPIO_generic_setup :: proc(rawctx: rawptr, ctx: ^GPIO_Context) -> rawptr
{
  // any generic setup needed goes here

  return ctx
}
