#ifndef SIMULATOR_H
#define SIMULATOR_H

#ifdef SIMULATOR_BUILD

//#ifndef SCnSCB_BASE
//#error Must include this file _after_ any CMSIS or HAL files
//#endif

#undef SCnSCB_BASE
#undef SCB_BASE
#undef SysTick_BASE
#undef NVIC_BASE
#undef ITM_BASE
#undef DWT_BASE
#undef TPI_BASE
#undef CoreDebug_BASE
#undef MPU_BASE
#undef FPU_BASE
#undef TIM2_BASE
#undef TIM3_BASE
#undef TIM4_BASE
#undef TIM5_BASE
#undef TIM6_BASE
#undef TIM7_BASE
#undef TIM13_BASE
#undef TIM14_BASE
#undef VREFBUF_BASE
#undef RTC_BASE
#undef WWDG1_BASE
#undef IWDG1_BASE
#undef SPI2_BASE
#undef SPI3_BASE
#undef SPI4_BASE
#undef SPI5_BASE
#undef SPI6_BASE
#undef USART2_BASE
#undef USART3_BASE
#undef USART6_BASE
#undef USART10_BASE
#undef UART7_BASE
#undef UART8_BASE
#undef UART9_BASE
#undef CRS_BASE
#undef UART4_BASE
#undef UART5_BASE
#undef I2C1_BASE
#undef I2C2_BASE
#undef I2C3_BASE
#undef I2C4_BASE
#undef I2C5_BASE
#undef FDCAN1_BASE
#undef FDCAN2_BASE
#undef FDCAN_CCU_BASE
#undef FDCAN3_BASE
#undef TIM23_BASE
#undef TIM24_BASE
#undef CEC_BASE
#undef LPTIM1_BASE
#undef PWR_BASE
#undef DAC1_BASE
#undef LPUART1_BASE
#undef SWPMI1_BASE
#undef LPTIM4_BASE
#undef LPTIM5_BASE
#undef SYSCFG_BASE
#undef COMP12_BASE
#undef COMP1_BASE
#undef COMP2_BASE
#undef COMP12_COMMON_BASE
#undef OPAMP_BASE
#undef OPAMP1_BASE
#undef OPAMP2_BASE
#undef EXTI_BASE
#undef EXTI_D1_BASE
#undef EXTI_D2_BASE
#undef TIM1_BASE
#undef SPI1_BASE
#undef TIM8_BASE
#undef USART1_BASE
#undef TIM12_BASE
#undef TIM15_BASE
#undef TIM16_BASE
#undef TIM17_BASE
#undef SAI1_BASE
#undef SAI1_Block_A_BASE
#undef SAI1_Block_B_BASE
#undef SAI4_BASE
#undef SAI4_Block_A_BASE
#undef SAI4_Block_B_BASE
#undef SPDIFRX_BASE
#undef DFSDM1_Channel0_BASE
#undef DFSDM1_Channel1_BASE
#undef DFSDM1_Channel2_BASE
#undef DFSDM1_Channel3_BASE
#undef DFSDM1_Channel4_BASE
#undef DFSDM1_Channel5_BASE
#undef DFSDM1_Channel6_BASE
#undef DFSDM1_Channel7_BASE
#undef DFSDM1_Filter0_BASE
#undef DFSDM1_Filter1_BASE
#undef DFSDM1_Filter2_BASE
#undef DFSDM1_Filter3_BASE
#undef DMA2D_BASE
#undef DCMI_BASE
#undef PSSI_BASE
#undef RCC_BASE
#undef FLASH_BASE
#undef CRC_BASE
#undef GPIOA_BASE
#undef GPIOB_BASE
#undef GPIOC_BASE
#undef GPIOD_BASE
#undef GPIOE_BASE
#undef GPIOF_BASE
#undef GPIOG_BASE
#undef GPIOH_BASE
#undef GPIOJ_BASE
#undef GPIOK_BASE
#undef ADC1_BASE
#undef ADC2_BASE
#undef ADC3_BASE
#undef ADC3_COMMON_BASE
#undef ADC12_COMMON_BASE
#undef RNG_BASE
#undef SDMMC2_BASE
#undef DLYB_SDMMC2_BASE
#undef FMAC_BASE
#undef CORDIC_BASE
#undef BDMA_BASE
#undef BDMA_Channel0_BASE
#undef BDMA_Channel1_BASE
#undef BDMA_Channel2_BASE
#undef BDMA_Channel3_BASE
#undef BDMA_Channel4_BASE
#undef BDMA_Channel5_BASE
#undef BDMA_Channel6_BASE
#undef BDMA_Channel7_BASE
#undef RAMECC1_BASE
#undef RAMECC1_Monitor1_BASE
#undef RAMECC1_Monitor2_BASE
#undef RAMECC1_Monitor3_BASE
#undef RAMECC1_Monitor4_BASE
#undef RAMECC1_Monitor5_BASE
#undef RAMECC1_Monitor6_BASE
#undef RAMECC2_BASE
#undef RAMECC2_Monitor1_BASE
#undef RAMECC2_Monitor2_BASE
#undef RAMECC2_Monitor3_BASE
#undef RAMECC3_BASE
#undef RAMECC3_Monitor1_BASE
#undef RAMECC3_Monitor2_BASE
#undef DMAMUX2_BASE
#undef DMAMUX2_Channel0_BASE
#undef DMAMUX2_Channel1_BASE
#undef DMAMUX2_Channel2_BASE
#undef DMAMUX2_Channel3_BASE
#undef DMAMUX2_Channel4_BASE
#undef DMAMUX2_Channel5_BASE
#undef DMAMUX2_Channel6_BASE
#undef DMAMUX2_Channel7_BASE
#undef DMAMUX2_RequestGenerator0_BASE
#undef DMAMUX2_RequestGenerator1_BASE
#undef DMAMUX2_RequestGenerator2_BASE
#undef DMAMUX2_RequestGenerator3_BASE
#undef DMAMUX2_RequestGenerator4_BASE
#undef DMAMUX2_RequestGenerator5_BASE
#undef DMAMUX2_RequestGenerator6_BASE
#undef DMAMUX2_RequestGenerator7_BASE
#undef DMAMUX2_ChannelStatus_BASE
#undef DMAMUX2_RequestGenStatus_BASE
#undef DMA2_BASE
#undef DMA2_Stream0_BASE
#undef DMA2_Stream1_BASE
#undef DMA2_Stream2_BASE
#undef DMA2_Stream3_BASE
#undef DMA2_Stream4_BASE
#undef DMA2_Stream5_BASE
#undef DMA2_Stream6_BASE
#undef DMA2_Stream7_BASE
#undef DMA1_BASE
#undef DMA1_Stream0_BASE
#undef DMA1_Stream1_BASE
#undef DMA1_Stream2_BASE
#undef DMA1_Stream3_BASE
#undef DMA1_Stream4_BASE
#undef DMA1_Stream5_BASE
#undef DMA1_Stream6_BASE
#undef DMA1_Stream7_BASE
#undef DMAMUX1_BASE
#undef DMAMUX1_Channel0_BASE
#undef DMAMUX1_Channel1_BASE
#undef DMAMUX1_Channel2_BASE
#undef DMAMUX1_Channel3_BASE
#undef DMAMUX1_Channel4_BASE
#undef DMAMUX1_Channel5_BASE
#undef DMAMUX1_Channel6_BASE
#undef DMAMUX1_Channel7_BASE
#undef DMAMUX1_Channel8_BASE
#undef DMAMUX1_Channel9_BASE
#undef DMAMUX1_Channel10_BASE
#undef DMAMUX1_Channel11_BASE
#undef DMAMUX1_Channel12_BASE
#undef DMAMUX1_Channel13_BASE
#undef DMAMUX1_Channel14_BASE
#undef DMAMUX1_Channel15_BASE
#undef DMAMUX1_RequestGenerator0_BASE
#undef DMAMUX1_RequestGenerator1_BASE
#undef DMAMUX1_RequestGenerator2_BASE
#undef DMAMUX1_RequestGenerator3_BASE
#undef DMAMUX1_RequestGenerator4_BASE
#undef DMAMUX1_RequestGenerator5_BASE
#undef DMAMUX1_RequestGenerator6_BASE
#undef DMAMUX1_RequestGenerator7_BASE
#undef DMAMUX1_ChannelStatus_BASE
#undef DMAMUX1_RequestGenStatus_BASE
#undef FMC_Bank1_R_BASE
#undef FMC_Bank1E_R_BASE
#undef FMC_Bank2_R_BASE
#undef FMC_Bank3_R_BASE
#undef FMC_Bank5_6_R_BASE
#undef OCTOSPI1_BASE
#undef DLYB_OCTOSPI1_BASE
#undef OCTOSPI2_BASE
#undef DLYB_OCTOSPI2_BASE
#undef OCTOSPIM_BASE
#undef SDMMC1_BASE
#undef DLYB_SDMMC1_BASE
#undef DBGMCU_BASE
#undef HSEM_BASE
#undef HSEM_COMMON_BASE
#undef LTDC_BASE
#undef LTDC_Layer1_BASE
#undef LTDC_Layer2_BASE
#undef MDIOS_BASE
#undef ETH_BASE
#undef MDMA_BASE
#undef MDMA_Channel0_BASE
#undef MDMA_Channel1_BASE
#undef MDMA_Channel2_BASE
#undef MDMA_Channel3_BASE
#undef MDMA_Channel4_BASE
#undef MDMA_Channel5_BASE
#undef MDMA_Channel6_BASE
#undef MDMA_Channel7_BASE
#undef MDMA_Channel8_BASE
#undef MDMA_Channel9_BASE
#undef MDMA_Channel10_BASE
#undef MDMA_Channel11_BASE
#undef MDMA_Channel12_BASE
#undef MDMA_Channel13_BASE
#undef MDMA_Channel14_BASE
#undef MDMA_Channel15_BASE
#undef USB1_OTG_HS_BASE
#undef GPV_BASE

extern void *SCnSCB_BASE;
extern void *SCB_BASE;
extern void *SysTick_BASE;
extern void *NVIC_BASE;
extern void *ITM_BASE;
extern void *DWT_BASE;
extern void *TPI_BASE;
extern void *CoreDebug_BASE;
extern void *MPU_BASE;
extern void *FPU_BASE;
extern void *TIM2_BASE;
extern void *TIM3_BASE;
extern void *TIM4_BASE;
extern void *TIM5_BASE;
extern void *TIM6_BASE;
extern void *TIM7_BASE;
extern void *TIM13_BASE;
extern void *TIM14_BASE;
extern void *VREFBUF_BASE;
extern void *RTC_BASE;
extern void *WWDG1_BASE;
extern void *IWDG1_BASE;
extern void *SPI2_BASE;
extern void *SPI3_BASE;
extern void *SPI4_BASE;
extern void *SPI5_BASE;
extern void *SPI6_BASE;
extern void *USART2_BASE;
extern void *USART3_BASE;
extern void *USART6_BASE;
extern void *USART10_BASE;
extern void *UART7_BASE;
extern void *UART8_BASE;
extern void *UART9_BASE;
extern void *CRS_BASE;
extern void *UART4_BASE;
extern void *UART5_BASE;
extern void *I2C1_BASE;
extern void *I2C2_BASE;
extern void *I2C3_BASE;
extern void *I2C4_BASE;
extern void *I2C5_BASE;
extern void *FDCAN1_BASE;
extern void *FDCAN2_BASE;
extern void *FDCAN_CCU_BASE;
extern void *FDCAN3_BASE;
extern void *TIM23_BASE;
extern void *TIM24_BASE;
extern void *CEC_BASE;
extern void *LPTIM1_BASE;
extern void *PWR_BASE;
extern void *DAC1_BASE;
extern void *LPUART1_BASE;
extern void *SWPMI1_BASE;
extern void *LPTIM4_BASE;
extern void *LPTIM5_BASE;
extern void *SYSCFG_BASE;
extern void *COMP12_BASE;
extern void *COMP1_BASE;
extern void *COMP2_BASE;
extern void *COMP12_COMMON_BASE;
extern void *OPAMP_BASE;
extern void *OPAMP1_BASE;
extern void *OPAMP2_BASE;
extern void *EXTI_BASE;
extern void *EXTI_D1_BASE;
extern void *EXTI_D2_BASE;
extern void *TIM1_BASE;
extern void *SPI1_BASE;
extern void *TIM8_BASE;
extern void *USART1_BASE;
extern void *TIM12_BASE;
extern void *TIM15_BASE;
extern void *TIM16_BASE;
extern void *TIM17_BASE;
extern void *SAI1_BASE;
extern void *SAI1_Block_A_BASE;
extern void *SAI1_Block_B_BASE;
extern void *SAI4_BASE;
extern void *SAI4_Block_A_BASE;
extern void *SAI4_Block_B_BASE;
extern void *SPDIFRX_BASE;
extern void *DFSDM1_Channel0_BASE;
extern void *DFSDM1_Channel1_BASE;
extern void *DFSDM1_Channel2_BASE;
extern void *DFSDM1_Channel3_BASE;
extern void *DFSDM1_Channel4_BASE;
extern void *DFSDM1_Channel5_BASE;
extern void *DFSDM1_Channel6_BASE;
extern void *DFSDM1_Channel7_BASE;
extern void *DFSDM1_Filter0_BASE;
extern void *DFSDM1_Filter1_BASE;
extern void *DFSDM1_Filter2_BASE;
extern void *DFSDM1_Filter3_BASE;
extern void *DMA2D_BASE;
extern void *DCMI_BASE;
extern void *PSSI_BASE;
extern void *RCC_BASE;
extern void *FLASH_BASE;
extern void *CRC_BASE;
extern void *GPIOA_BASE;
extern void *GPIOB_BASE;
extern void *GPIOC_BASE;
extern void *GPIOD_BASE;
extern void *GPIOE_BASE;
extern void *GPIOF_BASE;
extern void *GPIOG_BASE;
extern void *GPIOH_BASE;
extern void *GPIOJ_BASE;
extern void *GPIOK_BASE;
extern void *ADC1_BASE;
extern void *ADC2_BASE;
extern void *ADC3_BASE;
extern void *ADC3_COMMON_BASE;
extern void *ADC12_COMMON_BASE;
extern void *RNG_BASE;
extern void *SDMMC2_BASE;
extern void *DLYB_SDMMC2_BASE;
extern void *FMAC_BASE;
extern void *CORDIC_BASE;
extern void *BDMA_BASE;
extern void *BDMA_Channel0_BASE;
extern void *BDMA_Channel1_BASE;
extern void *BDMA_Channel2_BASE;
extern void *BDMA_Channel3_BASE;
extern void *BDMA_Channel4_BASE;
extern void *BDMA_Channel5_BASE;
extern void *BDMA_Channel6_BASE;
extern void *BDMA_Channel7_BASE;
extern void *RAMECC1_BASE;
extern void *RAMECC1_Monitor1_BASE;
extern void *RAMECC1_Monitor2_BASE;
extern void *RAMECC1_Monitor3_BASE;
extern void *RAMECC1_Monitor4_BASE;
extern void *RAMECC1_Monitor5_BASE;
extern void *RAMECC1_Monitor6_BASE;
extern void *RAMECC2_BASE;
extern void *RAMECC2_Monitor1_BASE;
extern void *RAMECC2_Monitor2_BASE;
extern void *RAMECC2_Monitor3_BASE;
extern void *RAMECC3_BASE;
extern void *RAMECC3_Monitor1_BASE;
extern void *RAMECC3_Monitor2_BASE;
extern void *DMAMUX2_BASE;
extern void *DMAMUX2_Channel0_BASE;
extern void *DMAMUX2_Channel1_BASE;
extern void *DMAMUX2_Channel2_BASE;
extern void *DMAMUX2_Channel3_BASE;
extern void *DMAMUX2_Channel4_BASE;
extern void *DMAMUX2_Channel5_BASE;
extern void *DMAMUX2_Channel6_BASE;
extern void *DMAMUX2_Channel7_BASE;
extern void *DMAMUX2_RequestGenerator0_BASE;
extern void *DMAMUX2_RequestGenerator1_BASE;
extern void *DMAMUX2_RequestGenerator2_BASE;
extern void *DMAMUX2_RequestGenerator3_BASE;
extern void *DMAMUX2_RequestGenerator4_BASE;
extern void *DMAMUX2_RequestGenerator5_BASE;
extern void *DMAMUX2_RequestGenerator6_BASE;
extern void *DMAMUX2_RequestGenerator7_BASE;
extern void *DMAMUX2_ChannelStatus_BASE;
extern void *DMAMUX2_RequestGenStatus_BASE;
extern void *DMA2_BASE;
extern void *DMA2_Stream0_BASE;
extern void *DMA2_Stream1_BASE;
extern void *DMA2_Stream2_BASE;
extern void *DMA2_Stream3_BASE;
extern void *DMA2_Stream4_BASE;
extern void *DMA2_Stream5_BASE;
extern void *DMA2_Stream6_BASE;
extern void *DMA2_Stream7_BASE;
extern void *DMA1_BASE;
extern void *DMA1_Stream0_BASE;
extern void *DMA1_Stream1_BASE;
extern void *DMA1_Stream2_BASE;
extern void *DMA1_Stream3_BASE;
extern void *DMA1_Stream4_BASE;
extern void *DMA1_Stream5_BASE;
extern void *DMA1_Stream6_BASE;
extern void *DMA1_Stream7_BASE;
extern void *DMAMUX1_BASE;
extern void *DMAMUX1_Channel0_BASE;
extern void *DMAMUX1_Channel1_BASE;
extern void *DMAMUX1_Channel2_BASE;
extern void *DMAMUX1_Channel3_BASE;
extern void *DMAMUX1_Channel4_BASE;
extern void *DMAMUX1_Channel5_BASE;
extern void *DMAMUX1_Channel6_BASE;
extern void *DMAMUX1_Channel7_BASE;
extern void *DMAMUX1_Channel8_BASE;
extern void *DMAMUX1_Channel9_BASE;
extern void *DMAMUX1_Channel10_BASE;
extern void *DMAMUX1_Channel11_BASE;
extern void *DMAMUX1_Channel12_BASE;
extern void *DMAMUX1_Channel13_BASE;
extern void *DMAMUX1_Channel14_BASE;
extern void *DMAMUX1_Channel15_BASE;
extern void *DMAMUX1_RequestGenerator0_BASE;
extern void *DMAMUX1_RequestGenerator1_BASE;
extern void *DMAMUX1_RequestGenerator2_BASE;
extern void *DMAMUX1_RequestGenerator3_BASE;
extern void *DMAMUX1_RequestGenerator4_BASE;
extern void *DMAMUX1_RequestGenerator5_BASE;
extern void *DMAMUX1_RequestGenerator6_BASE;
extern void *DMAMUX1_RequestGenerator7_BASE;
extern void *DMAMUX1_ChannelStatus_BASE;
extern void *DMAMUX1_RequestGenStatus_BASE;
extern void *FMC_Bank1_R_BASE;
extern void *FMC_Bank1E_R_BASE;
extern void *FMC_Bank2_R_BASE;
extern void *FMC_Bank3_R_BASE;
extern void *FMC_Bank5_6_R_BASE;
extern void *OCTOSPI1_BASE;
extern void *DLYB_OCTOSPI1_BASE;
extern void *OCTOSPI2_BASE;
extern void *DLYB_OCTOSPI2_BASE;
extern void *OCTOSPIM_BASE;
extern void *SDMMC1_BASE;
extern void *DLYB_SDMMC1_BASE;
extern void *DBGMCU_BASE;
extern void *HSEM_BASE;
extern void *HSEM_COMMON_BASE;
extern void *LTDC_BASE;
extern void *LTDC_Layer1_BASE;
extern void *LTDC_Layer2_BASE;
extern void *MDIOS_BASE;
extern void *ETH_BASE;
extern void *MDMA_BASE;
extern void *MDMA_Channel0_BASE;
extern void *MDMA_Channel1_BASE;
extern void *MDMA_Channel2_BASE;
extern void *MDMA_Channel3_BASE;
extern void *MDMA_Channel4_BASE;
extern void *MDMA_Channel5_BASE;
extern void *MDMA_Channel6_BASE;
extern void *MDMA_Channel7_BASE;
extern void *MDMA_Channel8_BASE;
extern void *MDMA_Channel9_BASE;
extern void *MDMA_Channel10_BASE;
extern void *MDMA_Channel11_BASE;
extern void *MDMA_Channel12_BASE;
extern void *MDMA_Channel13_BASE;
extern void *MDMA_Channel14_BASE;
extern void *MDMA_Channel15_BASE;
extern void *USB1_OTG_HS_BASE;
extern void *GPV_BASE;

typedef struct Simulator_Memory Simulator_Memory;
struct Simulator_Memory {
  void *SCnSCB_base;
  void *SCB_base;

  void *SysTick_base;
  void *NVIC_base;
  void *ITM_base;
  void *DWT_base;
  void *TPI_base;
  void *CoreDebug_base;
  void *MPU_base;
  void *FPU_base;

  void *TIM2_base;
  void *TIM3_base;
  void *TIM4_base;
  void *TIM5_base;
  void *TIM6_base;
  void *TIM7_base;
  void *TIM13_base;
  void *TIM14_base;

  void *VREFBUF_base;
  void *RTC_base;
  void *WWDG1_base;
  void *IWDG1_base;

  void *SPI2_base;
  void *SPI3_base;
  void *SPI4_base;
  void *SPI5_base;
  void *SPI6_base;

  void *USART2_base;
  void *USART3_base;
  void *USART6_base;
  void *USART10_base;
  void *UART7_base;
  void *UART8_base;
  void *UART9_base;
  void *CRS_base;
  void *UART4_base;
  void *UART5_base;
  void *I2C1_base;
  void *I2C2_base;
  void *I2C3_base;
  void *I2C4_base;
  void *I2C5_base;
  void *FDCAN1_base;
  void *FDCAN2_base;
  void *FDCAN_CCU_base;
  void *FDCAN3_base;
  void *TIM23_base;
  void *TIM24_base;
  void *CEC_base;
  void *LPTIM1_base;
  void *PWR_base;
  void *DAC1_base;
  void *LPUART1_base;
  void *SWPMI1_base;
  void *LPTIM4_base;
  void *LPTIM5_base;

  void *SYSCFG_base;
  void *COMP12_base;
  void *COMP1_base;
  void *COMP2_base;
  void *COMP12_COMMON_base;
  void *OPAMP_base;
  void *OPAMP1_base;
  void *OPAMP2_base;

  void *EXTI_base;
  void *EXTI_D1_base;
  void *EXTI_D2_base;
  void *TIM1_base;
  void *SPI1_base;
  void *TIM8_base;
  void *USART1_base;
  void *TIM12_base;
  void *TIM15_base;
  void *TIM16_base;
  void *TIM17_base;
  void *SAI1_base;
  void *SAI1_Block_A_base;
  void *SAI1_Block_B_base;
  void *SAI4_base;
  void *SAI4_Block_A_base;
  void *SAI4_Block_B_base;

  void *SPDIFRX_base;
  void *DFSDM1_Channel0_base;
  void *DFSDM1_Channel1_base;
  void *DFSDM1_Channel2_base;
  void *DFSDM1_Channel3_base;
  void *DFSDM1_Channel4_base;
  void *DFSDM1_Channel5_base;
  void *DFSDM1_Channel6_base;
  void *DFSDM1_Channel7_base;
  void *DFSDM1_Filter0_base;
  void *DFSDM1_Filter1_base;
  void *DFSDM1_Filter2_base;
  void *DFSDM1_Filter3_base;
  void *DMA2D_base;
  void *DCMI_base;
  void *PSSI_base;
  void *RCC_base;
  void *FLASH_base;
  void *CRC_base;

  void *GPIOA_base;
  void *GPIOB_base;
  void *GPIOC_base;
  void *GPIOD_base;
  void *GPIOE_base;
  void *GPIOF_base;
  void *GPIOG_base;
  void *GPIOH_base;
  void *GPIOJ_base;
  void *GPIOK_base;

  void *ADC1_base;
  void *ADC2_base;
  void *ADC3_base;
  void *ADC3_COMMON_base;
  void *ADC12_COMMON_base;

  void *RNG_base;
  void *SDMMC2_base;
  void *DLYB_SDMMC2_base;
  void *FMAC_base;
  void *CORDIC_base;

  void *BDMA_base;
  void *BDMA_Channel0_base;
  void *BDMA_Channel1_base;
  void *BDMA_Channel2_base;
  void *BDMA_Channel3_base;
  void *BDMA_Channel4_base;
  void *BDMA_Channel5_base;
  void *BDMA_Channel6_base;
  void *BDMA_Channel7_base;

  void *RAMECC1_base;
  void *RAMECC1_Monitor1_base;
  void *RAMECC1_Monitor2_base;
  void *RAMECC1_Monitor3_base;
  void *RAMECC1_Monitor4_base;
  void *RAMECC1_Monitor5_base;
  void *RAMECC1_Monitor6_base;

  void *RAMECC2_base;
  void *RAMECC2_Monitor1_base;
  void *RAMECC2_Monitor2_base;
  void *RAMECC2_Monitor3_base;

  void *RAMECC3_base;
  void *RAMECC3_Monitor1_base;
  void *RAMECC3_Monitor2_base;

  void *DMAMUX2_base;
  void *DMAMUX2_Channel0_base;
  void *DMAMUX2_Channel1_base;
  void *DMAMUX2_Channel2_base;
  void *DMAMUX2_Channel3_base;
  void *DMAMUX2_Channel4_base;
  void *DMAMUX2_Channel5_base;
  void *DMAMUX2_Channel6_base;
  void *DMAMUX2_Channel7_base;

  void *DMAMUX2_RequestGenerator0_base;
  void *DMAMUX2_RequestGenerator1_base;
  void *DMAMUX2_RequestGenerator2_base;
  void *DMAMUX2_RequestGenerator3_base;
  void *DMAMUX2_RequestGenerator4_base;
  void *DMAMUX2_RequestGenerator5_base;
  void *DMAMUX2_RequestGenerator6_base;
  void *DMAMUX2_RequestGenerator7_base;

  void *DMAMUX2_ChannelStatus_base;
  void *DMAMUX2_RequestGenStatus_base;

  void *DMA2_base;
  void *DMA2_Stream0_base;
  void *DMA2_Stream1_base;
  void *DMA2_Stream2_base;
  void *DMA2_Stream3_base;
  void *DMA2_Stream4_base;
  void *DMA2_Stream5_base;
  void *DMA2_Stream6_base;
  void *DMA2_Stream7_base;

  void *DMA1_base;
  void *DMA1_Stream0_base;
  void *DMA1_Stream1_base;
  void *DMA1_Stream2_base;
  void *DMA1_Stream3_base;
  void *DMA1_Stream4_base;
  void *DMA1_Stream5_base;
  void *DMA1_Stream6_base;
  void *DMA1_Stream7_base;

  void *DMAMUX1_base;
  void *DMAMUX1_Channel0_base;
  void *DMAMUX1_Channel1_base;
  void *DMAMUX1_Channel2_base;
  void *DMAMUX1_Channel3_base;
  void *DMAMUX1_Channel4_base;
  void *DMAMUX1_Channel5_base;
  void *DMAMUX1_Channel6_base;
  void *DMAMUX1_Channel7_base;
  void *DMAMUX1_Channel8_base;
  void *DMAMUX1_Channel9_base;
  void *DMAMUX1_Channel10_base;
  void *DMAMUX1_Channel11_base;
  void *DMAMUX1_Channel12_base;
  void *DMAMUX1_Channel13_base;
  void *DMAMUX1_Channel14_base;
  void *DMAMUX1_Channel15_base;

  void *DMAMUX1_RequestGenerator0_base;
  void *DMAMUX1_RequestGenerator1_base;
  void *DMAMUX1_RequestGenerator2_base;
  void *DMAMUX1_RequestGenerator3_base;
  void *DMAMUX1_RequestGenerator4_base;
  void *DMAMUX1_RequestGenerator5_base;
  void *DMAMUX1_RequestGenerator6_base;
  void *DMAMUX1_RequestGenerator7_base;

  void *DMAMUX1_ChannelStatus_base;
  void *DMAMUX1_RequestGenStatus_base;

  void *FMC_Bank1_R_base;
  void *FMC_Bank1E_R_base;
  void *FMC_Bank2_R_base;
  void *FMC_Bank3_R_base;
  void *FMC_Bank5_6_R_base;

  void *OCTOSPI1_base;
  void *DLYB_OCTOSPI1_base;
  void *OCTOSPI2_base;
  void *DLYB_OCTOSPI2_base;
  void *OCTOSPIM_base;

  void *SDMMC1_base;
  void *DLYB_SDMMC1_base;

  void *DBGMCU_base;

  void *HSEM_base;
  void *HSEM_COMMON_base;

  void *LTDC_base;
  void *LTDC_Layer1_base;
  void *LTDC_Layer2_base;

  void *MDIOS_base;

  void *ETH_base;
  void *MDMA_base;
  void *MDMA_Channel0_base;
  void *MDMA_Channel1_base;
  void *MDMA_Channel2_base;
  void *MDMA_Channel3_base;
  void *MDMA_Channel4_base;
  void *MDMA_Channel5_base;
  void *MDMA_Channel6_base;
  void *MDMA_Channel7_base;
  void *MDMA_Channel8_base;
  void *MDMA_Channel9_base;
  void *MDMA_Channel10_base;
  void *MDMA_Channel11_base;
  void *MDMA_Channel12_base;
  void *MDMA_Channel13_base;
  void *MDMA_Channel14_base;
  void *MDMA_Channel15_base;

  void *USB1_OTG_HS_base;

  // void *GPV;

  void *arena_base;
};

void Simulator_InitMemory(void *rawmem);

#endif // SIMULATOR_BUILD
#endif // SIMULATOR_H
