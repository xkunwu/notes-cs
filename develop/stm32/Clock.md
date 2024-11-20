---
---

### 时钟树

#### 时钟信号

每个上升沿读写数据：周期大于内部逻辑电路工作时延，防止数值不稳定。

#### 总线

- AHB (Advanced High-speed Bus)：72Mhz max
- APB1 (Advanced Peripheral Bus)：36MHz max
- APB2：72MHz max

#### 逻辑电路

- 组合逻辑电路：不含记忆元件
- 时序逻辑电路：含有记忆元件，有时钟信号才能工作
  - CP (Clock Pulse)：时钟脉冲，决定电路运行速度

#### 时钟源

HSI, HSE, LSI, LSE

- HS (High Speed) vs LS (Low Speed)
- I (Internal) vs E (External)
  - LSE: 32.768kHz (2^15k), HSE: 8MHz

SYSCLK (SYStem CLocK, 系统时钟): 72MHz max

- 来源：HSI, HSE, PLL (Phase Locked Loop, 锁相环)
- 流向：1. HCLK (72MHz max); 2. PCLK1 (36MHz max), PCLK2 (72MHz max)

#### 复位和时钟控制器

RCC (Reset & Clock Controller)

- BYPASS Clock Source：旁路时钟源，直接使用生成好的时钟信号
- Crystal/Ceramic Resonator：晶体/陶瓷振荡器，通过外接电路产生时钟信号

#### 实验：核心时钟

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low

```c
uint32_t ci;
HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
for (ci = 0; ci < 1000000; ++ci);
HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
for (ci = 0; ci < 1000000; ++ci);
```

#### 实验：外部晶振

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. RCC/Mode: HSE = Crystal/Ceramic Resonator
   1. HCLK (MHz) = 72

#### 时钟输出

MCO (Master Clock Output)

- PA8/RCC_MCO
