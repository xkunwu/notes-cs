---
---

### 引脚分布

#### 特殊功能引脚（彩色）

电源：Vdd (Voltage drain-drain)、Vss (Voltage source-source)
备用电池：VBAT
复位：NRST
启动模式选择：BOOT0

#### 普通IO引脚（灰色）

GPIOA：PA0-PA15
GPIOB：PB0-PB15
GPIOC：PC13、PC14、PC15
GPIOD：PD0、PD1

### IO功能复用、重映射

功能复用：同一IO引脚具备多个不同功能。

复用功能重映射：将冲突的复用功能移动到备用引脚上。

### 4种输出工作模式

通用输出推挽、通用输出开漏、复用输出推挽、复用输出开漏

#### 推挽 vs 开漏

- 推挽输出：MOS管对交替导通，对外输出**低电压**/**高电压**
- 开漏输出：PMOS保持关断，对外输出**低电压**/**高阻抗**

#### 通用 vs 复用

- 通用输出：直接控制输出高低电平
- 复用输出：其他模块托管输出

### IO最大输出速度

单个时钟周期：上升时间、保持时间、下降时间。

- 上升、下降时间越短，最大输出速度越高

STM32：选取满足要求的最小值

- 低速：2MHz，125ns+250ns+125ns
- 中速：10MHz，25ns+50ns+25ns
- 高速：50MHz，5ns+10ns+5ns

### 实验：闪灯

一般单片机，低电平驱动能力大于高电平驱动能力。

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. PA9: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: low
   3. Maximum output speed: Low

```c
// void HAL_GPIO_WritePin(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin, GPIO_PinState PinState)
// __weak void HAL_Delay(uint32_t Delay)

HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET);

HAL_Delay(500);

HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_RESET);

HAL_Delay(500);
```

### 使用BootLoader清除程序

安装`STM32CubeProgrammer`。

### 4种输入工作模式

输入上拉、输入下拉、输入浮空、模拟模式。

- 输入模式相当于电压表：测量外部输入信号的电压，故内阻应当无穷大（否则并联分流，影响被测电路状态）。
- 无穷大电阻相当于开路
  - 如果没有上拉、下拉电阻，IO引脚完全悬空，相当于天线：会接收空间电磁波，产生随机输入

#### 上拉 vs 下拉

- 上拉电阻：当引脚悬空时，提供默认的**高**电压
- 下拉电阻：当引脚悬空时，提供默认的**低**电压

### 实验：按键控制LED

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. PA9: GPIO_Input
   1. GPIO mode: Pull-down

```c
// GPIO_PinState HAL_GPIO_ReadPin(GPIO_TypeDef *GPIOx, uint16_t GPIO_Pin)
if (GPIO_PIN_SET == HAL_GPIO_ReadPin(GPIOA, GPIO_PIN_9))
{
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
} else {
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
}
```

### 实验：流水灯

1. SYS/Debug: Serial Wire
2. PA8-PA11, PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low

```c
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_11, GPIO_PIN_SET);
HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
HAL_Delay(100);

HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_RESET);
HAL_Delay(100);

HAL_GPIO_WritePin(GPIOA, GPIO_PIN_8, GPIO_PIN_SET);
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_RESET);
HAL_Delay(100);

HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET);
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_10, GPIO_PIN_RESET);
HAL_Delay(100);

HAL_GPIO_WritePin(GPIOA, GPIO_PIN_10, GPIO_PIN_SET);
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_11, GPIO_PIN_RESET);
HAL_Delay(100);
```
