#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package fmi3

Instance :: distinct rawptr
InstanceEnvironment :: distinct rawptr
FMUState :: distinct rawptr

/* handle to the value of a variable */
ValueReference :: distinct u32

Float32 :: f32
Float64 :: f64

Int8   :: i8
UInt8  :: u8
Int16  :: i16
UInt16 :: u16
Int32  :: i32
UInt32 :: u32
Int64  :: i64
UInt64 :: u64

Boolean :: bool

Char   :: u8
String :: cstring
Byte   :: byte
Binary :: [^]byte

/* active or inactive */
Clock :: bool

True  :: true
False :: false

ClockActive   :: true
ClockInactive :: false
