---
---

### 时基单元基础

#### 基本术语

- PSC (Pre-scaler)：预分频器
- CNT (Counter)：计数器
- ARR (Auto Reload Register)：自动重装寄存器
- RCR (Repetition Counter Register)：重复计数寄存器

#### 时钟来源

- RCC (Reset & Clock Controller)：时钟树
- TRIG：从模式控制器的触发信号
- TIMx_ETRF：外部参考信号

#### 预分频器 PSC

降频计算公式：/(PSC + 1), PSC \in [0, 65535]

#### 计数器 CNT

对时钟脉冲进行计数：+1/-1, CNT \in [0, 65535]

- 上计数 counting-up：至ARR重置为0
- 下计数 counting-down：至0重置为ARR
- 中心对齐 center-align：在0、ARR之间来回往复

#### 自动重装寄存器 ARR

设置计数重装周期：ARR + 1, ARR \in [0, 65535]

#### 重复计数寄存器 RCR

设置重复计数次数：RCR + 1, RCR \in [0, 65535]

- CNT每计满一个定时周期溢出一次
- CNT每溢出RCR + 1次，产生一次update事件

### 时基单元进阶

#### STM32F1系列的4种定时器

- Advanced-control timers: TIM1, TIM8
- General-purpose timers: TIM2-TIM5
- General-purpose timers: TIM9-TIM14
- Basic timers: TIM6, TIM7

#### 预加载

寄存器预加载：缓冲机制

- 活动、影子寄存器：数值首先写入影子寄存器；更新事件发生时再写入活动寄存器
- 安全机制：防止“跑飞”，例如设置的ARR数值低于CNT，则只能等到CNT累加至最大值65535
- 强制使能：PSC、RCR；默认关闭、可手动开关：ARR

#### 实验：延迟函数

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. TIM1
   1. Mode/Clock Source: Internal Clock
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 8-1
         2. Counter Period (AutoReload Register): 1000-1
         3. Repetition Counter (RCR): 0
         4. auto-reload preload: Enable
   3. NVIC Settings
      1. TIM1 update interrupt: Enabled

```c
static void MyDelay(uint32_t delay)
{
    uint32_t expireTime = MyGetTick() + delay; // may (but rarely) overflow
//    uint32_t t = 1;
//    t = t << 32;
//    --t;
//    printf("%lu, %lu\n", t, t - 1); // should redirect to UART
    while (expireTime > MyGetTick());
}

static uint32_t MyGetTick(void)
{
    return currentMilliSeconds;
}

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
    if (htim != &htim1) return;
    ++currentMilliSeconds;
}

HAL_TIM_Base_Start_IT(&htim1);
uint32_t blinkInterval = 1000;

while (1)
{
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
    MyDelay(blinkInterval);

    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
    MyDelay(blinkInterval);
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
}
```

### 输出比较

#### PWM

PWM (Pulse-Width Modulation)：脉冲宽度调制信号

- 占空比：高电压时间/周期长度 *100%
  - 表示波形：周期恒定、占空比可调（高占空比表示波的振幅大）

#### CCR

CCR (Capture/Compare Register)：捕获/比较寄存器

- 决定占空比：超过寄存器值时输出高电平

#### 模式

- Frozen 冻结：保持不变
- Active On Match 相等有效：CNT = CCR时输出有效电平
- Inactive On Match 相等无效：CNT = CCR时输出无效电平
- Toggle 翻转：CNT = CCR时输出电压翻转一次
- Force Inactive 强制无效：强制输出无效电平
- Force Active 强制有效：强制输出有效电平
- PWM1：CNT < CCR时输出有效电平
- PWM2：CNT < CCR时输出无效电平

#### 极性选择

互补输出：方便同时输出相反电压

- 同时取正极性 Positive时，输出相反
  - No Output：两种输出都禁止
  - CHx：只使能正常输出
  - CHxN：只使能互补输出
  - CHx CHxN：两种输出都使能

#### 实验：呼吸灯

1. SYS/Debug: Serial Wire
2. TIM1
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel1: PWM Generation CH1 CH1N
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 8-1
         2. Counter Period (AutoReload Register): 1000-1
         3. Repetition Counter (RCR): 0
         4. auto-reload preload: Enable
      2. PWM Generation Channel 1
         1. Mode: PWM mode 1
         2. Pulse (CCR): 0
         3. Output compare preload: Enable
         4. CH Polarity: High
         5. CHN Polarity: High

```c
HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_1);
HAL_TIMEx_PWMN_Start(&htim1, TIM_CHANNEL_1);

while (1)
{
    float t = HAL_GetTick() * .001f;
    float duty = .5f * sin(2 * 3.14159265358979323846f * t) + .5f;
    uint16_t arr = __HAL_TIM_GET_AUTORELOAD(&htim1);
    uint16_t ccr = duty * (arr + 1);
    __HAL_TIM_SET_COMPARE(&htim1, TIM_CHANNEL_1, ccr);
}
```

### 输入捕获

捕捉信号变化的时间点：将CNT保存于CCR

1. 输入滤波：消除噪音毛刺
2. 边沿检测：上升沿脉冲/下降沿脉冲
3. 信号选择：直接/间接/TRC
4. 分频
5. 触发CCx事件：保存、读取

#### 计数脉冲宽度

脉宽 = (CCR2 - CCR1) * 分辨率

- CCR1：上升沿脉冲+直接
- CCR2：下降沿脉冲+间接

#### 实验：超声波测距

- 距离 = 声速（340m/s）* 传播时间（脉冲宽度） / 2
- 测距分辨率 = 声速（340m/s）* 1us（1MHz） / 2 = 0.17mm
- HC-SR04超声波：40kHz * 8 = 0.2ms
  - Trig：>10us
  - Echo：<=38ms

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. PA11: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: low
   3. Maximum output speed: Low
4. RCC
   1. Mode/High Speed Clock (HSE): Crystal/Ceramic Resonator
      1. Clock Configuration/HCLK: 72
5. TIM1
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel1: Input Capture direct mode
      3. Channel2: Input Capture indirect mode
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 72-1
         2. auto-reload preload: Enable
      2. Input Capture Channel 1
         1. Polarity Selection: Rising Edge
         2. IC Selection: Direct
         3. Prescaler Division Ratio: No division
      3. Input Capture Channel 2
         1. Polarity Selection: Falling Edge
         2. IC Selection: Indirect
         3. Prescaler Division Ratio: No division
   3. NVIC Settings
      1. TIM1 capture compare interrupt: Enabled

```c
// 1. Clear CNT
__HAL_TIM_SET_COUNTER(&htim1, 0);

// 2. Clear CC1/CC2
__HAL_TIM_CLEAR_FLAG(&htim1, TIM_FLAG_CC1);
__HAL_TIM_CLEAR_FLAG(&htim1, TIM_FLAG_CC2);

// 3. Start Input Capture
// HAL_TIM_Base_Start(&htim1);
HAL_TIM_IC_Start(&htim1, TIM_CHANNEL_1);
HAL_TIM_IC_Start(&htim1, TIM_CHANNEL_2);

// 4. Send pulse to TRIG
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_11, GPIO_PIN_SET);
for (uint32_t ii=0; ii < 10; ++ii); // 10us (for loop takes 8 cycles)
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_11, GPIO_PIN_RESET);

// 5. Wait for sensing
uint8_t success = 0;
const uint32_t expireTime = HAL_GetTick() + 50;
while (expireTime > HAL_GetTick()) {
    uint32_t cc1Flag = __HAL_TIM_GET_FLAG(&htim1, TIM_FLAG_CC1);
    uint32_t cc2Flag = __HAL_TIM_GET_FLAG(&htim1, TIM_FLAG_CC2);
    if (cc1Flag && cc2Flag) {
        success = 1;
        break;
    }
}

// 6. Stop timer
HAL_TIM_IC_Stop(&htim1, TIM_CHANNEL_1);
HAL_TIM_IC_Stop(&htim1, TIM_CHANNEL_2);

// 7. Compute distance
if (1 != success) continue;
uint16_t ccr1 = __HAL_TIM_GET_COMPARE(&htim1, TIM_CHANNEL_1);
uint16_t ccr2 = __HAL_TIM_GET_COMPARE(&htim1, TIM_CHANNEL_2);
float pulseWidth = (ccr2 - ccr1) * 1e-6f;
float distance = 340.f * pulseWidth / 2.f;
if (.2f > distance) HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
else HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
```

```c
static uint32_t edgeRise = 0;
static uint32_t edgeFall = 0;
void HAL_TIM_IC_CaptureCallback(TIM_HandleTypeDef *htim)
{
    if (htim != &htim1) return;
    if (htim->Channel != HAL_TIM_ACTIVE_CHANNEL_2) return;
    edgeRise = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_1);
    edgeFall = HAL_TIM_ReadCapturedValue(htim, TIM_CHANNEL_2);
}

HAL_TIM_IC_Start(&htim1, TIM_CHANNEL_1);
HAL_TIM_IC_Start_IT(&htim1, TIM_CHANNEL_2); // generate interrupt only on falling edge

while (1) {
   __HAL_TIM_SET_COUNTER(&htim1, 0);
   HAL_GPIO_WritePin(GPIOA, GPIO_PIN_11, GPIO_PIN_SET);
   for (uint32_t ii=0; ii < 10; ++ii); // 10us (for loop takes 8 cycles)
   HAL_GPIO_WritePin(GPIOA, GPIO_PIN_11, GPIO_PIN_RESET);
   HAL_Delay(20);

   float pulseWidth = (edgeFall - edgeRise) * 1e-6f;
   float distance = 340.f * pulseWidth / 2.f;
   if (.2f > distance) HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
   else HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
   HAL_Delay(500);
}
```

### 从模式控制器

可以同时用作主机、从机，互不冲突

#### 作为从机被控制

- TRGI (Trigger Input)：触发输入，获取控制信号
  - 外部时钟模式1：经过触发器，传入定时器内部的触发控制器（经由从模式控制器处理）
    - TIxFPy Timer Input x Filtered Polarized y：来自x定时器输入，经过滤波、极性选择后，由y通道输出
    - TI1_ED：只能双边沿检测（无极性选择）
    - ETR (External Trigger)：外部触发器
  - 外部时钟模式2：没有经过触发器，直接传入定时器内部的触发控制器（不经过从模式控制器处理）
    - ETR (External Trigger)：外部触发器
      - External trigger filter 外部触发滤波：数字滤波器是事件计数器，记录到N个事件后产生一个输出跳变
- 控制当前定时器：启、停、复位、增、减
  - Slave Mode disable 从模式禁止：不使用从机功能
  - Encoder Mode [1-3] 编码器模式[1-3]
  - Reset Mode 复位模式：TRGI的上升沿复位（清零）CNT，同时产生Update事件
  - Gated Mode 门模式：TRGI控制时基单元的开关，即CNT的计数开关，高（电压导）通、低（电压）断（开）
  - Trigger Mode 触发模式：TRGI的上升沿启动定时器，使得CNT开始计数
    - One Pulse Mode 单脉冲模式：只触发一次
  - External Clock Mode 1 外部时钟模式1：TRGI作为定时器的时钟，让CNT计数频率与其脉冲周期一致

#### 作为主机

- TRGO (Trigger Output)：触发输出，输出TRGI的控制信号
- 控制其他模块：定时器、ADC、DAC等
  - Reset 复位
  - Enable 使能：TRGO输出时基单元的开关状态，通-高、断-低
  - Update 更新：每产生一个Update事件（CNT溢出），就向TRGO输出一个脉冲
  - Compare Pulse 输出比较脉冲
  - Compare OC[1-4]Ref 输出比较参考信号[1-4]

#### 实验：测量占空比

1. SYS/Debug: Serial Wire
2. USART1/Mode: Asynchronous
3. TIM3
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel1: PWM Generation CH1
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 8-1
         2. Counter Period (AutoReload Register): 1000-1
         3. auto-reload preload: Enable
      2. PWM Generation Channel 1
         1. Mode: PWM mode 1
         2. Pulse (CCR): 200
         3. CH Polarity: High
4. TIM1
   1. Mode
      1. Slave Mode: Reset Mode
      2. Trigger Source: TI1FP1
      3. Clock Source: Internal Clock
      4. Channel1: Input Capture direct mode
      5. Channel2: Input Capture indirect mode
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 7
         2. Counter Period (AutoReload Register): 65535
         3. auto-reload preload: Enable
      2. Input Capture Channel 1
         1. Polarity Selection: Rising Edge
      3. Input Capture Channel 2
         1. Polarity Selection: Falling Edge

```c
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

static void UART_Printf(UART_HandleTypeDef *huart, const char *format, ...)
{
    /** Project - Properties - C/C++ Build - Settings - Tool Settings
        Use float with printf/scanf
     */
    char buffer[128];

    va_list args;
    va_start(args, format);
    vsnprintf(buffer, sizeof(buffer), format, args);
    va_end(args);

    HAL_UART_Transmit(huart, (const uint8_t *)&buffer, strlen(buffer), HAL_MAX_DELAY);
}

HAL_UART_Transmit(&huart1, (const uint8_t*)"你好！\n", 10, HAL_MAX_DELAY); // UTF-8
HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_1);

while (1)
{
    // 1. Clear CC1
    __HAL_TIM_CLEAR_FLAG(&htim1, TIM_FLAG_CC1);

    // 2. Start timer
    HAL_TIM_IC_Start(&htim1, TIM_CHANNEL_1);
    HAL_TIM_IC_Start(&htim1, TIM_CHANNEL_2);

    // 3. Wait for receiving CC1 and clear it again
    while (0 == __HAL_TIM_GET_FLAG(&htim1, TIM_FLAG_CC1));
    __HAL_TIM_CLEAR_FLAG(&htim1, TIM_FLAG_CC1);

    // 4. Wait for receiving CC1 again
    while (0 == __HAL_TIM_GET_FLAG(&htim1, TIM_FLAG_CC1));

    // 5. Stop timer
    HAL_TIM_IC_Stop(&htim1, TIM_CHANNEL_1);
    HAL_TIM_IC_Stop(&htim1, TIM_CHANNEL_2);

    // 6. Compute duty
    uint16_t ccr1 = __HAL_TIM_GET_COMPARE(&htim1, TIM_CHANNEL_1);
    uint16_t ccr2 = __HAL_TIM_GET_COMPARE(&htim1, TIM_CHANNEL_2);

    float period = ccr1 * 1e-6f;
    float pulseWidth = ccr2 * 1e-6f;
    float duty = pulseWidth /period;

    // 7. Print via UART
    UART_Printf(
            &huart1,
            "Pulse width = %.1fus, Period = %.1fus, Duty ratio = %.1f%%",
            pulseWidth * 1e6f, period * 1e6f, duty * 100.f);
    HAL_Delay(1000);
}
```

#### 实验：红外线循迹模块计数器/红外线对射计数器

1. SYS/Debug: Serial Wire
2. I2C2/Mode: I2C
   1. Parameter Settings/Master features
      1. I2C Speed Mode: Fast Mode
3. TIM2
   1. Mode/Clock Source: ETR2
   2. Parameter Settings
      1. Counter Settings
         1. Counter Period (AutoReload Register): 10
      2. Clock/Clock Filter: 15
   3. NVIC Settings/TIM2 global interrupt: Enabled

```c
static uint32_t loop = 0;

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
  if (htim != htim2) return;
  ++loop;
}

int main(void)
{
  HAL_Delay(20);
  OLED_Init();
  HAL_TIM_Base_Start_IT(&htim2);
  const uint32_t period = htim2.Init.Period;
  uint32_t counter = 0;
  char message[32] = "";
  loop = 0;
  while (1)
  {
//    counter = __HAL_TIM_GET_COUNTER(&htim2);
    counter = loop * period + __HAL_TIM_GET_COUNTER(&htim2);
    sprintf(message, "counter: %lu", counter);
    OLED_NewFrame();
    OLED_PrintString(0, 20, message, &font15x15, OLED_COLOR_NORMAL);
    OLED_ShowFrame();
    HAL_Delay(100);
  }
}
```

### 编码器

编码器相当于电机：测量角度、转速

- 引脚A - CLK；引脚B - DT
- 两个引脚都连上拉电阻：产生脉冲电压
  - 触电接触内部金属片：输出低电压
  - 触电脱离内部金属片：输出高电压
- 旋转方向决定输出顺序
  - 顺时针：A输出在前，表示正转，CNT递增
  - 逆时针：B输出在前，表示反转，CNT递减
- Encoder Mode [1-3] 编码器模式[1-3]
  - 模式1：在A相边沿（TI1）计数
  - 模式2：在B相边沿（TI2）计数
  - 模式3：双边沿（TI1、TI2）都计数

#### 实验：编码器

1. SYS/Debug: Serial Wire
2. USART1/Mode: Asynchronous
3. RCC
   1. Mode/High Speed Clock (HSE): Crystal/Ceramic Resonator
      1. Clock Configuration/HCLK: 72
4. TIM1
   1. Mode
      1. Combined Channels: Encoder Mode
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 2-1
         2. Counter Period (AutoReload Register): 10
         3. auto-reload preload: Enable
      2. Encoder
         1. Encoder Mode: Encoder Mode TI1
         2. Parameters for Channel 1
            1. Polarity: Rising Edge
            2. Input Filter: 15
         3. Parameters for Channel 2
            1. Polarity: Rising Edge
            2. Input Filter: 15
5. TIM3
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel1: PWM Generation CH1
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 72-1
         2. Counter Period (AutoReload Register): 10-1
         3. auto-reload preload: Enable
6. I2C2/Mode: I2C
   1. Parameter Settings/Master features
      1. I2C Speed Mode: Fast Mode

```c
HAL_TIM_Encoder_Start(&htim3, TIM_CHANNEL_1);
HAL_TIM_Encoder_Start(&htim3, TIM_CHANNEL_2);

uint16_t cnt = __HAL_TIM_GET_COUNTER(&htim3);
UART_Printf(&huart1, "Encoder = %u", cnt);
HAL_Delay(500);
```

```c
HAL_TIM_Encoder_Start(&htim1, TIM_CHANNEL_ALL);
HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_1);

HAL_Delay(20);
OLED_Init();

uint32_t counter = 0;
char message[32] = "";
while (1)
{
   counter = __HAL_TIM_GET_COUNTER(&htim1);
   sprintf(message, "counter: %lu", counter);   __HAL_TIM_SET_COMPARE(&htim3, TIM_CHANNEL_1, counter);

   OLED_NewFrame();
   OLED_PrintString(13, 0, message, &font15x15, OLED_COLOR_NORMAL);
   OLED_DrawRectangle(13, 25, 101, 12, OLED_COLOR_NORMAL);
   OLED_DrawFilledRectangle(13, 26, counter * 10, 11, OLED_COLOR_NORMAL);
   OLED_ShowFrame();

   HAL_Delay(500);
}
```

#### 实验：舵机

1. SYS/Debug: Serial Wire
2. RCC
   1. Mode/High Speed Clock (HSE): Crystal/Ceramic Resonator
      1. Clock Configuration/HCLK: 72
3. TIM1
   1. Mode
      1. Combined Channels: Encoder Mode
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 2-1
         2. Counter Period (AutoReload Register): 20
         3. auto-reload preload: Enable
      2. Encoder
         1. Encoder Mode: Encoder Mode TI1
         2. Parameters for Channel 1
            1. Polarity: Rising Edge
            2. Input Filter: 15
         3. Parameters for Channel 2
            1. Polarity: Rising Edge
            2. Input Filter: 15
4. TIM4
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel3: PWM Generation CH3
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 720-1
         2. Counter Period (AutoReload Register): 2000-1
         3. auto-reload preload: Enable
5. I2C2/Mode: I2C
   1. Parameter Settings/Master features
      1. I2C Speed Mode: Fast Mode

```c
HAL_TIM_Encoder_Start(&htim1, TIM_CHANNEL_ALL);
HAL_TIM_PWM_Start(&htim4, TIM_CHANNEL_3);

HAL_Delay(20);
OLED_Init();

uint32_t counter = 0;
uint32_t duty = 0;
char message[32] = "";

while (1)
{
   counter = __HAL_TIM_GET_COUNTER(&htim1);
   duty = (10 * counter / 20.f + 2.5f) / 100.f * 2000;
   __HAL_TIM_SET_COMPARE(&htim4, TIM_CHANNEL_3, duty);

   sprintf(message, "counter: %lu", counter);
   OLED_NewFrame();
   OLED_PrintString(13, 0, message, &font15x15, OLED_COLOR_NORMAL);
   OLED_DrawRectangle(13, 25, 101, 12, OLED_COLOR_NORMAL);
   OLED_DrawFilledRectangle(13, 26, counter * 5, 11, OLED_COLOR_NORMAL);
   OLED_ShowFrame();

   HAL_Delay(500);
}
```

#### 实验：电机 DRV8833

- IN1高+IN2低：正转
  - IN1输入PWM（快衰减）：占空比越大，速度越快
  - IN2输入PWM（慢衰减）：占空比越小，速度越快
- IN1低+IN2高：反转
  - IN2输入PWM（快衰减）：占空比越大，速度越快
  - IN1输入PWM（慢衰减）：占空比越小，速度越快
- IN1高+IN2高：刹车（慢衰减）
- IN1低+IN2低：滑行（快衰减）

1. SYS/Debug: Serial Wire
2. RCC
   1. Mode/High Speed Clock (HSE): Crystal/Ceramic Resonator
      1. Clock Configuration/HCLK: 72
3. TIM1
   1. Mode
      1. Combined Channels: Encoder Mode
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 2-1
         2. Counter Period (AutoReload Register): 40
         3. auto-reload preload: Enable
      2. Encoder
         2. Parameters for Channel 1
            2. Input Filter: 15
         3. Parameters for Channel 2
            2. Input Filter: 15
4. TIM2
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel1: PWM Generation CH1
      3. Channel2: PWM Generation CH2
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 72-1
         2. Counter Period (AutoReload Register): 100-1
         3. auto-reload preload: Enable
5. I2C2/Mode: I2C
   1. Parameter Settings/Master features
      1. I2C Speed Mode: Fast Mode

Note: jump wire cannot pass voltage to motor for unknown reason.

- solved by changing to more solid wires.

```c
DRV8833_Init();
HAL_TIM_Encoder_Start(&htim1, TIM_CHANNEL_ALL);

HAL_Delay(20);
OLED_Init();

uint32_t counter = 0;
uint32_t speed = 0;
char message[32] = "";
const uint32_t MID_COUNT = 20;
const uint32_t MID_COUNT_H = MID_COUNT / 2;

while (1)
{
   counter = __HAL_TIM_GET_COUNTER(&htim1);
   if (MID_COUNT > counter) {
      speed = (MID_COUNT_H > counter) ? counter : MID_COUNT - counter;
      DRV8833_Forward(speed * 10);
   } else {
      speed = counter - MID_COUNT;
      speed = (MID_COUNT_H > speed) ? speed : MID_COUNT - speed;
      DRV8833_Backward(speed * 10);
   }

   sprintf(message, "counter: %lu", counter);
   OLED_NewFrame();
   OLED_PrintString(3, 0, message, &font15x15, OLED_COLOR_NORMAL);
   OLED_DrawRectangle(3, 25, 121, 12, OLED_COLOR_NORMAL);
   OLED_DrawFilledRectangle(3, 26, counter * 3, 11, OLED_COLOR_NORMAL);
   OLED_ShowFrame();

   HAL_Delay(500);
}
```

#### 实验：电机 TB6612

- STBY高：工作；STBY低：待机
- 刹车：IN1高+IN2高+PWM高/低
- 滑行：IN1低+IN2低+PWM高
- IN1高+IN2低：正转
  - PWM：占空比越大，速度越快
  - PWM低：刹车
- IN1低+IN2高：反转
  - PWM：占空比越大，速度越快
  - PWM低：刹车

1. TIM2
   1. Mode
      1. Clock Source: Internal Clock
      2. Channel3: PWM Generation CH3
   2. Parameter Settings
      1. Counter Settings
         1. Prescaler (PSC): 72-1
         2. Counter Period (AutoReload Register): 100-1
         3. auto-reload preload: Enable
