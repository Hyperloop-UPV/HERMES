#+vet style
#+vet unused
#+vet unused-variables
#+vet unused-imports
#+vet shadowing
package peripherals

/* File containing Timer simulation for STM32H723xx
 * It is currently unfinished
 *
 * Created on: 4 nov. 2026
 *   Author: victor
 */

import "core:time"

import mcu "mcu:stm32h723xx"
// will be used for events (soon)
import "../../usim"

// CR1 register bit values

// 0 -> UIF status bit is not copied to CNT register bit 31;
// 1 -> UIF status bit is copied to CNT register bit 31
@(private="file") CR1_UIFREMAP_Offset :: 11
// bits [9:8], division ratio between the timer clock CK_INT frequency and the dead-time
// and sampling clock t_dts used bythe dead-time generators and the digital filters
@(private="file") CR1_CKD_Offset :: 8
@(private="file") CR1_CKD_Mask :: 0b11 << CR1_CKD_Offset
// 0 -> ARR is not buffered; 1 -> ARR is buffered
@(private="file") CR1_ARPE_Offset :: 7

// Center-aligned mode selection
@(private="file") CR1_CMS_Offset :: 5
@(private="file") CR1_CMS_Mask :: 0b11 << CR1_CMS_Offset
// The counter counts up or down depending on the direction bit (DIR)
@(private="file") CR1_CMS_EdgeAligned          :: 0b00 << CR1_CMS_Offset
// The counter counts up and down alternatively. Output compare interrupt flags of channels
// configured in output (CCxS=00 in CCMRx register) are set only when the counter is counting down
@(private="file") CR1_CMS_CenterAligned_Down   :: 0b01 << CR1_CMS_Offset
// The counter counts up and down alternatively. Output compare interrupt flags of channels
// configured in output (CCxS=00 in CCMRx register) are set only when the counter is counting up
@(private="file") CR1_CMS_CenterAligned_Up     :: 0b10 << CR1_CMS_Offset
// The counter counts up and down alternatively. Output compare interrupt flags of channels
// configured in output (CCxS=00 in CCMRx register) are set when the counter is counting up or down
@(private="file") CR1_CMS_CenterAligned_UpDown :: 0b11 << CR1_CMS_Offset

// 0 -> upcounter; 1 -> downcounter
// ReadOnly when the timer is configured in center-aligned or encoder mode
@(private="file") CR1_DIR_Offset :: 4
// one pulse mode -> counter stops counting at the next update event (CEN gets cleared)
@(private="file") CR1_OPM_Offset :: 3
@(private="file") CR1_URS_Offset :: 2
@(private="file") CR1_UDIS_Offset :: 1
@(private="file") CR1_CEN_Offset :: 0

// CR2 register bit values

// master mode selection 2
@(private="file") CR2_MMS2_Offset :: 20
@(private="file") CR2_MMS2_Mask :: 0b1111 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Reset              :: 0b0000 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Enable             :: 0b0001 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Update             :: 0b0010 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse       :: 0b0011 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Compare_1          :: 0b0100 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Compare_2          :: 0b0101 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Compare_3          :: 0b0110 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Compare_4          :: 0b0111 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Compare_5          :: 0b1000 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_Compare_6          :: 0b1001 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse_4     :: 0b1010 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse_6     :: 0b1011 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse_4r_6r :: 0b1100 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse_4r_6f :: 0b1101 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse_5r_6r :: 0b1110 << CR2_MMS2_Offset
@(private="file") CR2_MMS2_ComparePulse_5r_6f :: 0b1111 << CR2_MMS2_Offset

// Output Idle state 6
@(private="file") CR2_OIS6_Offset :: 18
// Output Idle state 5
@(private="file") CR2_OIS5_Offset :: 16
// Output Idle state 4
@(private="file") CR2_OIS4_Offset :: 14
// Output Idle state 3 (OC3N output)
@(private="file") CR2_OIS3N_Offset :: 13
// Output Idle state 3
@(private="file") CR2_OIS3_Offset :: 12
// Output Idle state 2 (OC2N output)
@(private="file") CR2_OIS2N_Offset :: 11
// Output Idle state 2
@(private="file") CR2_OIS2_Offset :: 10
// Output Idle state 1 (OC1N output)
@(private="file") CR2_OIS1N_Offset :: 9
// Output Idle state 1
@(private="file") CR2_OIS1_Offset :: 8
// TI1 selection
// 0 -> TIMxCH1 pin is connected to TI1 input
// 1 -> TIMx_CH1,CH2,CH3 are connected to the TI1 input (XOR combination)
@(private="file") CR2_TI1S_Offset :: 7

// Master mode selection
@(private="file") CR2_MMS_Offset :: 4
@(private="file") CR2_MMS_Mask :: 0b111 << CR2_MMS_Offset
@(private="file") CR2_MMS_Reset        :: 0b001
@(private="file") CR2_MMS_Update       :: 0b010
@(private="file") CR2_MMS_ComparePulse :: 0b011
@(private="file") CR2_MMS_Compare_1    :: 0b100
@(private="file") CR2_MMS_Compare_2    :: 0b101
@(private="file") CR2_MMS_Compare_3    :: 0b110
@(private="file") CR2_MMS_Compare_4    :: 0b111

// Capture/compare DMA selection
@(private="file") CR2_CCDS_Offset :: 3
// Capture/compare control update selection
@(private="file") CR2_CCUS_Offset :: 2
// Capture/compare preloaded control
@(private="file") CR2_CCPC_Offset :: 0

// SMCR register bit values

// External trigger polarity
@(private="file") SMCR_ETP_Offset :: 15
// External clock enable
@(private="file") SMCR_ECE_Offset :: 14
// External trigger prescaler
@(private="file") SMCR_ETPS_Offset :: 12
@(private="file") SMCR_ETPS_Mask :: 0b11 << SMCR_ETPS_Offset
// External trigger filter
@(private="file") SMCR_ETF_Offset :: 8
@(private="file") SMCR_ETF_Mask :: 0b1111 << SMCR_ETF_Offset
// Master/slave mode
@(private="file") SMCR_MSM_Offset :: 7

// bits [21,20,6,5,4], Trigger selection
@(private="file") SMCR_TS_0_Offset :: 4
@(private="file") SMCR_TS_1_Offset :: 5
@(private="file") SMCR_TS_2_Offset :: 6
@(private="file") SMCR_TS_3_Offset :: 20
@(private="file") SMCR_TS_4_Offset :: 21
@(private="file") SMCR_TS_0Offset_Mask :: 1 << SMCR_TS_0_Offset | 1 << SMCR_TS_1_Offset | 1 << SMCR_TS_2_Offset | 1 << SMCR_TS_3_Offset | 1 << SMCR_TS_4_Offset
@(private="file") SMCR_TS_InternalTrigger0   :: 0
@(private="file") SMCR_TS_InternalTrigger1   :: 1 << SMCR_TS_0_Offset
@(private="file") SMCR_TS_InternalTrigger2   :: 1 << SMCR_TS_1_Offset
@(private="file") SMCR_TS_InternalTrigger3   :: 1 << SMCR_TS_1_Offset | 1 << SMCR_TS_0_Offset
@(private="file") SMCR_TS_TI1_EdgeDetector   :: 1 << SMCR_TS_2_Offset
@(private="file") SMCR_TS_FilteredTimerIn1   :: 1 << SMCR_TS_2_Offset | 1 << SMCR_TS_0_Offset
@(private="file") SMCR_TS_FilteredTimerIn2   :: 1 << SMCR_TS_2_Offset | 1 << SMCR_TS_1_Offset
@(private="file") SMCR_TS_ExternalTriggerIn  :: 1 << SMCR_TS_2_Offset | 1 << SMCR_TS_1_Offset | 1 << SMCR_TS_0_Offset
@(private="file") SMCR_TS_InternalTrigger12  :: 1 << SMCR_TS_4_Offset
@(private="file") SMCR_TS_InternalTrigger13  :: 1 << SMCR_TS_4_Offset | 1 << SMCR_TS_0_Offset

// bits [16,2,1,0], Slave mode selection
@(private="file") SMCR_SMS_0_Offset :: 0
@(private="file") SMCR_SMS_1_Offset :: 1
@(private="file") SMCR_SMS_2_Offset :: 2
@(private="file") SMCR_SMS_3_Offset :: 16
@(private="file") SMCR_SMS_0Offset_Mask :: 1 << SMCR_SMS_0_Offset | 1 << SMCR_SMS_1_Offset | 1 << SMCR_SMS_2_Offset | 1 << SMCR_SMS_3_Offset
// If CEN = '1' then the prescaler is clocked directly by the internal clock
@(private="file") SMCR_SMS_Disabled      :: 0
@(private="file") SMCR_SMS_EncoderMode1  :: 1 << SMCR_SMS_0_Offset
@(private="file") SMCR_SMS_EncoderMode2  :: 1 << SMCR_SMS_1_Offset
@(private="file") SMCR_SMS_EncoderMode3  :: 1 << SMCR_SMS_1_Offset | 1 << SMCR_SMS_0_Offset
@(private="file") SMCR_SMS_ResetMode     :: 1 << SMCR_SMS_2_Offset
@(private="file") SMCR_SMS_GatedMode     :: 1 << SMCR_SMS_2_Offset | 1 << SMCR_SMS_0_Offset
@(private="file") SMCR_SMS_TriggerMode   :: 1 << SMCR_SMS_2_Offset | 1 << SMCR_SMS_1_Offset
@(private="file") SMCR_SMS_ExtClockMode  :: 1 << SMCR_SMS_2_Offset | 1 << SMCR_SMS_1_Offset | 1 << SMCR_SMS_0_Offset
// Combined reset + trigger mode
@(private="file") SMCR_SMS_ResetTrigger  :: 1 << SMCR_SMS_3_Offset

// DIER register bit values

// Trigger DMA request enable
@(private="file") DIER_TDE_Offset   :: 14
// COM DMA request enable
@(private="file") DIER_COMDE_Offset :: 13
// Capture/Compare 4 DMA request enable
@(private="file") DIER_CC4DE_Offset :: 12
// Capture/Compare 3 DMA request enable
@(private="file") DIER_CC3DE_Offset :: 11
// Capture/Compare 2 DMA request enable
@(private="file") DIER_CC2DE_Offset :: 10
// Capture/Compare 1 DMA request enable
@(private="file") DIER_CC1DE_Offset :: 9
// Update DMA request enable
@(private="file") DIER_UDE_Offset   :: 8
// Break interrupt enable
@(private="file") DIER_BIE_Offset   :: 7
// Trigger interrupt enable
@(private="file") DIER_TIE_Offset   :: 6
// COM interrupt enable
@(private="file") DIER_COMIE_Offset :: 5
// Capture/Compare 4 interrupt enable
@(private="file") DIER_CC4IE_Offset :: 4
// Capture/Compare 3 interrupt enable
@(private="file") DIER_CC3IE_Offset :: 3
// Capture/Compare 2 interrupt enable
@(private="file") DIER_CC2IE_Offset :: 2
// Capture/Compare 1 interrupt enable
@(private="file") DIER_CC1IE_Offset :: 1
// Update interrupt enable
@(private="file") DIER_UIE_Offset   :: 0

// SR register bit values

// Compare 6 interrupt flag
@(private="file") SR_CC6IF_Offset :: 17
// Compare 5 interrupt flag
@(private="file") SR_CC5IF_Offset :: 16
// System Break interrupt flag
@(private="file") SR_SBIF_Offset  :: 13
// Compare 4 overcapture flag
@(private="file") SR_CC4OF_Offset :: 12
// Compare 3 overcapture flag
@(private="file") SR_CC3OF_Offset :: 11
// Compare 2 overcapture flag
@(private="file") SR_CC2OF_Offset :: 10
// Compare 1 overcapture flag
@(private="file") SR_CC1OF_Offset :: 9
// Break 2 interrupt flag
@(private="file") SR_B2IF_Offset  :: 8
// Break interrupt flag
@(private="file") SR_BIF_Offset   :: 7
// Trigger interrupt flag
@(private="file") SR_TIF_Offset   :: 6
// COM interrupt flag
@(private="file") SR_COMIF_Offset :: 5
// Compare 4 interrupt flag
@(private="file") SR_CC4IF_Offset :: 4
// Compare 3 interrupt flag
@(private="file") SR_CC3IF_Offset :: 3
// Compare 2 interrupt flag
@(private="file") SR_CC2IF_Offset :: 2
// Compare 1 interrupt flag
@(private="file") SR_CC1IF_Offset :: 1
// Update interrupt flag
@(private="file") SR_UIF_Offset   :: 0

// TODO: CCMRx
// TODO: CCER

// CNT register bit values

// read-only copy of the UIF bit of the TIMx_ISR register
// or 0, if UIFREMAP bit in CR1 is reset
@(private="file") CNT_UIFCPY_Offset :: 31

// TODO: EGR, PSC, ARR, RCR, CCRx, BDTR, DCR, DMAR, AFx, TISEL

@(private="file")
TIM_Context :: struct {
  tim: ^mcu.TIM,
  // Irq address for the counter
  irq_addr: ^#type proc "c"(),

  // Mask for 32/16 bit timers:
  // 0x0000_FFFF on 16 bit
  // 0xFFFF_FFFF on 32 bit
  cnt_arr_mask: u32,

  rcc_enabled_reg: ^u32,
  rcc_enabled_bit: u8,
  // Given at init time: 1,2,3,4,5,6,7,8,12,13,14,15,16,17,23 or 24
  tim_num: u8,
  // Irq number for the counter
  irq_num: u8,

  /* the timer is 32 bits wide (register offsets are the same as 16 bit timers)
   * Timers: {2,5,23,24}
   */
  is_32bit: b8,
  /* the timer supports break input
   * Timers: {1,8,15,16,17}
   */
  is_break: b8,
  /* the timer has at least 2 capture compare channels
   * Timers: {1,2,3,4,5,8,12,15,23,24}
   */
  has_cc2: b8,
  /* the timer has at least 3 capture compare channels
   * Timers: {1,2,3,4,5,8,23,24}
   */
  has_cc3: b8,
  /* the timer has at least 4 (max) capture compare channels
   * Timers: {1,2,3,4,5,8,23,24}
   */
  has_cc4: b8,
  /* the timer doesn't support counting down or both up and down
   * Timers: {6,7,12,13,14,15,16,17}
   */
  only_supports_upcounting: b8,

  //last_val: u32,
  //change_was_internal: bool,
}

@(private="file")
call_update_interrupt :: proc(memory: ^Memory, ctx: ^TIM_Context)
{
  ctx.tim.SR |= 1 << SR_UIF_Offset
  ctx.irq_addr^()

  event: usim.Event
  enqueue_event(memory, &event, .TIM, usim.Event_Variant(ctx.tim_num))
}

TIM_handler :: proc(rawctx, this_rawctx: rawptr)
{
  // TODO: Check for invalid writes
  //  e.g. changing from upcounter to downcounter in a timer that does not support it.
}

TIM_step :: proc(rawctx, this_rawctx: rawptr, step_time: time.Duration)
{
  memory := cast(^Memory)rawctx
  ctx := cast(^TIM_Context)this_rawctx

  rcc_is_on := (ctx.rcc_enabled_reg^ & (1 << u32(ctx.rcc_enabled_bit))) != 0
  cen_is_on := (ctx.tim.CR1 & (1 << CR1_CEN_Offset)) != 0
  if rcc_is_on && cen_is_on {
    // the timer clock is on and the counter is enabled

    // TODO: Make sure to use the whole clock tree here.
    time_change := i64(step_time) / i64(ctx.tim.PSC)
    // center-aligned mode selection
    cms := ctx.tim.CR1 & CR1_CMS_Mask

    shouldChangeDirection := false
    shouldCallInterrupt := false

    new_cnt: i64
    if (ctx.tim.CR1 & (1 << CR1_DIR_Offset)) != 0 {
      // downcounter
      new_cnt = i64(ctx.tim.CNT) - time_change
      if new_cnt < 0 {
        new_cnt = -new_cnt

        // Edge aligned or interrupt when down
        shouldCallInterrupt = (cms == CR1_CMS_EdgeAligned) ||
          ((cms & (0b01 << CR1_CMS_Offset)) == 1)
        shouldChangeDirection = cms != CR1_CMS_EdgeAligned
      }
    } else {
      // upcounter
      new_cnt = i64(ctx.tim.CNT) - time_change
      if new_cnt >= i64(ctx.tim.ARR & ctx.cnt_arr_mask) {
        new_cnt = new_cnt - i64(ctx.tim.ARR & ctx.cnt_arr_mask)

        // Edge aligned or interrupt when down
        shouldCallInterrupt = (cms == CR1_CMS_EdgeAligned) ||
          ((cms & (0b10 << CR1_CMS_Offset)) == 1)
        shouldChangeDirection = cms != CR1_CMS_EdgeAligned
      }
    }

    if shouldCallInterrupt {
      call_update_interrupt(memory, ctx)
    }

    if shouldChangeDirection {
      // XOR only the DIR bit, keep the rest the same
      ctx.tim.CR1 =
        (ctx.tim.CR1 & (1 << CR1_DIR_Offset)) |
        (~ctx.tim.CR1 & (1 << CR1_DIR_Offset))
    }

    ctx.tim.CNT = u32(new_cnt) & ctx.cnt_arr_mask
  }
}

TIM1_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM1EN_Offset :: 0

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM1_base
  ctx.tim_num = 1
  // This is the irq for the CNT
  ctx.irq_num = mcu.TIM1_UP_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM1EN_Offset
  ctx.is_32bit = true
  ctx.is_break = true
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM2_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM2EN_Offset :: 0

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM2_base
  ctx.tim_num = 2
  ctx.irq_num = mcu.TIM2_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM2EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM3_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM3EN_Offset :: 1

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM3_base
  ctx.tim_num = 3
  ctx.irq_num = mcu.TIM3_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM3EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM4_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM4EN_Offset :: 2

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM4_base
  ctx.tim_num = 4
  ctx.irq_num = mcu.TIM4_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM4EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM5_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM5EN_Offset :: 3

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM5_base
  ctx.tim_num = 5
  ctx.irq_num = mcu.TIM5_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM5EN_Offset
  ctx.is_32bit = true
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM6_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM6EN_Offset :: 4

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM6_base
  ctx.tim_num = 6
  // TIM6 irq is shared with DAC
  ctx.irq_num = mcu.TIM6_DAC_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM6EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = false
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM7_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM7EN_Offset :: 5

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM7_base
  ctx.tim_num = 7
  ctx.irq_num = mcu.TIM7_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM7EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = false
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM8_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM8EN_Offset :: 1

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM8_base
  ctx.tim_num = 8
  ctx.irq_num = mcu.TIM8_UP_TIM13_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM8EN_Offset
  ctx.is_32bit = false
  ctx.is_break = true
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM12_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM12EN_Offset :: 6

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM12_base
  ctx.tim_num = 12
  // TIM12 irq is shared with TIM8 brk irq
  ctx.irq_num = mcu.TIM8_BRK_TIM12_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM12EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM13_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM13EN_Offset :: 7

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM13_base
  ctx.tim_num = 13
  // TIM13 irq is shared with TIM8 irq
  ctx.irq_num = mcu.TIM8_UP_TIM13_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM13EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = false
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM14_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1LENR_TIM14EN_Offset :: 8

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM14_base
  ctx.tim_num = 14
  // TIM14 irq is shared with TIM8 com trigger irq
  ctx.irq_num = mcu.TIM8_TRG_COM_TIM14_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1LENR
  ctx.rcc_enabled_bit = RCC_APB1LENR_TIM14EN_Offset
  ctx.is_32bit = false
  ctx.is_break = false
  ctx.has_cc2 = false
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM15_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM15EN_Offset :: 16

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM15_base
  ctx.tim_num = 15
  ctx.irq_num = mcu.TIM15_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM15EN_Offset
  ctx.is_32bit = false
  ctx.is_break = true
  ctx.has_cc2 = true
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM16_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM16EN_Offset :: 17

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM16_base
  ctx.tim_num = 16
  ctx.irq_num = mcu.TIM16_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM16EN_Offset
  ctx.is_32bit = false
  ctx.is_break = true
  ctx.has_cc2 = false
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM17_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB2ENR_TIM17EN_Offset :: 18

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM17_base
  ctx.tim_num = 17
  ctx.irq_num = mcu.TIM17_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB2ENR
  ctx.rcc_enabled_bit = RCC_APB2ENR_TIM17EN_Offset
  ctx.is_32bit = false
  ctx.is_break = true
  ctx.has_cc2 = false
  ctx.has_cc3 = false
  ctx.has_cc4 = false
  ctx.only_supports_upcounting = true

  return TIM_generic_setup(memory, ctx)
}

TIM23_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1HENR_TIM23EN_Offset :: 24

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM23_base
  ctx.tim_num = 23
  ctx.irq_num = mcu.TIM23_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1HENR
  ctx.rcc_enabled_bit = RCC_APB1HENR_TIM23EN_Offset
  ctx.is_32bit = true
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM24_setup :: proc(rawctx: rawptr) -> rawptr
{
  RCC_APB1HENR_TIM24EN_Offset :: 25

  memory := cast(^Memory)rawctx
  ctx := new(TIM_Context, memory.arena_allocator)
  ctx.tim = memory.TIM24_base
  ctx.tim_num = 24
  ctx.irq_num = mcu.TIM24_IRQn
  ctx.rcc_enabled_reg = &memory.RCC_base.APB1HENR
  ctx.rcc_enabled_bit = RCC_APB1HENR_TIM24EN_Offset
  ctx.is_32bit = true
  ctx.is_break = false
  ctx.has_cc2 = true
  ctx.has_cc3 = true
  ctx.has_cc4 = true
  ctx.only_supports_upcounting = false

  return TIM_generic_setup(memory, ctx)
}

TIM_generic_setup :: proc(memory: ^Memory, ctx: ^TIM_Context) -> rawptr
{
  // we can only do this because SCB_setup is before any TIMx_setup
  scb := memory.SCB_base
  vector_base := uintptr(memory.arena_base) + uintptr(scb.VTOR)
  ctx.irq_addr = cast(^#type proc "c"())(vector_base + uintptr(ctx.irq_num) * size_of(rawptr))

  if ctx.is_32bit {
    ctx.cnt_arr_mask = 0xFFFF_FFFF
  } else {
    ctx.cnt_arr_mask = 0x0000_FFFF
  }

  return ctx
}
