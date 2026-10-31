#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package logger

/* File containing custom logger for simulator
 * Outputs local time instead of UTC
 *
 * Created on: 11 oct. 2026
 *   Author: victor
 */

import "base:runtime"

import "core:os"
import "core:fmt"
import "core:log"
import "core:time"
import "core:strings"
import "core:terminal"
import "core:time/datetime"
import "core:time/timezone"

@(private) global_subtract_stdout_options: log.Options
@(private) global_subtract_stderr_options: log.Options

@(init, private)
init_standard_stream_status :: proc "contextless" () {
	// NOTE(Feoramund): While it is technically possible for these streams to
	// be redirected during the runtime of the program, the cost of checking on
	// every single log message is not worth it to support such an
	// uncommonly-used feature.
	if terminal.color_enabled {
		context = runtime.default_context()

		// This is done this way because it's possible that only one of these
		// streams could be redirected to a file.
		if !terminal.is_terminal(os.stdout) {
			global_subtract_stdout_options = {.Terminal_Color}
		}
		if !terminal.is_terminal(os.stderr) {
			global_subtract_stderr_options = {.Terminal_Color}
		}
	} else {
		// Override any terminal coloring.
		global_subtract_stdout_options = {.Terminal_Color}
		global_subtract_stderr_options = {.Terminal_Color}
	}
}

Logger_Data :: struct {
  using file_logger: log.File_Console_Logger_Data,
  region: ^datetime.TZ_Region,
}

_file_logger_proc :: proc(h: ^os.File, ident: string, level: log.Level, text: string, t: time.Time, options: log.Options, location: runtime.Source_Code_Location)
{
  backing: [1024]byte
  buf := strings.builder_from_bytes(backing[:])

  log.do_level_header(options, &buf, level)

  when time.IS_SUPPORTED {
    log.do_time_header(options, &buf, t)
  }

  log.do_location_header(options, &buf, location)

  if .Thread_Id in options {
    fmt.sbprintf(&buf, "[{}] ", os.get_current_thread_id())
  }

  if ident != "" {
		fmt.sbprintf(&buf, "[%s] ", ident)
	}

  fmt.fprintf(h, "%s%s\n", strings.to_string(buf), text)
}

logger_proc :: proc(logger_data: rawptr, level: log.Level, text: string, options: log.Options, location := #caller_location)
{
  options := options
  data := cast(^Logger_Data)logger_data
  h: ^os.File = nil
  if level < log.Level.Error {
    h = os.stdout
    options -= global_subtract_stdout_options
  } else {
    h = os.stderr
    options -= global_subtract_stderr_options
  }

  date: datetime.DateTime
  ok: bool

  t := time.now()
  date, ok = time.time_to_datetime(t)
  if !ok {
    fmt.eprintln("Could not convert time to datetime")
    os.exit(1)
  }
  date, ok = timezone.datetime_to_tz(date, data.region)
  if !ok {
    fmt.eprintln("Could not convert datetime to local time")
    os.exit(1)
  }
  t, ok = time.datetime_to_time(date)
  if !ok {
    fmt.eprintln("Could not convert datetime to time")
    os.exit(1)
  }

  _file_logger_proc(h, data.ident, level, text, t, options, location)
}

create_logger :: proc(lowest := log.Level.Debug, opt := log.Default_Console_Logger_Opts, ident := "", allocator := context.allocator) -> log.Logger
{
  data := new(Logger_Data, allocator)
  data.file_handle = nil
  data.ident = ident

  ok: bool
  data.region, ok = timezone.region_load("local")
  if !ok {
    fmt.eprintfln("Could not fetch local timezone info")
    os.exit(1)
  }
  return log.Logger{logger_proc, data, lowest, opt}
}

destroy_logger :: proc(log: log.Logger, allocator := context.allocator)
{
  timezone.region_destroy((cast(^Logger_Data)log.data).region, allocator)
  free(log.data, allocator)
}