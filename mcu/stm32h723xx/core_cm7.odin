#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package stm32h723xx

/* File containing struct definitions for all core_cm7 peripherals
 *
 * Created on: 8 oct. 2026
 *   Author: victor
 */

/* System Control and ID Register not in the SCB */
SCnSCB :: struct {
  RESERVED0: [1]u32,
  /*!< Offset: 0x004 (R/ )  Interrupt Controller Type Register */
  ICTR: u32, // ReadOnly
  /*!< Offset: 0x008 (R/W)  Auxiliary Control Register */
  ACTLR: u32, // ReadWrite
}

/* System Control Block (SCB) */
SCB :: struct {
  /*!< Offset: 0x000 (R/ )  CPUID Base Register */
  CPUID: u32, // ReadOnly
  /*!< Offset: 0x004 (R/W)  Interrupt Control and State Register */
  ICSR: u32, // ReadWrite
  /*!< Offset: 0x008 (R/W)  Vector Table Offset Register */
  VTOR: u32, // ReadWrite
  /*!< Offset: 0x00C (R/W)  Application Interrupt and Reset Control Register */
  AIRCR: u32, // ReadWrite
  /*!< Offset: 0x010 (R/W)  System Control Register */
  SCR: u32, // ReadWrite
  /*!< Offset: 0x014 (R/W)  Configuration Control Register */
  CCR: u32, // ReadWrite
  /*!< Offset: 0x018 (R/W)  System Handlers Priority Registers (4-7, 8-11, 12-15) */
  SHPR: [12]u8, // ReadWrite
  /*!< Offset: 0x024 (R/W)  System Handler Control and State Register */
  SHCSR: u32, // ReadWrite
  /*!< Offset: 0x028 (R/W)  Configurable Fault Status Register */
  CFSR: u32, // ReadWrite
  /*!< Offset: 0x02C (R/W)  HardFault Status Register */
  HFSR: u32, // ReadWrite
  /*!< Offset: 0x030 (R/W)  Debug Fault Status Register */
  DFSR: u32, // ReadWrite
  /*!< Offset: 0x034 (R/W)  MemManage Fault Address Register */
  MMFAR: u32, // ReadWrite
  /*!< Offset: 0x038 (R/W)  BusFault Address Register */
  BFAR: u32, // ReadWrite
  /*!< Offset: 0x03C (R/W)  Auxiliary Fault Status Register */
  AFSR: u32, // ReadWrite
  /*!< Offset: 0x040 (R/ )  Processor Feature Register */
  ID_PFR: [2]u32, // ReadOnly
  /*!< Offset: 0x048 (R/ )  Debug Feature Register */
  ID_DFR: u32, // ReadOnly
  /*!< Offset: 0x04C (R/ )  Auxiliary Feature Register */
  ID_AFR: u32, // ReadOnly
  /*!< Offset: 0x050 (R/ )  Memory Model Feature Register */
  ID_MFR: [4]u32, // ReadOnly
  /*!< Offset: 0x060 (R/ )  Instruction Set Attributes Register */
  ID_ISAR: [5]u32, // ReadOnly
  RESERVED0: [1]u32,
  /*!< Offset: 0x078 (R/ )  Cache Level ID register */
  CLIDR: u32, // ReadOnly
  /*!< Offset: 0x07C (R/ )  Cache Type register */
  CTR: u32, // ReadOnly
  /*!< Offset: 0x080 (R/ )  Cache Size ID Register */
  CCSIDR: u32, // ReadOnly
  /*!< Offset: 0x084 (R/W)  Cache Size Selection Register */
  CSSELR: u32, // ReadWrite
  /*!< Offset: 0x088 (R/W)  Coprocessor Access Control Register */
  CPACR: u32, // ReadWrite
  RESERVED3: [93]u32,
  /*!< Offset: 0x200 ( /W)  Software Triggered Interrupt Register */
  STIR: u32, // WriteOnly
  RESERVED4: [15]u32,
  /*!< Offset: 0x240 (R/ )  Media and VFP Feature Register 0 */
  MVFR0: u32, // ReadOnly
  /*!< Offset: 0x244 (R/ )  Media and VFP Feature Register 1 */
  MVFR1: u32, // ReadOnly
  /*!< Offset: 0x248 (R/ )  Media and VFP Feature Register 2 */
  MVFR2: u32, // ReadOnly
  RESERVED5: [1]u32,
  /*!< Offset: 0x250 ( /W)  I-Cache Invalidate All to PoU */
  ICIALLU: u32, // WriteOnly
  RESERVED6: [1]u32,
  /*!< Offset: 0x258 ( /W)  I-Cache Invalidate by MVA to PoU */
  ICIMVAU: u32, // WriteOnly
  /*!< Offset: 0x25C ( /W)  D-Cache Invalidate by MVA to PoC */
  DCIMVAC: u32, // WriteOnly
  /*!< Offset: 0x260 ( /W)  D-Cache Invalidate by Set-way */
  DCISW: u32, // WriteOnly
  /*!< Offset: 0x264 ( /W)  D-Cache Clean by MVA to PoU */
  DCCMVAU: u32, // WriteOnly
  /*!< Offset: 0x268 ( /W)  D-Cache Clean by MVA to PoC */
  DCCMVAC: u32, // WriteOnly
  /*!< Offset: 0x26C ( /W)  D-Cache Clean by Set-way */
  DCCSW: u32, // WriteOnly
  /*!< Offset: 0x270 ( /W)  D-Cache Clean and Invalidate by MVA to PoC */
  DCCIMVAC: u32, // WriteOnly
  /*!< Offset: 0x274 ( /W)  D-Cache Clean and Invalidate by Set-way */
  DCCISW: u32, // WriteOnly
  RESERVED7: [6]u32,
  /*!< Offset: 0x290 (R/W)  Instruction Tightly-Coupled Memory Control Register */
  ITCMCR: u32, // ReadWrite
  /*!< Offset: 0x294 (R/W)  Data Tightly-Coupled Memory Control Registers */
  DTCMCR: u32, // ReadWrite
  /*!< Offset: 0x298 (R/W)  AHBP Control Register */
  AHBPCR: u32, // ReadWrite
  /*!< Offset: 0x29C (R/W)  L1 Cache Control Register */
  CACR: u32, // ReadWrite
  /*!< Offset: 0x2A0 (R/W)  AHB Slave Control Register */
  AHBSCR: u32, // ReadWrite
  RESERVED8: [1]u32,
  /*!< Offset: 0x2A8 (R/W)  Auxiliary Bus Fault Status Register */
  ABFSR: u32, // ReadWrite
}

/* System Timer (SysTick) */
SysTick :: struct {
  /*!< Offset: 0x000 (R/W)  SysTick Control and Status Register */
  CTRL: u32, // ReadWrite
  /*!< Offset: 0x004 (R/W)  SysTick Reload Value Register */
  LOAD: u32, // ReadWrite
  /*!< Offset: 0x008 (R/W)  SysTick Current Value Register */
  VAL: u32, // ReadWrite
  /*!< Offset: 0x00C (R/ )  SysTick Calibration Register */
  CALIB: u32, // ReadOnly
}

/* Nested Vectored Interrupt Controller (NVIC) */
NVIC :: struct {
  /*!< Offset: 0x000 (R/W)  Interrupt Set Enable Register */
  ISER: [8]u32, // ReadWrite
  RESERVED0: [24]u32,
  /*!< Offset: 0x080 (R/W)  Interrupt Clear Enable Register */
  ICER: [8]u32, // ReadWrite
  RESERVED1: [24]u32,
  /*!< Offset: 0x100 (R/W)  Interrupt Set Pending Register */
  ISPR: [8]u32, // ReadWrite
  RESERVED2: [24]u32,
  /*!< Offset: 0x180 (R/W)  Interrupt Clear Pending Register */
  ICPR: [8]u32, // ReadWrite
  RESERVED3: [24]u32,
  /*!< Offset: 0x200 (R/W)  Interrupt Active bit Register */
  IABR: [8]u32, // ReadWrite
  RESERVED4: [56]u32,
  /*!< Offset: 0x300 (R/W)  Interrupt Priority Register (8Bit wide) */
  IP: [240]u8, // ReadWrite
  RESERVED5: [644]u32,
  /*!< Offset: 0xE00 ( /W)  Software Trigger Interrupt Register */
  STIR: u32, // WriteOnly
}

/* Instrumentation Trace Macrocell Register */
ITM :: struct {
  /*!< Offset: 0x000 ( /W)  ITM Stimulus Port Registers */
  PORT: [32]struct #raw_union { // WriteOnly
    /*!< Offset: 0x000 ( /W)  ITM Stimulus Port 8-bit */
    uint8: u8, // WriteOnly
    /*!< Offset: 0x000 ( /W)  ITM Stimulus Port 16-bit */
    uint16: u16, // WriteOnly
    /*!< Offset: 0x000 ( /W)  ITM Stimulus Port 32-bit */
    uint32: u32, // WriteOnly
  },
  RESERVED0: [864]u32,
  /*!< Offset: 0xE00 (R/W)  ITM Trace Enable Register */
  TER: u32, // ReadWrite
  RESERVED1: [15]u32,
  /*!< Offset: 0xE40 (R/W)  ITM Trace Privilege Register */
  TPR: u32, // ReadWrite
  RESERVED2: [15]u32,
  /*!< Offset: 0xE80 (R/W)  ITM Trace Control Register */
  TCR: u32, // ReadWrite
  RESERVED3: [32]u32,
  RESERVED4: [43]u32,
  /*!< Offset: 0xFB0 ( /W)  ITM Lock Access Register */
  LAR: u32, // WriteOnly
  /*!< Offset: 0xFB4 (R/ )  ITM Lock Status Register */
  LSR: u32, // ReadOnly
  RESERVED5: [6]u32,
  /*!< Offset: 0xFD0 (R/ )  ITM Peripheral Identification Register #4 */
  PID4: u32, // ReadOnly
  /*!< Offset: 0xFD4 (R/ )  ITM Peripheral Identification Register #5 */
  PID5: u32, // ReadOnly
  /*!< Offset: 0xFD8 (R/ )  ITM Peripheral Identification Register #6 */
  PID6: u32, // ReadOnly
  /*!< Offset: 0xFDC (R/ )  ITM Peripheral Identification Register #7 */
  PID7: u32, // ReadOnly
  /*!< Offset: 0xFE0 (R/ )  ITM Peripheral Identification Register #0 */
  PID0: u32, // ReadOnly
  /*!< Offset: 0xFE4 (R/ )  ITM Peripheral Identification Register #1 */
  PID1: u32, // ReadOnly
  /*!< Offset: 0xFE8 (R/ )  ITM Peripheral Identification Register #2 */
  PID2: u32, // ReadOnly
  /*!< Offset: 0xFEC (R/ )  ITM Peripheral Identification Register #3 */
  PID3: u32, // ReadOnly
  /*!< Offset: 0xFF0 (R/ )  ITM Component  Identification Register #0 */
  CID0: u32, // ReadOnly
  /*!< Offset: 0xFF4 (R/ )  ITM Component  Identification Register #1 */
  CID1: u32, // ReadOnly
  /*!< Offset: 0xFF8 (R/ )  ITM Component  Identification Register #2 */
  CID2: u32, // ReadOnly
  /*!< Offset: 0xFFC (R/ )  ITM Component  Identification Register #3 */
  CID3: u32, // ReadOnly
}

/* Data Watchpoint and Trace Register (DWT) */
DWT :: struct {
  /*!< Offset: 0x000 (R/W)  Control Register */
  CTRL: u32, // ReadWrite
  /*!< Offset: 0x004 (R/W)  Cycle Count Register */
  CYCCNT: u32, // ReadWrite
  /*!< Offset: 0x008 (R/W)  CPI Count Register */
  CPICNT: u32, // ReadWrite
  /*!< Offset: 0x00C (R/W)  Exception Overhead Count Register */
  EXCCNT: u32, // ReadWrite
  /*!< Offset: 0x010 (R/W)  Sleep Count Register */
  SLEEPCNT: u32, // ReadWrite
  /*!< Offset: 0x014 (R/W)  LSU Count Register */
  LSUCNT: u32, // ReadWrite
  /*!< Offset: 0x018 (R/W)  Folded-instruction Count Register */
  FOLDCNT: u32, // ReadWrite
  /*!< Offset: 0x01C (R/ )  Program Counter Sample Register */
  PCSR: u32, // ReadOnly
  /*!< Offset: 0x020 (R/W)  Comparator Register 0 */
  COMP0: u32, // ReadWrite
  /*!< Offset: 0x024 (R/W)  Mask Register 0 */
  MASK0: u32, // ReadWrite
  /*!< Offset: 0x028 (R/W)  Function Register 0 */
  FUNCTION0: u32, // ReadWrite
  RESERVED0: [1]u32,
  /*!< Offset: 0x030 (R/W)  Comparator Register 1 */
  COMP1: u32, // ReadWrite
  /*!< Offset: 0x034 (R/W)  Mask Register 1 */
  MASK1: u32, // ReadWrite
  /*!< Offset: 0x038 (R/W)  Function Register 1 */
  FUNCTION1: u32, // ReadWrite
  RESERVED1: [1]u32,
  /*!< Offset: 0x040 (R/W)  Comparator Register 2 */
  COMP2: u32, // ReadWrite
  /*!< Offset: 0x044 (R/W)  Mask Register 2 */
  MASK2: u32, // ReadWrite
  /*!< Offset: 0x048 (R/W)  Function Register 2 */
  FUNCTION2: u32, // ReadWrite
  RESERVED2: [1]u32,
  /*!< Offset: 0x050 (R/W)  Comparator Register 3 */
  COMP3: u32, // ReadWrite
  /*!< Offset: 0x054 (R/W)  Mask Register 3 */
  MASK3: u32, // ReadWrite
  /*!< Offset: 0x058 (R/W)  Function Register 3 */
  FUNCTION3: u32, // ReadWrite
  RESERVED3: [981]u32,
  /*!< Offset: 0xFB0 (  W)  Lock Access Register */
  LAR: u32, // WriteOnly
  /*!< Offset: 0xFB4 (R  )  Lock Status Register */
  LSR: u32, // ReadOnly
}

/* Trace Port Interface Register (TPI) */
TPI :: struct {
  /*!< Offset: 0x000 (R/ )  Supported Parallel Port Size Register */
  SSPSR: u32, // ReadOnly
  /*!< Offset: 0x004 (R/W)  Current Parallel Port Size Register */
  CSPSR: u32, // ReadWrite
  RESERVED0: [2]u32,
  /*!< Offset: 0x010 (R/W)  Asynchronous Clock Prescaler Register */
  ACPR: u32, // ReadWrite
  RESERVED1: [55]u32,
  /*!< Offset: 0x0F0 (R/W)  Selected Pin Protocol Register */
  SPPR: u32, // ReadWrite
  RESERVED2: [131]u32,
  /*!< Offset: 0x300 (R/ )  Formatter and Flush Status Register */
  FFSR: u32, // ReadOnly
  /*!< Offset: 0x304 (R/W)  Formatter and Flush Control Register */
  FFCR: u32, // ReadWrite
  /*!< Offset: 0x308 (R/ )  Formatter Synchronization Counter Register */
  FSCR: u32, // ReadOnly
  RESERVED3: [759]u32,
  /*!< Offset: 0xEE8 (R/ )  TRIGGER Register */
  TRIGGER: u32, // ReadOnly
  /*!< Offset: 0xEEC (R/ )  Integration ETM Data */
  FIFO0: u32, // ReadOnly
  /*!< Offset: 0xEF0 (R/ )  ITATBCTR2 */
  ITATBCTR2: u32, // ReadOnly
  RESERVED4: [1]u32,
  /*!< Offset: 0xEF8 (R/ )  ITATBCTR0 */
  ITATBCTR0: u32, // ReadOnly
  /*!< Offset: 0xEFC (R/ )  Integration ITM Data */
  FIFO1: u32, // ReadOnly
  /*!< Offset: 0xF00 (R/W)  Integration Mode Control */
  ITCTRL: u32, // ReadWrite
  RESERVED5: [39]u32,
  /*!< Offset: 0xFA0 (R/W)  Claim tag set */
  CLAIMSET: u32, // ReadWrite
  /*!< Offset: 0xFA4 (R/W)  Claim tag clear */
  CLAIMCLR: u32, // ReadWrite
  RESERVED7: [8]u32,
  /*!< Offset: 0xFC8 (R/ )  TPIU_DEVID */
  DEVID: u32, // ReadOnly
  /*!< Offset: 0xFCC (R/ )  TPIU_DEVTYPE */
  DEVTYPE: u32, // ReadOnly
}

/* Core Debug Register (CoreDebug) */
CoreDebug :: struct {
  /*!< Offset: 0x000 (R/W)  Debug Halting Control and Status Register */
  DHCSR: u32, // ReadWrite
  /*!< Offset: 0x004 ( /W)  Debug Core Register Selector Register */
  DCRSR: u32, // WriteOnly
  /*!< Offset: 0x008 (R/W)  Debug Core Register Data Register */
  DCRDR: u32, // ReadWrite
  /*!< Offset: 0x00C (R/W)  Debug Exception and Monitor Control Register */
  DEMCR: u32, // ReadWrite
}

/* Memory Protection Unit (MPU) */
MPU :: struct {
  /*!< Offset: 0x000 (R/ )  MPU Type Register */
  TYPE: u32, // WriteOnly
  /*!< Offset: 0x004 (R/W)  MPU Control Register */
  CTRL: u32, // ReadWrite
  /*!< Offset: 0x008 (R/W)  MPU Region RNRber Register */
  RNR: u32, // ReadWrite
  /*!< Offset: 0x00C (R/W)  MPU Region Base Address Register */
  RBAR: u32, // ReadWrite
  /*!< Offset: 0x010 (R/W)  MPU Region Attribute and Size Register */
  RASR: u32, // ReadWrite
  /*!< Offset: 0x014 (R/W)  MPU Alias 1 Region Base Address Register */
  RBAR_A1: u32, // ReadWrite
  /*!< Offset: 0x018 (R/W)  MPU Alias 1 Region Attribute and Size Register */
  RASR_A1: u32, // ReadWrite
  /*!< Offset: 0x01C (R/W)  MPU Alias 2 Region Base Address Register */
  RBAR_A2: u32, // ReadWrite
  /*!< Offset: 0x020 (R/W)  MPU Alias 2 Region Attribute and Size Register */
  RASR_A2: u32, // ReadWrite
  /*!< Offset: 0x024 (R/W)  MPU Alias 3 Region Base Address Register */
  RBAR_A3: u32, // ReadWrite
  /*!< Offset: 0x028 (R/W)  MPU Alias 3 Region Attribute and Size Register */
  RASR_A3: u32, // ReadWrite
}

/* Floating Point Unit (FPU) */
FPU :: struct {
  RESERVED0: [1]u32,
  /*!< Offset: 0x004 (R/W)  Floating-Point Context Control Register */
  FPCCR: u32, // ReadWrite
  /*!< Offset: 0x008 (R/W)  Floating-Point Context Address Register */
  FPCAR: u32, // ReadWrite
  /*!< Offset: 0x00C (R/W)  Floating-Point Default Status Control Register */
  FPDSCR: u32, // ReadWrite
  /*!< Offset: 0x010 (R/ )  Media and FP Feature Register 0 */
  MVFR0: u32, // ReadOnly
  /*!< Offset: 0x014 (R/ )  Media and FP Feature Register 1 */
  MVFR1: u32, // ReadOnly
  /*!< Offset: 0x018 (R/ )  Media and FP Feature Register 2 */
  MVFR2: u32, // ReadOnly
}
