#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package fmi_example

import "base:runtime"

import "core:fmt"

import "../../plugin"
import "fmi3"

Plugin_Memory :: struct {
  odin_ctx: runtime.Context,
  api: ^plugin.API,

  fmu: FunctionalMockupUnit,
}

First_init :: proc(plugin_mem: ^Plugin_Memory) -> bool
{
  ok: bool

  plugin_mem.fmu, ok = fmu_load("my_example_functional-mockup-unit.so")
  if !ok {
    fmt.eprintln("Could not load the functional mockup unit")
    return false
  }

  fmt.printfln("FMU FMI version: %s", plugin_mem.fmu.get_version())
  if !fmu_instantiate(&plugin_mem.fmu) {
    fmt.eprintln("Could not instantiate FMU")
    return false
  }

  return ok
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

    First_init(plugin_mem)
  } else {
    plugin_mem = (cast(^^Plugin_Memory)plugin_rawmem)^
  }
  context = plugin_mem.odin_ctx

  ok := api.subscribe_event(memory, plugin_id, .GPIO, .GPIO_PB0)
  if !ok {
    fmt.eprintfln("Could not subscribe to core simulator events in board %s", board_name)
    return false
  }

  plugin_rawmem^ = plugin_mem
  return true
}

@(export)
Plugin_step :: proc "c"(plugin_rawmem: rawptr, step_time: i64) -> (end_early: bool)
{
  plugin_mem := cast(^Plugin_Memory)plugin_rawmem
  context = plugin_mem.odin_ctx

  event: plugin.Recv_Event
  for plugin_mem.api.poll_event(plugin_mem.api.channel, &event) {
    #partial switch plugin.Recv_Event_Kind(event.kind) {
      case .GPIO: {
        // plugin_mem.fmu.set_bool(..., event.as.gpio.value)
      }
    }
  }

  dt_s := fmi3.Float64(step_time) / 1e9
  event_handling, terminate, early_return: fmi3.Boolean
  last_time: fmi3.Float64
  status := plugin_mem.fmu.do_step(
    instance = plugin_mem.fmu.instance,
    currentCommunicationPoint = plugin_mem.fmu.time,
    communicationStepSize = dt_s,
    noSetFMUStatePriorToCurrentPoint = fmi3.True,
    eventHandlingNeeded = &event_handling,
    terminateSimulation = &terminate,
    earlyReturn = &early_return,
    lastSuccessfulTime = &last_time,
  )
  if status != .OK {
    fmt.eprintfln("fmi3DoStep failed: %v", status)
    return true
  }
  plugin_mem.fmu.time += dt_s

  // NOTE: Read FMU outputs here with plugin_mem.fmu.get_x()

  return false
}

@(export)
Plugin_deinit :: proc "c"(plugin_rawmem: rawptr)
{
  plugin_mem := cast(^Plugin_Memory)plugin_rawmem
  context = plugin_mem.odin_ctx

  fmu_free(&plugin_mem.fmu)
  free(plugin_mem)
}
