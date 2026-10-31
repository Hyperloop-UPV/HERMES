#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing a stub peripheral
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

import "core:time"

Stub_handler :: proc(rawctx, this_rawctx: rawptr) {}

Stub_setup :: proc(rawctx: rawptr) -> rawptr { return nil }

Stub_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration) {}
