#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing NVIC simulation for core_cm7
 * It is currently unfinished but works for what is being simulated
 *
 * Created on: 9 oct. 2026
 *   Author: victor
 */

import "core:time"

NVIC_handler :: proc(rawctx, this_rawctx: rawptr)
{

}

NVIC_setup :: proc(rawctx: rawptr) -> rawptr
{
  //mem := cast(^Memory)rawctx
  //nvic := cast(^mcu.NVIC)mem.NVIC_base

  return nil
}

NVIC_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{

}
