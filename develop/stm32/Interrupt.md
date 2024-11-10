---
---

### 中断编程

解决问题：突发紧急事件需要优先处理；缓冲区溢出导致丢失事件

- 中断源：突发事件
- 中断响应函数：处理突发事件的代码

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
   /* USER CODE END WHILE */

   /* USER CODE BEGIN 3 */
}
```
