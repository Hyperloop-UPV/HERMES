#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
#+build windows
package simulator_platform

/* File containing
 *  - OS specific implementations of any needed functionality not in standard library
 * for windows
 *
 * Created on: 11 oct. 2026
 *   Author: victor
 */

import "core:os"
import "core:fmt"
import "core:log"
import "core:c/libc"

import win "core:sys/windows"

@(private="file")
internal_signal_handler: proc "contextless"()

@(private="file")
signal_handler :: proc "system"(ctrl_type: win.DWORD) -> win.BOOL
{
  libc.printf("in windows signal handler\n")
  if (ctrl_type == win.CTRL_C_EVENT) || (ctrl_type == win.CTRL_BREAK_EVENT) || (ctrl_type == win.CTRL_CLOSE_EVENT) {
    if internal_signal_handler != nil {
      internal_signal_handler()
    }
    os.exit(1)
    // (never gets here) return true
  }
  // we don't handle other ctrl_type events here
  return false
}

setup_signal_handler :: proc(handler: proc "contextless"())
{
  internal_signal_handler = handler

  if !win.SetConsoleCtrlHandler(signal_handler, win.TRUE) {
    fmt.eprintfln("[win32] Could not set signal handler: %v", win.GetLastError())
    os.exit(1)
  }

  // Do we want to catch the following:
	// - Asserts and panics;
	// - Out of Bounds exeptions;
	// - Arithmetic errors; and
	// - Segmentation faults (illegal memory access).
	// ? Then use this
	// win.AddVectoredExceptionHandler(0, signal_handler)
}

init_memory :: proc(totalMem: uint) -> rawptr
{
  MEM_WRITE_WATCH :: 0x00200000

  base := win.VirtualAlloc(nil,
    totalMem,
    win.MEM_COMMIT | win.MEM_RESERVE | MEM_WRITE_WATCH,
    win.PAGE_READWRITE,
  )
  if base == nil {
    log.errorf("[Win32] Could not allocate memory for peripherals: %v", win.GetLastError())
    os.exit(1)
  }

  return base
}

destroy_memory :: proc(base: rawptr)
{
  win.VirtualFree(base, 0, win.MEM_RELEASE)
}

get_written_pages :: proc(base: rawptr, reqMem: [^]rawptr, pageCount: ^uint, totalMem: uint) -> bool
{
  WRITE_WATCH_FLAG_RESET :: 0x01

  ok: bool = true
  // pageSize is ignored since we already know it's 4096 on windows
  pageSize: u32

  status := win.GetWriteWatch(
    WRITE_WATCH_FLAG_RESET,
    base,
    totalMem,
    reqMem,
    pageCount,
    &pageSize,
  )

  if !win.SUCCEEDED(status) {
    log.errorf("Could not GetWriteWatch: %v", win.GetLastError())
    ok = false
  }

  return ok
}
