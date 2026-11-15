#include "stm32h723xx.h"

//#include "simulator.h"
#include "simulator.c"

void init_systick(void)
{
  SysTick->CTRL &= ~SysTick_CTRL_CLKSOURCE_Msk;

  // assume CALIB is correct
  SysTick->LOAD = SysTick->CALIB*100;

  SysTick->CTRL |= SysTick_CTRL_TICKINT_Msk;

  SysTick->VAL = 0;
  SysTick->CTRL |= SysTick_CTRL_ENABLE_Msk;
}

void start_gpio_allpins(GPIO_TypeDef *gpio, char letter)
{
  RCC->AHB4ENR |= 1 << (letter - 'A');
  gpio->MODER |= 0b0101'0101'0101'0101'0101'0101'0101'0101;
}

extern "C" void Board_init(void *mem)
{
#ifdef SIMULATOR_BUILD
  Simulator_InitMemory(mem);
#else
  (void)mem;
#endif

  //static constexpr uint32_t pin = 0;
  //static constexpr uint32_t portletter = 'B';

  start_gpio_allpins(GPIOA, 'A');
  start_gpio_allpins(GPIOB, 'B');
  start_gpio_allpins(GPIOC, 'C');
  start_gpio_allpins(GPIOD, 'D');
  start_gpio_allpins(GPIOE, 'E');
  start_gpio_allpins(GPIOF, 'F');
  start_gpio_allpins(GPIOG, 'G');
  start_gpio_allpins(GPIOH, 'H');
  start_gpio_allpins(GPIOJ, 'J');
  start_gpio_allpins(GPIOK, 'K');
  //RCC->AHB4ENR |= 1 << (portletter - 'A');
  //GPIOB->MODER |= 1 << (pin * 2);

  init_systick();
}

extern "C" void Board_update(void)
{
  // do something here like toggle led or whatever?
}

void toggle_led(void)
{
  static bool is_on = false;
  if(is_on) {
    GPIOB->BSRR |= GPIO_BSRR_BR0;
  } else {
    GPIOB->BSRR |= GPIO_BSRR_BS0;
  }
  is_on = !is_on;
}

uint32_t RNG_seed_parkmiller(uint32_t val)
{
  // seed must be coprime of 0x7FFF'FFFF
  // and also not be 0
  if(val == 0) val++;
  else val %= 0x7FFFFFFF;

  return val;
}

uint32_t RNG_lcg_parkmiller(uint32_t *state)
{
  // 48271 is the Park-Miller multiplier
  uint64_t product = (uint64_t)*state * 48271;
  // avoid doing 64-bit division
  uint32_t x = (uint32_t)((product & 0x7FFFFFFF) + (product >> 31));

  x = (x & 0x7FFFFFFF) + (x >> 31);
  return *state = x;
}

void toggle_led_pattern(GPIO_TypeDef *gpio, uint32_t *seed)
{
  static bool is_on[16] = {0};

  // random between [1 .. 0xFFFF]
  uint32_t n = (RNG_lcg_parkmiller(seed) % 0xFFFE) + 1;

  while(n != 0) {
    uint32_t idx = __builtin_ctz(n);
    n &= ~(1 << idx);

    if(is_on[idx]) {
      gpio->BSRR |= (GPIO_BSRR_BR0 << idx);
    } else {
      gpio->BSRR |= (GPIO_BSRR_BS0 << idx);
    }
    is_on[idx] = !is_on[idx];
  }
}

#ifdef SIMULATOR_BUILD
#include "stdio.h"
#endif

extern "C" void SysTick_Handler(void)
{
  static uint32_t seeds['K' - 'A' + 1] = {
    120241,
    120242,
    120243,
    120244,
    120245,
    120246,
    120247,
    120248,
    120249,
    120250,
    120251,
  };

  toggle_led_pattern(GPIOA, &seeds['A' - 'A']);
  toggle_led_pattern(GPIOB, &seeds['B' - 'A']);
  toggle_led_pattern(GPIOC, &seeds['C' - 'A']);
  toggle_led_pattern(GPIOD, &seeds['D' - 'A']);
  toggle_led_pattern(GPIOE, &seeds['E' - 'A']);
  toggle_led_pattern(GPIOF, &seeds['F' - 'A']);
  toggle_led_pattern(GPIOG, &seeds['G' - 'A']);
  toggle_led_pattern(GPIOH, &seeds['H' - 'A']);
  toggle_led_pattern(GPIOJ, &seeds['J' - 'A']);
  toggle_led_pattern(GPIOK, &seeds['K' - 'A']);
  //toggle_led();
}

#ifndef SIMULATOR_BUILD
int main()
{
  Board_init(0);

  for(;;) {
    Board_update();
  }
}
#endif
