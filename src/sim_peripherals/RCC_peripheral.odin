#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing Reset and Clock Control simulation for STM32H723xx
 * It is currently unfinished but works for what is being simulated
 *
 * Created on: 11 oct. 2026
 *   Author: victor
 */

import "core:time"

// NOTE: I don't think we need to simulate anything for RCC for a
//       basic toggle-led demo

// However we should check what is necessary to simulate here.
// Timers for example will have to use RCC which implies
// if the clock of the timer is disabled in the RCC then enabled
// after, it should start the timer counter if its counter enable bit is on

RCC_handler :: proc(rawctx, this_rawctx: rawptr)
{

}

RCC_setup :: proc(rawctx: rawptr) -> rawptr
{

  return nil
}

RCC_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{

}

