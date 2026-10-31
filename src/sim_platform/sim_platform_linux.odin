#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
#+build !windows
package simulator_platform

/* File containing
 *  - OS specific implementations of any needed functionality not in standard library
 * for OSes other than windows
 *
 * Created on: 13 oct. 2026
 *   Author: victor
 */

import "core:os"
import "core:log"
import "core:mem"

import "core:sys/linux"
import "core:c/libc"

@(private="package")
uffdio_api :: struct {
  /* Requested API version (input) */
  api: u64,
  /* Requested features (input/output) */
  features: u64,
  /* Available ioctl() operations (output) */
  ioctls: u64,
}

@(private="package")
uffdio_range :: struct {
  /* Start of range */
  start: u64,
  /* Size of range (bytes) */
  len: u64,
}

@(private="package")
uffdio_register :: struct {
  range: uffdio_range,
  /* Desired mode of operation (input) */
  mode: u64,
  /* Available ioctl()s (output) */
  ioctls: u64,
}

@(private="package")
uffdio_writeprotect :: struct {
  /* Range to change write permission */
  range: uffdio_range,
  /* Mode to change write permission */
  mode: u64,
}

@(private="package")
pm_scan_arg :: struct {
  size: u64,
  flags: u64,
  start: u64,
  end: u64,
  walk_end: u64,
  vec: u64,
  vec_len: u64,
  max_pages: u64,
  category_inverted: u64,
  category_mask: u64,
  category_anyof_mask: u64,
  return_mask: u64,
}

@(private="package")
page_region :: struct {
  start: u64,
  end: u64,
  categories: u64,
}

@(private="package")
pagemapfile_name: cstring

@(private="package")
pagemapfile: linux.Fd

@(private="package")
errno: ^linux.Errno

@(private="package")
uffd: linux.Fd

init_memory :: proc(totalMem: uint) -> rawptr
{
  errno = cast(^linux.Errno)libc.errno()

  flags := (
    i32(linux.Eventfd_Flags{.CLOEXEC, .NONBLOCK}) |
    UFFD_USER_MODE_ONLY
  )

  fd := linux.syscall(linux.SYS_userfaultfd, flags)
  uffd = linux.Fd(fd)

  uff_api := uffdio_api {
    api = UFFD_API,
    features = UFFD_FEATURE_WP_ASYNC,
  }

  if linux.ioctl(uffd, UFFDIO_API, uintptr(&uff_api)) != 0 {
    log.errorf("[linux] Could not setup UFFD_FEATURE_WP_ASYNC: %v", errno^)
    os.exit(1)
  }

  if (uff_api.features & UFFD_FEATURE_WP_ASYNC) == 0 {
    log.errorf("Kernel does not support UFFD_FEATURE_WP_ASYNC: %v", errno^)
    os.exit(1)
  }

  memory, err := mem.alloc(int(totalMem), alignment = mem.PAGE_SIZE)
  if err != nil {
    log.errorf("Could not allocate memory for peripherals: %v", err)
    os.exit(1)
  }

  reg := uffdio_register {
    range = {
      start = u64(uintptr(memory)),
      len = u64(totalMem),
    },
    mode = UFFDIO_REGISTER_MODE_WP,
  }

  if linux.ioctl(uffd, UFFDIO_REGISTER, uintptr(&reg)) != 0 {
    log.errorf("[linux] Could not register peripheral pages: %v", errno^)
    os.exit(1)
  }

  wp := uffdio_writeprotect {
    range = {
      start = u64(uintptr(memory)),
      len = u64(totalMem),
    },
    mode = UFFDIO_WRITEPROTECT_MODE_WP,
  }

  if linux.ioctl(uffd, UFFDIO_WRITEPROTECT, uintptr(&wp)) != 0 {
    log.errorf("[linux] Could not writeprotect peripheral pages: %v", errno^)
    os.exit(1)
  }

  pagemapfile_name = "/proc/self/pagemap"

  open_err: linux.Errno
  pagemapfile, open_err = linux.open(pagemapfile_name, {}, nil)
  if open_err != .NONE || pagemapfile < -1 {
    log.errorf("[linux] Could not open pagemap file for this process: %v", open_err)
    os.exit(1)
  }

  return memory
}

destroy_memory :: proc(base: rawptr)
{
  linux.close(uffd)
  free(base)
}

get_written_pages :: proc(base: rawptr, reqMem: [^]rawptr, pageCount: ^uint, totalMem: uint) -> bool
{
  pm := pm_scan_arg {
    size = size_of(pm_scan_arg),
    flags = PM_SCAN_WP_MATCHING,
    start = u64(uintptr(base)),
    end = u64(uintptr(base) + uintptr(totalMem)),
    /* vec is filled in by ioctl call - The address of page_region array for output */
    vec = u64(uintptr(reqMem) + uintptr(pageCount^) * uintptr(size_of(rawptr))),
    /* vec_len is filled in by ioctl call - The length of the page_region struct array */
    vec_len = u64(pageCount^),
    max_pages = u64(pageCount^),
    category_mask = PAGE_IS_WRITTEN,
    return_mask = PAGE_IS_WRITTEN,
  }

  scanCount := linux.ioctl(pagemapfile, PAGEMAP_SCAN, uintptr(&pm))
  if (cast(^i64)(&scanCount))^ < 0 {
    log.errorf("[linux] PAGEMAP_SCAN ioctl failed. Status %v", linux.Errno(-scanCount))
    return false
  }

  // NOTE: I believe the only reason they wouldn't be equal is
  //       if max_pages is not the amount of pages in totalMem
  // walk_end is filled in by ioctl call -
  // The kernel returns the scan's ending address in it. The
  // walk_end equal to end means that scan has completed on the entire range.
  assert(pm.walk_end == pm.end)

  for i: u32 = 0; i < u32(scanCount); i += 1 {
    region := (cast([^]page_region)rawptr(uintptr(pm.vec)))[i]
    reqMem[i] = rawptr(uintptr(region.start))
  }
  pageCount^ = uint(scanCount)

  return true
}

