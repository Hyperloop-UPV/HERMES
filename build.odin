#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package build

/* File containing build script for simulator
 * Usage:
 * `odin build . -out:build[.exe]`
 * `./build [debug|release|rel-debug] [-disable-profiling] [-run]`
 *
 * Created on: 11 oct. 2026
 *   Author: victor
 */

import "core:slice"
import "base:runtime"
import "base:intrinsics"

import "core:os"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:flags"
import "core:dynlib"
import "core:reflect"

import custom_log "src/logger"

import "usim"

SIMULATOR_NAME :: "hermes"

when ODIN_OS == .Windows {
  SIMULATOR_EXE :: SIMULATOR_NAME + ".exe"
} else {
  SIMULATOR_EXE :: SIMULATOR_NAME
}

OUTPUT_DIR :: #config(OUTPUT_DIR, "bin")

Build_Mode :: enum {
  debug,
  release,
  /* release with debug info */
  rel_debug,
}

Build_Options :: struct {
  mode: Build_Mode `args:"pos=0" usage:"Build mode, can be debug, release or rel-debug for release with debug info"`,
  disable_profiling: bool `usage:"Disable or enable profiling. Profiling is enabled by default"`,
  run: bool `usage:"Also run the simulator after building"`,
  build_example_usims: bool `usage:"Build example usims"`,
}

run_command :: proc(cmd: []string, cwd := ".") -> (ok: bool)
{
  desc := os.Process_Desc{
    command = cmd,
    working_dir = cwd,
  }
  log.infof("Running %v", cmd)
  state, stdout, stderr, err := os.process_exec(desc, context.temp_allocator)
  if err != nil {
    log.errorf("Could not start process %v: %v", cmd, err)
    return
  }

  if len(stdout) != 0 {
    fmt.print(string(stdout))
  }
  if len(stderr) != 0 {
    fmt.eprint(string(stderr))
  }

  if state.exit_code != 0 {
    log.errorf("%s exited with return code %d", cmd[0], state.exit_code)
  } else {
    ok = true
  }

  return
}

append_odin_options :: proc(cmd: ^[dynamic; 256]string, opt: Build_Options)
{
  if opt.mode == .debug || opt.mode == .rel_debug {
    append(cmd, "-debug")
  }

  if opt.mode == .release || opt.mode == .rel_debug {
    append(cmd, "-o:speed", "-no-type-assert", "-no-bounds-check")
  } else {
    // it's getting annoying for debugging
    append(cmd, "-no-bounds-check")
  }
}

build_usims :: proc(opt: Build_Options) -> bool
{
  VIS_BUILD_SCRIPT :: "build" when ODIN_OS != .Windows else "build.exe"
  cmd: [dynamic; 256]string

  ///////////////////////////////////////
  // GUI visualization example

  cur_dir, _ := os.get_working_directory(context.temp_allocator)
  if !os.exists("example-usim/vis/" + VIS_BUILD_SCRIPT) {
    when ODIN_OS == .Windows {
      // requires msvc compiler
      append(&cmd, "cl", "build.c")
    } else {
      append(&cmd, "gcc", "build.c", "-o", VIS_BUILD_SCRIPT)
    }
    run_command(cmd[:], "example-usim/vis") or_return
    clear(&cmd)
  }
  append(&cmd, "example-usim/vis/" + VIS_BUILD_SCRIPT)
  if !run_command(cmd[:], "example-usim/vis") {
    os.change_directory(cur_dir)
    return false
  }
  clear(&cmd)
  os.change_directory(cur_dir)

  ///////////////////////////////////////
  // first and most simple example

  append(&cmd,
    "odin", "build", "example-usim/first",
    "-out:bin/usim_example." + dynlib.LIBRARY_FILE_EXTENSION,
    "-error-pos-style:unix",
    "-collection:mcu=mcu",
    "-build-mode:shared",
  )
  append_odin_options(&cmd, opt)
  run_command(cmd[:]) or_return
  clear(&cmd)

  ///////////////////////////////////////
  // functional mockup interface example

  append(&cmd,
    "odin", "build", "example-usim/FunctionalMockupInterface",
    "-out:bin/usim_example_with_fmi." + dynlib.LIBRARY_FILE_EXTENSION,
    "-error-pos-style:unix",
    "-collection:mcu=mcu",
    "-build-mode:shared",
  )
  append_odin_options(&cmd, opt)
  run_command(cmd[:]) or_return
  clear(&cmd)

  return true
}

build_sim :: proc(opt: Build_Options) -> bool
{
  cmd: [dynamic; 256]string
  append(&cmd,
    "odin", "build", "src",
    "-out:" + SIMULATOR_EXE,
    "-error-pos-style:unix",
    /* import mcu "mcu:stm32h723xx" */
    "-collection:mcu=mcu",
  )
  append_odin_options(&cmd, opt)
  run_command(cmd[:]) or_return
  clear(&cmd)

  return true
}

build_board :: proc(opt: Build_Options) -> bool
{
  cmd: [dynamic; 256]string

  append(&cmd, "gcc",
    "example-board/src/main.cpp",
    "example-board/src/system_stm32h7xx.c",
    "-DSTM32H723xx",
    "-DSIMULATOR_BUILD",
    "-shared",
    "-o", OUTPUT_DIR + "/test." + dynlib.LIBRARY_FILE_EXTENSION,
    "-Wall", "-Wextra",
    "-I", "example-board/inc",
    "-Wl,--gc-sections",
    "-fno-threadsafe-statics",
  )

  when ODIN_OS == .Windows {
    append(&cmd, "-Wl,--export-all-symbols")
  } else {
    append(&cmd, "-fPIC")
  }

  if opt.mode == .debug || opt.mode == .rel_debug {
    append(&cmd, "-ggdb")
  }

  if opt.mode == .release || opt.mode == .rel_debug {
    append(&cmd, "-O2")
  }

  run_command(cmd[:]) or_return
  clear(&cmd)

  return true
}

build :: proc(opt: Build_Options) -> bool
{
  build_sim(opt) or_return
  build_board(opt) or_return
  if opt.build_example_usims {
    build_usims(opt) or_return
  }

  return true
}

do_linux_syscalls_codegen :: proc() -> bool
{
  when ODIN_OS == .Linux {
    cmd := []string{
      "gcc",
      "ioctl_defs_linux.c",
      "-o", "../bin/codegen",
      "-Wall", "-Wextra",
      "-Werror",
    }

    run_command(cmd, cwd = "codegen") or_return

    cmd = []string{
      "bin/codegen",
    }

    run_command(cmd) or_return
  }

  return true
}

write_string :: proc(f: ^os.File, s: string) {
  _, err := os.write_string(f, s)
  if err != nil {
    fmt.eprintfln("could not write codegen string '%s': %v", s, err)
    os.exit(1)
  }
}

C_print_any_elem_from_odin :: proc(f: ^os.File, type: ^reflect.Type_Info, name: string, known_type_names: []string, indentation := 2, indent_width := 2, prefix := "USim_")
{
  indent_buf: [32]u8
  mem.set(&indent_buf, ' ', len(indent_buf))
  indent := string(indent_buf[:indentation])

  switch v in reflect.type_info_base(type).variant {
    case runtime.Type_Info_Named: {
      // should not be a field in a struct
      assert(false)
    }
    case runtime.Type_Info_Parameters: {
      // should not be a field in a struct
      assert(false)
    }

    case runtime.Type_Info_Complex: { assert(false, "unsupported") }
    case runtime.Type_Info_Quaternion: { assert(false, "unsupported") }
    case runtime.Type_Info_Any: { assert(false, "unsupported") }
    case runtime.Type_Info_Type_Id: { assert(false, "unsupported") }
    case runtime.Type_Info_Enumerated_Array: { assert(false, "unsupported") }
    case runtime.Type_Info_Union: { assert(false, "unsupported") }
    case runtime.Type_Info_Map: {
      write_string(f, fmt.tprintf("uint8_t %s[%d]", name, size_of(runtime.Raw_Map)))
      return
    }
    case runtime.Type_Info_Simd_Vector: { assert(false, "unsupported") }
    case runtime.Type_Info_Matrix: { assert(false, "unsupported") }
    case runtime.Type_Info_Soa_Pointer: { assert(false, "unsupported") }
    case runtime.Type_Info_Bit_Field: { assert(false, "unsupported") }
    // NOTE: not sure about fixed capacity dynamic array, might be easy but I don't
    //       think I have debug info for it so I can't know the implementation without
    //       looking at the odin compiler source code
    case runtime.Type_Info_Fixed_Capacity_Dynamic_Array: { assert(false, "unsupported") }

    case runtime.Type_Info_Integer: {
      type_name: string
      switch type.size {
        case 1: type_name = "int8_t" if v.signed else "uint8_t"
        case 2: type_name = "int16_t" if v.signed else "uint16_t"
        case 4: type_name = "int32_t" if v.signed else "uint32_t"
        case 8: type_name = "int64_t" if v.signed else "uint64_t"
        case: assert(false, "unsupported integer size")
      }
      s := fmt.tprintf("%s", type_name)
      write_string(f, s)
    }

    case runtime.Type_Info_Rune: {
      write_string(f, "uint32_t")
    }

    case runtime.Type_Info_Float: {
      type_name: string
      switch type.size {
        case 4: type_name = "float"
        case 8: type_name = "double"
        case: assert(false, "unsupported float size")
      }
      write_string(f, type_name)
    }

    case runtime.Type_Info_String: {
      // odin cstring and odin string (utf8 encoded)
      type_name := "const char*" if v.is_cstring else \
        "struct { const char* items; size_t count; }"
      write_string(f, type_name)
    }

    case runtime.Type_Info_Boolean: {
      write_string(f, "bool")
    }

    // prefer int *a from int * a
    case runtime.Type_Info_Pointer: {
      // e.g. "int*", "void*"
      if v.elem == nil {
        write_string(f, "void *")
        write_string(f, name)
        return
      } else {
        C_print_any_elem_from_odin(f, v.elem, "", known_type_names, indentation, indent_width)
        write_string(f, "*")
        write_string(f, name)
        return
      }
    }
    case runtime.Type_Info_Multi_Pointer: {
      // multi pointer is the same for C as pointer
      if v.elem == nil {
        write_string(f, "void *")
        write_string(f, name)
        return
      } else {
        C_print_any_elem_from_odin(f, v.elem, "", known_type_names, indentation, indent_width)
        write_string(f, "*")
        write_string(f, name)
        return
      }
    }

    case runtime.Type_Info_Procedure: {
      // commented out because odin "core:sync/chan" chan.Chan uses procedures as attributes
      //CDecl :: 3
      //fmt.assertf(v.convention == runtime.Calling_Convention(CDecl),
      //  "Calling convention must be Cdecl (\"c\") to translate it into C function pointer",
      //)
      fmt.assertf(!v.variadic, "varadic procedures are not supported")

      result_types: []^runtime.Type_Info
      if v.results != nil {
        results := v.results.variant.(runtime.Type_Info_Parameters)
        // commented out because odin "core:sync/chan" chan.Chan uses procedures with more than 1 return value
        //fmt.assertf(len(results.types) <= 1, "procedures with more than one return are not supported")
        result_types = results.types
      }

      if len(result_types) == 0 {
        write_string(f, "void (*")
      } else {
        C_print_any_elem_from_odin(f, result_types[0], "", known_type_names)
        write_string(f, "(*")
      }
      write_string(f, name)
      write_string(f, ")(")

      if v.params != nil {
        params := v.params.variant.(runtime.Type_Info_Parameters)
        for idx := 0; idx < len(params.types); idx += 1 {
          C_print_any_elem_from_odin(f, params.types[idx], params.names[idx], known_type_names, indentation, indent_width)
          if idx != (len(params.types) - 1) {
            write_string(f, ", ")
          }
        }
        write_string(f, ")")
      }

      return
    }

    case runtime.Type_Info_Array: {
      C_print_any_elem_from_odin(f, v.elem, "", known_type_names, indentation, indent_width)
      write_string(f, fmt.tprintf("%s[%d]", name, v.count))
      return
    }

    case runtime.Type_Info_Dynamic_Array: {
      // [dynamic]type -> struct{ type* items; size_t count; size_t capacity; }
      write_string(f, "struct{ ")
      C_print_any_elem_from_odin(f, v.elem, "", known_type_names, indentation, indent_width)
      write_string(f, "* items; size_t count; size_t capacity; }")
    }

    case runtime.Type_Info_Slice: {
      // []type -> struct{ const type* items; size_t count; }
      write_string(f, "struct{ const ")
      C_print_any_elem_from_odin(f, v.elem, "", known_type_names, indentation, indent_width)
      write_string(f, "* items; size_t count; }")
    }

    case runtime.Type_Info_Struct: {
      found: bool = false

      named, is_named := type.variant.(runtime.Type_Info_Named)
      if is_named {
        _, found = slice.linear_search(known_type_names, named.name)
        if found {
          write_string(f, prefix)
          write_string(f, named.name)
        }
      }

      if !found {
        if .raw_union in v.flags {
          write_string(f, "union {\n")
        } else {
          write_string(f, "struct {\n")
        }
        for idx: i32 = 0; idx < v.field_count; idx += 1 {
          write_string(f, indent)
          C_print_any_elem_from_odin(f, v.types[idx], v.names[idx], known_type_names, indentation + indent_width, indent_width)
          write_string(f, ";\n")
        }
        write_string(f, indent[:len(indent) - indent_width])
        write_string(f, "}")
      }
    }

    case runtime.Type_Info_Enum: {
      named := type.variant.(runtime.Type_Info_Named)
      write_string(f, prefix)
      write_string(f, named.name)
    }

    case runtime.Type_Info_Bit_Set: {
      // bit_set[Type; Underlying] -> Underlying
      C_print_any_elem_from_odin(f, v.underlying, "", known_type_names)
    }
  }

  write_string(f, " ")
  write_string(f, name)
}

C_struct_from_odin_struct :: proc(f: ^os.File, t: reflect.Type_Info_Struct, known_type_names: []string, indentation := 2, indent_width := 2, prefix := "USim_")
{
  indent_buf: [32]u8
  mem.set(&indent_buf, ' ', len(indent_buf))
  indent := string(indent_buf[:indentation])

  for idx: i32 = 0; idx < t.field_count; idx += 1 {
    type := t.types[idx]
    name := t.names[idx]

    write_string(f, indent)
    found: bool = false
    if reflect.is_struct(type) {
      named := type.variant.(runtime.Type_Info_Named)
      _, found = slice.linear_search(known_type_names, named.name)
      if found {
        write_string(f, prefix)
        write_string(f, named.name)
        write_string(f, " ")
        write_string(f, name)
        write_string(f, ";\n")
        continue
      }
    }

    C_print_any_elem_from_odin(f, type, name, known_type_names, indentation + indent_width, indent_width, prefix)
    write_string(f, ";\n")
  }
}

do_usim_codegen :: proc() -> bool
{
  write_struct :: proc(f: ^os.File, known_structs: []string, $T: typeid, name: string) {
    prefix := "USim_"
    name_with_prefix := fmt.tprintf("%s%s", prefix, name)

    write_string(f, "typedef struct ")
    write_string(f, name_with_prefix)
    write_string(f, " {\n")
    type_named := type_info_of(T).variant.(runtime.Type_Info_Named)
    type := type_named.base.variant.(runtime.Type_Info_Struct)
    C_struct_from_odin_struct(f, type, known_structs, prefix = prefix)
    write_string(f, "} ")
    write_string(f, name_with_prefix)
    write_string(f, ";\n\n")
  }

  os.make_directory("usim")
  output_lib := "usim/usim.h"
  f, err := os.open(output_lib, {.Write, .Trunc, .Create})
  fmt.assertf(err == nil, "could not open '%s' file for writing: %v", output_lib, err)
  defer os.close(f)

  known_structs := []string{
    "Event_Info",
    "Event",
    "GPIO_Mod_Event",
    "SysTick_Event",
    "NVIC_Event",
    "TIM_Event",
    "API",
    "Recv_Channel",
  }

  write_string(f,
    "#ifndef USIM_H\n" +
    "#define USIM_H\n" +
    "\n",
  )

  write_string(f,
    "/* THIS IS AN AUTOGENERATED FILE, DO NOT MODIFY */\n\n",
  )

  write_string(f,
    "/* File containing micro simulator API in C/C++\n" +
    " *\n" +
    " * Created on: 24 oct. 2026\n" +
    " *   Author: victor\n" +
    " */\n" +
    "\n",
  )

  write_string(f,
    "#include <stdint.h>\n" +
    "#include <stddef.h>\n" +
    "#include <stdbool.h>\n\n",
  )

  write_string(f, "#define USIM_API_VERSION_MAJOR ")
  write_string(f, usim.API_VERSION_MAJOR)
  write_string(f, "\n#define USIM_API_VERSION_MINOR ")
  write_string(f, usim.API_VERSION_MINOR)
  write_string(f, "\n#define USIM_API_VERSION_PATCH ")
  write_string(f, usim.API_VERSION_PATCH)
  write_string(f,
    "\n#define USIM_API_VERSION \\\n" +
    "  USIM_API_VERSION_MAJOR \".\" \\\n" +
    "  USIM_API_VERSION_MINOR \".\" \\\n" +
    "  USIM_API_VERSION_PATCH\n" +
    "\n",
  )

  write_string(f, "typedef enum USim_Event_Kind {\n")
  for kind in reflect.enum_fields_zipped(usim.Event_Kind) {
    line := fmt.tprintfln("  %s%s = %v,", "Event_Kind_", kind.name, i64(kind.value))
    write_string(f, line)
  }
  write_string(f, "} USim_Event_Kind;\n\n")

  write_string(f, "typedef enum USim_Event_Variant {\n")
  for kind in reflect.enum_fields_zipped(usim.Event_Variant) {
    line := fmt.tprintfln("  %s%s = %v,", "Event_Variant_", kind.name, i64(kind.value))
    write_string(f, line)
  }
  write_string(f, "} USim_Event_Variant;\n\n")

  write_struct(f, known_structs, usim.GPIO_Event, "GPIO_Mod_Event")
  write_struct(f, known_structs, usim.SysTick_Event, "SysTick_Event")
  write_struct(f, known_structs, usim.NVIC_Event, "NVIC_Event")
  write_struct(f, known_structs, usim.TIM_Event, "TIM_Event")

  write_string(f, "typedef union USim_Event_Info {\n")
  event_info_named := type_info_of(usim.Event_Info).variant.(runtime.Type_Info_Named)
  event_info := event_info_named.base.variant.(runtime.Type_Info_Struct)
  C_struct_from_odin_struct(f, event_info, known_structs, prefix = "USim_")
  write_string(f, "} USim_Event_Info;\n\n")

  write_struct(f, known_structs, usim.Event, "Event")

  write_string(f, "typedef void* USim_Recv;\n\n")

  write_struct(f, known_structs, usim.API, "API")

  write_string(f, "#endif // USIM_H\n")

  return true
}

do_codegen :: proc() -> bool
{
  do_usim_codegen() or_return
  do_linux_syscalls_codegen() or_return

  return true
}

main :: proc()
{
  context.logger = custom_log.create_logger(opt = {.Level, .Time, .Terminal_Color})
  defer custom_log.destroy_logger(context.logger)

  opt: Build_Options
  flags.parse_or_exit(&opt, os.args, .Unix)

  os.mkdir(OUTPUT_DIR)

  if !do_codegen() {
    log.error("Codegen failed")
    os.exit(1)
  }

  if !build(opt) {
    log.error("Build failed")
    os.exit(1)
  }

  if opt.run {
    ok := run_command({
      "sim",
      "--cfg", "cfg.json",
    })
    if !ok {
      os.exit(1)
    }
  }
}
