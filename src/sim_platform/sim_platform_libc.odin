#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
#+build linux, darwin, freebsd, openbsd, netbsd
package simulator_platform

import "core:os"
import "core:c/libc"

@(private="file")
internal_signal_handler: proc "contextless"()

@(private="file")
signal_handler :: proc "c"(sig: libc.int)
{
  if internal_signal_handler != nil {
    internal_signal_handler()
  }
  os.exit(1)
}

setup_signal_handler :: proc(handler: proc "contextless"())
{
  internal_signal_handler = handler

  // User interrupt / Ctrl+C
  libc.signal(libc.SIGINT, signal_handler)
  // Polite termination request
  libc.signal(libc.SIGTERM, signal_handler)

  // Want [SIGILL, SIGFPE, SIGSEGV] ?
}
