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

import "../../plugin"

Plugin_Memory :: struct {
  odin_ctx: runtime.Context,
  api: ^plugin.API,
}

@(export)
Plugin_init :: proc "c"(memory: rawptr, api: ^plugin.API, board_name: cstring, plugin_id: plugin.Id, plugin_rawmem: ^rawptr) -> bool
{
  plugin_mem: ^Plugin_Memory
  if plugin_rawmem^ == nil {
    // First time Plugin_init has been called
    context = runtime.default_context()
    plugin_mem = new(Plugin_Memory)
    plugin_mem.odin_ctx = context
    plugin_mem.api = api
  } else {
    plugin_mem = (cast(^^Plugin_Memory)plugin_rawmem)^
  }
  context = plugin_mem.odin_ctx

  ok :=      api.subscribe_event(memory, plugin_id, .GPIO, .GPIO_PB0)
  ok = ok && api.subscribe_event(memory, plugin_id, .SysTick, .SysTick_Interrupt)
  ok = ok && api.subscribe_event(memory, plugin_id, .NVIC, .NVIC_Interrupt)
  if !ok {
    fmt.eprintfln("Could not subscribe to core simulator events")
    return false
  }

  plugin_rawmem^ = plugin_mem
  return true
}

@(export)
Plugin_update :: proc "c"(plugin_rawmem: rawptr) -> (end_early: bool)
{
  plugin_mem := cast(^Plugin_Memory)plugin_rawmem
  context = plugin_mem.odin_ctx

  event: plugin.Recv_Event
  for plugin_mem.api.poll_event(plugin_mem.api.channel, &event) {
    switch plugin.Recv_Event_Kind(event.kind) {
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
Plugin_deinit :: proc "c"(plugin_rawmem: rawptr)
{
  plugin_mem := cast(^Plugin_Memory)plugin_rawmem
  context = plugin_mem.odin_ctx

  free(plugin_mem)
}
