 - [x] Separate peripheral definitions:
       {`peripherals.odin`, `peripheral_win32.odin`, `peripheral_other.odin`} in a module to orquestrate
       {`core_cm7.odin`, `stm32h723xx.odin`} in a module for the MCU
       {`stub_peripheral.odin`, ...} in a module to handle all peripherals
 - [ ] `__DSB()` (data synchronization barrier) stops simulated board until a full iteration of write detection in simulator happens

 - [ ] Command line: decide on what to do to emulate cfg.json through command line parsing. See `cmdline.odin`
 - [x] Global arena for core simulator, since most allocations are a one time thing
 - [ ] Handle Ctrl+C to join all active threads

## plugins
 - [x] Calling plugins from hermes (core simulator). Load dll etc.
 - [x] Event queue for plugins. Example: GPIOx pin value changes, SysTick interrupts, etc.
 - [x] Subscribing to events to avoid sending unwanted events ?
 - [x] Plugin example
 - [x] FMI plugin example
 - [x] Make a slightly different interface for emulating plugins, for example for emulating an AFE (Analog Front End)
 - [x] Event system from plugin to core simulator (other way round)
 - [ ] Emulating plugin example

## Peripherals
 - [ ] Finish SCB peripheral
 - [ ] Finish RCC peripheral (nothing has been simulated yet, only the file has been added)
 - [x] Finish NVIC peripheral
 - [ ] Finish GPIO peripheral (only basic digitaloutput has been simulated)
