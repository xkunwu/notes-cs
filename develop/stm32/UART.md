---
---

### 串口引脚

- Tx：数据发送引脚；Rx：数据接收引脚
- 双方交叉连接

### 串口的数据帧格式

- 起始位（1位）
- 数据位（8/9位），常用：
  - 8位：数据，无校验位
  - 9位：8位数据+1位校验
- 停止位（0.5/1/1.5/2位）

#### 校验位的使用方法

- 奇校验：要求数据帧中总共奇数个1
- 偶校验：要求数据帧中总共偶数个1

#### 波特率

- 每秒传输的位数量
- 注意：收发双方应该选择相同的波特率

#### UART vs USART

- UART (Universal Asynchronous Receiver/Transmitter)：通用异步收发器
- USART (Universal Synchronous/Asynchronous Receiver/Transmitter)：通用同步/异步收发器
  - CK：时钟线

### 实验：简单发送数据

1. SYS/Debug: Serial Wire
2. USART1/Mode: Asynchronous

```c
#include <string.h>

uint8_t byteNumber = 0x5a;
uint8_t byteArray[] = {1, 2, 3, 4, 5};
char ch = 'a';
char *str = "hello world";

// HAL_StatusTypeDef HAL_UART_Transmit(UART_HandleTypeDef *huart, const uint8_t *pData, uint16_t Size, uint32_t Timeout)
HAL_UART_Transmit(&huart1, &byteNumber, 1, HAL_MAX_DELAY);
HAL_UART_Transmit(&huart1, byteArray, 5, HAL_MAX_DELAY);
HAL_UART_Transmit(&huart1, (uint8_t *)&ch, 1, HAL_MAX_DELAY);
HAL_UART_Transmit(&huart1, (uint8_t *)str, strlen(str), HAL_MAX_DELAY);
```

### 实验：简单接收数据

1. SYS/Debug: Serial Wire
2. USART1/Mode: Asynchronous
3. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low

```c
uint8_t dataRcvd = 0;

// HAL_StatusTypeDef HAL_UART_Receive(UART_HandleTypeDef *huart, uint8_t *pData, uint16_t Size, uint32_t Timeout)
HAL_UART_Receive(&huart1, &dataRcvd, 1, HAL_MAX_DELAY);

if ('1' == dataRcvd)
{
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
} else {
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
}
```
