#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing
 * - definitions for all common structures used in firmware simulation
 * - enqueue_event: event handling common in all peripherals
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

import "base:runtime"
import "base:intrinsics"

import "core:log"
import "core:mem"
import "core:time"
import "core:dynlib"
import "core:mem/virtual"
import "core:sync/chan"

import mcu "mcu:stm32h723xx"
import "../../usim"

/*
Handles any change in the the pages the peripheral uses

Arguments:
 - `rawctx`: will contain a ^Memory
 - `this_rawctx`: will contain a rawptr returned from the function in `SetupFn`
*/
Handler_Proc :: proc(rawctx, this_rawctx: rawptr)

/*
Setup function for a peripheral, will be called before the first step(),
after allocating ^Memory

Arguments:
 - `rawctx`: will contain a ^Memory
Returns:
 - a rawptr to the memory required for StepFn
*/
Setup_Proc :: #type proc(rawctx: rawptr) -> rawptr

/*
Step function that will be called when doing a single step(),
whether it is a fixed step or a variable step

Arguments:
 - `rawctx`: will contain a ^Memory
 - `this_rawctx`: will contain a rawptr returned from the function in `SetupFn`
*/
Step_Proc :: #type proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)

/*
Holds the function pointers necessary for simulating a peripheral
*/
Sim_Data :: struct {
  setup: Setup_Proc,
  step: Step_Proc,
  handler: Handler_Proc,

  this_ctx: rawptr,
}

Board_API :: struct {
  init: proc "c"(mem: ^Memory),
  update: proc "c"(),

  library: dynlib.Library,
}

USim_Event_Watch_Key :: usim.Event_Kind
USim_Event_Watch_Data :: struct {
  callback: usim.Watch_Event_Proc_Callback,
  ctx: rawptr,
}

/* Some peripherals might use more than a single page here,
 * they won't be repeated but in Memory.handlers they will be
 */
SimArray :: [mcu.PERIPHERAL_COUNT]Sim_Data {
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SCnSCB */
  {SCB_setup, SCB_step, SCB_handler, nil}, /* SCB */
  {SysTick_setup, SysTick_step, SysTick_handler, nil}, /* SysTick */
  {NVIC_setup, NVIC_step, NVIC_handler, nil}, /* NVIC */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* ITM */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DWT */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TPI */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* CoreDebug */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MPU */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FPU */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM7 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM13 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM14 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* VREFBUF */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RTC */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* WWDG1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* IWDG1 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPI2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPI3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPI4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPI5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPI6 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* USART2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* USART3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* USART6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* USART10 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* UART7 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* UART8 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* UART9 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* CRS */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* UART4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* UART5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* I2C1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* I2C2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* I2C3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* I2C4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* I2C5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FDCAN1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FDCAN2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FDCAN_CCU */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FDCAN3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM23 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM24 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* CEC */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* LPTIM1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* PWR */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DAC1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* LPUART1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SWPMI1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* LPTIM4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* LPTIM5 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* SYSCFG */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* COMP12 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* COMP1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* COMP2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* COMP12_COMMON */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* OPAMP */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* OPAMP1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* OPAMP2 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* EXTI */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* EXTI_D1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* EXTI_D2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPI1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM8 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* USART1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM12 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM15 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM16 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* TIM17 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SAI1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SAI1_Block_A */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SAI1_Block_B */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SAI4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SAI4_Block_A */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SAI4_Block_B */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* SPDIFRX */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Channel7 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Filter0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Filter1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Filter2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DFSDM1_Filter3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2D */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DCMI */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* PSSI */
  {RCC_setup, RCC_step, RCC_handler, nil}, /* RCC */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FLASH */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* CRC */

  {GPIOA_setup, GPIO_step, GPIO_handler, nil}, /* GPIOA */
  {GPIOB_setup, GPIO_step, GPIO_handler, nil}, /* GPIOB */
  {GPIOC_setup, GPIO_step, GPIO_handler, nil}, /* GPIOC */
  {GPIOD_setup, GPIO_step, GPIO_handler, nil}, /* GPIOD */
  {GPIOE_setup, GPIO_step, GPIO_handler, nil}, /* GPIOE */
  {GPIOF_setup, GPIO_step, GPIO_handler, nil}, /* GPIOF */
  {GPIOG_setup, GPIO_step, GPIO_handler, nil}, /* GPIOG */
  {GPIOH_setup, GPIO_step, GPIO_handler, nil}, /* GPIOH */
  {GPIOJ_setup, GPIO_step, GPIO_handler, nil}, /* GPIOJ */
  {GPIOK_setup, GPIO_step, GPIO_handler, nil}, /* GPIOK */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* ADC1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* ADC2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* ADC3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* ADC3_COMMON */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* ADC12_COMMON */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* RNG */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* SDMMC2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DLYB_SDMMC2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FMAC */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* CORDIC */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* BDMA_Channel7 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1_Monitor1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1_Monitor2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1_Monitor3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1_Monitor4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1_Monitor5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC1_Monitor6 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC2_Monitor1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC2_Monitor2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC2_Monitor3 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC3_Monitor1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* RAMECC3_Monitor2 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_Channel7 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenerator7 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_ChannelStatus */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX2_RequestGenStatus */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA2_Stream7 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMA1_Stream7 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel7 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel8 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel9 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel10 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel11 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel12 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel13 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel14 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_Channel15 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenerator7 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_ChannelStatus */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DMAMUX1_RequestGenStatus */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* FMC_Bank1_R */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FMC_Bank1E_R */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FMC_Bank2_R */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FMC_Bank3_R */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* FMC_Bank5_6_R */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* OCTOSPI1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DLYB_OCTOSPI1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* OCTOSPI2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DLYB_OCTOSPI2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* OCTOSPIM */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* SDMMC1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* DLYB_SDMMC1 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* DBGMCU */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* HSEM */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* HSEM_COMMON */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* LTDC */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* LTDC_Layer1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* LTDC_Layer2 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDIOS */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* ETH */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel0 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel1 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel2 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel3 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel4 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel5 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel6 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel7 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel8 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel9 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel10 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel11 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel12 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel13 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel14 */
  {Stub_setup, Stub_step, Stub_handler, nil}, /* MDMA_Channel15 */

  {Stub_setup, Stub_step, Stub_handler, nil}, /* USB1_OTG_HS */
}

Memory :: struct {
  using raw: struct #raw_union {
    base_addresses: [mcu.PERIPHERAL_COUNT]rawptr,
    using memory: mcu.Raw_Memory,
  },

  /* base address of 'arena', will be used in the board code as a base then offset for stuff
   * like the SCB NVIC vector offset which is 32 bit, this way it can keep being 32 bit
   * but it will be an offset to this base.
   */
  arena_base: rawptr,

  /* NOTE: These are at the bottom because they don't need to be sent to the board */

  odin_ctx: runtime.Context,

  // Holds pageCount * PLATFORM_REQ_MULTIPLIER items max.
  writeWatchRequestMem: []rawptr,
  pageCount: uint,
  totalMem: uint,

  board_api: Board_API,
  board_name: cstring,
  // One handler per page (256 pages max, unless we use GPV)
  handlers: [dynamic; 256]Handler_Proc,
  peripheral_contexts: [dynamic; 256]rawptr,
  base: rawptr,
  simArray: []Sim_Data,

  start_tick: time.Tick,

  /*
  Event queue channels for usim, one per attached usim
  */
  channels: []chan.Chan(usim.Event, .Send),

  /*
  Map which holds indices into channels array, one bit per usim, maximum of 64 (64 bits)
  */
  subscribed_events: map[usim.Event_Kind]u64,

  /*
  Map which holds event watch callbacks that will be called when an event happens (stopping execution)
  */
  event_watch: map[USim_Event_Watch_Key][]USim_Event_Watch_Data,

  // NOTE: The arena does not support freeing of individual elements,
  //       it is purely for long-lived allocations
  arena: virtual.Arena,
  arena_allocator: mem.Allocator,
}

/* see Memory.subscibed_events */
#assert(usim.MAX_USIMS <= 64)

enqueue_event :: proc(memory: ^Memory, event: ^usim.Event, event_kind: usim.Event_Kind)
{
  kind := u32(event_kind)

  event.instant = i64(time.tick_since(memory.start_tick))
  event.board_name = memory.board_name
  event.kind = kind

  subs: u64
  watch_data, found := memory.event_watch[event_kind]
  if found {
    for wd in watch_data {
      wd.callback(event, wd.ctx)
    }
  }

  subs, found = memory.subscribed_events[event_kind]
  if !found {
    // no subscribers to this specific event
    return
  }

  for subs != 0 {
    idx := intrinsics.count_trailing_zeros(subs)
    subs &= ~(1 << idx)

    ch := memory.channels[idx]
    // needs some amount of time for timeout because another writer could be blocking
    status := chan.send_with_timeout(ch, event^, 8*time.Microsecond)
    if status != .Ok {
      log.warnf("Could not add event in queue for usim %d: Queue full", idx)
    }
  }
}
