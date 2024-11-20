---
---

### 逐次逼近型ADC

- ADC (Analog to Digital Converter)：模拟信号向数字信号转换器
  - 模拟信号：时间、幅度都连续，自然界
  - 数字信号：时间、幅度都离散，计算机
- 采样深度：用多少位二进制数来表示一个采样点
  - n位：分成$2^n - 1$份
- 逐次逼近型 SAR (Successive Approximation Register)：类比于天平称重
  - 比较器：电压发生器 vs 采样保持电路

#### STM32F1

12-bit SAR ADC

- 输入：IN0-IN9, Temperature Sensor Channel, Vrefint Channel
- 外部触发：常规序列（16个）、注入序列（4个）
- 时钟：来自PCLK2，不超过14MHz
  - 采样时间、转换时间：时钟周期的倍数
    - 转换时间 = 12（次尝试）+ 0.5（额外时间）= 12.5 时钟周期
    - 采样时间（采样开关闭合时间、采样电容充电时间）：误差远小于ADC最大精度即可
      - 采样误差 < 1/4 ADC分辨率 = 0.2mV
        - 12-bit采样深度、3.3V量程：分辨率 = 3.3 / (2^12 - 1) = 0.8mV
      - 最优采样时间 T_s = (R_AIN + R_ADC) * C_ADC * ln(2^(N + 2))
        - R_ADC = 1kO, C_ADC = 8pF, N = 12
        - T_s = (R_AIN + 1000) * 77.6 * 10^(-12)
          - 400O: 0.11us = 1.54 cycle
          - 10kO: 0.85us = 11.9 cycle
          - 50kO: 3.96us = 55.4 cycle
        - 理想情况（0O, 14MHz）：1.5 + 12.5 = 14 cycle = 1us
- 标志位
  - AWD (Analog Watch Dog)：模拟看门狗
  - EOC (End Of Conversion)：常规转换结束
  - JEOC (Injected End Of Conversion)：注入转换结束
- 结果寄存器
  - 常规序列：32-bit DR (Data Register) 数据寄存器
  - 注入序列：16-bit JDR1-JDR4 (Injected Data Register) 注入数据寄存器

#### 实验：达文西手电

1. SYS/Debug: Serial Wire
2. PA9: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: low
   3. Maximum output speed: Low
3. ADC1
   1. ADC_Regular_Conversion Mode
      1. Enable Regular Conversions: Enable
      2. Number of Conversion: 1
         1. Rank 1: Channel 0, 7.5 Cycles
      3. External Trigger Conversion Source: Regular Conversion launched by software

```c
HAL_ADCEx_Calibration_Start(&hadc1);

// 1. Start ADC
HAL_ADC_Start(&hadc1);

// 2. Poll for Conversion
HAL_ADC_PollForConversion(&hadc1, HAL_MAX_DELAY);

// 3. Get result
uint32_t dr = HAL_ADC_GetValue(&hadc1);

// 4. Convert result to voltage
float voltage = dr * 3.3f / 4096;
if (1.5f < voltage) // dark
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_SET); // on
else // bright
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_9, GPIO_PIN_RESET); // off
```

### 定时器触发

#### CCx事件

CCx (Capture Compare x Event)：捕获/比较x事件

- 捕获：对应信号变化
- 比较：CNT = CCRx

#### TRGO

从模式控制器，作为主机控制其他模块

- TRGO (Trigger Output)：触发输出，输出TRGI的控制信号
  - Update 更新：每产生一个Update事件（CNT溢出），就向TRGO输出一个脉冲

#### 实验：定时器触发采集

1. SYS/Debug: Serial Wire
2. USART1/Mode: Asynchronous
3. PA9: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: low
   3. Maximum output speed: Low
4. ADC1/Parameter Settings
   1. ADC_Regular_Conversion Mode
      1. Enable Regular Conversions: Enable
      2. Number of Conversion: 1
         1. Rank 1: Channel 0, 7.5 Cycles
      3. External Trigger Conversion Source: Timer 3 Trigger Out event
5. TIM3
   1. Mode
      1. Clock Source: Internal Clock
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 7
         2. Counter Period (AutoReload Register): 999
         3. auto-reload preload: Enable
      2. Trigger Output (TRGO) Parameters
         1. Trigger Event Selection: Update Event

```c
HAL_TIM_Base_Start(&htim3);
// 1. Start ADC
HAL_ADCEx_Calibration_Start(&hadc1);
HAL_ADC_Start(&hadc1);

while (1)
{
    // 2. Poll for Conversion
    HAL_ADC_PollForConversion(&hadc1, HAL_MAX_DELAY);

    // 3. Get result
    uint32_t dr = HAL_ADC_GetValue(&hadc1);

    // 4. Convert result to voltage
    float voltage = dr * 3.3f / 4096;

    // 5. Send voltage to UART
    char buffer[32];
    sprintf(buffer, "%.3f\n", voltage);
    HAL_UART_Transmit(&huart1, (uint8_t *)buffer, strlen(buffer), HAL_MAX_DELAY);
    if (1.5f < voltage) // dark
        HAL_GPIO_WritePin(GPIOA, GPIO_PIN_15, GPIO_PIN_SET); // on
    else // bright
        HAL_GPIO_WritePin(GPIOA, GPIO_PIN_15, GPIO_PIN_RESET); // off
}
```

#### 实验：定时器连续触发采集

- ADC1/Parameter Settings/ADC Settings/Continuous Conversion Mode: Enabled

```c
// 1. Start ADC
HAL_ADCEx_Calibration_Start(&hadc1);
HAL_ADC_Start(&hadc1);
// // 2. Poll for Conversion
// HAL_ADC_PollForConversion(&hadc1, HAL_MAX_DELAY);
while (1)
{
  // 3. Get result
  uint32_t dr = HAL_ADC_GetValue(&hadc1);
}
```
