#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package example_usim

/* File containing very simple example of a micro simulator implemented in odin
 *
 * Created on: 25 oct. 2026
 *   Author: victor
 */

import "base:runtime"
import "core:fmt"
import "core:time"

import "../../usim"

USim_Memory :: struct {
  odin_ctx: runtime.Context,
  api: ^usim.API,
}

@(export)
USim_init :: proc "c"(memory: rawptr, api: ^usim.API, board_name: cstring, usim_id: usim.Id, usim_rawmem: ^rawptr) -> bool
{
  usim_mem: ^USim_Memory
  if usim_rawmem^ == nil {
    // First time USim_init has been called
    context = runtime.default_context()
    usim_mem = new(USim_Memory)
    usim_mem.odin_ctx = context
    usim_mem.api = api
  } else {
    usim_mem = (cast(^^USim_Memory)usim_rawmem)^
  }
  context = usim_mem.odin_ctx

  ok :=      api.subscribe_event(memory, usim_id, .GPIO, .GPIO_PB0)
  ok = ok && api.subscribe_event(memory, usim_id, .SysTick, .SysTick_Interrupt)
  ok = ok && api.subscribe_event(memory, usim_id, .NVIC, .NVIC_Interrupt)
  if !ok {
    fmt.eprintfln("Could not subscribe to core simulator events")
    return false
  }

  usim_rawmem^ = usim_mem
  return true
}

@(export)
USim_update :: proc "c"(usim_rawmem: rawptr) -> (end_early: bool)
{
  usim_mem := cast(^USim_Memory)usim_rawmem
  context = usim_mem.odin_ctx

  event: usim.Event
  for usim_mem.api.poll_event(usim_mem.api.channel, &event) {
    switch usim.Event_Kind(event.kind) {
      case .Quit: {}
      case .Count: {}

      case .GPIO: {
        fmt.printfln("GPIO P%c%d modified in %s board. New value: %d",
          u8(event.variant / 0x10) + 'A',
          event.variant % 0x10,
          event.board_name,
          event.as.gpio.value,
        )
      }

      case .SysTick: {
        fmt.println("SysTick interrupt got called")
      }

      case .NVIC: {
        fmt.printfln("NVIC interrupt idx %u got called",
          event.as.nvic.interrupt_idx,
        )
      }

      case .TIM: {
        fmt.printfln("TIM%d interrupt got called", event.variant)
      }
    }
  }

  time.sleep(200*time.Millisecond)
  return false
}

@(export)
USim_deinit :: proc "c"(usim_rawmem: rawptr)
{
  usim_mem := cast(^USim_Memory)usim_rawmem
  context = usim_mem.odin_ctx

  free(usim_mem)
}
