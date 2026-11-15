#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
#+build !windows
package peripherals

/* File containing platform specific data required for firmware threads
 * for OSes other than windows
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

// NOTE: pagemap scan vec should not be in the same memory address space as
//       reqMem because (for some reason) the kernel might coalesce
//       contiguous matching pages into a single page_region...
// NOTE: pagemap ioctl returns memory in a 3x u64 struct + reqMem
PLATFORM_REQ_MULTIPLIER :: 4

Memory_PlatformSpecific :: struct {
}


