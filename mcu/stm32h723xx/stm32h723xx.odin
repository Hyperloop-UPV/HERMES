#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package stm32h723xx

/* File containing
 * - struct definitions for all STM32h723xx peripherals
 * - some constants like IRQ numbers
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

/* Cortex-M Processor Exceptions Numbers */

NonMaskableInt_IRQn     :: -14
HardFault_IRQn          :: -13
MemoryManagement_IRQn   :: -12
BusFault_IRQn           :: -11
UsageFault_IRQn         :: -10
SVCall_IRQn             :: -5
DebugMonitor_IRQn       :: -4
PendSV_IRQn             :: -2
SysTick_IRQn            :: -1

/* STM32 specific Interrupt Numbers */

WWDG_IRQn               :: 0
PVD_AVD_IRQn            :: 1
TAMP_STAMP_IRQn         :: 2
RTC_WKUP_IRQn           :: 3
FLASH_IRQn              :: 4
RCC_IRQn                :: 5
EXTI0_IRQn              :: 6
EXTI1_IRQn              :: 7
EXTI2_IRQn              :: 8
EXTI3_IRQn              :: 9
EXTI4_IRQn              :: 10
DMA1_Stream0_IRQn       :: 11
DMA1_Stream1_IRQn       :: 12
DMA1_Stream2_IRQn       :: 13
DMA1_Stream3_IRQn       :: 14
DMA1_Stream4_IRQn       :: 15
DMA1_Stream5_IRQn       :: 16
DMA1_Stream6_IRQn       :: 17
ADC_IRQn                :: 18
FDCAN1_IT0_IRQn         :: 19
FDCAN2_IT0_IRQn         :: 20
FDCAN1_IT1_IRQn         :: 21
FDCAN2_IT1_IRQn         :: 22
EXTI9_5_IRQn            :: 23
TIM1_BRK_IRQn           :: 24
TIM1_UP_IRQn            :: 25
TIM1_TRG_COM_IRQn       :: 26
TIM1_CC_IRQn            :: 27
TIM2_IRQn               :: 28
TIM3_IRQn               :: 29
TIM4_IRQn               :: 30
I2C1_EV_IRQn            :: 31
I2C1_ER_IRQn            :: 32
I2C2_EV_IRQn            :: 33
I2C2_ER_IRQn            :: 34
SPI1_IRQn               :: 35
SPI2_IRQn               :: 36
USART1_IRQn             :: 37
USART2_IRQn             :: 38
USART3_IRQn             :: 39
EXTI15_10_IRQn          :: 40
RTC_Alarm_IRQn          :: 41
TIM8_BRK_TIM12_IRQn     :: 43
TIM8_UP_TIM13_IRQn      :: 44
TIM8_TRG_COM_TIM14_IRQn :: 45
TIM8_CC_IRQn            :: 46
DMA1_Stream7_IRQn       :: 47
FMC_IRQn                :: 48
SDMMC1_IRQn             :: 49
TIM5_IRQn               :: 50
SPI3_IRQn               :: 51
UART4_IRQn              :: 52
UART5_IRQn              :: 53
TIM6_DAC_IRQn           :: 54
TIM7_IRQn               :: 55
DMA2_Stream0_IRQn       :: 56
DMA2_Stream1_IRQn       :: 57
DMA2_Stream2_IRQn       :: 58
DMA2_Stream3_IRQn       :: 59
DMA2_Stream4_IRQn       :: 60
ETH_IRQn                :: 61
ETH_WKUP_IRQn           :: 62
FDCAN_CAL_IRQn          :: 63
DMA2_Stream5_IRQn       :: 68
DMA2_Stream6_IRQn       :: 69
DMA2_Stream7_IRQn       :: 70
USART6_IRQn             :: 71
I2C3_EV_IRQn            :: 72
I2C3_ER_IRQn            :: 73
OTG_HS_EP1_OUT_IRQn     :: 74
OTG_HS_EP1_IN_IRQn      :: 75
OTG_HS_WKUP_IRQn        :: 76
OTG_HS_IRQn             :: 77
DCMI_PSSI_IRQn          :: 78
RNG_IRQn                :: 80
FPU_IRQn                :: 81
UART7_IRQn              :: 82
UART8_IRQn              :: 83
SPI4_IRQn               :: 84
SPI5_IRQn               :: 85
SPI6_IRQn               :: 86
SAI1_IRQn               :: 87
LTDC_IRQn               :: 88
LTDC_ER_IRQn            :: 89
DMA2D_IRQn              :: 90
OCTOSPI1_IRQn           :: 92
LPTIM1_IRQn             :: 93
CEC_IRQn                :: 94
I2C4_EV_IRQn            :: 95
I2C4_ER_IRQn            :: 96
SPDIF_RX_IRQn           :: 97
DMAMUX1_OVR_IRQn        :: 102
DFSDM1_FLT0_IRQn        :: 110
DFSDM1_FLT1_IRQn        :: 111
DFSDM1_FLT2_IRQn        :: 112
DFSDM1_FLT3_IRQn        :: 113
SWPMI1_IRQn             :: 115
TIM15_IRQn              :: 116
TIM16_IRQn              :: 117
TIM17_IRQn              :: 118
MDIOS_WKUP_IRQn         :: 119
MDIOS_IRQn              :: 120
MDMA_IRQn               :: 122
SDMMC2_IRQn             :: 124
HSEM1_IRQn              :: 125
ADC3_IRQn               :: 127
DMAMUX2_OVR_IRQn        :: 128
BDMA_Channel0_IRQn      :: 129
BDMA_Channel1_IRQn      :: 130
BDMA_Channel2_IRQn      :: 131
BDMA_Channel3_IRQn      :: 132
BDMA_Channel4_IRQn      :: 133
BDMA_Channel5_IRQn      :: 134
BDMA_Channel6_IRQn      :: 135
BDMA_Channel7_IRQn      :: 136
COMP_IRQn               :: 137
LPTIM2_IRQn             :: 138
LPTIM3_IRQn             :: 139
LPTIM4_IRQn             :: 140
LPTIM5_IRQn             :: 141
LPUART1_IRQn            :: 142
CRS_IRQn                :: 144
ECC_IRQn                :: 145
SAI4_IRQn               :: 146
DTS_IRQn                :: 147
WAKEUP_PIN_IRQn         :: 149
OCTOSPI2_IRQn           :: 150
FMAC_IRQn               :: 153
CORDIC_IRQn             :: 154
UART9_IRQn              :: 155
USART10_IRQn            :: 156
I2C5_EV_IRQn            :: 157
I2C5_ER_IRQn            :: 158
FDCAN3_IT0_IRQn         :: 159
FDCAN3_IT1_IRQn         :: 160
TIM23_IRQn              :: 161
TIM24_IRQn              :: 162

/* Timer */
TIM :: struct {
  /*!< TIM control register 1,                   Address offset: 0x00 */
  CR1: u32, // ReadWrite
  /*!< TIM control register 2,                   Address offset: 0x04 */
  CR2: u32, // ReadWrite
  /*!< TIM slave mode control register,          Address offset: 0x08 */
  SMCR: u32, // ReadWrite
  /*!< TIM DMA/interrupt enable register,        Address offset: 0x0C */
  DIER: u32, // ReadWrite
  /*!< TIM status register,                      Address offset: 0x10 */
  SR: u32, // ReadWrite
  /*!< TIM event generation register,            Address offset: 0x14 */
  EGR: u32, // ReadWrite
  /*!< TIM capture/compare mode register 1,      Address offset: 0x18 */
  CCMR1: u32, // ReadWrite
  /*!< TIM capture/compare mode register 2,      Address offset: 0x1C */
  CCMR2: u32, // ReadWrite
  /*!< TIM capture/compare enable register,      Address offset: 0x20 */
  CCER: u32, // ReadWrite
  /*!< TIM counter register,                     Address offset: 0x24 */
  CNT: u32, // ReadWrite
  /*!< TIM prescaler,                            Address offset: 0x28 */
  PSC: u32, // ReadWrite
  /*!< TIM auto-reload register,                 Address offset: 0x2C */
  ARR: u32, // ReadWrite
  /*!< TIM repetition counter register,          Address offset: 0x30 */
  RCR: u32, // ReadWrite
  /*!< TIM capture/compare register 1,           Address offset: 0x34 */
  CCR1: u32, // ReadWrite
  /*!< TIM capture/compare register 2,           Address offset: 0x38 */
  CCR2: u32, // ReadWrite
  /*!< TIM capture/compare register 3,           Address offset: 0x3C */
  CCR3: u32, // ReadWrite
  /*!< TIM capture/compare register 4,           Address offset: 0x40 */
  CCR4: u32, // ReadWrite
  /*!< TIM break and dead-time register,         Address offset: 0x44 */
  BDTR: u32, // ReadWrite
  /*!< TIM DMA control register,                 Address offset: 0x48 */
  DCR: u32, // ReadWrite
  /*!< TIM DMA address for full transfer,        Address offset: 0x4C */
  DMAR: u32, // ReadWrite
  /*!< Reserved, 0x50                                                 */
  RESERVED1: u32,
  /*!< TIM capture/compare mode register 3,      Address offset: 0x54 */
  CCMR3: u32, // ReadWrite
  /*!< TIM capture/compare register5,            Address offset: 0x58 */
  CCR5: u32, // ReadWrite
  /*!< TIM capture/compare register6,            Address offset: 0x5C */
  CCR6: u32, // ReadWrite
  /*!< TIM alternate function option register 1, Address offset: 0x60 */
  AF1: u32, // ReadWrite
  /*!< TIM alternate function option register 2, Address offset: 0x64 */
  AF2: u32, // ReadWrite
  /*!< TIM Input Selection register,             Address offset: 0x68 */
  TISEL: u32, // ReadWrite
}

/* VREFBUF */
VREFBUF :: struct {
  /*!< VREFBUF control and status register,         Address offset: 0x00 */
  CSR: u32, // ReadWrite
  /*!< VREFBUF calibration and control register,    Address offset: 0x04 */
  CCR: u32, // ReadWrite
}

/* Real-Time Clock */
RTC :: struct {
  /*!< RTC time register,                                         Address offset: 0x00 */
  TR: u32, // ReadWrite
  /*!< RTC date register,                                         Address offset: 0x04 */
  DR: u32, // ReadWrite
  /*!< RTC control register,                                      Address offset: 0x08 */
  CR: u32, // ReadWrite
  /*!< RTC initialization and status register,                    Address offset: 0x0C */
  ISR: u32, // ReadWrite
  /*!< RTC prescaler register,                                    Address offset: 0x10 */
  PRER: u32, // ReadWrite
  /*!< RTC wakeup timer register,                                 Address offset: 0x14 */
  WUTR: u32, // ReadWrite
  /*!< Reserved,                                                  Address offset: 0x18 */
  RESERVED: u32,
  /*!< RTC alarm A register,                                      Address offset: 0x1C */
  ALRMAR: u32, // ReadWrite
  /*!< RTC alarm B register,                                      Address offset: 0x20 */
  ALRMBR: u32, // ReadWrite
  /*!< RTC write protection register,                             Address offset: 0x24 */
  WPR: u32, // ReadWrite
  /*!< RTC sub second register,                                   Address offset: 0x28 */
  SSR: u32, // ReadWrite
  /*!< RTC shift control register,                                Address offset: 0x2C */
  SHIFTR: u32, // ReadWrite
  /*!< RTC time stamp time register,                              Address offset: 0x30 */
  TSTR: u32, // ReadWrite
  /*!< RTC time stamp date register,                              Address offset: 0x34 */
  TSDR: u32, // ReadWrite
  /*!< RTC time-stamp sub second register,                        Address offset: 0x38 */
  TSSSR: u32, // ReadWrite
  /*!< RTC calibration register,                                  Address offset: 0x3C */
  CALR: u32, // ReadWrite
  /*!< RTC tamper and alternate function configuration register,  Address offset: 0x40 */
  TAFCR: u32, // ReadWrite
  /*!< RTC alarm A sub second register,                           Address offset: 0x44 */
  ALRMASSR: u32, // ReadWrite
  /*!< RTC alarm B sub second register,                           Address offset: 0x48 */
  ALRMBSSR: u32, // ReadWrite
  /*!< RTC option register,                                       Address offset: 0x4C */
  OR: u32, // ReadWrite
  /*!< RTC backup register 0,                                     Address offset: 0x50 */
  BKP0R: u32, // ReadWrite
  /*!< RTC backup register 1,                                     Address offset: 0x54 */
  BKP1R: u32, // ReadWrite
  /*!< RTC backup register 2,                                     Address offset: 0x58 */
  BKP2R: u32, // ReadWrite
  /*!< RTC backup register 3,                                     Address offset: 0x5C */
  BKP3R: u32, // ReadWrite
  /*!< RTC backup register 4,                                     Address offset: 0x60 */
  BKP4R: u32, // ReadWrite
  /*!< RTC backup register 5,                                     Address offset: 0x64 */
  BKP5R: u32, // ReadWrite
  /*!< RTC backup register 6,                                     Address offset: 0x68 */
  BKP6R: u32, // ReadWrite
  /*!< RTC backup register 7,                                     Address offset: 0x6C */
  BKP7R: u32, // ReadWrite
  /*!< RTC backup register 8,                                     Address offset: 0x70 */
  BKP8R: u32, // ReadWrite
  /*!< RTC backup register 9,                                     Address offset: 0x74 */
  BKP9R: u32, // ReadWrite
  /*!< RTC backup register 10,                                    Address offset: 0x78 */
  BKP10R: u32, // ReadWrite
  /*!< RTC backup register 11,                                    Address offset: 0x7C */
  BKP11R: u32, // ReadWrite
  /*!< RTC backup register 12,                                    Address offset: 0x80 */
  BKP12R: u32, // ReadWrite
  /*!< RTC backup register 13,                                    Address offset: 0x84 */
  BKP13R: u32, // ReadWrite
  /*!< RTC backup register 14,                                    Address offset: 0x88 */
  BKP14R: u32, // ReadWrite
  /*!< RTC backup register 15,                                    Address offset: 0x8C */
  BKP15R: u32, // ReadWrite
  /*!< RTC backup register 16,                                    Address offset: 0x90 */
  BKP16R: u32, // ReadWrite
  /*!< RTC backup register 17,                                    Address offset: 0x94 */
  BKP17R: u32, // ReadWrite
  /*!< RTC backup register 18,                                    Address offset: 0x98 */
  BKP18R: u32, // ReadWrite
  /*!< RTC backup register 19,                                    Address offset: 0x9C */
  BKP19R: u32, // ReadWrite
  /*!< RTC backup register 20,                                    Address offset: 0xA0 */
  BKP20R: u32, // ReadWrite
  /*!< RTC backup register 21,                                    Address offset: 0xA4 */
  BKP21R: u32, // ReadWrite
  /*!< RTC backup register 22,                                    Address offset: 0xA8 */
  BKP22R: u32, // ReadWrite
  /*!< RTC backup register 23,                                    Address offset: 0xAC */
  BKP23R: u32, // ReadWrite
  /*!< RTC backup register 24,                                    Address offset: 0xB0 */
  BKP24R: u32, // ReadWrite
  /*!< RTC backup register 25,                                    Address offset: 0xB4 */
  BKP25R: u32, // ReadWrite
  /*!< RTC backup register 26,                                    Address offset: 0xB8 */
  BKP26R: u32, // ReadWrite
  /*!< RTC backup register 27,                                    Address offset: 0xBC */
  BKP27R: u32, // ReadWrite
  /*!< RTC backup register 28,                                    Address offset: 0xC0 */
  BKP28R: u32, // ReadWrite
  /*!< RTC backup register 29,                                    Address offset: 0xC4 */
  BKP29R: u32, // ReadWrite
  /*!< RTC backup register 30,                                    Address offset: 0xC8 */
  BKP30R: u32, // ReadWrite
  /*!< RTC backup register 31,                                    Address offset: 0xCC */
  BKP31R: u32, // ReadWrite
}

/* Window Watchdog */
WWDG :: struct {
  /*!< WWDG Control register,       Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< WWDG Configuration register, Address offset: 0x04 */
  CFR: u32, // ReadWrite
  /*!< WWDG Status register,        Address offset: 0x08 */
  SR: u32, // ReadWrite
}

/* Independent Watchdog */
IWDG :: struct {
  /*!< IWDG Key register,       Address offset: 0x00 */
  KR: u32, // ReadWrite
  /*!< IWDG Prescaler register, Address offset: 0x04 */
  PR: u32, // ReadWrite
  /*!< IWDG Reload register,    Address offset: 0x08 */
  RLR: u32, // ReadWrite
  /*!< IWDG Status register,    Address offset: 0x0C */
  SR: u32, // ReadWrite
  /*!< IWDG Window register,    Address offset: 0x10 */
  WINR: u32, // ReadWrite
}

/* Serial Peripheral Interface */
SPI :: struct {
  /*!< SPI/I2S Control register 1,                      Address offset: 0x00 */
  CR1: u32, // ReadWrite
  /*!< SPI Control register 2,                          Address offset: 0x04 */
  CR2: u32, // ReadWrite
  /*!< SPI Configuration register 1,                    Address offset: 0x08 */
  CFG1: u32, // ReadWrite
  /*!< SPI Configuration register 2,                    Address offset: 0x0C */
  CFG2: u32, // ReadWrite
  /*!< SPI/I2S Interrupt Enable register,               Address offset: 0x10 */
  IER: u32, // ReadWrite
  /*!< SPI/I2S Status register,                         Address offset: 0x14 */
  SR: u32, // ReadWrite
  /*!< SPI/I2S Interrupt/Status flags clear register,   Address offset: 0x18 */
  IFCR: u32, // ReadWrite
  /*!< Reserved, 0x1C                                                        */
  RESERVED0: u32,
  /*!< SPI/I2S Transmit data register,                  Address offset: 0x20 */
  TXDR: u32, // ReadWrite
  /*!< Reserved, 0x24-0x2C                                                   */
  RESERVED1: [3]u32,
  /*!< SPI/I2S Receive data register,                   Address offset: 0x30 */
  RXDR: u32, // ReadWrite
  /*!< Reserved, 0x34-0x3C                                                   */
  RESERVED2: [3]u32,
  /*!< SPI CRC Polynomial register,                     Address offset: 0x40 */
  CRCPOLY: u32, // ReadWrite
  /*!< SPI Transmitter CRC register,                    Address offset: 0x44 */
  TXCRC: u32, // ReadWrite
  /*!< SPI Receiver CRC register,                       Address offset: 0x48 */
  RXCRC: u32, // ReadWrite
  /*!< SPI Underrun data register,                      Address offset: 0x4C */
  UDRDR: u32, // ReadWrite
  /*!< I2S Configuration register,                      Address offset: 0x50 */
  I2SCFGR: u32, // ReadWrite
}

/* Universal Synchronous Asynchronous Receiver Transmitter */
USART :: struct {
  /*!< USART Control register 1,                 Address offset: 0x00 */
  CR1: u32, // ReadWrite
  /*!< USART Control register 2,                 Address offset: 0x04 */
  CR2: u32, // ReadWrite
  /*!< USART Control register 3,                 Address offset: 0x08 */
  CR3: u32, // ReadWrite
  /*!< USART Baud rate register,                 Address offset: 0x0C */
  BRR: u32, // ReadWrite
  /*!< USART Guard time and prescaler register,  Address offset: 0x10 */
  GTPR: u32, // ReadWrite
  /*!< USART Receiver Time Out register,         Address offset: 0x14 */
  RTOR: u32, // ReadWrite
  /*!< USART Request register,                   Address offset: 0x18 */
  RQR: u32, // ReadWrite
  /*!< USART Interrupt and status register,      Address offset: 0x1C */
  ISR: u32, // ReadWrite
  /*!< USART Interrupt flag Clear register,      Address offset: 0x20 */
  ICR: u32, // ReadWrite
  /*!< USART Receive Data register,              Address offset: 0x24 */
  RDR: u32, // ReadWrite
  /*!< USART Transmit Data register,             Address offset: 0x28 */
  TDR: u32, // ReadWrite
  /*!< USART clock Prescaler register,           Address offset: 0x2C */
  PRESC: u32, // ReadWrite
}

/* Clock Recovery System */
CRS :: struct {
  /*!< CRS ccontrol register,              Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< CRS configuration register,         Address offset: 0x04 */
  CFGR: u32, // ReadWrite
  /*!< CRS interrupt and status register,  Address offset: 0x08 */
  ISR: u32, // ReadWrite
  /*!< CRS interrupt flag clear register,  Address offset: 0x0C */
  ICR: u32, // ReadWrite
}

/* Inter-integrated Circuit Interface */
I2C :: struct {
  /*!< I2C Control register 1,            Address offset: 0x00 */
  CR1: u32, // ReadWrite
  /*!< I2C Control register 2,            Address offset: 0x04 */
  CR2: u32, // ReadWrite
  /*!< I2C Own address 1 register,        Address offset: 0x08 */
  OAR1: u32, // ReadWrite
  /*!< I2C Own address 2 register,        Address offset: 0x0C */
  OAR2: u32, // ReadWrite
  /*!< I2C Timing register,               Address offset: 0x10 */
  TIMINGR: u32, // ReadWrite
  /*!< I2C Timeout register,              Address offset: 0x14 */
  TIMEOUTR: u32, // ReadWrite
  /*!< I2C Interrupt and status register, Address offset: 0x18 */
  ISR: u32, // ReadWrite
  /*!< I2C Interrupt clear register,      Address offset: 0x1C */
  ICR: u32, // ReadWrite
  /*!< I2C PEC register,                  Address offset: 0x20 */
  PECR: u32, // ReadWrite
  /*!< I2C Receive data register,         Address offset: 0x24 */
  RXDR: u32, // ReadWrite
  /*!< I2C Transmit data register,        Address offset: 0x28 */
  TXDR: u32, // ReadWrite
}

/* FD Controller Area Network */
FDCAN :: struct {
  /*!< FDCAN Core Release register,                                     Address offset: 0x000 */
  CREL: u32, // ReadWrite
  /*!< FDCAN Endian register,                                           Address offset: 0x004 */
  ENDN: u32, // ReadWrite
  /*!< Reserved,                                                                        0x008 */
  RESERVED1: u32,
  /*!< FDCAN Data Bit Timing & Prescaler register,                      Address offset: 0x00C */
  DBTP: u32, // ReadWrite
  /*!< FDCAN Test register,                                             Address offset: 0x010 */
  TEST: u32, // ReadWrite
  /*!< FDCAN RAM Watchdog register,                                     Address offset: 0x014 */
  RWD: u32, // ReadWrite
  /*!< FDCAN CC Control register,                                       Address offset: 0x018 */
  CCCR: u32, // ReadWrite
  /*!< FDCAN Nominal Bit Timing & Prescaler register,                   Address offset: 0x01C */
  NBTP: u32, // ReadWrite
  /*!< FDCAN Timestamp Counter Configuration register,                  Address offset: 0x020 */
  TSCC: u32, // ReadWrite
  /*!< FDCAN Timestamp Counter Value register,                          Address offset: 0x024 */
  TSCV: u32, // ReadWrite
  /*!< FDCAN Timeout Counter Configuration register,                    Address offset: 0x028 */
  TOCC: u32, // ReadWrite
  /*!< FDCAN Timeout Counter Value register,                            Address offset: 0x02C */
  TOCV: u32, // ReadWrite
  /*!< Reserved,                                                                0x030 - 0x03C */
  RESERVED2: [4]u32,
  /*!< FDCAN Error Counter register,                                    Address offset: 0x040 */
  ECR: u32, // ReadWrite
  /*!< FDCAN Protocol Status register,                                  Address offset: 0x044 */
  PSR: u32, // ReadWrite
  /*!< FDCAN Transmitter Delay Compensation register,                   Address offset: 0x048 */
  TDCR: u32, // ReadWrite
  /*!< Reserved,                                                                        0x04C */
  RESERVED3: u32,
  /*!< FDCAN Interrupt register,                                        Address offset: 0x050 */
  IR: u32, // ReadWrite
  /*!< FDCAN Interrupt Enable register,                                 Address offset: 0x054 */
  IE: u32, // ReadWrite
  /*!< FDCAN Interrupt Line Select register,                            Address offset: 0x058 */
  ILS: u32, // ReadWrite
  /*!< FDCAN Interrupt Line Enable register,                            Address offset: 0x05C */
  ILE: u32, // ReadWrite
  /*!< Reserved,                                                                0x060 - 0x07C */
  RESERVED4: [8]u32,
  /*!< FDCAN Global Filter Configuration register,                      Address offset: 0x080 */
  GFC: u32, // ReadWrite
  /*!< FDCAN Standard ID Filter Configuration register,                 Address offset: 0x084 */
  SIDFC: u32, // ReadWrite
  /*!< FDCAN Extended ID Filter Configuration register,                 Address offset: 0x088 */
  XIDFC: u32, // ReadWrite
  /*!< Reserved,                                                                        0x08C */
  RESERVED5: u32,
  /*!< FDCAN Extended ID AND Mask register,                             Address offset: 0x090 */
  XIDAM: u32, // ReadWrite
  /*!< FDCAN High Priority Message Status register,                     Address offset: 0x094 */
  HPMS: u32, // ReadWrite
  /*!< FDCAN New Data 1 register,                                       Address offset: 0x098 */
  NDAT1: u32, // ReadWrite
  /*!< FDCAN New Data 2 register,                                       Address offset: 0x09C */
  NDAT2: u32, // ReadWrite
  /*!< FDCAN Rx FIFO 0 Configuration register,                          Address offset: 0x0A0 */
  RXF0C: u32, // ReadWrite
  /*!< FDCAN Rx FIFO 0 Status register,                                 Address offset: 0x0A4 */
  RXF0S: u32, // ReadWrite
  /*!< FDCAN Rx FIFO 0 Acknowledge register,                            Address offset: 0x0A8 */
  RXF0A: u32, // ReadWrite
  /*!< FDCAN Rx Buffer Configuration register,                          Address offset: 0x0AC */
  RXBC: u32, // ReadWrite
  /*!< FDCAN Rx FIFO 1 Configuration register,                          Address offset: 0x0B0 */
  RXF1C: u32, // ReadWrite
  /*!< FDCAN Rx FIFO 1 Status register,                                 Address offset: 0x0B4 */
  RXF1S: u32, // ReadWrite
  /*!< FDCAN Rx FIFO 1 Acknowledge register,                            Address offset: 0x0B8 */
  RXF1A: u32, // ReadWrite
  /*!< FDCAN Rx Buffer/FIFO Element Size Configuration register,        Address offset: 0x0BC */
  RXESC: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Configuration register,                          Address offset: 0x0C0 */
  TXBC: u32, // ReadWrite
  /*!< FDCAN Tx FIFO/Queue Status register,                             Address offset: 0x0C4 */
  TXFQS: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Element Size Configuration register,             Address offset: 0x0C8 */
  TXESC: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Request Pending register,                        Address offset: 0x0CC */
  TXBRP: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Add Request register,                            Address offset: 0x0D0 */
  TXBAR: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Cancellation Request register,                   Address offset: 0x0D4 */
  TXBCR: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Transmission Occurred register,                  Address offset: 0x0D8 */
  TXBTO: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Cancellation Finished register,                  Address offset: 0x0DC */
  TXBCF: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Transmission Interrupt Enable register,          Address offset: 0x0E0 */
  TXBTIE: u32, // ReadWrite
  /*!< FDCAN Tx Buffer Cancellation Finished Interrupt Enable register, Address offset: 0x0E4 */
  TXBCIE: u32, // ReadWrite
  /*!< Reserved,                                                                0x0E8 - 0x0EC */
  RESERVED6: [2]u32,
  /*!< FDCAN Tx Event FIFO Configuration register,                      Address offset: 0x0F0 */
  TXEFC: u32, // ReadWrite
  /*!< FDCAN Tx Event FIFO Status register,                             Address offset: 0x0F4 */
  TXEFS: u32, // ReadWrite
  /*!< FDCAN Tx Event FIFO Acknowledge register,                        Address offset: 0x0F8 */
  TXEFA: u32, // ReadWrite
  /*!< Reserved,                                                                        0x0FC */
  RESERVED7: u32,
}

/* FD Controller Area Network Clock Calibration Unit */
FDCAN_CCU :: struct {
  /*!< Clock Calibration Unit Core Release register, Address offset: 0x00 */
  CREL: u32, // ReadWrite
  /*!< Calibration Configuration register,           Address offset: 0x04 */
  CCFG: u32, // ReadWrite
  /*!< Calibration Status register,                  Address offset: 0x08 */
  CSTAT: u32, // ReadWrite
  /*!< Calibration Watchdog register,                Address offset: 0x0C */
  CWD: u32, // ReadWrite
  /*!< CCU Interrupt register,                       Address offset: 0x10 */
  IR: u32, // ReadWrite
  /*!< CCU Interrupt Enable register,                Address offset: 0x14 */
  IE: u32, // ReadWrite
}

/* Consumer Electronics Control */
CEC :: struct {
  /*!< CEC control register,              Address offset:0x00 */
  CR: u32, // ReadWrite
  /*!< CEC configuration register,        Address offset:0x04 */
  CFGR: u32, // ReadWrite
  /*!< CEC Tx data register ,             Address offset:0x08 */
  TXDR: u32, // ReadWrite
  /*!< CEC Rx Data Register,              Address offset:0x0C */
  RXDR: u32, // ReadWrite
  /*!< CEC Interrupt and Status Register, Address offset:0x10 */
  ISR: u32, // ReadWrite
  /*!< CEC interrupt enable register,     Address offset:0x14 */
  IER: u32, // ReadWrite
}

/* Low Power Timer */
LPTIM :: struct {
  /*!< LPTIM Interrupt and Status register,         Address offset: 0x00 */
  ISR: u32, // ReadWrite
  /*!< LPTIM Interrupt Clear register,              Address offset: 0x04 */
  ICR: u32, // ReadWrite
  /*!< LPTIM Interrupt Enable register,             Address offset: 0x08 */
  IER: u32, // ReadWrite
  /*!< LPTIM Configuration register,                Address offset: 0x0C */
  CFGR: u32, // ReadWrite
  /*!< LPTIM Control register,                      Address offset: 0x10 */
  CR: u32, // ReadWrite
  /*!< LPTIM Compare register,                      Address offset: 0x14 */
  CMP: u32, // ReadWrite
  /*!< LPTIM Autoreload register,                   Address offset: 0x18 */
  ARR: u32, // ReadWrite
  /*!< LPTIM Counter register,                      Address offset: 0x1C */
  CNT: u32, // ReadWrite
  /*!< Reserved, 0x20                                                    */
  RESERVED1: u32,
  /*!< LPTIM Configuration register,                Address offset: 0x24 */
  CFGR2: u32, // ReadWrite
}

/* Power Control */
PWR :: struct {
  /*!< PWR power control register 1,            Address offset: 0x00 */
  CR1: u32, // ReadWrite
  /*!< PWR power control status register 1,     Address offset: 0x04 */
  CSR1: u32, // ReadWrite
  /*!< PWR power control register 2,            Address offset: 0x08 */
  CR2: u32, // ReadWrite
  /*!< PWR power control register 3,            Address offset: 0x0C */
  CR3: u32, // ReadWrite
  /*!< PWR CPU control register,                Address offset: 0x10 */
  CPUCR: u32, // ReadWrite
  /*!< Reserved,                                Address offset: 0x14 */
  RESERVED0: u32,
  /*!< PWR D3 domain control register,          Address offset: 0x18 */
  D3CR: u32, // ReadWrite
  /*!< Reserved,                                Address offset: 0x1C */
  RESERVED1: u32,
  /*!< PWR wakeup clear register,               Address offset: 0x20 */
  WKUPCR: u32, // ReadWrite
  /*!< PWR wakeup flag register,                Address offset: 0x24 */
  WKUPFR: u32, // ReadWrite
  /*!< PWR wakeup enable and polarity register, Address offset: 0x28 */
  WKUPEPR: u32, // ReadWrite
}

/* Digital to Analog Converter */
DAC :: struct {
  /*!< DAC control register,                                    Address offset: 0x00 */
  CR: u32,
  /*!< DAC software trigger register,                           Address offset: 0x04 */
  SWTRIGR: u32,
  /*!< DAC channel1 12-bit right-aligned data holding register, Address offset: 0x08 */
  DHR12R1: u32,
  /*!< DAC channel1 12-bit left aligned data holding register,  Address offset: 0x0C */
  DHR12L1: u32,
  /*!< DAC channel1 8-bit right aligned data holding register,  Address offset: 0x10 */
  DHR8R1: u32,
  /*!< DAC channel2 12-bit right aligned data holding register, Address offset: 0x14 */
  DHR12R2: u32,
  /*!< DAC channel2 12-bit left aligned data holding register,  Address offset: 0x18 */
  DHR12L2: u32,
  /*!< DAC channel2 8-bit right-aligned data holding register,  Address offset: 0x1C */
  DHR8R2: u32,
  /*!< Dual DAC 12-bit right-aligned data holding register,     Address offset: 0x20 */
  DHR12RD: u32,
  /*!< DUAL DAC 12-bit left aligned data holding register,      Address offset: 0x24 */
  DHR12LD: u32,
  /*!< DUAL DAC 8-bit right aligned data holding register,      Address offset: 0x28 */
  DHR8RD: u32,
  /*!< DAC channel1 data output register,                       Address offset: 0x2C */
  DOR1: u32,
  /*!< DAC channel2 data output register,                       Address offset: 0x30 */
  DOR2: u32,
  /*!< DAC status register,                                     Address offset: 0x34 */
  SR: u32,
  /*!< DAC calibration control register,                        Address offset: 0x38 */
  CCR: u32,
  /*!< DAC mode control register,                               Address offset: 0x3C */
  MCR: u32,
  /*!< DAC Sample and Hold sample time register 1,              Address offset: 0x40 */
  SHSR1: u32,
  /*!< DAC Sample and Hold sample time register 2,              Address offset: 0x44 */
  SHSR2: u32,
  /*!< DAC Sample and Hold hold time register,                  Address offset: 0x48 */
  SHHR: u32,
  /*!< DAC Sample and Hold refresh time register,               Address offset: 0x4C */
  SHRR: u32,
}

/* Single Wire Protocol Master Interface SPWMI */
SWPMI :: struct {
  /*!< SWPMI Configuration/Control register,     Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< SWPMI bitrate register,                   Address offset: 0x04 */
  BRR: u32, // ReadWrite
  /*!< Reserved, 0x08                                                 */
  RESERVED1: u32,
  /*!< SWPMI Interrupt and Status register,      Address offset: 0x0C */
  ISR: u32, // ReadWrite
  /*!< SWPMI Interrupt Flag Clear register,      Address offset: 0x10 */
  ICR: u32, // ReadWrite
  /*!< SWPMI Interrupt Enable register,          Address offset: 0x14 */
  IER: u32, // ReadWrite
  /*!< SWPMI Receive Frame Length register,      Address offset: 0x18 */
  RFL: u32, // ReadWrite
  /*!< SWPMI Transmit data register,             Address offset: 0x1C */
  TDR: u32, // ReadWrite
  /*!< SWPMI Receive data register,              Address offset: 0x20 */
  RDR: u32, // ReadWrite
  /*!< SWPMI Option register,                    Address offset: 0x24 */
  OR: u32, // ReadWrite
}

/* DTS */
DTS :: struct {
  /*!< DTS configuration register,                Address offset: 0x00 */
  CFGR1: u32, // ReadWrite
  /*!< Reserved,                                  Address offset: 0x04 */
  RESERVED0: u32,
  /*!< DTS T0 Value register,                     Address offset: 0x08 */
  T0VALR1: u32, // ReadWrite
  /*!< Reserved,                                  Address offset: 0x0C */
  RESERVED1: u32,
  /*!< DTS Ramp value register,                   Address offset: 0x10 */
  RAMPVALR: u32, // ReadWrite
  /*!< DTS Interrupt threshold register,          Address offset: 0x14 */
  ITR1: u32, // ReadWrite
  /*!< Reserved,                                  Address offset: 0x18 */
  RESERVED2: u32,
  /*!< DTS data register,                         Address offset: 0x1C */
  DR: u32, // ReadWrite
  /*!< DTS status register                        Address offset: 0x20 */
  SR: u32, // ReadWrite
  /*!< DTS Interrupt enable register,             Address offset: 0x24 */
  ITENR: u32, // ReadWrite
  /*!< DTS Clear Interrupt flag register,         Address offset: 0x28 */
  ICIFR: u32, // ReadWrite
  /*!< DTS option register 1,                     Address offset: 0x2C */
  OR: u32, // ReadWrite
}

/* System Configuration Controller */
SYSCFG :: struct {
  /*!< Reserved,                                           Address offset: 0x00        */
  RESERVED1: u32,
  /*!< SYSCFG peripheral mode configuration register,      Address offset: 0x04        */
  PMCR: u32, // ReadWrite
  /*!< SYSCFG external interrupt configuration registers,  Address offset: 0x08-0x14   */
  EXTICR: [4]u32, // ReadWrite
  /*!< SYSCFG configuration registers,                     Address offset: 0x18        */
  CFGR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x1C        */
  RESERVED2: u32,
  /*!< SYSCFG compensation cell control/status register,   Address offset: 0x20        */
  CCCSR: u32, // ReadWrite
  /*!< SYSCFG compensation cell value register,            Address offset: 0x24        */
  CCVR: u32, // ReadWrite
  /*!< SYSCFG compensation cell code register,             Address offset: 0x28        */
  CCCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x2C        */
  RESERVED3: u32,
  /*!< ADC2 internal input alternate connection register,  Address offset: 0x30        */
  ADC2ALT: u32, // ReadWrite
  /*!< Reserved, 0x34-0x120                                                            */
  RESERVED4: [60]u32,
  /*!< SYSCFG package register,                            Address offset: 0x124       */
  PKGR: u32, // ReadWrite
  /*!< Reserved, 0x128-0x2FC                                                           */
  RESERVED5: [118]u32,
  /*!< SYSCFG user register 0,                             Address offset: 0x300       */
  UR0: u32, // ReadWrite
  /*!< SYSCFG user register 1,                             Address offset: 0x304       */
  UR1: u32, // ReadWrite
  /*!< SYSCFG user register 2,                             Address offset: 0x308       */
  UR2: u32, // ReadWrite
  /*!< SYSCFG user register 3,                             Address offset: 0x30C       */
  UR3: u32, // ReadWrite
  /*!< SYSCFG user register 4,                             Address offset: 0x310       */
  UR4: u32, // ReadWrite
  /*!< SYSCFG user register 5,                             Address offset: 0x314       */
  UR5: u32, // ReadWrite
  /*!< SYSCFG user register 6,                             Address offset: 0x318       */
  UR6: u32, // ReadWrite
  /*!< SYSCFG user register 7,                             Address offset: 0x31C       */
  UR7: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x320-0x328 */
  RESERVED6: [3]u32,
  /*!< SYSCFG user register 11,                            Address offset: 0x32C       */
  UR11: u32, // ReadWrite
  /*!< SYSCFG user register 12,                            Address offset: 0x330       */
  UR12: u32, // ReadWrite
  /*!< SYSCFG user register 13,                            Address offset: 0x334       */
  UR13: u32, // ReadWrite
  /*!< SYSCFG user register 14,                            Address offset: 0x338       */
  UR14: u32, // ReadWrite
  /*!< SYSCFG user register 15,                            Address offset: 0x33C       */
  UR15: u32, // ReadWrite
  /*!< SYSCFG user register 16,                            Address offset: 0x340       */
  UR16: u32, // ReadWrite
  /*!< SYSCFG user register 17,                            Address offset: 0x344       */
  UR17: u32, // ReadWrite
  /*!< SYSCFG user register 18,                            Address offset: 0x348       */
  UR18: u32, // ReadWrite
}

/* Comparator */
COMPOPT :: struct {
  /*!< Comparator status register,                    Address offset: 0x00 */
  SR: u32, // ReadWrite
  /*!< Comparator interrupt clear flag register,       Address offset: 0x04 */
  ICFR: u32, // ReadWrite
  /*!< Comparator option register,                  Address offset: 0x08 */
  OR: u32, // ReadWrite
}

COMP :: struct {
  /*!< Comparator configuration register  ,           Address offset: 0x00 */
  CFGR: u32, // ReadWrite
}

COMP_Common :: struct {
  /*!< COMP control and status register, used for bits common to several COMP instances, Address offset: 0x00 */
  CFGR: u32, // ReadWrite
}

/* Operational Amplifier (OPAMP) */
OPAMP :: struct {
  /*!< OPAMP control/status register,                      Address offset: 0x00 */
  CSR: u32, // ReadWrite
  /*!< OPAMP offset trimming register for normal mode,     Address offset: 0x04 */
  OTR: u32, // ReadWrite
  /*!< OPAMP offset trimming register for high speed mode, Address offset: 0x08 */
  HSOTR: u32, // ReadWrite
}

/* External Interrupt/Event Controller */
EXTI :: struct {
  /*!< EXTI Rising trigger selection register,          Address offset: 0x00 */
  RTSR1: u32, // ReadWrite
  /*!< EXTI Falling trigger selection register,         Address offset: 0x04 */
  FTSR1: u32, // ReadWrite
  /*!< EXTI Software interrupt event register,          Address offset: 0x08 */
  SWIER1: u32, // ReadWrite
  /*!< EXTI D3 Pending mask register, (same register as to SRDPMR1) Address offset: 0x0C */
  D3PMR1: u32, // ReadWrite
  /*!< EXTI D3 Pending clear selection register low, (same register as to SRDPCR1L)     Address offset: 0x10 */
  D3PCR1L: u32, // ReadWrite
  /*!< EXTI D3 Pending clear selection register High, (same register as to SRDPCR1H)   Address offset: 0x14 */
  D3PCR1H: u32, // ReadWrite
  /*!< Reserved,                                        0x18 to 0x1C         */
  RESERVED1: [2]u32,
  /*!< EXTI Rising trigger selection register,          Address offset: 0x20 */
  RTSR2: u32, // ReadWrite
  /*!< EXTI Falling trigger selection register,         Address offset: 0x24 */
  FTSR2: u32, // ReadWrite
  /*!< EXTI Software interrupt event register,          Address offset: 0x28 */
  SWIER2: u32, // ReadWrite
  /*!< EXTI D3 Pending mask register, (same register as to SRDPMR2) Address offset: 0x2C */
  D3PMR2: u32, // ReadWrite
  /*!< EXTI D3 Pending clear selection register low, (same register as to SRDPCR2L)  Address offset: 0x30 */
  D3PCR2L: u32, // ReadWrite
  /*!< EXTI D3 Pending clear selection register High, (same register as to SRDPCR2H) Address offset: 0x34 */
  D3PCR2H: u32, // ReadWrite
  /*!< Reserved,                                        0x38 to 0x3C         */
  RESERVED2: [2]u32,
  /*!< EXTI Rising trigger selection register,          Address offset: 0x40 */
  RTSR3: u32, // ReadWrite
  /*!< EXTI Falling trigger selection register,         Address offset: 0x44 */
  FTSR3: u32, // ReadWrite
  /*!< EXTI Software interrupt event register,          Address offset: 0x48 */
  SWIER3: u32, // ReadWrite
  /*!< EXTI D3 Pending mask register, (same register as to SRDPMR3) Address offset: 0x4C */
  D3PMR3: u32, // ReadWrite
  /*!< EXTI D3 Pending clear selection register low, (same register as to SRDPCR3L) Address offset: 0x50 */
  D3PCR3L: u32, // ReadWrite
  /*!< EXTI D3 Pending clear selection register High, (same register as to SRDPCR3H) Address offset: 0x54 */
  D3PCR3H: u32, // ReadWrite
  /*!< Reserved,                                        0x58 to 0x7C         */
  RESERVED3: [10]u32,
  /*!< EXTI Interrupt mask register,                    Address offset: 0x80 */
  IMR1: u32, // ReadWrite
  /*!< EXTI Event mask register,                        Address offset: 0x84 */
  EMR1: u32, // ReadWrite
  /*!< EXTI Pending register,                           Address offset: 0x88 */
  PR1: u32, // ReadWrite
  /*!< Reserved,                                        0x8C                 */
  RESERVED4: u32,
  /*!< EXTI Interrupt mask register,                    Address offset: 0x90 */
  IMR2: u32, // ReadWrite
  /*!< EXTI Event mask register,                        Address offset: 0x94 */
  EMR2: u32, // ReadWrite
  /*!< EXTI Pending register,                           Address offset: 0x98 */
  PR2: u32, // ReadWrite
  /*!< Reserved,                                        0x9C                 */
  RESERVED5: u32,
  /*!< EXTI Interrupt mask register,                    Address offset: 0xA0 */
  IMR3: u32, // ReadWrite
  /*!< EXTI Event mask register,                        Address offset: 0xA4 */
  EMR3: u32, // ReadWrite
  /*!< EXTI Pending register,                           Address offset: 0xA8 */
  PR3: u32, // ReadWrite
}

/*
 * This structure registers corresponds to EXTI_Typdef CPU1/CPU2 registers subset (IMRx, EMRx and PRx), allowing to define EXTI_D1/EXTI_D2
 *   with rapid/common access to these IMRx, EMRx, PRx registers for CPU1 and CPU2.
 *   Note that EXTI_D1 and EXTI_D2 bases addresses are calculated to point to CPUx first register:
 *     IMR1   in case of EXTI_D1 that is addressing CPU1 (Cortex-M7)
 *     C2IMR1 in case of EXTI_D2 that is addressing CPU2 (Cortex-M4)
 *   Note: EXTI_D2 and corresponding C2IMRx, C2EMRx and C2PRx registers are available for Dual Core devices only
 */
EXTI_Core :: struct {
  /*!< EXTI Interrupt mask register,                Address offset: 0x00 */
  IMR1: u32, // ReadWrite
  /*!< EXTI Event mask register,                    Address offset: 0x04 */
  EMR1: u32, // ReadWrite
  /*!< EXTI Pending register,                       Address offset: 0x08 */
  PR1: u32, // ReadWrite
  /*!< Reserved, 0x0C                                                    */
  RESERVED1: u32,
  /*!< EXTI Interrupt mask register,                Address offset: 0x10 */
  IMR2: u32, // ReadWrite
  /*!< EXTI Event mask register,                    Address offset: 0x14 */
  EMR2: u32, // ReadWrite
  /*!< EXTI Pending register,                       Address offset: 0x18 */
  PR2: u32, // ReadWrite
  /*!< Reserved, 0x1C                                                    */
  RESERVED2: u32,
  /*!< EXTI Interrupt mask register,                Address offset: 0x20 */
  IMR3: u32, // ReadWrite
  /*!< EXTI Event mask register,                    Address offset: 0x24 */
  EMR3: u32, // ReadWrite
  /*!< EXTI Pending register,                       Address offset: 0x28 */
  PR3: u32, // ReadWrite
}

/* Serial Audio Interface */
SAI :: struct {
  /*!< SAI global configuration register, Address offset: 0x00 */
  GCR: u32, // ReadWrite
  /*!< Reserved, 0x04 - 0x43                                   */
  RESERVED0: [16]u32,
  /*!< SAI PDM control register,          Address offset: 0x44 */
  PDMCR: u32, // ReadWrite
  /*!< SAI PDM delay register,            Address offset: 0x48 */
  PDMDLY: u32, // ReadWrite
}

SAI_Block :: struct {
  /*!< SAI block x configuration register 1,     Address offset: 0x04 */
  CR1: u32, // ReadWrite
  /*!< SAI block x configuration register 2,     Address offset: 0x08 */
  CR2: u32, // ReadWrite
  /*!< SAI block x frame configuration register, Address offset: 0x0C */
  FRCR: u32, // ReadWrite
  /*!< SAI block x slot register,                Address offset: 0x10 */
  SLOTR: u32, // ReadWrite
  /*!< SAI block x interrupt mask register,      Address offset: 0x14 */
  IMR: u32, // ReadWrite
  /*!< SAI block x status register,              Address offset: 0x18 */
  SR: u32, // ReadWrite
  /*!< SAI block x clear flag register,          Address offset: 0x1C */
  CLRFR: u32, // ReadWrite
  /*!< SAI block x data register,                Address offset: 0x20 */
  DR: u32, // ReadWrite
}

/* SPDIF-RX Interface */
SPDIFRX :: struct {
  /*!< Control register,                   Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< Interrupt mask register,            Address offset: 0x04 */
  IMR: u32, // ReadWrite
  /*!< Status register,                    Address offset: 0x08 */
  SR: u32, // ReadWrite
  /*!< Interrupt Flag Clear register,      Address offset: 0x0C */
  IFCR: u32, // ReadWrite
  /*!< Data input register,                Address offset: 0x10 */
  DR: u32, // ReadWrite
  /*!< Channel Status register,            Address offset: 0x14 */
  CSR: u32, // ReadWrite
  /*!< Debug Information register,         Address offset: 0x18 */
  DIR: u32, // ReadWrite
  /*!< Reserved,  0x1A                                          */
  RESERVED2: u32,
}

/* DFSDM channel configuration registers */
DFSDM_Channel :: struct {
  /*!< DFSDM channel configuration register1,                             Address offset: 0x00 */
  CHCFGR1: u32, // ReadWrite
  /*!< DFSDM channel configuration register2,                             Address offset: 0x04 */
  CHCFGR2: u32, // ReadWrite
  /*!< DFSDM channel analog watchdog and short circuit detector register, Address offset: 0x08 */
  CHAWSCDR: u32, // ReadWrite
  /*!< DFSDM channel watchdog filter data register,                       Address offset: 0x0C */
  CHWDATAR: u32, // ReadWrite
  /*!< DFSDM channel data input register,                                 Address offset: 0x10 */
  CHDATINR: u32, // ReadWrite
}

/* DFSDM module registers */
DFSDM_Filter :: struct {
  /*!< DFSDM control register1,                          Address offset: 0x100 */
  FLTCR1: u32, // ReadWrite
  /*!< DFSDM control register2,                          Address offset: 0x104 */
  FLTCR2: u32, // ReadWrite
  /*!< DFSDM interrupt and status register,              Address offset: 0x108 */
  FLTISR: u32, // ReadWrite
  /*!< DFSDM interrupt flag clear register,              Address offset: 0x10C */
  FLTICR: u32, // ReadWrite
  /*!< DFSDM injected channel group selection register,  Address offset: 0x110 */
  FLTJCHGR: u32, // ReadWrite
  /*!< DFSDM filter control register,                    Address offset: 0x114 */
  FLTFCR: u32, // ReadWrite
  /*!< DFSDM data register for injected group,           Address offset: 0x118 */
  FLTJDATAR: u32, // ReadWrite
  /*!< DFSDM data register for regular group,            Address offset: 0x11C */
  FLTRDATAR: u32, // ReadWrite
  /*!< DFSDM analog watchdog high threshold register,    Address offset: 0x120 */
  FLTAWHTR: u32, // ReadWrite
  /*!< DFSDM analog watchdog low threshold register,     Address offset: 0x124 */
  FLTAWLTR: u32, // ReadWrite
  /*!< DFSDM analog watchdog status register             Address offset: 0x128 */
  FLTAWSR: u32, // ReadWrite
  /*!< DFSDM analog watchdog clear flag register         Address offset: 0x12C */
  FLTAWCFR: u32, // ReadWrite
  /*!< DFSDM extreme detector maximum register,          Address offset: 0x130 */
  FLTEXMAX: u32, // ReadWrite
  /*!< DFSDM extreme detector minimum register           Address offset: 0x134 */
  FLTEXMIN: u32, // ReadWrite
  /*!< DFSDM conversion timer,                           Address offset: 0x138 */
  FLTCNVTIMR: u32, // ReadWrite
}

/* DMA2D Controller */
DMA2D :: struct {
  /*!< DMA2D Control Register,                         Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< DMA2D Interrupt Status Register,                Address offset: 0x04 */
  ISR: u32, // ReadWrite
  /*!< DMA2D Interrupt Flag Clear Register,            Address offset: 0x08 */
  IFCR: u32, // ReadWrite
  /*!< DMA2D Foreground Memory Address Register,       Address offset: 0x0C */
  FGMAR: u32, // ReadWrite
  /*!< DMA2D Foreground Offset Register,               Address offset: 0x10 */
  FGOR: u32, // ReadWrite
  /*!< DMA2D Background Memory Address Register,       Address offset: 0x14 */
  BGMAR: u32, // ReadWrite
  /*!< DMA2D Background Offset Register,               Address offset: 0x18 */
  BGOR: u32, // ReadWrite
  /*!< DMA2D Foreground PFC Control Register,          Address offset: 0x1C */
  FGPFCCR: u32, // ReadWrite
  /*!< DMA2D Foreground Color Register,                Address offset: 0x20 */
  FGCOLR: u32, // ReadWrite
  /*!< DMA2D Background PFC Control Register,          Address offset: 0x24 */
  BGPFCCR: u32, // ReadWrite
  /*!< DMA2D Background Color Register,                Address offset: 0x28 */
  BGCOLR: u32, // ReadWrite
  /*!< DMA2D Foreground CLUT Memory Address Register,  Address offset: 0x2C */
  FGCMAR: u32, // ReadWrite
  /*!< DMA2D Background CLUT Memory Address Register,  Address offset: 0x30 */
  BGCMAR: u32, // ReadWrite
  /*!< DMA2D Output PFC Control Register,              Address offset: 0x34 */
  OPFCCR: u32, // ReadWrite
  /*!< DMA2D Output Color Register,                    Address offset: 0x38 */
  OCOLR: u32, // ReadWrite
  /*!< DMA2D Output Memory Address Register,           Address offset: 0x3C */
  OMAR: u32, // ReadWrite
  /*!< DMA2D Output Offset Register,                   Address offset: 0x40 */
  OOR: u32, // ReadWrite
  /*!< DMA2D Number of Line Register,                  Address offset: 0x44 */
  NLR: u32, // ReadWrite
  /*!< DMA2D Line Watermark Register,                  Address offset: 0x48 */
  LWR: u32, // ReadWrite
  /*!< DMA2D AHB Master Timer Configuration Register,  Address offset: 0x4C */
  AMTCR: u32, // ReadWrite
  /*!< Reserved, 0x50-0x3FF */
  RESERVED: [236]u32,
  /*!< DMA2D Foreground CLUT,                          Address offset:400-7FF */
  FGCLUT: [256]u32,
  /*!< DMA2D Background CLUT,                          Address offset:800-BFF */
  BGCLUT: [256]u32,
}

/* DCMI */
DCMI :: struct {
  /*!< DCMI control register 1,                       Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< DCMI status register,                          Address offset: 0x04 */
  SR: u32, // ReadWrite
  /*!< DCMI raw interrupt status register,            Address offset: 0x08 */
  RISR: u32, // ReadWrite
  /*!< DCMI interrupt enable register,                Address offset: 0x0C */
  IER: u32, // ReadWrite
  /*!< DCMI masked interrupt status register,         Address offset: 0x10 */
  MISR: u32, // ReadWrite
  /*!< DCMI interrupt clear register,                 Address offset: 0x14 */
  ICR: u32, // ReadWrite
  /*!< DCMI embedded synchronization code register,   Address offset: 0x18 */
  ESCR: u32, // ReadWrite
  /*!< DCMI embedded synchronization unmask register, Address offset: 0x1C */
  ESUR: u32, // ReadWrite
  /*!< DCMI crop window start,                        Address offset: 0x20 */
  CWSTRTR: u32, // ReadWrite
  /*!< DCMI crop window size,                         Address offset: 0x24 */
  CWSIZER: u32, // ReadWrite
  /*!< DCMI data register,                            Address offset: 0x28 */
  DR: u32, // ReadWrite
}

/* PSSI */
PSSI :: struct {
  /*!< PSSI control register 1,               Address offset: 0x000 */
  CR: u32, // ReadWrite
  /*!< PSSI status register,                  Address offset: 0x004 */
  SR: u32, // ReadWrite
  /*!< PSSI raw interrupt status register,    Address offset: 0x008 */
  RIS: u32, // ReadWrite
  /*!< PSSI interrupt enable register,        Address offset: 0x00C */
  IER: u32, // ReadWrite
  /*!< PSSI masked interrupt status register, Address offset: 0x010 */
  MIS: u32, // ReadWrite
  /*!< PSSI interrupt clear register,         Address offset: 0x014 */
  ICR: u32, // ReadWrite
  /*!< Reserved,                                      0x018 - 0x024 */
  RESERVED1: [4]u32,
  /*!< PSSI data register,                    Address offset: 0x028 */
  DR: u32, // ReadWrite
  /*!< Reserved,                                      0x02C - 0x3EC */
  RESERVED2: [241]u32,
  /*!< PSSI IP HW configuration register,     Address offset: 0x3F0 */
  HWCFGR: u32, // ReadWrite
  /*!< PSSI IP version register,              Address offset: 0x3F4 */
  VERR: u32, // ReadWrite
  /*!< PSSI IP ID register,                   Address offset: 0x3F8 */
  IPIDR: u32, // ReadWrite
  /*!< PSSI SIZE ID register,                 Address offset: 0x3FC */
  SIDR: u32, // ReadWrite
}

/* Reset and Clock Control */
RCC :: struct {
  /*!< RCC clock control register,                                              Address offset: 0x00  */
  CR: u32, // ReadWrite
  /*!< HSI Clock Calibration Register,                                          Address offset: 0x04  */
  HSICFGR: u32, // ReadWrite
  /*!< Clock Recovery RC  Register,                                             Address offset: 0x08  */
  CRRCR: u32, // ReadWrite
  /*!< CSI Clock Calibration Register,                                          Address offset: 0x0C  */
  CSICFGR: u32, // ReadWrite
  /*!< RCC clock configuration register,                                        Address offset: 0x10  */
  CFGR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0x14  */
  RESERVED1: u32,
  /*!< RCC Domain 1 configuration register,                                     Address offset: 0x18  */
  D1CFGR: u32, // ReadWrite
  /*!< RCC Domain 2 configuration register,                                     Address offset: 0x1C  */
  D2CFGR: u32, // ReadWrite
  /*!< RCC Domain 3 configuration register,                                     Address offset: 0x20  */
  D3CFGR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0x24  */
  RESERVED2: u32,
  /*!< RCC PLLs Clock Source Selection Register,                                Address offset: 0x28  */
  PLLCKSELR: u32, // ReadWrite
  /*!< RCC PLLs  Configuration Register,                                        Address offset: 0x2C  */
  PLLCFGR: u32, // ReadWrite
  /*!< RCC PLL1 Dividers Configuration Register,                                Address offset: 0x30  */
  PLL1DIVR: u32, // ReadWrite
  /*!< RCC PLL1 Fractional Divider Configuration Register,                      Address offset: 0x34  */
  PLL1FRACR: u32, // ReadWrite
  /*!< RCC PLL2 Dividers Configuration Register,                                Address offset: 0x38  */
  PLL2DIVR: u32, // ReadWrite
  /*!< RCC PLL2 Fractional Divider Configuration Register,                      Address offset: 0x3C  */
  PLL2FRACR: u32, // ReadWrite
  /*!< RCC PLL3 Dividers Configuration Register,                                Address offset: 0x40  */
  PLL3DIVR: u32, // ReadWrite
  /*!< RCC PLL3 Fractional Divider Configuration Register,                      Address offset: 0x44  */
  PLL3FRACR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0x48  */
  RESERVED3: u32,
  /*!< RCC Domain 1 Kernel Clock Configuration Register                         Address offset: 0x4C  */
  D1CCIPR: u32, // ReadWrite
  /*!< RCC Domain 2 Kernel Clock Configuration Register                         Address offset: 0x50  */
  D2CCIP1R: u32, // ReadWrite
  /*!< RCC Domain 2 Kernel Clock Configuration Register                         Address offset: 0x54  */
  D2CCIP2R: u32, // ReadWrite
  /*!< RCC Domain 3 Kernel Clock Configuration Register                         Address offset: 0x58  */
  D3CCIPR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0x5C  */
  RESERVED4: u32,
  /*!< RCC Clock Source Interrupt Enable Register                               Address offset: 0x60  */
  CIER: u32, // ReadWrite
  /*!< RCC Clock Source Interrupt Flag Register                                 Address offset: 0x64  */
  CIFR: u32, // ReadWrite
  /*!< RCC Clock Source Interrupt Clear Register                                Address offset: 0x68  */
  CICR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0x6C  */
  RESERVED5: u32,
  /*!< RCC Vswitch Backup Domain Control Register,                              Address offset: 0x70  */
  BDCR: u32, // ReadWrite
  /*!< RCC clock control & status register,                                     Address offset: 0x74  */
  CSR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0x78  */
  RESERVED6: u32,
  /*!< RCC AHB3 peripheral reset register,                                      Address offset: 0x7C  */
  AHB3RSTR: u32, // ReadWrite
  /*!< RCC AHB1 peripheral reset register,                                      Address offset: 0x80  */
  AHB1RSTR: u32, // ReadWrite
  /*!< RCC AHB2 peripheral reset register,                                      Address offset: 0x84  */
  AHB2RSTR: u32, // ReadWrite
  /*!< RCC AHB4 peripheral reset register,                                      Address offset: 0x88  */
  AHB4RSTR: u32, // ReadWrite
  /*!< RCC APB3 peripheral reset register,                                      Address offset: 0x8C  */
  APB3RSTR: u32, // ReadWrite
  /*!< RCC APB1 peripheral reset Low Word register,                             Address offset: 0x90  */
  APB1LRSTR: u32, // ReadWrite
  /*!< RCC APB1 peripheral reset High Word register,                            Address offset: 0x94  */
  APB1HRSTR: u32, // ReadWrite
  /*!< RCC APB2 peripheral reset register,                                      Address offset: 0x98  */
  APB2RSTR: u32, // ReadWrite
  /*!< RCC APB4 peripheral reset register,                                      Address offset: 0x9C  */
  APB4RSTR: u32, // ReadWrite
  /*!< RCC RCC Global Control  Register,                                        Address offset: 0xA0  */
  GCR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0xA4  */
  RESERVED8: u32,
  /*!< RCC Domain 3 Autonomous Mode Register,                                   Address offset: 0xA8  */
  D3AMR: u32, // ReadWrite
  /*!< Reserved, 0xAC-0xCC                                                      Address offset: 0xAC  */
  RESERVED11: [9]u32,
  /*!< RCC Reset status register,                                               Address offset: 0xD0  */
  RSR: u32, // ReadWrite
  /*!< RCC AHB3 peripheral clock  register,                                     Address offset: 0xD4  */
  AHB3ENR: u32, // ReadWrite
  /*!< RCC AHB1 peripheral clock  register,                                     Address offset: 0xD8  */
  AHB1ENR: u32, // ReadWrite
  /*!< RCC AHB2 peripheral clock  register,                                     Address offset: 0xDC  */
  AHB2ENR: u32, // ReadWrite
  /*!< RCC AHB4 peripheral clock  register,                                     Address offset: 0xE0  */
  AHB4ENR: u32, // ReadWrite
  /*!< RCC APB3 peripheral clock  register,                                     Address offset: 0xE4  */
  APB3ENR: u32, // ReadWrite
  /*!< RCC APB1 peripheral clock  Low Word register,                            Address offset: 0xE8  */
  APB1LENR: u32, // ReadWrite
  /*!< RCC APB1 peripheral clock  High Word register,                           Address offset: 0xEC  */
  APB1HENR: u32, // ReadWrite
  /*!< RCC APB2 peripheral clock  register,                                     Address offset: 0xF0  */
  APB2ENR: u32, // ReadWrite
  /*!< RCC APB4 peripheral clock  register,                                     Address offset: 0xF4  */
  APB4ENR: u32, // ReadWrite
  /*!< Reserved,                                                                Address offset: 0xF8  */
  RESERVED12: u32,
  /*!< RCC AHB3 peripheral sleep clock  register,                               Address offset: 0xFC  */
  AHB3LPENR: u32, // ReadWrite
  /*!< RCC AHB1 peripheral sleep clock  register,                               Address offset: 0x100 */
  AHB1LPENR: u32, // ReadWrite
  /*!< RCC AHB2 peripheral sleep clock  register,                               Address offset: 0x104 */
  AHB2LPENR: u32, // ReadWrite
  /*!< RCC AHB4 peripheral sleep clock  register,                               Address offset: 0x108 */
  AHB4LPENR: u32, // ReadWrite
  /*!< RCC APB3 peripheral sleep clock  register,                               Address offset: 0x10C */
  APB3LPENR: u32, // ReadWrite
  /*!< RCC APB1 peripheral sleep clock  Low Word register,                      Address offset: 0x110 */
  APB1LLPENR: u32, // ReadWrite
  /*!< RCC APB1 peripheral sleep clock  High Word register,                     Address offset: 0x114 */
  APB1HLPENR: u32, // ReadWrite
  /*!< RCC APB2 peripheral sleep clock  register,                               Address offset: 0x118 */
  APB2LPENR: u32, // ReadWrite
  /*!< RCC APB4 peripheral sleep clock  register,                               Address offset: 0x11C */
  APB4LPENR: u32, // ReadWrite
  /*!< Reserved, 0x120-0x12C                                                    Address offset: 0x120 */
  RESERVED13: [4]u32,
}

/* FLASH Registers */
FLASH :: struct {
  /*!< FLASH access control register,                            Address offset: 0x00  */
  ACR: u32, // ReadWrite
  /*!< Flash Key Register for bank1,                             Address offset: 0x04  */
  KEYR1: u32, // ReadWrite
  /*!< Flash Option Key Register,                                Address offset: 0x08  */
  OPTKEYR: u32, // ReadWrite
  /*!< Flash Control Register for bank1,                         Address offset: 0x0C  */
  CR1: u32, // ReadWrite
  /*!< Flash Status Register for bank1,                          Address offset: 0x10  */
  SR1: u32, // ReadWrite
  /*!< Flash Control Register for bank1,                         Address offset: 0x14  */
  CCR1: u32, // ReadWrite
  /*!< Flash Option Control Register,                            Address offset: 0x18  */
  OPTCR: u32, // ReadWrite
  /*!< Flash Option Status Current Register,                     Address offset: 0x1C  */
  OPTSR_CUR: u32, // ReadWrite
  /*!< Flash Option Status to Program Register,                  Address offset: 0x20  */
  OPTSR_PRG: u32, // ReadWrite
  /*!< Flash Option Clear Control Register,                      Address offset: 0x24  */
  OPTCCR: u32, // ReadWrite
  /*!< Flash Current Protection Address Register for bank1,      Address offset: 0x28  */
  PRAR_CUR1: u32, // ReadWrite
  /*!< Flash Protection Address to Program Register for bank1,   Address offset: 0x2C  */
  PRAR_PRG1: u32, // ReadWrite
  /*!< Flash Current Secure Address Register for bank1,          Address offset: 0x30  */
  SCAR_CUR1: u32, // ReadWrite
  /*!< Flash Secure Address to Program Register for bank1,       Address offset: 0x34  */
  SCAR_PRG1: u32, // ReadWrite
  /*!< Flash Current Write Protection Register on bank1,         Address offset: 0x38  */
  WPSN_CUR1: u32, // ReadWrite
  /*!< Flash Write Protection to Program Register on bank1,      Address offset: 0x3C  */
  WPSN_PRG1: u32, // ReadWrite
  /*!< Flash Current Boot Address for Pelican Core Register,     Address offset: 0x40  */
  BOOT_CUR: u32, // ReadWrite
  /*!< Flash Boot Address to Program for Pelican Core Register,  Address offset: 0x44  */
  BOOT_PRG: u32, // ReadWrite
  /*!< Reserved, 0x48 to 0x4C                                                          */
  RESERVED0: [2]u32,
  /*!< Flash CRC Control register For Bank1 Register ,           Address offset: 0x50  */
  CRCCR1: u32, // ReadWrite
  /*!< Flash CRC Start Address Register for Bank1 ,              Address offset: 0x54  */
  CRCSADD1: u32, // ReadWrite
  /*!< Flash CRC End Address Register for Bank1 ,                Address offset: 0x58  */
  CRCEADD1: u32, // ReadWrite
  /*!< Flash CRC Data Register for Bank1 ,                       Address offset: 0x5C  */
  CRCDATA: u32, // ReadWrite
  /*!< Flash ECC Fail Address For Bank1 Register ,               Address offset: 0x60  */
  ECC_FA1: u32, // ReadWrite
  /*!< Reserved, 0x64 to 0x6C                                                          */
  RESERVED: [3]u32,
  /*!< Flash Option Status Current Register 2,                   Address offset: 0x70  */
  OPTSR2_CUR: u32, // ReadWrite
  /*!< Flash Option Status to Program Register 2,                Address offset: 0x74  */
  OPTSR2_PRG: u32, // ReadWrite
}

/* CRC calculation unit */
CRC :: struct {
  /*!< CRC Data register,                           Address offset: 0x00 */
  DR: u32, // ReadWrite
  /*!< CRC Independent data register,               Address offset: 0x04 */
  IDR: u32, // ReadWrite
  /*!< CRC Control register,                        Address offset: 0x08 */
  CR: u32, // ReadWrite
  /*!< Reserved,                                                    0x0C */
  RESERVED2: u32,
  /*!< Initial CRC value register,                  Address offset: 0x10 */
  INIT: u32, // ReadWrite
  /*!< CRC polynomial register,                     Address offset: 0x14 */
  POL: u32, // ReadWrite
}

/* General Purpose I/O */
GPIO :: struct {
  /*!< GPIO port mode register,               Address offset: 0x00      */
  MODER: u32, // ReadWrite
  /*!< GPIO port output type register,        Address offset: 0x04      */
  OTYPER: u32, // ReadWrite
  /*!< GPIO port output speed register,       Address offset: 0x08      */
  OSPEEDR: u32, // ReadWrite
  /*!< GPIO port pull-up/pull-down register,  Address offset: 0x0C      */
  PUPDR: u32, // ReadWrite
  /*!< GPIO port input data register,         Address offset: 0x10      */
  IDR: u32, // ReadWrite
  /*!< GPIO port output data register,        Address offset: 0x14      */
  ODR: u32, // ReadWrite
  /*!< GPIO port bit set/reset,               Address offset: 0x18      */
  BSRR: u32, // ReadWrite
  /*!< GPIO port configuration lock register, Address offset: 0x1C      */
  LCKR: u32, // ReadWrite
  /*!< GPIO alternate function registers,     Address offset: 0x20-0x24 */
  AFR: [2]u32, // ReadWrite
}

/* Analog to Digital Converter */
ADC :: struct {
  /*!< ADC Interrupt and Status Register,                          Address offset: 0x00 */
  ISR: u32, // ReadWrite
  /*!< ADC Interrupt Enable Register,                              Address offset: 0x04 */
  IER: u32, // ReadWrite
  /*!< ADC control register,                                       Address offset: 0x08 */
  CR: u32, // ReadWrite
  /*!< ADC Configuration register,                                 Address offset: 0x0C */
  CFGR: u32, // ReadWrite
  /*!< ADC Configuration register 2,                               Address offset: 0x10 */
  CFGR2: u32, // ReadWrite
  /*!< ADC sample time register 1,                                 Address offset: 0x14 */
  SMPR1: u32, // ReadWrite
  /*!< ADC sample time register 2,                                 Address offset: 0x18 */
  SMPR2: u32, // ReadWrite
  /*!< Reserved for ADC3, ADC1/2 pre-channel selection,             Address offset: 0x1C */
  PCSEL_RES0: u32, // ReadWrite
  /*!< ADC watchdog Lower threshold register 1,                    Address offset: 0x20 */
  LTR1_TR1: u32, // ReadWrite
  /*!< ADC watchdog higher threshold register 1,                   Address offset: 0x24 */
  HTR1_TR2: u32, // ReadWrite
  /*!< Reserved for ADC1/2, ADC3 threshold register,                Address offset: 0x28 */
  RES1_TR3: u32, // ReadWrite
  /*!< Reserved, 0x02C                                                                  */
  RESERVED2: u32,
  /*!< ADC regular sequence register 1,                            Address offset: 0x30 */
  SQR1: u32, // ReadWrite
  /*!< ADC regular sequence register 2,                            Address offset: 0x34 */
  SQR2: u32, // ReadWrite
  /*!< ADC regular sequence register 3,                            Address offset: 0x38 */
  SQR3: u32, // ReadWrite
  /*!< ADC regular sequence register 4,                            Address offset: 0x3C */
  SQR4: u32, // ReadWrite
  /*!< ADC regular data register,                                  Address offset: 0x40 */
  DR: u32, // ReadWrite
  /*!< Reserved, 0x044                                                                  */
  RESERVED3: u32,
  /*!< Reserved, 0x048                                                                  */
  RESERVED4: u32,
  /*!< ADC injected sequence register,                             Address offset: 0x4C */
  JSQR: u32, // ReadWrite
  /*!< Reserved, 0x050 - 0x05C                                                          */
  RESERVED5: [4]u32,
  /*!< ADC offset register 1,                                      Address offset: 0x60 */
  OFR1: u32, // ReadWrite
  /*!< ADC offset register 2,                                      Address offset: 0x64 */
  OFR2: u32, // ReadWrite
  /*!< ADC offset register 3,                                      Address offset: 0x68 */
  OFR3: u32, // ReadWrite
  /*!< ADC offset register 4,                                      Address offset: 0x6C */
  OFR4: u32, // ReadWrite
  /*!< Reserved, 0x070 - 0x07C                                                          */
  RESERVED6: [4]u32,
  /*!< ADC injected data register 1,                               Address offset: 0x80 */
  JDR1: u32, // ReadWrite
  /*!< ADC injected data register 2,                               Address offset: 0x84 */
  JDR2: u32, // ReadWrite
  /*!< ADC injected data register 3,                               Address offset: 0x88 */
  JDR3: u32, // ReadWrite
  /*!< ADC injected data register 4,                               Address offset: 0x8C */
  JDR4: u32, // ReadWrite
  /*!< Reserved, 0x090 - 0x09C                                                          */
  RESERVED7: [4]u32,
  /*!< ADC  Analog Watchdog 2 Configuration Register,              Address offset: 0xA0 */
  AWD2CR: u32, // ReadWrite
  /*!< ADC  Analog Watchdog 3 Configuration Register,              Address offset: 0xA4 */
  AWD3CR: u32, // ReadWrite
  /*!< Reserved, 0x0A8                                                                  */
  RESERVED8: u32,
  /*!< Reserved, 0x0AC                                                                  */
  RESERVED9: u32,
  /*!< ADC watchdog Lower threshold register 2, Difsel for ADC3,   Address offset: 0xB0 */
  LTR2_DIFSEL: u32, // ReadWrite
  /*!< ADC watchdog Higher threshold register 2, Calfact for ADC3, Address offset: 0xB4 */
  HTR2_CALFACT: u32, // ReadWrite
  /*!< ADC watchdog Lower threshold register 3, specific ADC1/2,   Address offset: 0xB8 */
  LTR3_RES10: u32, // ReadWrite
  /*!< ADC watchdog Higher threshold register 3, specific ADC1/2,  Address offset: 0xBC */
  HTR3_RES11: u32, // ReadWrite
  /*!< ADC Differential Mode Selection Register specific ADC1/2,   Address offset: 0xC0 */
  DIFSEL_RES12: u32, // ReadWrite
  /*!< ADC Calibration Factors specific ADC1/2,                    Address offset: 0xC4 */
  CALFACT_RES13: u32, // ReadWrite
  /*!< ADC Linearity Calibration Factors specific ADC1/2,          Address offset: 0xC8 */
  CALFACT2_RES14: u32, // ReadWrite
}

ADC_Common :: struct {
  /*!< ADC Common status register, Address offset: ADC1/3 base address + 0x300 */
  CSR: u32, // ReadWrite
  /*!< Reserved, ADC1/3 base address + 0x304 */
  RESERVED: u32,
  /*!< ADC common control register, Address offset: ADC1/3 base address + 0x308 */
  CCR: u32, // ReadWrite
  /*!< ADC common regular data register for dual Address offset: ADC1/3 base address + 0x30C */
  CDR: u32, // ReadWrite
  /*!< ADC common regular data register for 32-bit dual mode Address offset: ADC1/3 base address + 0x310 */
  CDR2: u32, // ReadWrite
}

/* RNG */
RNG :: struct {
  /*!< RNG control register, Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< RNG status register,  Address offset: 0x04 */
  SR: u32, // ReadWrite
  /*!< RNG data register,    Address offset: 0x08 */
  DR: u32, // ReadWrite
  RESERVED: u32,
  /*!< RNG health test configuration register, Address offset: 0x10 */
  HTCR: u32, // ReadWrite
}

/* Secure digital input/output Interface */

SDMMC :: struct {
  /*!< SDMMC power control register,             Address offset: 0x00  */
  POWER: u32, // ReadWrite
  /*!< SDMMC clock control register,             Address offset: 0x04  */
  CLKCR: u32, // ReadWrite
  /*!< SDMMC argument register,                  Address offset: 0x08  */
  ARG: u32, // ReadWrite
  /*!< SDMMC command register,                   Address offset: 0x0C  */
  CMD: u32, // ReadWrite
  /*!< SDMMC command response register,          Address offset: 0x10  */
  RESPCMD: u32, // ReadOnly
  /*!< SDMMC response 1 register,                Address offset: 0x14  */
  RESP1: u32, // ReadOnly
  /*!< SDMMC response 2 register,                Address offset: 0x18  */
  RESP2: u32, // ReadOnly
  /*!< SDMMC response 3 register,                Address offset: 0x1C  */
  RESP3: u32, // ReadOnly
  /*!< SDMMC response 4 register,                Address offset: 0x20  */
  RESP4: u32, // ReadOnly
  /*!< SDMMC data timer register,                Address offset: 0x24  */
  DTIMER: u32, // ReadWrite
  /*!< SDMMC data length register,               Address offset: 0x28  */
  DLEN: u32, // ReadWrite
  /*!< SDMMC data control register,              Address offset: 0x2C  */
  DCTRL: u32, // ReadWrite
  /*!< SDMMC data counter register,              Address offset: 0x30  */
  DCOUNT: u32, // ReadOnly
  /*!< SDMMC status register,                    Address offset: 0x34  */
  STA: u32, // ReadOnly
  /*!< SDMMC interrupt clear register,           Address offset: 0x38  */
  ICR: u32, // ReadWrite
  /*!< SDMMC mask register,                      Address offset: 0x3C  */
  MASK: u32, // ReadWrite
  /*!< SDMMC Acknowledgement timer register,     Address offset: 0x40  */
  ACKTIME: u32, // ReadWrite
  /*!< Reserved, 0x44 - 0x4C - 0x4C                                    */
  RESERVED0: [3]u32,
  /*!< SDMMC DMA control register,               Address offset: 0x50  */
  IDMACTRL: u32, // ReadWrite
  /*!< SDMMC DMA buffer size register,           Address offset: 0x54  */
  IDMABSIZE: u32, // ReadWrite
  /*!< SDMMC DMA buffer 0 base address register, Address offset: 0x58  */
  IDMABASE0: u32, // ReadWrite
  /*!< SDMMC DMA buffer 1 base address register, Address offset: 0x5C  */
  IDMABASE1: u32, // ReadWrite
  /*!< Reserved, 0x60-0x7C                                             */
  RESERVED1: [8]u32,
  /*!< SDMMC data FIFO register,                 Address offset: 0x80  */
  FIFO: u32, // ReadWrite
  /*!< Reserved, 0x84-0x3F8                                            */
  RESERVED2: [222]u32,
  /*!< SDMMC data FIFO register,                 Address offset: 0x3FC */
  IPVR: u32, // ReadWrite
}

/* Delay Block DLYB */
DLYB :: struct {
  /*!< DELAY BLOCK control register,  Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< DELAY BLOCK configuration register,  Address offset: 0x04 */
  CFGR: u32, // ReadWrite
}

/* Filter and Mathematical ACcelerator */
FMAC :: struct {
  /*!< FMAC X1 Buffer Configuration register, Address offset: 0x00          */
  X1BUFCFG: u32, // ReadWrite
  /*!< FMAC X2 Buffer Configuration register, Address offset: 0x04          */
  X2BUFCFG: u32, // ReadWrite
  /*!< FMAC Y Buffer Configuration register,  Address offset: 0x08          */
  YBUFCFG: u32, // ReadWrite
  /*!< FMAC Parameter register,               Address offset: 0x0C          */
  PARAM: u32, // ReadWrite
  /*!< FMAC Control register,                 Address offset: 0x10          */
  CR: u32, // ReadWrite
  /*!< FMAC Status register,                  Address offset: 0x14          */
  SR: u32, // ReadWrite
  /*!< FMAC Write Data register,              Address offset: 0x18          */
  WDATA: u32, // ReadWrite
  /*!< FMAC Read Data register,               Address offset: 0x1C          */
  RDATA: u32, // ReadWrite
}

/* COordinate Rotation DIgital Computer */
CORDIC :: struct {
  /*!< CORDIC control and status register,        Address offset: 0x00 */
  CSR: u32, // ReadWrite
  /*!< CORDIC argument register,                  Address offset: 0x04 */
  WDATA: u32, // ReadWrite
  /*!< CORDIC result register,                    Address offset: 0x08 */
  RDATA: u32, // ReadWrite
}

/* Basic Direct Memory Access controller */
BDMA :: struct {
  /*!< DMA interrupt status register,               Address offset: 0x00 */
  ISR: u32, // ReadWrite
  /*!< DMA interrupt flag clear register,           Address offset: 0x04 */
  IFCR: u32, // ReadWrite
}

BDMA_Channel :: struct {
  /*!< DMA channel x configuration register          */
  CCR: u32, // ReadWrite
  /*!< DMA channel x number of data register         */
  CNDTR: u32, // ReadWrite
  /*!< DMA channel x peripheral address register     */
  CPAR: u32, // ReadWrite
  /*!< DMA channel x memory 0 address register       */
  CM0AR: u32, // ReadWrite
  /*!< DMA channel x memory 1 address register       */
  CM1AR: u32, // ReadWrite
}

RAMECC :: struct {
  /*!< RAMECC interrupt enable register */
  IER: u32, // ReadWrite
}

RAMECC_Monitor :: struct {
  /*!< RAMECC monitor configuration register          */
  CR: u32, // ReadWrite
  /*!< RAMECC monitor status register                 */
  SR: u32, // ReadWrite
  /*!< RAMECC monitor failing address register        */
  FAR: u32, // ReadWrite
  /*!< RAMECC monitor failing data low register       */
  FDRL: u32, // ReadWrite
  /*!< RAMECC monitor failing data high register      */
  FDRH: u32, // ReadWrite
  /*!< RAMECC monitor failing ECC error code register */
  FECR: u32, // ReadWrite
}

DMAMUX_Channel :: struct {
  /*!< DMA Multiplexer Channel x Control Register   */
  CCR: u32, // ReadWrite
}

DMAMUX_RequestGen :: struct {
  /*!< DMA Request Generator x Control Register   */
  RGCR: u32, // ReadWrite
}

DMAMUX_ChannelStatus :: struct {
  /*!< DMA Channel Status Register     */
  CSR: u32, // ReadWrite
  /*!< DMA Channel Clear Flag Register */
  CFR: u32, // ReadWrite
}

DMAMUX_RequestGenStatus :: struct {
  /*!< DMA Request Generator Status Register       */
  RGSR: u32, // ReadWrite
  /*!< DMA Request Generator Clear Flag Register   */
  RGCFR: u32, // ReadWrite
}

/* Direct Memory Access controller */
DMA :: struct {
  /*!< DMA low interrupt status register,      Address offset: 0x00 */
  LISR: u32, // ReadWrite
  /*!< DMA high interrupt status register,     Address offset: 0x04 */
  HISR: u32, // ReadWrite
  /*!< DMA low interrupt flag clear register,  Address offset: 0x08 */
  LIFCR: u32, // ReadWrite
  /*!< DMA high interrupt flag clear register, Address offset: 0x0C */
  HIFCR: u32, // ReadWrite
}

DMA_Stream :: struct {
  /*!< DMA stream x configuration register      */
  CR: u32, // ReadWrite
  /*!< DMA stream x number of data register     */
  NDTR: u32, // ReadWrite
  /*!< DMA stream x peripheral address register */
  PAR: u32, // ReadWrite
  /*!< DMA stream x memory 0 address register   */
  M0AR: u32, // ReadWrite
  /*!< DMA stream x memory 1 address register   */
  M1AR: u32, // ReadWrite
  /*!< DMA stream x FIFO control register       */
  FCR: u32, // ReadWrite
}

/* Flexible Memory Controller */
FMC_Bank1 :: struct {
  /*!< NOR/PSRAM chip-select control register(BCR) and chip-select timing register(BTR), Address offset: 0x00-1C */
  BTCR: [8]u32, // ReadWrite
}

FMC_Bank1E :: struct {
  /*!< NOR/PSRAM write timing registers, Address offset: 0x104-0x11C */
  BWTR: [7]u32, // ReadWrite
}

FMC_Bank2 :: struct {
  /*!< NAND Flash control register 2,                       Address offset: 0x60 */
  PCR2: u32, // ReadWrite
  /*!< NAND Flash FIFO status and interrupt register 2,     Address offset: 0x64 */
  SR2: u32, // ReadWrite
  /*!< NAND Flash Common memory space timing register 2,    Address offset: 0x68 */
  PMEM2: u32, // ReadWrite
  /*!< NAND Flash Attribute memory space timing register 2, Address offset: 0x6C */
  PATT2: u32, // ReadWrite
  /*!< Reserved, 0x70                                                            */
  RESERVED0: u32,
  /*!< NAND Flash ECC result registers 2,                   Address offset: 0x74 */
  ECCR2: u32, // ReadWrite
}

FMC_Bank3 :: struct {
  /*!< NAND Flash control register 3,                       Address offset: 0x80 */
  PCR: u32, // ReadWrite
  /*!< NAND Flash FIFO status and interrupt register 3,     Address offset: 0x84 */
  SR: u32, // ReadWrite
  /*!< NAND Flash Common memory space timing register 3,    Address offset: 0x88 */
  PMEM: u32, // ReadWrite
  /*!< NAND Flash Attribute memory space timing register 3, Address offset: 0x8C */
  PATT: u32, // ReadWrite
  /*!< Reserved, 0x90                                                            */
  RESERVED: u32,
  /*!< NAND Flash ECC result registers 3,                   Address offset: 0x94 */
  ECCR: u32, // ReadWrite
}

FMC_Bank5_6 :: struct {
  /*!< SDRAM Control registers ,      Address offset: 0x140-0x144  */
  SDCR: [2]u32, // ReadWrite
  /*!< SDRAM Timing registers ,       Address offset: 0x148-0x14C  */
  SDTR: [2]u32, // ReadWrite
  /*!< SDRAM Command Mode register,    Address offset: 0x150  */
  SDCMR: u32, // ReadWrite
  /*!< SDRAM Refresh Timer register,   Address offset: 0x154  */
  SDRTR: u32, // ReadWrite
  /*!< SDRAM Status register,          Address offset: 0x158  */
  SDSR: u32, // ReadWrite
}

/* OCTO Serial Peripheral Interface */
OCTOSPI :: struct {
  /*!< OCTOSPI Control register,                           Address offset: 0x000 */
  CR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x004 */
  RESERVED: u32,
  /*!< OCTOSPI Device Configuration register 1,            Address offset: 0x008 */
  DCR1: u32, // ReadWrite
  /*!< OCTOSPI Device Configuration register 2,            Address offset: 0x00C */
  DCR2: u32, // ReadWrite
  /*!< OCTOSPI Device Configuration register 3,            Address offset: 0x010 */
  DCR3: u32, // ReadWrite
  /*!< OCTOSPI Device Configuration register 4,            Address offset: 0x014 */
  DCR4: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x018-0x01C */
  RESERVED1: [2]u32,
  /*!< OCTOSPI Status register,                            Address offset: 0x020 */
  SR: u32, // ReadWrite
  /*!< OCTOSPI Flag Clear register,                        Address offset: 0x024 */
  FCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x028-0x03C */
  RESERVED2: [6]u32,
  /*!< OCTOSPI Data Length register,                       Address offset: 0x040 */
  DLR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x044 */
  RESERVED3: u32,
  /*!< OCTOSPI Address register,                           Address offset: 0x048 */
  AR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x04C */
  RESERVED4: u32,
  /*!< OCTOSPI Data register,                              Address offset: 0x050 */
  DR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x054-0x07C */
  RESERVED5: [11]u32,
  /*!< OCTOSPI Polling Status Mask register,               Address offset: 0x080 */
  PSMKR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x084 */
  RESERVED6: u32,
  /*!< OCTOSPI Polling Status Match register,              Address offset: 0x088 */
  PSMAR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x08C */
  RESERVED7: u32,
  /*!< OCTOSPI Polling Interval register,                  Address offset: 0x090 */
  PIR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x094-0x0FC */
  RESERVED8: [27]u32,
  /*!< OCTOSPI Communication Configuration register,       Address offset: 0x100 */
  CCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x104 */
  RESERVED9: u32,
  /*!< OCTOSPI Timing Configuration register,              Address offset: 0x108 */
  TCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x10C */
  RESERVED10: u32,
  /*!< OCTOSPI Instruction register,                       Address offset: 0x110 */
  IR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x114-0x11C */
  RESERVED11: [3]u32,
  /*!< OCTOSPI Alternate Bytes register,                   Address offset: 0x120 */
  ABR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x124-0x12C */
  RESERVED12: [3]u32,
  /*!< OCTOSPI Low Power Timeout register,                 Address offset: 0x130 */
  LPTR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x134-0x13C */
  RESERVED13: [3]u32,
  /*!< OCTOSPI Wrap Communication Configuration register,  Address offset: 0x140 */
  WPCCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x144 */
  RESERVED14: u32,
  /*!< OCTOSPI Wrap Timing Configuration register,         Address offset: 0x148 */
  WPTCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x14C */
  RESERVED15: u32,
  /*!< OCTOSPI Wrap Instruction register,                  Address offset: 0x150 */
  WPIR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x154-0x15C */
  RESERVED16: [3]u32,
  /*!< OCTOSPI Wrap Alternate Bytes register,              Address offset: 0x160 */
  WPABR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x164-0x17C */
  RESERVED17: [7]u32,
  /*!< OCTOSPI Write Communication Configuration register, Address offset: 0x180 */
  WCCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x184 */
  RESERVED18: u32,
  /*!< OCTOSPI Write Timing Configuration register,        Address offset: 0x188 */
  WTCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x18C */
  RESERVED19: u32,
  /*!< OCTOSPI Write Instruction register,                 Address offset: 0x190 */
  WIR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x194-0x19C */
  RESERVED20: [3]u32,
  /*!< OCTOSPI Write Alternate Bytes register,             Address offset: 0x1A0 */
  WABR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x1A4-0x1FC */
  RESERVED21: [23]u32,
  /*!< OCTOSPI Hyperbus Latency Configuration register,    Address offset: 0x200 */
  HLCR: u32, // ReadWrite
  /*!< Reserved,                                           Address offset: 0x204-0x3EC */
  RESERVED22: [122]u32,
  /*!< OCTOSPI HW Configuration register,                  Address offset: 0x3F0 */
  HWCFGR: u32, // ReadWrite
  /*!< OCTOSPI Version register,                           Address offset: 0x3F4 */
  VER: u32, // ReadWrite
  /*!< OCTOSPI Identification register,                    Address offset: 0x3F8 */
  ID: u32, // ReadWrite
  /*!< OCTOPSI HW Magic ID register,                       Address offset: 0x3FC */
  MID: u32, // ReadWrite
}

/* OCTO Serial Peripheral Interface IO Manager */
OCTOSPIM :: struct {
  /*!< OCTOSPI IO Manager Control register,                 Address offset: 0x00 */
  CR: u32, // ReadWrite
  /*!< OCTOSPI IO Manager Port[1:3] Configuration register, Address offset: 0x04-0x20 */
  PCR: [3]u32, // ReadWrite
}

/* Debug MCU */
DBGMCU :: struct {
  /*!< MCU device ID code,                     Address offset: 0x00 */
  IDCODE: u32, // ReadWrite
  /*!< Debug MCU configuration register,       Address offset: 0x04 */
  CR: u32, // ReadWrite
  /*!< Reserved,                             Address offset: 0x08 */
  RESERVED4: [11]u32,
  /*!< Debug MCU APB3FZ1 freeze register,    Address offset: 0x34 */
  APB3FZ1: u32, // ReadWrite
  /*!< Reserved,                             Address offset: 0x38 */
  RESERVED5: u32,
  /*!< Debug MCU APB1LFZ1 freeze register,   Address offset: 0x3C */
  APB1LFZ1: u32, // ReadWrite
  /*!< Reserved,                             Address offset: 0x40 */
  RESERVED6: u32,
  /*!< Debug MCU APB1LFZ1 freeze register,   Address offset: 0x44 */
  APB1HFZ1: u32, // ReadWrite
  /*!< Reserved,                             Address offset: 0x48 */
  RESERVED7: u32,
  /*!< Debug MCU APB2FZ1 freeze register,    Address offset: 0x4C */
  APB2FZ1: u32, // ReadWrite
  /*!< Reserved,                             Address offset: 0x50 */
  RESERVED8: u32,
  /*!< Debug MCU APB4FZ1 freeze register,    Address offset: 0x54 */
  APB4FZ1: u32, // ReadWrite
  /*!< Reserved,                         Address offset: 0x58-0xFCC */
  RESERVED9: [990]u32,
  /*!< Debug MCU peripheral identity register 4,  Address offset: 0xFD0 */
  PIDR4: u32, // ReadWrite
  /*!< Reserved,                            Address offset: 0xFD4-0xFDC */
  RESERVED10: [3]u32,
  /*!< Debug MCU peripheral identity register 0,  Address offset: 0xFE0 */
  PIDR0: u32, // ReadWrite
  /*!< Debug MCU peripheral identity register 1,  Address offset: 0xFE4 */
  PIDR1: u32, // ReadWrite
  /*!< Debug MCU peripheral identity register 2,  Address offset: 0xFE8 */
  PIDR2: u32, // ReadWrite
  /*!< Debug MCU peripheral identity register 3,  Address offset: 0xFEC */
  PIDR3: u32, // ReadWrite
  /*!< Debug MCU component identity register 0,   Address offset: 0xFF0 */
  CIDR0: u32, // ReadWrite
  /*!< Debug MCU component identity register 1,   Address offset: 0xFF4 */
  CIDR1: u32, // ReadWrite
  /*!< Debug MCU component identity register 2,   Address offset: 0xFF8 */
  CIDR2: u32, // ReadWrite
  /*!< Debug MCU component identity register 3,   Address offset: 0xFFC */
  CIDR3: u32, // ReadWrite
}

/* HW Semaphore HSEM */
HSEM :: struct {
  /*!< 2-step write lock and read back registers,     Address offset: 00h-7Ch  */
  R: [32]u32, // ReadWrite
  /*!< 1-step read lock registers,                    Address offset: 80h-FCh  */
  RLR: [32]u32, // ReadWrite
  /*!< HSEM Interrupt enable register ,             Address offset: 100h     */
  C1IER: u32, // ReadWrite
  /*!< HSEM Interrupt clear register ,              Address offset: 104h     */
  C1ICR: u32, // ReadWrite
  /*!< HSEM Interrupt Status register ,             Address offset: 108h     */
  C1ISR: u32, // ReadWrite
  /*!< HSEM Interrupt Masked Status register ,      Address offset: 10Ch     */
  C1MISR: u32, // ReadWrite
  /* Reserved                                       Address offset: 110h-13Ch  */
  Reserved: [12]u32,
  /*!< HSEM Semaphore clear register ,                Address offset: 140h      */
  CR: u32, // ReadWrite
  /*!< HSEM Semaphore clear key register ,            Address offset: 144h      */
  KEYR: u32, // ReadWrite
}

HSEM_Common :: struct {
  /*!< HSEM interrupt enable register ,                Address offset:   0h     */
  IER: u32, // ReadWrite
  /*!< HSEM interrupt clear register ,                 Address offset:   4h     */
  ICR: u32, // ReadWrite
  /*!< HSEM interrupt status register ,                Address offset:   8h     */
  ISR: u32, // ReadWrite
  /*!< HSEM masked interrupt status register ,         Address offset:   Ch     */
  MISR: u32, // ReadWrite
}

/* LCD-TFT Display Controller */
LTDC :: struct {
  /*!< Reserved, 0x00-0x04                                                       */
  RESERVED0: [2]u32,
  /*!< LTDC Synchronization Size Configuration Register,    Address offset: 0x08 */
  SSCR: u32, // ReadWrite
  /*!< LTDC Back Porch Configuration Register,              Address offset: 0x0C */
  BPCR: u32, // ReadWrite
  /*!< LTDC Active Width Configuration Register,            Address offset: 0x10 */
  AWCR: u32, // ReadWrite
  /*!< LTDC Total Width Configuration Register,             Address offset: 0x14 */
  TWCR: u32, // ReadWrite
  /*!< LTDC Global Control Register,                        Address offset: 0x18 */
  GCR: u32, // ReadWrite
  /*!< Reserved, 0x1C-0x20                                                       */
  RESERVED1: [2]u32,
  /*!< LTDC Shadow Reload Configuration Register,           Address offset: 0x24 */
  SRCR: u32, // ReadWrite
  /*!< Reserved, 0x28                                                            */
  RESERVED2: [1]u32,
  /*!< LTDC Background Color Configuration Register,        Address offset: 0x2C */
  BCCR: u32, // ReadWrite
  /*!< Reserved, 0x30                                                            */
  RESERVED3: [1]u32,
  /*!< LTDC Interrupt Enable Register,                      Address offset: 0x34 */
  IER: u32, // ReadWrite
  /*!< LTDC Interrupt Status Register,                      Address offset: 0x38 */
  ISR: u32, // ReadWrite
  /*!< LTDC Interrupt Clear Register,                       Address offset: 0x3C */
  ICR: u32, // ReadWrite
  /*!< LTDC Line Interrupt Position Configuration Register, Address offset: 0x40 */
  LIPCR: u32, // ReadWrite
  /*!< LTDC Current Position Status Register,               Address offset: 0x44 */
  CPSR: u32, // ReadWrite
  /*!< LTDC Current Display Status Register,                 Address offset: 0x48 */
  CDSR: u32, // ReadWrite
}

/* LCD-TFT Display layer x Controller */
LTDC_Layer :: struct {
  /*!< LTDC Layerx Control Register                                  Address offset: 0x84 */
  CR: u32,
  /*!< LTDC Layerx Window Horizontal Position Configuration Register Address offset: 0x88 */
  WHPCR: u32,
  /*!< LTDC Layerx Window Vertical Position Configuration Register   Address offset: 0x8C */
  WVPCR: u32,
  /*!< LTDC Layerx Color Keying Configuration Register               Address offset: 0x90 */
  CKCR: u32,
  /*!< LTDC Layerx Pixel Format Configuration Register               Address offset: 0x94 */
  PFCR: u32,
  /*!< LTDC Layerx Constant Alpha Configuration Register             Address offset: 0x98 */
  CACR: u32,
  /*!< LTDC Layerx Default Color Configuration Register              Address offset: 0x9C */
  DCCR: u32,
  /*!< LTDC Layerx Blending Factors Configuration Register           Address offset: 0xA0 */
  BFCR: u32,
  /*!< Reserved */
  RESERVED0: [2]u32,
  /*!< LTDC Layerx Color Frame Buffer Address Register               Address offset: 0xAC */
  CFBAR: u32,
  /*!< LTDC Layerx Color Frame Buffer Length Register                Address offset: 0xB0 */
  CFBLR: u32,
  /*!< LTDC Layerx ColorFrame Buffer Line Number Register            Address offset: 0xB4 */
  CFBLNR: u32,
  /*!< Reserved */
  RESERVED1: [3]u32,
  /*!< LTDC Layerx CLUT Write Register                               Address offset: 0x144 */
  CLUTWR: u32,
}

/* MDIOS */
MDIOS :: struct {
  CR: u32, // ReadWrite
  WRFR: u32, // ReadWrite
  CWRFR: u32, // ReadWrite
  RDFR: u32, // ReadWrite
  CRDFR: u32, // ReadWrite
  SR: u32, // ReadWrite
  CLRFR: u32, // ReadWrite
  DINR0: u32, // ReadWrite
  RESERVED: [57]u32, // ReadWrite
  DINR1: u32, // ReadWrite
  DINR2: u32, // ReadWrite
  DINR3: u32, // ReadWrite
  DINR4: u32, // ReadWrite
  DINR5: u32, // ReadWrite
  DINR6: u32, // ReadWrite
  DINR7: u32, // ReadWrite
  DINR8: u32, // ReadWrite
  DINR9: u32, // ReadWrite
  DINR10: u32, // ReadWrite
  DINR11: u32, // ReadWrite
  DINR12: u32, // ReadWrite
  DINR13: u32, // ReadWrite
  DINR14: u32, // ReadWrite
  DINR15: u32, // ReadWrite
  DINR16: u32, // ReadWrite
  DINR17: u32, // ReadWrite
  DINR18: u32, // ReadWrite
  DINR19: u32, // ReadWrite
  DINR20: u32, // ReadWrite
  DINR21: u32, // ReadWrite
  DINR22: u32, // ReadWrite
  DINR23: u32, // ReadWrite
  DINR24: u32, // ReadWrite
  DINR25: u32, // ReadWrite
  DINR26: u32, // ReadWrite
  DINR27: u32, // ReadWrite
  DINR28: u32, // ReadWrite
  DINR29: u32, // ReadWrite
  DINR30: u32, // ReadWrite
  DINR31: u32, // ReadWrite
  DOUTR0: u32, // ReadWrite
  DOUTR1: u32, // ReadWrite
  DOUTR2: u32, // ReadWrite
  DOUTR3: u32, // ReadWrite
  DOUTR4: u32, // ReadWrite
  DOUTR5: u32, // ReadWrite
  DOUTR6: u32, // ReadWrite
  DOUTR7: u32, // ReadWrite
  DOUTR8: u32, // ReadWrite
  DOUTR9: u32, // ReadWrite
  DOUTR10: u32, // ReadWrite
  DOUTR11: u32, // ReadWrite
  DOUTR12: u32, // ReadWrite
  DOUTR13: u32, // ReadWrite
  DOUTR14: u32, // ReadWrite
  DOUTR15: u32, // ReadWrite
  DOUTR16: u32, // ReadWrite
  DOUTR17: u32, // ReadWrite
  DOUTR18: u32, // ReadWrite
  DOUTR19: u32, // ReadWrite
  DOUTR20: u32, // ReadWrite
  DOUTR21: u32, // ReadWrite
  DOUTR22: u32, // ReadWrite
  DOUTR23: u32, // ReadWrite
  DOUTR24: u32, // ReadWrite
  DOUTR25: u32, // ReadWrite
  DOUTR26: u32, // ReadWrite
  DOUTR27: u32, // ReadWrite
  DOUTR28: u32, // ReadWrite
  DOUTR29: u32, // ReadWrite
  DOUTR30: u32, // ReadWrite
  DOUTR31: u32, // ReadWrite
}

/* Ethernet MAC */
ETH :: struct {
  MACCR: u32, // ReadWrite
  MACECR: u32, // ReadWrite
  MACPFR: u32, // ReadWrite
  MACWTR: u32, // ReadWrite
  MACHT0R: u32, // ReadWrite
  MACHT1R: u32, // ReadWrite
  RESERVED1: [14]u32,
  MACVTR: u32, // ReadWrite
  RESERVED2: u32,
  MACVHTR: u32, // ReadWrite
  RESERVED3: u32,
  MACVIR: u32, // ReadWrite
  MACIVIR: u32, // ReadWrite
  RESERVED4: [2]u32,
  MACTFCR: u32, // ReadWrite
  RESERVED5: [7]u32,
  MACRFCR: u32, // ReadWrite
  RESERVED6: [7]u32,
  MACISR: u32, // ReadWrite
  MACIER: u32, // ReadWrite
  MACRXTXSR: u32, // ReadWrite
  RESERVED7: u32,
  MACPCSR: u32, // ReadWrite
  MACRWKPFR: u32, // ReadWrite
  RESERVED8: [2]u32,
  MACLCSR: u32, // ReadWrite
  MACLTCR: u32, // ReadWrite
  MACLETR: u32, // ReadWrite
  MAC1USTCR: u32, // ReadWrite
  RESERVED9: [12]u32,
  MACVR: u32, // ReadWrite
  MACDR: u32, // ReadWrite
  RESERVED10: u32,
  MACHWF0R: u32, // ReadWrite
  MACHWF1R: u32, // ReadWrite
  MACHWF2R: u32, // ReadWrite
  RESERVED11: [54]u32,
  MACMDIOAR: u32, // ReadWrite
  MACMDIODR: u32, // ReadWrite
  RESERVED12: [2]u32,
  MACARPAR: u32, // ReadWrite
  RESERVED13: [59]u32,
  MACA0HR: u32, // ReadWrite
  MACA0LR: u32, // ReadWrite
  MACA1HR: u32, // ReadWrite
  MACA1LR: u32, // ReadWrite
  MACA2HR: u32, // ReadWrite
  MACA2LR: u32, // ReadWrite
  MACA3HR: u32, // ReadWrite
  MACA3LR: u32, // ReadWrite
  RESERVED14: [248]u32,
  MMCCR: u32, // ReadWrite
  MMCRIR: u32, // ReadWrite
  MMCTIR: u32, // ReadWrite
  MMCRIMR: u32, // ReadWrite
  MMCTIMR: u32, // ReadWrite
  RESERVED15: [14]u32,
  MMCTSCGPR: u32, // ReadWrite
  MMCTMCGPR: u32, // ReadWrite
  RESERVED16: [5]u32,
  MMCTPCGR: u32, // ReadWrite
  RESERVED17: [10]u32,
  MMCRCRCEPR: u32, // ReadWrite
  MMCRAEPR: u32, // ReadWrite
  RESERVED18: [10]u32,
  MMCRUPGR: u32, // ReadWrite
  RESERVED19: [9]u32,
  MMCTLPIMSTR: u32, // ReadWrite
  MMCTLPITCR: u32, // ReadWrite
  MMCRLPIMSTR: u32, // ReadWrite
  MMCRLPITCR: u32, // ReadWrite
  RESERVED20: [65]u32,
  MACL3L4C0R: u32, // ReadWrite
  MACL4A0R: u32, // ReadWrite
  RESERVED21: [2]u32,
  MACL3A0R0R: u32, // ReadWrite
  MACL3A1R0R: u32, // ReadWrite
  MACL3A2R0R: u32, // ReadWrite
  MACL3A3R0R: u32, // ReadWrite
  RESERVED22: [4]u32,
  MACL3L4C1R: u32, // ReadWrite
  MACL4A1R: u32, // ReadWrite
  RESERVED23: [2]u32,
  MACL3A0R1R: u32, // ReadWrite
  MACL3A1R1R: u32, // ReadWrite
  MACL3A2R1R: u32, // ReadWrite
  MACL3A3R1R: u32, // ReadWrite
  RESERVED24: [108]u32,
  MACTSCR: u32, // ReadWrite
  MACSSIR: u32, // ReadWrite
  MACSTSR: u32, // ReadWrite
  MACSTNR: u32, // ReadWrite
  MACSTSUR: u32, // ReadWrite
  MACSTNUR: u32, // ReadWrite
  MACTSAR: u32, // ReadWrite
  RESERVED25: u32,
  MACTSSR: u32, // ReadWrite
  RESERVED26: [3]u32,
  MACTTSSNR: u32, // ReadWrite
  MACTTSSSR: u32, // ReadWrite
  RESERVED27: [2]u32,
  MACACR: u32, // ReadWrite
  RESERVED28: u32,
  MACATSNR: u32, // ReadWrite
  MACATSSR: u32, // ReadWrite
  MACTSIACR: u32, // ReadWrite
  MACTSEACR: u32, // ReadWrite
  MACTSICNR: u32, // ReadWrite
  MACTSECNR: u32, // ReadWrite
  RESERVED29: [4]u32,
  MACPPSCR: u32, // ReadWrite
  RESERVED30: [3]u32,
  MACPPSTTSR: u32, // ReadWrite
  MACPPSTTNR: u32, // ReadWrite
  MACPPSIR: u32, // ReadWrite
  MACPPSWR: u32, // ReadWrite
  RESERVED31: [12]u32,
  MACPOCR: u32, // ReadWrite
  MACSPI0R: u32, // ReadWrite
  MACSPI1R: u32, // ReadWrite
  MACSPI2R: u32, // ReadWrite
  MACLMIR: u32, // ReadWrite
  RESERVED32: [11]u32,
  MTLOMR: u32, // ReadWrite
  RESERVED33: [7]u32,
  MTLISR: u32, // ReadWrite
  RESERVED34: [55]u32,
  MTLTQOMR: u32, // ReadWrite
  MTLTQUR: u32, // ReadWrite
  MTLTQDR: u32, // ReadWrite
  RESERVED35: [8]u32,
  MTLQICSR: u32, // ReadWrite
  MTLRQOMR: u32, // ReadWrite
  MTLRQMPOCR: u32, // ReadWrite
  MTLRQDR: u32, // ReadWrite
  RESERVED36: [177]u32,
  DMAMR: u32, // ReadWrite
  DMASBMR: u32, // ReadWrite
  DMAISR: u32, // ReadWrite
  DMADSR: u32, // ReadWrite
  RESERVED37: [60]u32,
  DMACCR: u32, // ReadWrite
  DMACTCR: u32, // ReadWrite
  DMACRCR: u32, // ReadWrite
  RESERVED38: [2]u32,
  DMACTDLAR: u32, // ReadWrite
  RESERVED39: u32,
  DMACRDLAR: u32, // ReadWrite
  DMACTDTPR: u32, // ReadWrite
  RESERVED40: u32,
  DMACRDTPR: u32, // ReadWrite
  DMACTDRLR: u32, // ReadWrite
  DMACRDRLR: u32, // ReadWrite
  DMACIER: u32, // ReadWrite
  DMACRIWTR: u32, // ReadWrite
  DMACSFCSR: u32, // ReadWrite
  RESERVED41: u32,
  DMACCATDR: u32, // ReadWrite
  RESERVED42: u32,
  DMACCARDR: u32, // ReadWrite
  RESERVED43: u32,
  DMACCATBR: u32, // ReadWrite
  RESERVED44: u32,
  DMACCARBR: u32, // ReadWrite
  DMACSR: u32, // ReadWrite
  RESERVED45: [2]u32,
  DMACMFCR: u32, // ReadWrite
}

/* MDMA controller */
MDMA :: struct {
  /*!< MDMA Global Interrupt/Status Register 0,          Address offset: 0x00 */
  GISR0: u32, // ReadWrite
}

MDMA_Channel :: struct {
  /*!< MDMA channel x interrupt/status register,             Address offset: 0x40 */
  CISR: u32, // ReadWrite
  /*!< MDMA channel x interrupt flag clear register,         Address offset: 0x44 */
  CIFCR: u32, // ReadWrite
  /*!< MDMA Channel x error status register,                 Address offset: 0x48 */
  CESR: u32, // ReadWrite
  /*!< MDMA channel x control register,                      Address offset: 0x4C */
  CCR: u32, // ReadWrite
  /*!< MDMA channel x Transfer Configuration register,       Address offset: 0x50 */
  CTCR: u32, // ReadWrite
  /*!< MDMA Channel x block number of data register,         Address offset: 0x54 */
  CBNDTR: u32, // ReadWrite
  /*!< MDMA channel x source address register,               Address offset: 0x58 */
  CSAR: u32, // ReadWrite
  /*!< MDMA channel x destination address register,          Address offset: 0x5C */
  CDAR: u32, // ReadWrite
  /*!< MDMA channel x Block Repeat address Update register,  Address offset: 0x60 */
  CBRUR: u32, // ReadWrite
  /*!< MDMA channel x Link Address register,                 Address offset: 0x64 */
  CLAR: u32, // ReadWrite
  /*!< MDMA channel x Trigger and Bus selection Register,    Address offset: 0x68 */
  CTBR: u32, // ReadWrite
  /*!< Reserved, 0x6C                                                             */
  RESERVED0: u32,
  /*!< MDMA channel x Mask address register,                 Address offset: 0x70 */
  CMAR: u32, // ReadWrite
  /*!< MDMA channel x Mask Data register,                    Address offset: 0x74 */
  CMDR: u32, // ReadWrite
}

/* USB_OTG_Core_Registers */
USB_OTG :: struct {
  /*!< USB_OTG Control and Status Register          000h */
  GOTGCTL: u32, // ReadWrite
  /*!< USB_OTG Interrupt Register                   004h */
  GOTGINT: u32, // ReadWrite
  /*!< Core AHB Configuration Register              008h */
  GAHBCFG: u32, // ReadWrite
  /*!< Core USB Configuration Register              00Ch */
  GUSBCFG: u32, // ReadWrite
  /*!< Core Reset Register                          010h */
  GRSTCTL: u32, // ReadWrite
  /*!< Core Interrupt Register                      014h */
  GINTSTS: u32, // ReadWrite
  /*!< Core Interrupt Mask Register                 018h */
  GINTMSK: u32, // ReadWrite
  /*!< Receive Sts Q Read Register                  01Ch */
  GRXSTSR: u32, // ReadWrite
  /*!< Receive Sts Q Read & POP Register            020h */
  GRXSTSP: u32, // ReadWrite
  /*!< Receive FIFO Size Register                   024h */
  GRXFSIZ: u32, // ReadWrite
  /*!< EP0 / Non Periodic Tx FIFO Size Register     028h */
  DIEPTXF0_HNPTXFSIZ: u32, // ReadWrite
  /*!< Non Periodic Tx FIFO/Queue Sts reg           02Ch */
  HNPTXSTS: u32, // ReadWrite
  /*!< Reserved                                     030h */
  Reserved30: [2]u32,
  /*!< General Purpose IO Register                  038h */
  GCCFG: u32, // ReadWrite
  /*!< User ID Register                             03Ch */
  CID: u32, // ReadWrite
  /* USB_OTG core ID                                040h*/
  GSNPSID: u32, // ReadWrite
  /* User HW config1                                044h*/
  GHWCFG1: u32, // ReadWrite
  /* User HW config2                                048h*/
  GHWCFG2: u32, // ReadWrite
  /*!< User HW config3                              04Ch */
  GHWCFG3: u32, // ReadWrite
  /*!< Reserved                                     050h */
  Reserved6: u32,
  /*!< LPM Register                                 054h */
  GLPMCFG: u32, // ReadWrite
  /*!< Power Down Register                          058h */
  GPWRDN: u32, // ReadWrite
  /*!< DFIFO Software Config Register               05Ch */
  GDFIFOCFG: u32, // ReadWrite
  /*!< ADP Timer, Control and Status Register       60Ch */
  GADPCTL: u32, // ReadWrite
  /*!< Reserved                                058h-0FFh */
  Reserved43: [39]u32,
  /*!< Host Periodic Tx FIFO Size Reg               100h */
  HPTXFSIZ: u32, // ReadWrite
  /*!< dev Periodic Transmit FIFO */
  DIEPTXF: [0x0F]u32, // ReadWrite
}

/* Global Programmer View */
GPV :: struct {
  /*!< Reserved,                                                                           Address offset: 0x00-0x1FCC     */
  RESERVED0: [2036]u32,
  /*!< AXI interconnect - peripheral ID4 register,                                         Address offset: 0x1FD0          */
  AXI_PERIPH_ID_4: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x1FD4          */
  AXI_PERIPH_ID_5: u32,
  /*!< Reserved,                                                                           Address offset: 0x1FD8          */
  AXI_PERIPH_ID_6: u32,
  /*!< Reserved,                                                                           Address offset: 0x1FDC          */
  AXI_PERIPH_ID_7: u32,
  /*!< AXI interconnect - peripheral ID0 register,                                         Address offset: 0x1FE0          */
  AXI_PERIPH_ID_0: u32, // ReadWrite
  /*!< AXI interconnect - peripheral ID1 register,                                         Address offset: 0x1FE4          */
  AXI_PERIPH_ID_1: u32, // ReadWrite
  /*!< AXI interconnect - peripheral ID2 register,                                         Address offset: 0x1FE8          */
  AXI_PERIPH_ID_2: u32, // ReadWrite
  /*!< AXI interconnect - peripheral ID3 register,                                         Address offset: 0x1FEC          */
  AXI_PERIPH_ID_3: u32, // ReadWrite
  /*!< AXI interconnect - component ID0 register,                                          Address offset: 0x1FF0          */
  AXI_COMP_ID_0: u32, // ReadWrite
  /*!< AXI interconnect - component ID1 register,                                          Address offset: 0x1FF4          */
  AXI_COMP_ID_1: u32, // ReadWrite
  /*!< AXI interconnect - component ID2 register,                                          Address offset: 0x1FF8          */
  AXI_COMP_ID_2: u32, // ReadWrite
  /*!< AXI interconnect - component ID3 register,                                          Address offset: 0x1FFC          */
  AXI_COMP_ID_3: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x2000-0x2004   */
  RESERVED1: [2]u32,
  /*!< AXI interconnect - TARG 1 bus matrix issuing functionality register,           Address offset: 0x2008          */
  AXI_TARG1_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x200C-0x2020   */
  RESERVED2: [6]u32,
  /*!< AXI interconnect - TARG 1 bus matrix functionality 2 register,                      Address offset: 0x2024          */
  AXI_TARG1_FN_MOD2: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x2028          */
  RESERVED3: u32,
  /*!< AXI interconnect - TARG 1 long burst functionality modification register,           Address offset: 0x202C          */
  AXI_TARG1_FN_MOD_LB: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x2030-0x2104   */
  RESERVED4: [54]u32,
  /*!< AXI interconnect - TARG 1 issuing functionality modification register,              Address offset: 0x2108          */
  AXI_TARG1_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x210C-0x3004   */
  RESERVED5: [959]u32,
  /*!< AXI interconnect - TARG 2 bus matrix issuing functionality register,           Address offset: 0x3008          */
  AXI_TARG2_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x300C-0x3020   */
  RESERVED6: [6]u32,
  /*!< AXI interconnect - TARG 2 bus matrix functionality 2 register,                      Address offset: 0x3024          */
  AXI_TARG2_FN_MOD2: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x3028          */
  RESERVED7: u32,
  /*!< AXI interconnect - TARG 2 long burst functionality modification register,           Address offset: 0x302C          */
  AXI_TARG2_FN_MOD_LB: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x3030-0x3104   */
  RESERVED8: [54]u32,
  /*!< AXI interconnect - TARG 2 issuing functionality modification register,              Address offset: 0x3108          */
  AXI_TARG2_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x310C-0x4004   */
  RESERVED9: [959]u32,
  /*!< AXI interconnect - TARG 3 bus matrix issuing functionality register,          Address offset: 0x4008          */
  AXI_TARG3_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x400C-0x5004   */
  RESERVED10: [1023]u32,
  /*!< AXI interconnect - TARG 4 bus matrix issuing functionality register,           Address offset: 0x5008          */
  AXI_TARG4_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x500C-0x6004   */
  RESERVED11: [1023]u32,
  /*!< AXI interconnect - TARG 5 bus matrix issuing functionality register,           Address offset: 0x6008          */
  AXI_TARG5_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x600C-0x7004   */
  RESERVED12: [1023]u32,
  /*!< AXI interconnect - TARG 6 bus matrix issuing functionality register,           Address offset: 0x7008          */
  AXI_TARG6_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x700C-0x8004   */
  RESERVED13: [1023]u32,
  /*!< AXI interconnect - TARG 7 bus matrix issuing functionality register,           Address offset: 0x8008          */
  AXI_TARG7_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x800C-0x8020   */
  RESERVED14: [6]u32,
  /*!< AXI interconnect - TARG 7 bus matrix functionality 2 register,                      Address offset: 0x8024          */
  AXI_TARG7_FN_MOD2: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x8028          */
  RESERVED15: u32,
  /*!< AXI interconnect - TARG 7 long burst functionality modification register,           Address offset: 0x802C          */
  AXI_TARG7_FN_MOD_LB: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x8030-0x8104   */
  RESERVED16: [54]u32,
  /*!< AXI interconnect - TARG 7 issuing functionality modification register,              Address offset: 0x8108          */
  AXI_TARG7_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x810C-0x9004   */
  RESERVED17: [959]u32,
  /*!< AXI interconnect - TARG 8 bus matrix issuing functionality register,           Address offset: 0x9008          */
  AXI_TARG8_FN_MOD_ISS_BM: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x900C-0x9020   */
  RESERVED117: [6]u32,
  /*!< AXI interconnect - TARG 8 bus matrix functionality 2 register,                      Address offset: 0x9024          */
  AXI_TARG8_FN_MOD2: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x9028-0x9104   */
  RESERVED118: [56]u32,
  /*!< AXI interconnect - TARG 8 issuing functionality modification register,              Address offset: 0x9108          */
  AXI_TARG8_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x910C-0x42020  */
  RESERVED119: [58310]u32,
  /*!< AXI interconnect - INI 1 functionality modification 2 register,                     Address offset: 0x42024         */
  AXI_INI1_FN_MOD2: u32, // ReadWrite
  /*!< AXI interconnect - INI 1 AHB functionality modification register,                   Address offset: 0x42028         */
  AXI_INI1_FN_MOD_AHB: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4202C-0x420FC */
  RESERVED18: [53]u32,
  /*!< AXI interconnect - INI 1 read QoS register,                                         Address offset: 0x42100         */
  AXI_INI1_READ_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 1 write QoS register,                                        Address offset: 0x42104         */
  AXI_INI1_WRITE_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 1 issuing functionality modification register,               Address offset: 0x42108         */
  AXI_INI1_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4210C-0x430FC */
  RESERVED19: [1021]u32,
  /*!< AXI interconnect - INI 2 read QoS register,                                         Address offset: 0x43100         */
  AXI_INI2_READ_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 2 write QoS register,                                        Address offset: 0x43104         */
  AXI_INI2_WRITE_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 2 issuing functionality modification register,               Address offset: 0x43108         */
  AXI_INI2_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4310C-0x44020 */
  RESERVED20: [966]u32,
  /*!< AXI interconnect - INI 3 functionality modification 2 register,                     Address offset: 0x44024         */
  AXI_INI3_FN_MOD2: u32, // ReadWrite
  /*!< AXI interconnect - INI 3 AHB functionality modification register,                   Address offset: 0x44028         */
  AXI_INI3_FN_MOD_AHB: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4402C-0x440FC */
  RESERVED21: [53]u32,
  /*!< AXI interconnect - INI 3 read QoS register,                                         Address offset: 0x44100         */
  AXI_INI3_READ_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 3 write QoS register,                                        Address offset: 0x44104         */
  AXI_INI3_WRITE_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 3 issuing functionality modification register,               Address offset: 0x44108         */
  AXI_INI3_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4410C-0x450FC */
  RESERVED22: [1021]u32,
  /*!< AXI interconnect - INI 4 read QoS register,                                         Address offset: 0x45100         */
  AXI_INI4_READ_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 4 write QoS register,                                        Address offset: 0x45104         */
  AXI_INI4_WRITE_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 4 issuing functionality modification register,               Address offset: 0x45108         */
  AXI_INI4_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4510C-0x460FC */
  RESERVED23: [1021]u32,
  /*!< AXI interconnect - INI 5 read QoS register,                                         Address offset: 0x46100         */
  AXI_INI5_READ_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 5 write QoS register,                                        Address offset: 0x46104         */
  AXI_INI5_WRITE_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 5 issuing functionality modification register,               Address offset: 0x46108         */
  AXI_INI5_FN_MOD: u32, // ReadWrite
  /*!< Reserved,                                                                           Address offset: 0x4610C-0x470FC */
  RESERVED24: [1021]u32,
  /*!< AXI interconnect - INI 6 read QoS register,                                         Address offset: 0x47100         */
  AXI_INI6_READ_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 6 write QoS register,                                        Address offset: 0x47104         */
  AXI_INI6_WRITE_QOS: u32, // ReadWrite
  /*!< AXI interconnect - INI 6 issuing functionality modification register,               Address offset: 0x47108         */
  AXI_INI6_FN_MOD: u32, // ReadWrite
}

