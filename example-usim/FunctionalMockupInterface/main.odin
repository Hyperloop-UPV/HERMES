#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package fmi_example

import "base:runtime"

import "core:fmt"

import "../../usim"
import "fmi3"

USim_Memory :: struct {
  odin_ctx: runtime.Context,
  api: ^usim.API,

  fmu: FunctionalMockupUnit,
}

First_init :: proc(usim_mem: ^USim_Memory) -> bool
{
  ok: bool

  usim_mem.fmu, ok = fmu_load("my_example_functional-mockup-unit.so")
  if !ok {
    fmt.eprintln("Could not load the functional mockup unit")
    return false
  }

  fmt.printfln("FMU FMI version: %s", usim_mem.fmu.get_version())
  if !fmu_instantiate(&usim_mem.fmu) {
    fmt.eprintln("Could not instantiate FMU")
    return false
  }

  return ok
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

    First_init(usim_mem)
  } else {
    usim_mem = (cast(^^USim_Memory)usim_rawmem)^
  }
  context = usim_mem.odin_ctx

  ok := api.subscribe_event(memory, usim_id, .GPIO, .GPIO_PB0)
  if !ok {
    fmt.eprintfln("Could not subscribe to core simulator events in board %s", board_name)
    return false
  }

  usim_rawmem^ = usim_mem
  return true
}

@(export)
USim_step :: proc "c"(usim_rawmem: rawptr, step_time: i64) -> (end_early: bool)
{
  usim_mem := cast(^USim_Memory)usim_rawmem
  context = usim_mem.odin_ctx

  event: usim.Event
  for usim_mem.api.poll_event(usim_mem.api.channel, &event) {
    #partial switch usim.Event_Kind(event.kind) {
      case .GPIO: {
        // usim_mem.fmu.set_bool(..., event.as.gpio.value)
      }
    }
  }

  dt_s := fmi3.Float64(step_time) / 1e9
  event_handling, terminate, early_return: fmi3.Boolean
  last_time: fmi3.Float64
  status := usim_mem.fmu.do_step(
    instance = usim_mem.fmu.instance,
    currentCommunicationPoint = usim_mem.fmu.time,
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
  usim_mem.fmu.time += dt_s

  return false
}

@(export)
USim_deinit :: proc "c"(usim_rawmem: rawptr)
{
  usim_mem := cast(^USim_Memory)usim_rawmem
  context = usim_mem.odin_ctx

  fmu_free(&usim_mem.fmu)
  free(usim_mem)
}
