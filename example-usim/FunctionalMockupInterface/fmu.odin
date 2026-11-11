#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package fmi_example

import "base:runtime"

import "core:fmt"
import "core:dynlib"

import "fmi3"

FunctionalMockupUnit :: struct {
  lib:      dynlib.Library,
  odin_ctx: runtime.Context,
  time:     fmi3.Float64,

  get_version:   fmi3.GetVersionTYPE,
  instantiate:   fmi3.InstantiateCoSimulationTYPE,
  free_instance: fmi3.FreeInstanceTYPE,
  enter_init:    fmi3.EnterInitializationModeTYPE,
  exit_init:     fmi3.ExitInitializationModeTYPE,
  terminate:     fmi3.TerminateTYPE,
  do_step:       fmi3.DoStepTYPE,

  set_f32: fmi3.SetFloat32TYPE,
  get_f32: fmi3.GetFloat32TYPE,
  set_f64: fmi3.SetFloat64TYPE,
  get_f64: fmi3.GetFloat64TYPE,

  set_i8: fmi3.SetInt8TYPE,
  get_i8: fmi3.GetInt8TYPE,
  set_u8: fmi3.SetUInt8TYPE,
  get_u8: fmi3.GetUInt8TYPE,
  set_i16: fmi3.SetInt16TYPE,
  get_i16: fmi3.GetInt16TYPE,
  set_u16: fmi3.SetUInt16TYPE,
  get_u16: fmi3.GetUInt16TYPE,
  set_i32: fmi3.SetInt32TYPE,
  get_i32: fmi3.GetInt32TYPE,
  set_u32: fmi3.SetUInt32TYPE,
  get_u32: fmi3.GetUInt32TYPE,
  set_i64: fmi3.SetInt64TYPE,
  get_i64: fmi3.GetInt64TYPE,
  set_u64: fmi3.SetUInt64TYPE,
  get_u64: fmi3.GetUInt64TYPE,

  set_bool: fmi3.SetBooleanTYPE,
  get_bool: fmi3.GetBooleanTYPE,

  set_cstring: fmi3.SetStringTYPE,
  get_cstring: fmi3.GetStringTYPE,

  set_binary: fmi3.SetBinaryTYPE,
  get_binary: fmi3.GetBinaryTYPE,

  set_clock: fmi3.SetClockTYPE,
  get_clock: fmi3.GetClockTYPE,

  instance: fmi3.Instance,
}

fmu_log :: proc "c"(env: fmi3.InstanceEnvironment, status: fmi3.Status,
                    category, message: fmi3.String) {
    if env == nil { return }
    fmu := cast(^FunctionalMockupUnit)env
    context = fmu.odin_ctx
    fmt.eprintfln("[FMU %v] %s: %s", status, category, message)
}

fmu_load :: proc(path: string) -> (fmu: FunctionalMockupUnit, ok: bool)
{
  load_symbol :: proc(lib: dynlib.Library, name: string) -> (rawptr, bool)
  {
    if ptr, found := dynlib.symbol_address(lib, name); found {
      return ptr, true
    }
    return nil, false
  }

  lib, lib_ok := dynlib.load_library(path)
  if !lib_ok { return {}, false }
  fmu.lib = lib
  fmu.odin_ctx = context

  fmu.get_version   = auto_cast load_symbol(lib, "fmi3GetVersion") or_return
  fmu.instantiate   = auto_cast load_symbol(lib, "fmi3InstantiateCoSimulation") or_return
  fmu.free_instance = auto_cast load_symbol(lib, "fmi3FreeInstance") or_return
  fmu.enter_init    = auto_cast load_symbol(lib, "fmi3EnterInitializationMode") or_return
  fmu.exit_init     = auto_cast load_symbol(lib, "fmi3ExitInitializationMode") or_return
  fmu.terminate     = auto_cast load_symbol(lib, "fmi3Terminate") or_return
  fmu.do_step       = auto_cast load_symbol(lib, "fmi3DoStep") or_return


  fmu.set_f32     = auto_cast load_symbol(lib, "fmi3SetFloat32") or_return
  fmu.get_f32     = auto_cast load_symbol(lib, "fmi3GetFloat32") or_return
  fmu.set_f64     = auto_cast load_symbol(lib, "fmi3SetFloat64") or_return
  fmu.get_f64     = auto_cast load_symbol(lib, "fmi3GetFloat64") or_return

  fmu.set_i8      = auto_cast load_symbol(lib, "fmi3SetInt8") or_return
  fmu.get_i8      = auto_cast load_symbol(lib, "fmi3GetInt8") or_return
  fmu.set_u8      = auto_cast load_symbol(lib, "fmi3SetUInt8") or_return
  fmu.get_u8      = auto_cast load_symbol(lib, "fmi3GetUInt8") or_return
  fmu.set_i16     = auto_cast load_symbol(lib, "fmi3SetInt16") or_return
  fmu.get_i16     = auto_cast load_symbol(lib, "fmi3GetInt16") or_return
  fmu.set_u16     = auto_cast load_symbol(lib, "fmi3SetUInt16") or_return
  fmu.get_u16     = auto_cast load_symbol(lib, "fmi3GetUInt16") or_return
  fmu.set_i32     = auto_cast load_symbol(lib, "fmi3SetInt32") or_return
  fmu.get_i32     = auto_cast load_symbol(lib, "fmi3GetInt32") or_return
  fmu.set_u32     = auto_cast load_symbol(lib, "fmi3SetUInt32") or_return
  fmu.get_u32     = auto_cast load_symbol(lib, "fmi3GetUInt32") or_return
  fmu.set_i64     = auto_cast load_symbol(lib, "fmi3SetInt64") or_return
  fmu.get_i64     = auto_cast load_symbol(lib, "fmi3GetInt64") or_return
  fmu.set_u64     = auto_cast load_symbol(lib, "fmi3SetUInt64") or_return
  fmu.get_u64     = auto_cast load_symbol(lib, "fmi3GetUInt64") or_return

  fmu.set_bool    = auto_cast load_symbol(lib, "fmi3SetBoolean") or_return
  fmu.get_bool    = auto_cast load_symbol(lib, "fmi3GetBoolean") or_return

  fmu.set_cstring = auto_cast load_symbol(lib, "fmi3SetString") or_return
  fmu.get_cstring = auto_cast load_symbol(lib, "fmi3GetString") or_return

  fmu.set_binary  = auto_cast load_symbol(lib, "fmi3SetBinary") or_return
  fmu.get_binary  = auto_cast load_symbol(lib, "fmi3GetBinary") or_return

  fmu.set_clock   = auto_cast load_symbol(lib, "fmi3SetClock") or_return
  fmu.get_clock   = auto_cast load_symbol(lib, "fmi3GetClock") or_return

  return fmu, true
}

fmu_instantiate :: proc(fmu: ^FunctionalMockupUnit) -> bool {
  fmu.instance = fmu.instantiate(
    instanceName = "usim_fmu",
    instantiationToken = "guid-here", // (from modelDescription.xml)
    resourcePath = ".",               // resourcePath
    visible = fmi3.False,
    loggingOn = fmi3.False,
    eventModeUsed = fmi3.False,
    earlyReturnAllowed = fmi3.False,
    requiredIntermediateValues = nil,
    nRequiredIntermediateVariables = 0,
    instanceEnvironment = cast(fmi3.InstanceEnvironment)fmu,
    logMessage = fmu_log,
    intermediateUpdate = nil,
  )
  if fmu.instance == nil {
    return false
  }

  if fmu.enter_init(fmu.instance, fmi3.False, 0, 0, fmi3.False, 0) != .OK {
    return false
  }

  // NOTE: Use fmu.set_x(...) here for starting values

  if fmu.exit_init(fmu.instance) != .OK {
    return false
  }

  fmu.time = 0
  return true
}

fmu_free :: proc(fmu: ^FunctionalMockupUnit) {
  if fmu.instance != nil {
    _ = fmu.terminate(fmu.instance)
    fmu.free_instance(fmu.instance)
    fmu.instance = nil
  }
  if fmu.lib != nil {
    dynlib.unload_library(fmu.lib)
    fmu.lib = nil
  }
}
