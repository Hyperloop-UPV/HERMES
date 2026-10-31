#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing SysTick simulation for core_cm7
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

import "core:os"
import "core:fmt"
import "core:time"
import "core:sync"

import mcu "mcu:stm32h723xx"

/* NOTE: This SysTick implementation works at 10 microsecond precision,
 *       As you can see by the value of CALIB
 *
 * Important to note too that SysTick counts down, not up
 */

/* Control and Status Register */

/* Returns 1 if timer counted to 0 since last time this was read */
@(private="file") CTRL_COUNTFLAG_Offset          :: 16
@(private="file") CTRL_COUNTFLAG_CountedTo0      :: 1 << 16
@(private="file") CTRL_COUNTFLAG_DidntCountTo0   :: 0 << 16

@(private="file") CTRL_CLKSOURCE_Offset          :: 2
@(private="file") CTRL_CLKSOURCE_ProcessorClock  :: 1 << CTRL_CLKSOURCE_Offset
@(private="file") CTRL_CLKSOURCE_ExternalClock   :: 0 << CTRL_CLKSOURCE_Offset

@(private="file") CTRL_TICKINT_Offset            :: 1
@(private="file") CTRL_TICKINT_InterruptEnabled  :: 1 << CTRL_TICKINT_Offset
@(private="file") CTRL_TICKINT_InterruptDisabled :: 0 << CTRL_TICKINT_Offset

@(private="file") CTRL_ENABLE_Offset             :: 0
@(private="file") CTRL_ENABLE_CounterEnabled     :: 1 << CTRL_ENABLE_Offset
@(private="file") CTRL_ENABLE_CounterDisabled    :: 0 << CTRL_ENABLE_Offset

/* Reload Value Register */

@(private="file") LOAD_RELOAD_Offset :: 0

/* Current Value Register */

/* A write of any value clears the field to 0,
 * and also clears the CTRL.COUNTFLAG bit to 0
 */
@(private="file") VAL_CURRENT_Offset :: 0

/* Calibration Register. ReadOnly */

/* If the device does not provide a reference clock,
 * the CTRL.CLKSOURCE bit reads-as-one and ignores writes
 */
@(private="file") CALIB_NOREF_Offset :: 31
@(private="file") CALIB_NOREF_NoRef  :: 1 << CALIB_NOREF_Offset
@(private="file") CALIB_NOREF_YesRef :: 0 << CALIB_NOREF_Offset

@(private="file") CALIB_SKEW_Offset  :: 30
@(private="file") CALIB_SKEW_Inexact :: 1 << CALIB_SKEW_Offset
@(private="file") CALIB_SKEW_Exact   :: 0 << CALIB_SKEW_Offset

/* Reload value for 10ms (100Hz) timing, subject to system clock skew errors.
* If the value reads as zero, the calibration value is not known
*/
@(private="file") CALIB_TENMS_Offset :: 0

/* ------- end systick registers ------- */

/* 10us max precision */
@(private="file") SYSTICK_DIVISOR :: 1000

@(private="file") SYSTICK_NANOS_TO_TICKS :: 10_000

/* calibration for 10ms (100hz) timing is 1000 since this implementation of SysTick
 * has a maximum of 10 microsecond precision
 */
@(private="file") CALIB_VALUE :: CALIB_SKEW_Exact | SYSTICK_DIVISOR

@(private="file")
Systick_Context :: struct {
  last_val: u32,
  change_was_internal: bool,
}

SysTick_handler :: proc(rawctx, this_rawctx: rawptr)
{
  memory := cast(^Memory)rawctx
  systick := cast(^mcu.SysTick)memory.SysTick_base
  ctx := cast(^Systick_Context)this_rawctx

  if systick.CALIB != CALIB_VALUE {
    fmt.eprintfln("[ERROR] Written to SysTick CALIB, a ReadOnly register")
    os.exit(1)
  }

  if (ctx.last_val != systick.VAL) && !ctx.change_was_internal {
    /* A write of any value clears the field to 0,
     * and also clears the CTRL.COUNTFLAG bit to 0
     */
    systick.VAL = 0
    systick.CTRL &= ~ u32(1 << CTRL_COUNTFLAG_Offset)
  }

  ctx.last_val = systick.VAL
  ctx.change_was_internal = false
}

SysTick_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  systick := cast(^mcu.SysTick)memory.SysTick_base

  systick.CALIB = CALIB_VALUE

  ctx := new(Systick_Context, memory.arena_allocator)
  ctx.last_val = 0

  return ctx
}

SysTick_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{
  mem := cast(^Memory)rawctx
  systick := cast(^mcu.SysTick)mem.SysTick_base
  ctx := cast(^Systick_Context)this_rawctx

  if (systick.CTRL & CTRL_ENABLE_CounterEnabled) != 0 {
    // SysTick counter is enabled, update it by `step_time`
    new_systick_val := u32(max(
      i32(systick.VAL) - i32(step_time / SYSTICK_NANOS_TO_TICKS),
      0,
    ))

    // NOTE: No need to sync or atomics here as long as this doesn't get reordered
    ctx.change_was_internal = true
    sync.atomic_thread_fence(sync.Atomic_Memory_Order.Release)
    systick.VAL = new_systick_val

    if systick.VAL == 0 && systick.LOAD != 0 {
      /* A start value of 0 is possible, but has no effect because the SysTick
       * exception request and COUNTFLAG are activated when counting from 1 to 0.
       */
      systick.CTRL |= CTRL_COUNTFLAG_Offset

      // NOTE: No need to sync or atomics here as long as this doesn't get reordered
      ctx.change_was_internal = true
      sync.atomic_thread_fence(sync.Atomic_Memory_Order.Release)
      systick.VAL = systick.LOAD

      if (systick.CTRL & CTRL_TICKINT_InterruptEnabled) != 0 {
        // NOTE: SysTick interrupt enable is not in NVIC (no need to enable it)
        scb := cast(^mcu.SCB)mem.SCB_base

        vector_base := uintptr(mem.arena_base) + uintptr(scb.VTOR)
        vector_table := cast([^]#type proc "c"())(vector_base)

        vector_table[mcu.SysTick_IRQn]()
      }
    }
  }

  ctx.last_val = systick.VAL
}
