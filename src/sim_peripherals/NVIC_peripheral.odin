#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing NVIC simulation for core_cm7
 *
 * Created on: 9 oct. 2026
 *   Author: victor
 */

import "core:time"
import "core:slice"

import "../../usim"

/*
When an ISER bit gets set, the same ICER bit needs to be set from handler
and when ICER bit gets set, both that bit and the one from ISER need to be cleared from handler. Same for ISPR and ICPR
*/

@(private="file")
NVIC_Context :: struct {
  prev_ISER: [8]u32,
  prev_ICER: [8]u32,
  prev_ISPR: [8]u32,
  prev_ICPR: [8]u32,
}

@(private="file")
call_interrupt :: proc(memory: ^Memory, int_idx: u8)
{
  vtor := memory.SCB_base.VTOR

  vector_addr := (uintptr(memory.arena_base) +
    uintptr(vtor) + uintptr(int_idx) * size_of(rawptr)
  )
  vector := cast(#type proc "c"())rawptr(vector_addr)

  vector()

  event: usim.Event
  event.as.nvic.interrupt_idx = int_idx
  enqueue_event(memory, &event, .NVIC)
}

NVIC_handler :: proc(rawctx, this_rawctx: rawptr)
{
  memory := cast(^Memory)rawctx
  nvic := memory.NVIC_base
  ctx := cast(^NVIC_Context)this_rawctx

  if nvic.ICER != ctx.prev_ICER {
    // any bits not set in ISER won't have any effect when written to in ICER
    clear_bits := (nvic.ISER & nvic.ICER)
    // XOR since we want any new ICER bits to clear ISER bits
    next_ISER := nvic.ISER ~ clear_bits
    next_ICER := next_ISER

    nvic.ISER = next_ISER
    nvic.ICER = next_ICER

    ctx.prev_ISER = next_ISER
    ctx.prev_ICER = next_ICER
  }

  if nvic.ISER != ctx.prev_ISER {
    nvic.ICER = nvic.ISER
    ctx.prev_ICER = nvic.ICER
  }

  if nvic.ICPR != ctx.prev_ICPR {
    // any bits not set in ISPR won't have any effect when written to in ICPR
    clear_bits := (nvic.ISPR & nvic.ICPR)
    // XOR since we want any new ICPR bits to clear ISPR bits
    next_ISPR := nvic.ISPR ~ clear_bits
    next_ICPR := next_ISPR

    nvic.ISPR = next_ISPR
    nvic.ICPR = next_ICPR

    ctx.prev_ISPR = next_ISPR
    ctx.prev_ICPR = next_ICPR
  }

  if nvic.ISPR != ctx.prev_ISPR {
    nvic.ICPR = nvic.ISPR
    ctx.prev_ICPR = nvic.ICPR
  }

  if nvic.STIR != 0 {
    // ref manual says only low 8 bits can be used here
    call_interrupt(memory, u8(nvic.STIR))
  }
}

NVIC_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx

  ctx := new(NVIC_Context, memory.arena_allocator)
  ctx.prev_ISER = 0
  ctx.prev_ICER = 0
  ctx.prev_ISPR = 0
  ctx.prev_ICPR = 0

  return ctx
}

NVIC_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{
  Pending_Struct :: struct {
    idx, priority: u8,
  }

  memory := cast(^Memory)rawctx
  nvic := memory.NVIC_base

  pending: [dynamic; size_of(nvic.ISPR)]Pending_Struct

  // gather all pending interrupts
  for word, word_idx in nvic.ISPR {
    // loop through each bit
    for idx: u8 = 0; idx < 32; idx += 1 {
      bit := u32(1 << idx)
      if ((word & bit) == bit) && ((nvic.IABR[word_idx] & bit) == bit) {
        pend: Pending_Struct = ---
        pend.idx = u8(word_idx)*32 + idx
        pend.priority = nvic.IP[pend.idx*8]
        append(&pending, pend)
      }
    }
  }

  // from low bits of ISPR to high bits when equal priority
  slice.stable_sort_by(pending[:],
    proc(i, j: Pending_Struct) -> bool { return i.priority < j.priority },
  )

  for pend in pending {
    call_interrupt(memory, pend.idx)
  }
}
