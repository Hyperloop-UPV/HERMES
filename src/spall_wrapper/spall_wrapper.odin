#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
#+no-instrumentation
package spall_wrapper

/* File containing a spall wrapper with easy disabling using PROFILING configurable constant
 *
 * Created on: 12 oct. 2026
 *   Author: victor
 */

import "core:time"
import "core:sync"
import "core:prof/spall"

Begin_Event :: spall.Begin_Event
Buffer :: spall.Buffer
Context :: spall.Context
End_Event :: spall.End_Event
Manual_Buffer_Header :: spall.Manual_Buffer_Header
Manual_Event_Type :: spall.Manual_Event_Type
Manual_Stream_Header :: spall.Manual_Stream_Header
Name_Event :: spall.Name_Event
Pad_Skip :: spall.Pad_Skip

PROFILING :: #config(PROFILING, true)
MAX_THREADS :: #config(MAX_THREADS, 256)

when PROFILING {
  ctx: spall.Context
  buffer_idx: int /* this is atomic */
  backing_buffers: [MAX_THREADS][]u8
  @thread_local buffer: spall.Buffer
}

init :: proc(filename: string) -> (ok: bool)
{
  when PROFILING {
    sync.atomic_store(&buffer_idx, 1)
    ctx = context_create_with_scale(filename, false, 1.0) or_return
    backing_buffers[0] = make([]u8, BUFFER_DEFAULT_SIZE)
    if backing_buffers[0] == nil { return }
    buffer, ok = buffer_create(backing_buffers[0], u32(sync.current_thread_id()))
    // have thread buffers start at 1, 0 is main buffer
  } else {
    ok = true
  }
  return
}

/* You are assumed to have enough size in backing_buffers for all threads */
init_thread :: proc() -> (ok: bool)
{
  when PROFILING {
    thread_idx := sync.atomic_add(&buffer_idx, 1)
    if thread_idx >= MAX_THREADS {
      // too many threads, configure MAX_THREADS
      return
    }
    backing_buffers[thread_idx] = make([]u8, BUFFER_DEFAULT_SIZE)
    if backing_buffers[thread_idx] == nil { return }
    buffer, ok = buffer_create(backing_buffers[thread_idx], u32(sync.current_thread_id()))
  } else {
    ok = true
  }
  return
}

/* must be called BEFORE deinit */
deinit_thread :: proc()
{
  when PROFILING {
    spall.buffer_destroy(&ctx, &buffer)
  }
}

/* must be called from a SINGLE thread after anything else */
deinit :: proc()
{
  when PROFILING {
    spall.context_destroy(&ctx)
    for i := 0; i < buffer_idx; i += 1 {
      delete(backing_buffers[i])
    }
  }
}

when PROFILING {
  // NOTE: random thing from core:time to avoid error
  Nanosecond :: time.Duration(1)

  BUFFER_DEFAULT_SIZE :: 0x10_0000

  @(deferred_in=_scoped_buffer_end)
  SCOPED_EVENT :: proc(name: string, args: string = "", location := #caller_location) -> bool
  {
    _buffer_begin(name, args, location)
    return true
  }

  @(private)
  _scoped_buffer_end :: proc(_, _: string, _ := #caller_location) {
    _buffer_end()
  }

  buffer_create :: spall.buffer_create
  buffer_destroy :: spall.buffer_destroy
  buffer_flush :: spall.buffer_flush
  context_create_with_scale :: spall.context_create_with_scale
  context_create_with_sleep :: spall.context_create_with_sleep
  context_destroy :: spall.context_destroy

  /* bounds check would segfault instrumentation */
  _buffer_begin :: #force_inline proc "contextless"(name: string, args: string = "", location := #caller_location) #no_bounds_check
  {
    spall._buffer_begin(&ctx, &buffer, name, args, location)
  }

  /* bounds check would segfault instrumentation */
  _buffer_end :: #force_inline proc "contextless"() #no_bounds_check
  {
    spall._buffer_end(&ctx, &buffer)
  }
} else {
  BUFFER_DEFAULT_SIZE :: 0x4

  SCOPED_EVENT :: proc(name: string, args: string = "", location := #caller_location) -> bool { return true }

  buffer_create :: proc(data: []u8, tid: u32 = 0, pid: u32 = 0) -> (buffer: Buffer, ok: bool) #optional_ok { ok = true; return }

  buffer_destroy :: proc(ctx: ^Context, buffer: ^Buffer) {}

  buffer_flush :: proc "contextless" (ctx: ^Context, buffer: ^Buffer) {}

  context_create_with_scale :: proc(filename: string, precise_time: bool, timestamp_scale: f64) -> (ctx: Context, ok: bool) { ok = true; return }

  context_create_with_sleep :: proc(filename: string, sleep: time.Duration = 2 * time.Second) -> (ctx: Context, ok: bool) { ok = true; return }

  context_destroy :: proc(ctx: ^Context) {}

  _buffer_begin :: proc "contextless" (name: string, args: string = "", location := #caller_location) #no_bounds_check /* bounds check would segfault instrumentation */ {}

  _buffer_end :: proc "contextless" () #no_bounds_check /* bounds check would segfault instrumentation */ {}
}

context_create :: proc{
  context_create_with_scale,
  context_create_with_sleep,
}