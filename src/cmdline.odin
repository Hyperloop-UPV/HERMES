#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package simulator

/* File containing command line parsing for simulator
 * Also includes cfg.json parsing
 *
 * Created on: 23 oct. 2026
 *   Author: victor
 */

import "base:runtime"
import "core:os"
import "core:fmt"
import "core:time"
import "core:flags"
import "core:dynlib"
import "core:strconv"
import "core:strings"
import "core:encoding/json"

SIM_CMDLINE_PARSING_STYLE :: flags.Parsing_Style.Unix

// TODO: Figure out how to integrate usims in command line parsing, for now it is done with cfg.

@(private="file")
Sim_Options_SemiParsed :: struct {
  //board: [dynamic]string `usage:"Board dynamic libraries"`,
  //usim: [dynamic]string `usage:"Micro simulators attached"`,
  max_iterations: int `usage:"Max iterations for the simulator"`,
  max_time: string `usage:"Max time for the simulator, starts counting after most of the initialization"`,
  /* Temporarily shutting down not using a cfg.json because
   * I have not modified the rest of the command line parsing
   */
  cfg: string `args:"required" usage:"config json file"`,
}

USim_Cfg_Options :: struct {
  dll: string,
  attached_boards: []cstring,
}

Sim_Options :: struct {
  board: []string,
  usim: []USim_Cfg_Options,
  max_iterations: int,
  max_time: time.Duration,
}

@(private="file")
parse_time :: proc(t: string) -> time.Duration
{
  p: int
  n, _ := strconv.parse_i64(t, n = &p)
  if n <= 0 {
    fmt.eprintfln("Could not parse time from max-time argument '%s': not a number or not greater than 0", t)
    os.exit(1)
  }

  tick := time.Duration(n)
  modified := t[p:]
  if len(modified) == 0 {
    fmt.eprintfln("Could not parse time from max-time argument '%s': no modifier, expected one of ['s','ms','us','ns']")
    os.exit(1)
  }

  switch modified {
    case "s":  tick *= 1000_000_000
    case "ms": tick *= 1000_000
    case "us": tick *= 1000
    case "ns": tick *= 1
  }

  return tick
}

parse_json_object_field :: proc(file, field, from: string, parent: json.Object, $T: typeid, obligatory := true) -> T
{
  element: T
  json_val, ok := parent[field]
  if ok {
    element, ok = json_val.(T)
  }
  if !ok {
    if !obligatory {
      return T{}
    }
    type_info := type_info_of(T).variant.(runtime.Type_Info_Named)
    fmt.eprintfln(
      "Could not parse cfg from '%s': expected %s to have a \"%s\" %s",
      file, from, field,
      type_info.name,
    )
    os.exit(1)
  }
  return element
}

parse_json_array :: proc(file, field, from: string, parent: json.Object, obligatory := true) -> json.Array
{
  return parse_json_object_field(file, field, from, parent, json.Array, obligatory)
}

parse_cfg_file :: proc(file: string, opt: ^Sim_Options)
{
  data, read_err := os.read_entire_file(file, context.temp_allocator)
  if read_err != nil {
    fmt.eprintfln("Could not read cfg file '%s': %v", file, read_err)
    os.exit(1)
  }

  json_data, err := json.parse(data)
  if err != nil {
    fmt.eprintfln("Could not parse json from '%s': %v", file, err)
    os.exit(1)
  }
  defer json.destroy_value(json_data)

  root, ok := json_data.(json.Object)
  if !ok {
    fmt.eprintfln("Could not parse cfg from '%s': %s", file,
      "expected root element to be an object",
    )
    os.exit(1)
  }

  boards := parse_json_array(file, "boards", "root object", root)

  opt.board = make([]string, len(boards))
  for val, idx in boards {
    board_name: string
    board_name, ok = val.(json.String)
    if !ok {
      fmt.eprintfln("Could not parse cfg from '%s': %s", file,
        "expected boards array to contain strings",
      )
      os.exit(1)
    }
    opt.board[idx] = fmt.aprintf("%s." + dynlib.LIBRARY_FILE_EXTENSION, board_name)
  }

  usims := parse_json_array(file, "usims", "root object", root, false)
  if usims != nil {
    opt.usim = make([]USim_Cfg_Options, len(usims))
    for val, idx in usims {
      cfg := &opt.usim[idx]

      obj: json.Object
      obj, ok = val.(json.Object)
      if !ok {
        fmt.eprintfln("Could not parse cfg file from '%s': %s", file,
          "expected objects in usims array",
        )
        os.exit(1)
      }

      cfg.dll = fmt.aprintf("%s." + dynlib.LIBRARY_FILE_EXTENSION,
        parse_json_object_field(file, "dll", "usims array element", obj, json.String),
      )
      attached := parse_json_object_field(file,
        "attached_boards", "usims array element",
        obj, json.Array,
      )

      cfg.attached_boards = make([]cstring, len(attached))
      for board_val, b_idx in attached {
        board_name: string
        board_name, ok = board_val.(json.String)
        if !ok {
          fmt.eprintfln("Could not parse cfg from '%s': %s", file,
            "expected attached_boards array to contain strings",
          )
          os.exit(1)
        }
        cfg.attached_boards[b_idx] = strings.clone_to_cstring(board_name)
      }
    }
  }
}

cmdline_parse :: proc() -> Sim_Options
{
  opt: Sim_Options_SemiParsed
  flags.parse_or_exit(&opt, os.args, SIM_CMDLINE_PARSING_STYLE)

  opt_result: Sim_Options
  //opt_result.board = opt.board
  //opt_result.usim = opt.usim
  opt_result.max_iterations = opt.max_iterations
  if opt.max_time != "" {
    opt_result.max_time = parse_time(opt.max_time)
  }
  if opt.cfg != "" {
    parse_cfg_file(opt.cfg, &opt_result)
  }
  return opt_result
}

cmdline_destroy :: proc(opt: ^Sim_Options)
{
  if opt.board != nil {
    for b in opt.board {
      delete(b)
    }
    delete(opt.board)
  }

  if opt.usim != nil {
    for u in opt.usim {
      delete(u.dll)
      for name in u.attached_boards {
        delete(name)
      }
      delete(u.attached_boards)
    }
    delete(opt.usim)
  }
}
