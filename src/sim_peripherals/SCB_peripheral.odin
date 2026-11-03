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

import "core:os"
import "core:fmt"
import "core:time"
import "core:dynlib"

import mcu "mcu:stm32h723xx"

// TODO: The rest of this peripheral, only the VTOR has been simulated for now.

/*
What has been simulated:
 - CPUID
 - VTOR
 - SCR (will be used elsewhere, no simulation needed here)
 - CCR (only checks for writes in readonly fields)
 - SHPR (will be used elsewhere, no simulation needed here)

What is missing:
 - ICSR Interrupt calls
 - AIRCR Software reset
 - SHCSR
 - CFSR
 - HFSR
 - DFSR
 - MMFAR
 - BFAR
 - AFSR
 - ID_PFR
 - ID_DFR
 - ID_AFR
 - ID_MFR
 - ID_ISAR
 - CLIDR
 - CTR
 - CCSIDR
 - CSSELR
 - CPACR
 - STIR
 - MVFR0
 - MVFR1
 - MVFR2
 - ICIALLU
 - ICIMVAU
 - DCIMVAC
 - DCISW
 - DCCMVAU
 - DCCMVAC
 - DCCISW
 - ITCMCR
 - DTCMCR
 - AHBPCR
 - CACR
 - AHBSCR
 - ABFSR
*/

/*
ACTLR provides disable bits for the following processor functions:
 - FPU exception outputs
 - Dual-issue functionality
 - Flushing of the trace output from the ITM and DWT
 - Dynamic read allocate mode
I don't think this is a register we need to simulate
It is part of SCnSCB
*/

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

@(private="file")
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

// CPUID bits

@(private="file") CPUID_IMPLEMENTER :: 0x41 // Arm
@(private="file") CPUID_VARIANT :: 0x0 // Revision 0
@(private="file") CPUID_CONSTANT :: 0xF // Yes this is the real name
@(private="file") CPUID_PARTNO :: 0xC27 // Cortex-M7
@(private="file") CPUID_REVISION :: 0x0 // Revision 0
@(private="file")
CPUID_VALUE :: (CPUID_IMPLEMENTER << 24) | (CPUID_VARIANT << 20) | (CPUID_CONSTANT << 16) | (CPUID_PARTNO << 4) | (CPUID_REVISION << 0)

// ICSR bits

@(private="file") ICSR_NMIPENDSET_Offset :: 31
@(private="file") ICSR_PENDSVSET_Offset :: 28
@(private="file") ICSR_PENDSVCLR_Offset :: 27
@(private="file") ICSR_PENDSTSET_Offset :: 26
@(private="file") ICSR_PENDSTCLR_Offset :: 25
// no real name for this bit just 'Reserved for Debug use', read only
@(private="file") ICSR_ZeroWhenNotInDebug_Offset :: 23
// read only
@(private="file") ICSR_ISRPENDING_Offset :: 22
// bits [20:12], read only
@(private="file") ICSR_VECTPENDING_Offset :: 12
// read only
@(private="file") ICSR_RETTOBASE_Offset :: 11
// bits [8:0], read only
@(private="file") ICSR_VECTACTIVE_Offset :: 0

// AIRCR bits

@(private="file") AIRCR_VECTKEY_Offset :: 16
@(private="file") AIRCR_VECTKEYSTAT :: 0xFA05 << AIRCR_VECTKEY_Offset
@(private="file") AIRCR_VECTKEY :: 0x05FA << AIRCR_VECTKEY_Offset
@(private="file") AIRCR_ENDIANNESS_Offset :: 15
@(private="file") AIRCR_ENDIANNESS :: 0 << AIRCR_ENDIANNESS_Offset // little endian
@(private="file") AIRCR_PRIGROUP_Offset :: 8
// Offset for SYSRESETREQ bit in AIRCR, which causes a software reset
@(private="file") AIRCR_SYSRESETREQ_Offset :: 2
// A write of 1 to this bit is invalid
@(private="file") AIRCR_VECTCLRACTIVE_Invalid :: 1 << 1
// A write of 1 to this bit is invalid
@(private="file") AIRCR_VECTRESET_Invalid :: 1 << 0

// SCR bits

@(private="file") SCR_SEVONPEND_Offset :: 4
@(private="file") SCR_DEEPSLEEP_Offset :: 2
@(private="file") SCR_SLEEPONEXIT_Offset :: 1

// CCR bits

@(private="file") CCR_BP_Offset :: 18
@(private="file") CCR_BP :: 1 << 18 // branch prediction is always on
// enable/disable instruction cache
@(private="file") CCR_IC_Offset :: 17
// enable/disable data cache
@(private="file") CCR_DC_Offset :: 16
@(private="file") CCR_STKALIGN_Offset :: 9
@(private="file") CCR_STKALIGN :: 1 << 9 // always reads as 1
@(private="file") CCR_BFHFNMIGN_Offset :: 8
// 0 -> (0/0 equ 0); 1 -> (sdiv/udiv causes trap when div 0)
@(private="file") CCR_DIV_0_TRP_Offset :: 4
// dont trap/trap when unaligned access to word
@(private="file") CCR_UNALIGN_TRP_Offset :: 3
// disables/enables unprivilaged access to STIR
@(private="file") CCR_USERSETMPEND_Offset :: 1
@(private="file") CCR_NONBASETHRDENA_Offset :: 0

@(private="file")
SCB_Context :: struct {
  prev_ICSR: u32,
  prev_AIRCR: u32,
}

@(private="file")
handle_ICSR :: proc(scb: ^mcu.SCB, ctx: ^SCB_Context)
{
  ICSR_ZeroNotInDbg :: 0 << ICSR_ZeroWhenNotInDebug_Offset

  if ((scb.ICSR & (1 << ICSR_PENDSVSET_Offset)) != 0) &&
     ((scb.ICSR & (1 << ICSR_PENDSVCLR_Offset)) != 0)
  {
    fmt.eprintln(
      "[ERROR] Undefined behaviour when setting both\n" +
      "        PENDSVSET (bit 28)\n" +
      "    and PENDSVCLR (bit 27)\n" +
      "        bits to 1",
    )
    os.exit(1)
  }

  if ((scb.ICSR & (1 << ICSR_PENDSTSET_Offset)) != 0) &&
     ((scb.ICSR & (1 << ICSR_PENDSTCLR_Offset)) != 0)
  {
    fmt.eprintln(
      "[ERROR] Undefined behaviour when setting both\n" +
      "        PENDSTSET (bit 26)\n" +
      "    and PENDSTCLR (bit 25)\n" +
      "        bits to 1",
    )
    os.exit(1)
  }

  if ((scb.ICSR & (1 << ICSR_ZeroWhenNotInDebug_Offset)) != ICSR_ZeroNotInDbg) {
    fmt.eprintfln("[ERROR] Written to SCB ICSR %s, %s",
      "bit 23", "a ReadOnly bit",
    )
    os.exit(1)
  }

  if ((scb.ICSR & (1 << ICSR_ISRPENDING_Offset)) !=
      (ctx.prev_ICSR & (1 << ICSR_ISRPENDING_Offset)))
  {
    fmt.eprintfln("[ERROR] Written to SCB ICSR %s, %s",
      "bit 22", "a ReadOnly bit",
    )
    os.exit(1)
  }

  if ((scb.ICSR & (0xF << ICSR_VECTPENDING_Offset)) !=
      (ctx.prev_ICSR & (0xF << ICSR_VECTPENDING_Offset)))
  {
    fmt.eprintfln("[ERROR] Written to SCB ICSR %s, %s",
      "bits [20:12]", "ReadOnly bits",
    )
    os.exit(1)
  }

  if ((scb.ICSR & (1 << ICSR_RETTOBASE_Offset)) !=
      (ctx.prev_ICSR & (1 << ICSR_RETTOBASE_Offset)))
  {
    fmt.eprintfln("[ERROR] Written to SCB ICSR %s, %s",
      "bit 11", "a ReadOnly bit",
    )
    os.exit(1)
  }

  if ((scb.ICSR & (0xF << ICSR_VECTACTIVE_Offset)) !=
      (ctx.prev_ICSR & (0xF << ICSR_VECTACTIVE_Offset)))
  {
    fmt.eprintfln("[ERROR] Written to SCB ICSR %s, %s",
      "bits [8:0]", "ReadOnly bits",
    )
    os.exit(1)
  }
}

@(private="file")
handle_AIRCR :: proc(scb: ^mcu.SCB, ctx: ^SCB_Context)
{
  if (scb.AIRCR & (0xFF << AIRCR_VECTKEY_Offset)) != AIRCR_VECTKEY {
    fmt.eprintln("[WARN ] Written to SCB AIRCR but high 16 bits are not VECTKEY (0x05FA). Ignoring write.")
    return
  }

  if (scb.AIRCR & (1 << AIRCR_ENDIANNESS_Offset)) != AIRCR_ENDIANNESS {
    fmt.eprintln("[ERROR] Written to SCB AIRCR ENDIANNENSS bit, a ReadOnly register")
    os.exit(1)
  }

  if (scb.AIRCR & (1 << AIRCR_SYSRESETREQ_Offset)) != 0 {
    // TODO: Software reset (!)
  }

  if (scb.AIRCR & (3 << 0)) != 0 {
    fmt.eprintln("[ERROR] Written 1 to SCB AIRCR VECTCLRACTIVE or VECTRESET, which should only be 0")
    os.exit(1)
  }
}

@(private="file")
handle_CCR :: proc(scb: ^mcu.SCB, ctx: ^SCB_Context)
{
  if (scb.CCR & (1 << CCR_BP_Offset)) != CCR_BP {
    fmt.eprintln("[ERROR] Written to SCB CCR BP, a ReadOnly bit")
    os.exit(1)
  }

  if (scb.CCR & (1 << CCR_STKALIGN_Offset)) != CCR_STKALIGN {
    fmt.eprintln("[ERROR] Written to SCB CCR STKALIGN, a ReadOnly bit")
    os.exit(1)
  }
}

SCB_handler :: proc(rawctx, this_rawctx: rawptr)
{
  memory := cast(^Memory)rawctx
  scb := memory.SCB_base
  ctx := cast(^SCB_Context)this_rawctx
  // keep a local copy
  scb_current := scb^

  if scb_current.CPUID != CPUID_VALUE {
    fmt.eprintln("[ERROR] Written to SCB CPUID, a ReadOnly register")
    os.exit(1)
  }

  if scb_current.ICSR != ctx.prev_ICSR {
    handle_ICSR(&scb_current, ctx)
    ctx.prev_ICSR = scb.ICSR
  }

  if scb_current.AIRCR != ctx.prev_AIRCR {
    handle_AIRCR(&scb_current, ctx)
    ctx.prev_AIRCR = scb.AIRCR
  }
}

SCB_setup :: proc(rawctx: rawptr) -> rawptr
{
  memory := cast(^Memory)rawctx
  scb := cast(^mcu.SCB)memory.SCB_base

  ctx := new(SCB_Context, memory.arena_allocator)
  ctx.prev_ICSR = 0
  ctx.prev_AIRCR = 0

  scb.CPUID = CPUID_VALUE
  scb.CCR = CCR_BP | CCR_STKALIGN

  vector_table := new([IRQn_Max - IRQn_Min]rawptr, memory.arena_allocator)
  // NOTE: This won't underflow because IRQn_Min is a negative number
  #assert(IRQn_Min < 0)
  vector_table_base := cast([^]rawptr)uintptr(
    i64(uintptr(&vector_table[0])) - i64(IRQn_Min * size_of(rawptr)),
  )
  scb.VTOR = u32(uintptr(&vector_table_base[0]) - uintptr(memory.arena_base))

  get_NVIC_interrupts_from_dynlib(memory, vector_table_base)

  return ctx
}

SCB_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{
  memory := cast(^Memory)rawctx
  scb := memory.SCB_base

  if (scb.ICSR & (1 << ICSR_NMIPENDSET_Offset)) != 0 {
    // TODO: Call NMI exception handler. TODO: move to _handler()
  }
}
