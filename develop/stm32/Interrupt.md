---
---

### 中断编程

解决问题：突发紧急事件需要优先处理；缓冲区溢出导致丢失事件

- 中断源：突发事件，写入请求挂起寄存器
  - 边沿检测电路：上升沿触发选择寄存器、下降沿触发选择寄存器
  - 软件中断事件寄存器：软件模拟中断
- 屏蔽、传递
  - 中断屏蔽寄存器：中断控制器 NVIC
  - 事件屏蔽寄存器：脉冲发生器，传给外设自行处理
- 中断响应函数：处理突发事件的代码
  - EXTI[0-4]: EXTI[0-4]_IRQHandler
  - EXTI9_5: EXTI9_5_IRQHandler
  - EXTI15_10: EXTI15_10_IRQHandler

### 中断优先级

#### 中断优先级分组

- Preemption Priority：抢占优先级，中断嵌套+中断排队
- Sub Priority：子优先级，中断排队

#### 中断排队

类比：火车站检票

1. 优先级越高，排队越靠前
2. 优先级相同，先来后到

#### 中断嵌套

条件：新中断的抢占优先级更高

### NVIC

NVIC (Nested Vectored Interrupt Controller)：嵌套向量中断控制器

- 仲裁电路：判定嵌套/排队

### 实验：串口控制闪灯

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. USART1/Mode: Asynchronous
   1. NVIC Settings/USART1 global interrupt: Enabled

```c
static uint32_t blinkInterval = 1000;
static uint8_t dataRcvd = 0;

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
    if (huart != &huart1) return;
    switch (dataRcvd)
    {
    case '1': blinkInterval = 100;
    break;
    case '2': blinkInterval = 500;
    break;
    case '3': blinkInterval = 2000;
    break;
    default: blinkInterval = 1000;
    }
    HAL_UART_Receive_IT(&huart1, &dataRcvd, 1);
}

HAL_UART_Receive_IT(&huart1, &dataRcvd, 1);
while (1)
{
   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
   HAL_Delay(blinkInterval);

   HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
   HAL_Delay(blinkInterval);
}
```

### EXTI

EXTI (External Interrupt)：外部中断

#### 实验：蜂鸣器

1. SYS/Debug: Serial Wire
2. PA3: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
3. PB5: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: Low
4. PA1: GPIO_Input
   1. GPIO mode: Pull-up

```c
const uint32_t blinkInterval = 1000;
HAL_GPIO_WritePin(GPIOB, GPIO_PIN_5, GPIO_PIN_SET);
HAL_Delay(blinkInterval);
HAL_GPIO_WritePin(GPIOB, GPIO_PIN_5, GPIO_PIN_RESET);
HAL_Delay(blinkInterval);

if (GPIO_PIN_SET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin)) continue;
HAL_Delay(10);
if (GPIO_PIN_SET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin)) continue;
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_3, GPIO_PIN_RESET);
while (GPIO_PIN_RESET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin));
HAL_GPIO_WritePin(GPIOA, GPIO_PIN_3, GPIO_PIN_SET);
```

#### 实验：中断触发蜂鸣器

1. SYS/Debug: Serial Wire
2. PA3: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
3. PB5: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: Low
4. PA1: GPIO_EXTI1
   1. GPIO mode: External Interrupt Mode with Rising/Falling edge trigger
   2. GPIO Pull-up/Pull-down: Pull-up
5. NVIC
   1. EXTI line 1 interrupt: Enabled, Preemptive priority = 15
   2. Time base: System tick timer: Enabled, Preemptive priority = 14

```c
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
    if (KEY_Pin != GPIO_Pin) return;
    if (GPIO_PIN_RESET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin)) {
        HAL_Delay(10);
        if (GPIO_PIN_RESET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin)) {
            HAL_GPIO_WritePin(GPIOA, GPIO_PIN_3, GPIO_PIN_RESET);
        }
    } else if (GPIO_PIN_SET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin)) {
        HAL_Delay(10);
        if (GPIO_PIN_SET == HAL_GPIO_ReadPin(GPIOA, KEY_Pin)) {
            HAL_GPIO_WritePin(GPIOA, GPIO_PIN_3, GPIO_PIN_SET);
        }
    }
}
```

### DMA

DMA (Direct Memory Access) 直接内存访问

- DMA传输完成中断（接收/发送完成时）
  - vs 中断模式：接收数据寄存器非空中断/发送数据寄存器空中断（每接收/发送1字节时）
- 串口空闲中断：串口接收不定长数据
