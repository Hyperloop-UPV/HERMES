#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing SCB simulation for core_cm7
 * Includes:
 *  - vector table
 * It is currently unfinished but works for what is being simulated
 *
 * Created on: 9 oct. 2026
 *   Author: victor
 */

import "core:time"
import "core:dynlib"

import mcu "mcu:stm32h723xx"

// TODO: The rest of this peripheral, only the VTOR has been simulated for now.

/* Address          Acronym      enum in stm32h723xx.h
 * 0x0000              -                 -
 * 0x0004           Reset                -
 * 0x0008           NMI          NonMaskableInt_IRQn
 * 0x000C           HardFault    HardFault_IRQn
 * 0x0010           MemManage    MemoryManagement_IRQn
 * 0x0014           BusFault     BusFault_IRQn
 * 0x0018           UsageFault   UsageFault_IRQn
 * 0x001C - 0x002B     -                 -
 * 0x002C           SVCall       SVCall_IRQn
 * 0x0030           DebugMonitor DebugMonitor_IRQn
 * 0x0034              -                 -
 * 0x0038           PendSV       PendSV_IRQn
 * 0x003C           SysTick      SysTick_IRQn
 * 0x0040           WWDG1        WWDG_IRQn
 * ...
 */

@(private="file") Reset_IRQn :: -15

get_NVIC_interrupts_from_dynlib :: proc(mem: ^Memory, vector_table: [^]rawptr)
{
  get_symbol :: dynlib.symbol_address

  library := mem.board_api.library
  found: bool

  vector_table[Reset_IRQn], found = get_symbol(library, "Reset_Handler")
  vector_table[mcu.NonMaskableInt_IRQn], found = get_symbol(library, "NMI_Handler")
  vector_table[mcu.HardFault_IRQn], found = get_symbol(library, "HardFault_Handler")
  vector_table[mcu.MemoryManagement_IRQn], found = get_symbol(library, "MemManage_Handler")
  vector_table[mcu.BusFault_IRQn], found = get_symbol(library, "BusFault_Handler")
  vector_table[mcu.UsageFault_IRQn], found = get_symbol(library, "UsageFault_Handler")
  vector_table[mcu.SVCall_IRQn], found = get_symbol(library, "SVC_Handler")
  vector_table[mcu.DebugMonitor_IRQn], found = get_symbol(library, "DebugMon_Handler")
  vector_table[mcu.PendSV_IRQn], found = get_symbol(library, "PendSV_Handler")
  vector_table[mcu.SysTick_IRQn], found = get_symbol(library, "SysTick_Handler")

  vector_table[mcu.WWDG_IRQn], found = get_symbol(library, "WWDG_IRQHandler")
  vector_table[mcu.PVD_AVD_IRQn], found = get_symbol(library, "PVD_AVD_IRQHandler")
  vector_table[mcu.TAMP_STAMP_IRQn], found = get_symbol(library, "TAMP_STAMP_IRQHandler")
  vector_table[mcu.RTC_WKUP_IRQn], found = get_symbol(library, "RTC_WKUP_IRQHandler")
  vector_table[mcu.FLASH_IRQn], found = get_symbol(library, "FLASH_IRQHandler")
  vector_table[mcu.RCC_IRQn], found = get_symbol(library, "RCC_IRQHandler")
  vector_table[mcu.EXTI0_IRQn], found = get_symbol(library, "EXTI0_IRQHandler")
  vector_table[mcu.EXTI1_IRQn], found = get_symbol(library, "EXTI1_IRQHandler")
  vector_table[mcu.EXTI2_IRQn], found = get_symbol(library, "EXTI2_IRQHandler")
  vector_table[mcu.EXTI3_IRQn], found = get_symbol(library, "EXTI3_IRQHandler")
  vector_table[mcu.EXTI4_IRQn], found = get_symbol(library, "EXTI4_IRQHandler")
  vector_table[mcu.DMA1_Stream0_IRQn], found = get_symbol(library, "DMA1_Stream0_IRQHandler")
  vector_table[mcu.DMA1_Stream1_IRQn], found = get_symbol(library, "DMA1_Stream1_IRQHandler")
  vector_table[mcu.DMA1_Stream2_IRQn], found = get_symbol(library, "DMA1_Stream2_IRQHandler")
  vector_table[mcu.DMA1_Stream3_IRQn], found = get_symbol(library, "DMA1_Stream3_IRQHandler")
  vector_table[mcu.DMA1_Stream4_IRQn], found = get_symbol(library, "DMA1_Stream4_IRQHandler")
  vector_table[mcu.DMA1_Stream5_IRQn], found = get_symbol(library, "DMA1_Stream5_IRQHandler")
  vector_table[mcu.DMA1_Stream6_IRQn], found = get_symbol(library, "DMA1_Stream6_IRQHandler")
  vector_table[mcu.ADC_IRQn], found = get_symbol(library, "ADC_IRQHandler")
  vector_table[mcu.FDCAN1_IT0_IRQn], found = get_symbol(library, "FDCAN1_IT0_IRQHandler")
  vector_table[mcu.FDCAN2_IT0_IRQn], found = get_symbol(library, "FDCAN2_IT0_IRQHandler")
  vector_table[mcu.FDCAN1_IT1_IRQn], found = get_symbol(library, "FDCAN1_IT1_IRQHandler")
  vector_table[mcu.FDCAN2_IT1_IRQn], found = get_symbol(library, "FDCAN2_IT1_IRQHandler")
  vector_table[mcu.EXTI9_5_IRQn], found = get_symbol(library, "EXTI9_5_IRQHandler")
  vector_table[mcu.TIM1_BRK_IRQn], found = get_symbol(library, "TIM1_BRK_IRQHandler")
  vector_table[mcu.TIM1_UP_IRQn], found = get_symbol(library, "TIM1_UP_IRQHandler")
  vector_table[mcu.TIM1_TRG_COM_IRQn], found = get_symbol(library, "TIM1_TRG_COM_IRQHandler")
  vector_table[mcu.TIM1_CC_IRQn], found = get_symbol(library, "TIM1_CC_IRQHandler")
  vector_table[mcu.TIM2_IRQn], found = get_symbol(library, "TIM2_IRQHandler")
  vector_table[mcu.TIM3_IRQn], found = get_symbol(library, "TIM3_IRQHandler")
  vector_table[mcu.TIM4_IRQn], found = get_symbol(library, "TIM4_IRQHandler")
  vector_table[mcu.I2C1_EV_IRQn], found = get_symbol(library, "I2C1_EV_IRQHandler")
  vector_table[mcu.I2C1_ER_IRQn], found = get_symbol(library, "I2C1_ER_IRQHandler")
  vector_table[mcu.I2C2_EV_IRQn], found = get_symbol(library, "I2C2_EV_IRQHandler")
  vector_table[mcu.I2C2_ER_IRQn], found = get_symbol(library, "I2C2_ER_IRQHandler")
  vector_table[mcu.SPI1_IRQn], found = get_symbol(library, "SPI1_IRQHandler")
  vector_table[mcu.SPI2_IRQn], found = get_symbol(library, "SPI2_IRQHandler")
  vector_table[mcu.USART1_IRQn], found = get_symbol(library, "USART1_IRQHandler")
  vector_table[mcu.USART2_IRQn], found = get_symbol(library, "USART2_IRQHandler")
  vector_table[mcu.USART3_IRQn], found = get_symbol(library, "USART3_IRQHandler")
  vector_table[mcu.EXTI15_10_IRQn], found = get_symbol(library, "EXTI15_10_IRQHandler")
  vector_table[mcu.RTC_Alarm_IRQn], found = get_symbol(library, "RTC_Alarm_IRQHandler")
  vector_table[mcu.TIM8_BRK_TIM12_IRQn], found = get_symbol(library, "TIM8_BRK_TIM12_IRQHandler")
  vector_table[mcu.TIM8_UP_TIM13_IRQn], found = get_symbol(library, "TIM8_UP_TIM13_IRQHandler")
  vector_table[mcu.TIM8_TRG_COM_TIM14_IRQn], found = get_symbol(library, "TIM8_TRG_COM_TIM14_IRQHandler")
  vector_table[mcu.TIM8_CC_IRQn], found = get_symbol(library, "TIM8_CC_IRQHandler")
  vector_table[mcu.DMA1_Stream7_IRQn], found = get_symbol(library, "DMA1_Stream7_IRQHandler")
  vector_table[mcu.FMC_IRQn], found = get_symbol(library, "FMC_IRQHandler")
  vector_table[mcu.SDMMC1_IRQn], found = get_symbol(library, "SDMMC1_IRQHandler")
  vector_table[mcu.TIM5_IRQn], found = get_symbol(library, "TIM5_IRQHandler")
  vector_table[mcu.SPI3_IRQn], found = get_symbol(library, "SPI3_IRQHandler")
  vector_table[mcu.UART4_IRQn], found = get_symbol(library, "UART4_IRQHandler")
  vector_table[mcu.UART5_IRQn], found = get_symbol(library, "UART5_IRQHandler")
  vector_table[mcu.TIM6_DAC_IRQn], found = get_symbol(library, "TIM6_DAC_IRQHandler")
  vector_table[mcu.TIM7_IRQn], found = get_symbol(library, "TIM7_IRQHandler")
  vector_table[mcu.DMA2_Stream0_IRQn], found = get_symbol(library, "DMA2_Stream0_IRQHandler")
  vector_table[mcu.DMA2_Stream1_IRQn], found = get_symbol(library, "DMA2_Stream1_IRQHandler")
  vector_table[mcu.DMA2_Stream2_IRQn], found = get_symbol(library, "DMA2_Stream2_IRQHandler")
  vector_table[mcu.DMA2_Stream3_IRQn], found = get_symbol(library, "DMA2_Stream3_IRQHandler")
  vector_table[mcu.DMA2_Stream4_IRQn], found = get_symbol(library, "DMA2_Stream4_IRQHandler")
  vector_table[mcu.ETH_IRQn], found = get_symbol(library, "ETH_IRQHandler")
  vector_table[mcu.ETH_WKUP_IRQn], found = get_symbol(library, "ETH_WKUP_IRQHandler")
  vector_table[mcu.FDCAN_CAL_IRQn], found = get_symbol(library, "FDCAN_CAL_IRQHandler")
  vector_table[mcu.DMA2_Stream5_IRQn], found = get_symbol(library, "DMA2_Stream5_IRQHandler")
  vector_table[mcu.DMA2_Stream6_IRQn], found = get_symbol(library, "DMA2_Stream6_IRQHandler")
  vector_table[mcu.DMA2_Stream7_IRQn], found = get_symbol(library, "DMA2_Stream7_IRQHandler")
  vector_table[mcu.USART6_IRQn], found = get_symbol(library, "USART6_IRQHandler")
  vector_table[mcu.I2C3_EV_IRQn], found = get_symbol(library, "I2C3_EV_IRQHandler")
  vector_table[mcu.I2C3_ER_IRQn], found = get_symbol(library, "I2C3_ER_IRQHandler")
  vector_table[mcu.OTG_HS_EP1_OUT_IRQn], found = get_symbol(library, "OTG_HS_EP1_OUT_IRQHandler")
  vector_table[mcu.OTG_HS_EP1_IN_IRQn], found = get_symbol(library, "OTG_HS_EP1_IN_IRQHandler")
  vector_table[mcu.OTG_HS_WKUP_IRQn], found = get_symbol(library, "OTG_HS_WKUP_IRQHandler")
  vector_table[mcu.OTG_HS_IRQn], found = get_symbol(library, "OTG_HS_IRQHandler")
  vector_table[mcu.DCMI_PSSI_IRQn], found = get_symbol(library, "DCMI_PSSI_IRQHandler")
  vector_table[mcu.RNG_IRQn], found = get_symbol(library, "RNG_IRQHandler")
  vector_table[mcu.FPU_IRQn], found = get_symbol(library, "FPU_IRQHandler")
  vector_table[mcu.UART7_IRQn], found = get_symbol(library, "UART7_IRQHandler")
  vector_table[mcu.UART8_IRQn], found = get_symbol(library, "UART8_IRQHandler")
  vector_table[mcu.SPI4_IRQn], found = get_symbol(library, "SPI4_IRQHandler")
  vector_table[mcu.SPI5_IRQn], found = get_symbol(library, "SPI5_IRQHandler")
  vector_table[mcu.SPI6_IRQn], found = get_symbol(library, "SPI6_IRQHandler")
  vector_table[mcu.SAI1_IRQn], found = get_symbol(library, "SAI1_IRQHandler")
  vector_table[mcu.LTDC_IRQn], found = get_symbol(library, "LTDC_IRQHandler")
  vector_table[mcu.LTDC_ER_IRQn], found = get_symbol(library, "LTDC_ER_IRQHandler")
  vector_table[mcu.DMA2D_IRQn], found = get_symbol(library, "DMA2D_IRQHandler")
  vector_table[mcu.OCTOSPI1_IRQn], found = get_symbol(library, "OCTOSPI1_IRQHandler")
  vector_table[mcu.LPTIM1_IRQn], found = get_symbol(library, "LPTIM1_IRQHandler")
  vector_table[mcu.CEC_IRQn], found = get_symbol(library, "CEC_IRQHandler")
  vector_table[mcu.I2C4_EV_IRQn], found = get_symbol(library, "I2C4_EV_IRQHandler")
  vector_table[mcu.I2C4_ER_IRQn], found = get_symbol(library, "I2C4_ER_IRQHandler")
  vector_table[mcu.SPDIF_RX_IRQn], found = get_symbol(library, "SPDIF_RX_IRQHandler")
  vector_table[mcu.DMAMUX1_OVR_IRQn], found = get_symbol(library, "DMAMUX1_OVR_IRQHandler")
  vector_table[mcu.DFSDM1_FLT0_IRQn], found = get_symbol(library, "DFSDM1_FLT0_IRQHandler")
  vector_table[mcu.DFSDM1_FLT1_IRQn], found = get_symbol(library, "DFSDM1_FLT1_IRQHandler")
  vector_table[mcu.DFSDM1_FLT2_IRQn], found = get_symbol(library, "DFSDM1_FLT2_IRQHandler")
  vector_table[mcu.DFSDM1_FLT3_IRQn], found = get_symbol(library, "DFSDM1_FLT3_IRQHandler")
  vector_table[mcu.SWPMI1_IRQn], found = get_symbol(library, "SWPMI1_IRQHandler")
  vector_table[mcu.TIM15_IRQn], found = get_symbol(library, "TIM15_IRQHandler")
  vector_table[mcu.TIM16_IRQn], found = get_symbol(library, "TIM16_IRQHandler")
  vector_table[mcu.TIM17_IRQn], found = get_symbol(library, "TIM17_IRQHandler")
  vector_table[mcu.MDIOS_WKUP_IRQn], found = get_symbol(library, "MDIOS_WKUP_IRQHandler")
  vector_table[mcu.MDIOS_IRQn], found = get_symbol(library, "MDIOS_IRQHandler")
  vector_table[mcu.MDMA_IRQn], found = get_symbol(library, "MDMA_IRQHandler")
  vector_table[mcu.SDMMC2_IRQn], found = get_symbol(library, "SDMMC2_IRQHandler")
  vector_table[mcu.HSEM1_IRQn], found = get_symbol(library, "HSEM1_IRQHandler")
  vector_table[mcu.ADC3_IRQn], found = get_symbol(library, "ADC3_IRQHandler")
  vector_table[mcu.DMAMUX2_OVR_IRQn], found = get_symbol(library, "DMAMUX2_OVR_IRQHandler")
  vector_table[mcu.BDMA_Channel0_IRQn], found = get_symbol(library, "BDMA_Channel0_IRQHandler")
  vector_table[mcu.BDMA_Channel1_IRQn], found = get_symbol(library, "BDMA_Channel1_IRQHandler")
  vector_table[mcu.BDMA_Channel2_IRQn], found = get_symbol(library, "BDMA_Channel2_IRQHandler")
  vector_table[mcu.BDMA_Channel3_IRQn], found = get_symbol(library, "BDMA_Channel3_IRQHandler")
  vector_table[mcu.BDMA_Channel4_IRQn], found = get_symbol(library, "BDMA_Channel4_IRQHandler")
  vector_table[mcu.BDMA_Channel5_IRQn], found = get_symbol(library, "BDMA_Channel5_IRQHandler")
  vector_table[mcu.BDMA_Channel6_IRQn], found = get_symbol(library, "BDMA_Channel6_IRQHandler")
  vector_table[mcu.BDMA_Channel7_IRQn], found = get_symbol(library, "BDMA_Channel7_IRQHandler")
  vector_table[mcu.COMP_IRQn], found = get_symbol(library, "COMP1_IRQHandler")
  vector_table[mcu.LPTIM2_IRQn], found = get_symbol(library, "LPTIM2_IRQHandler")
  vector_table[mcu.LPTIM3_IRQn], found = get_symbol(library, "LPTIM3_IRQHandler")
  vector_table[mcu.LPTIM4_IRQn], found = get_symbol(library, "LPTIM4_IRQHandler")
  vector_table[mcu.LPTIM5_IRQn], found = get_symbol(library, "LPTIM5_IRQHandler")
  vector_table[mcu.LPUART1_IRQn], found = get_symbol(library, "LPUART1_IRQHandler")
  vector_table[mcu.CRS_IRQn], found = get_symbol(library, "CRS_IRQHandler")
  vector_table[mcu.ECC_IRQn], found = get_symbol(library, "ECC_IRQHandler")
  vector_table[mcu.SAI4_IRQn], found = get_symbol(library, "SAI4_IRQHandler")
  vector_table[mcu.DTS_IRQn], found = get_symbol(library, "DTS_IRQHandler")
  vector_table[mcu.WAKEUP_PIN_IRQn], found = get_symbol(library, "WAKEUP_PIN_IRQHandler")
  vector_table[mcu.OCTOSPI2_IRQn], found = get_symbol(library, "OCTOSPI2_IRQHandler")
  vector_table[mcu.FMAC_IRQn], found = get_symbol(library, "FMAC_IRQHandler")
  vector_table[mcu.CORDIC_IRQn], found = get_symbol(library, "CORDIC_IRQHandler")
  vector_table[mcu.UART9_IRQn], found = get_symbol(library, "UART9_IRQHandler")
  vector_table[mcu.USART10_IRQn], found = get_symbol(library, "USART10_IRQHandler")
  vector_table[mcu.I2C5_EV_IRQn], found = get_symbol(library, "I2C5_EV_IRQHandler")
  vector_table[mcu.I2C5_ER_IRQn], found = get_symbol(library, "I2C5_ER_IRQHandler")
  vector_table[mcu.FDCAN3_IT0_IRQn], found = get_symbol(library, "FDCAN3_IT0_IRQHandler")
  vector_table[mcu.FDCAN3_IT1_IRQn], found = get_symbol(library, "FDCAN3_IT1_IRQHandler")
  vector_table[mcu.TIM23_IRQn], found = get_symbol(library, "TIM23_IRQHandler")
  vector_table[mcu.TIM24_IRQn], found = get_symbol(library, "TIM24_IRQHandler")
}

//////////////////////////////////////////

// Reserved 0x0000 address is -16, WWDG1 is 0
@(private="file") IRQn_Min :: -16

// TIM24_IRQn
@(private="file") IRQn_Max :: 162

SCB_handler :: proc(rawctx, this_rawctx: rawptr)
{

}

SCB_setup :: proc(rawctx: rawptr) -> rawptr
{
  mem := cast(^Memory)rawctx
  scb := cast(^mcu.SCB)mem.SCB_base

  vector_table := new([IRQn_Max - IRQn_Min]rawptr, mem.arena_allocator)
  // NOTE: This won't underflow because IRQn_Min is a negative number
  #assert(IRQn_Min < 0)
  vector_table_base := cast([^]rawptr)uintptr(
    i64(uintptr(&vector_table[0])) - i64(IRQn_Min * size_of(rawptr)),
  )
  scb.VTOR = u32(uintptr(&vector_table_base[0]) - uintptr(mem.arena_base))

  get_NVIC_interrupts_from_dynlib(mem, vector_table_base)

  return nil
}

SCB_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{

}
