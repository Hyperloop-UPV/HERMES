## Hyperloop UPV firmware, (eventually) communications and (eventually) physical emulator

This is a simulator. Not an emulator (yet).

For any name proposals, please comment them in [#2](https://github.com/Hyperloop-UPV/super-simulador/issues/2)

### Roadmap

Version `0.9` (first release):
 - [x] Multiple boards running in the same 'step time'
 - [x] Global barrier for all `step` functions/procedures in the simulator (#4)
 - [x] Event system from core sim to usim
 - [ ] Event system from usim to core sim (#5)
 - [ ] Handle Ctrl+C to stop the simulator from running in a graceful way (#3)
 - [x] SysTick emulation
 - [/] GPIO emulation (output is done, input is not)
 - [x] Basic timer emulation
 - [ ] PWM emulation
 - [ ] DMA emulation

Version `1.0`:
 - [ ] Make a version of the HAL that builds with simulator native build

### Usage

```
sim --cfg <config json> [--max-iterations <integer>] [--max-time <string>]
```
example:
```
sim --cfg cfg.json --max-iterations 1000_000
```

An example json config can be found in `cfg.json` and its schema in `https://raw.githubusercontent.com/Hyperloop-UPV/super-simulador/refs/heads/main/misc/sim-cfg.schema.json`

### Building

```
odin run .
```
or alternatively, keep the build executable and run it later:

on linux:
```
odin build . -out:build
./build
```
on windows:
```
odin build . -out:build.exe
build
```
You can build the usim examples by adding `-build-example-usims` in build script:
```
./build -build-example-usims
```

### Source structure

 - `simulator.odin`: contains main program for the simulator
 - `cmdline.odin`: contains command line parsing for core simulator
 - `sim_platform`: contains any platform specific code needed for main program (`simulator.odin` will use this when it is made)
 - `sim_peripherals`: contains all simulation for peripherals
 - `mcu/stm32h723xx/core_cm7.odin`: contains definitions for cm7 core registers
 - `mcu/stm32h723xx/stm32h723xx.odin`: contains definitions for stm32h723xx peripheral registers
 - `usim`: contains the api for micro simulators

Extra info:
 - `build.odin`: odin build script for the simulator
 - `cfg.json`: example, working config for running the simulator
 - `Changes.md`: lists changes that had to be made to make the simulated board code compile/run
 - `codegen/ioctl_defs_linux.c`: small code to autogenerate `sim_platform_linux_ioctls.odin`
 - `example-board`: an example code for a board
 - `example-usim`: example micro simulator code
 - `ols.json`: odin language server config, to specify any collections used

### Reasoning for the language we are going to use
We are choosing Odin because:
 - It is a systems programming language
 - It is simple, as opposed to C++ and Rust. The [overview](https://odin-lang.org/docs/overview) describes the whole language
 - It has a good [standard library](https://pkg.odin-lang.org/core), as opposed to C or C++ which don't include much
 - It has hashmaps builtin to the language (which we will probably use)
 - It has generics and reflection (which we will probably use)
 - It has inline assembly built in to the compiler (we might use this)
 - It has a large repository of easy to find [example code](https://pkg.odin-lang.org/examples)
 - It contains, in its standard library an [odin parser](https://pkg.odin-lang.org/core/odin/parser)
 - It contains, in its standard library an easy to use [profiler](https://pkg.odin-lang.org/core/prof/spall)
 - It contains, in its standard library, [channels](https://pkg.odin-lang.org/core/sync/chan) for thread-safe communication between multiple readers and multiple writers
 - It contains, in its standard library a high-performance multi-architecture [encoder/decoder/printer](https://pkg.odin-lang.org/core/rexcode)
 - It contains, in its vendor library (provided by the compiler), a high performance real time [physics simulation library](https://pkg.odin-lang.org/vendor/box3d)
 - It is soon to get to [v1.0](https://www.youtube.com/watch?v=dLPAqXi9In0)

Personally:
 - It is a language I enjoy using
 - It is a language I have used many times before, as opposed to Rust, Haskell, Java, Prolog or Javascript
