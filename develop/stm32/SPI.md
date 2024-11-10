---
---

### SPI总线

SPI (Serial Peripheral Interface，串行外设接口)：适用于高速、双向数据传输场景

- MOSI (Master Output Slave Input)
- MISO (Master Input Slave Output)
- SCK (Serial Clock)：串行时钟线
- NSS (Negative Slave Select)：从机选择（低电压有效），主机向对应的NSS发送低电压

### SPI参数

- 波特率：每秒钟传输高低电压的数量
  - SPI没有规定波特率的范围，一般取几兆到几十兆bps
    - 选择允许的最大值
    - 考虑设备能够承受的极限：W25QXX最高80MHz
    - 考虑电路板能够承受的极限：面包板大概10MHz
- 比特位的传输顺序
  - MSB (Most Significant Bit) First：先传最高有效位
  - LSB (Least Significant Bit) First：先传最低有效位
- 数据位的长度：8位/16位
- 时钟的极性
  - 低/高：空闲状态为低/高电压
  - 第1/2边沿：第1/2个出现的上升/下降边沿
- 时钟的相位
  - 第1/2边沿采集：发送、采集交替发生

4种时钟模式

- `00`：低极性+第1边沿采集
- `01`：低极性+第2边沿采集
- `10`：高极性+第1边沿采集
- `11`：高极性+第2边沿采集

### 工作模式

Master vs Slave：主机、从机

- Full-Duplex：全双工，双向同时通信
- Half-Duplex：半双工，双向不同时通信
- Receive Only：只接收数据
- Transmit Only：只发送数据

Hardware NSS Signal：硬件NSS信号，用于多主机通信，基本用不到

### W25QXX

XX：容量，64M bit = 8M Byte

- 块 Block: 64KB
- 扇区 Sector: 4KB
- 页 Page: 256Byte

Flash写入之前必须要先擦除，每个数据只能由1改写为0

- 擦除的最小单元是扇区（4KB），写入的最小单元是页（256B）
- 写使能 - 扇区擦除 - 延迟100ms - 写使能 - 页编程 - 延迟10ms

## 实验：按钮消抖

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. PA1: GPIO_Input
   1. GPIO mode: Pull-up

```c
uint8_t pre, cur = 1;
uint8_t ledState = 0;

pre = cur;
cur = (GPIO_PIN_SET == HAL_GPIO_ReadPin(GPIOA, GPIO_PIN_1)) ? 1 : 0;

if (pre != cur) {
    HAL_Delay(10);
    if (0 == cur) continue;
    if (1 == ledState) {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
        ledState = 0;
    } else {
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
        ledState = 1;
    }
}
```

## 实验：外部Flash

1. SYS/Debug: Serial Wire
2. SPI1
   1. Mode: Full-Duplex Master
   2. GPIO Settings
      1. PA5/SPI1_SCK
      2. PA6/SPI1_MISO
      3. PA7/SPI1_MOSI
   3. Parameter Settings
      1. Clock Parameters
         1. Prescaler (for Baud Rate): 8
         2. Clock Polarity (CPOL): High
         3. Clock Phase (CPHA): 2 Edge
3. PA4: GPIO_Output
   1. GPIO mode: Output Push Pull
   2. GPIO output level: High
   3. Maximum output speed: High

```c
static uint8_t LoadLEDState(void)
{
    uint8_t ledState = 0xff;
    static uint8_t sectorAddr[] = {0x00, 0x00, 0x00}; // 24-bit sector address
    static uint8_t readDataCmd[4];
    readDataCmd[0] = 0x03;
    readDataCmd[1] = sectorAddr[0]; readDataCmd[2] = sectorAddr[1]; readDataCmd[3] = sectorAddr[2];
    // for (int ii = 0; ii < 3; ++ii) readDataCmd[ii + 1] = sectorAddr[ii]; // for loop is slow
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
    HAL_SPI_Transmit(&hspi1, readDataCmd, 4, HAL_MAX_DELAY);
    HAL_SPI_Receive(&hspi1, &ledState, 1, HAL_MAX_DELAY);
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);
    return ledState;
}

static void SaveLEDState(uint8_t ledState)
{
    static uint8_t sectorAddr[] = {0x00, 0x00, 0x00}; // 24-bit sector address

    // 1. Write enable
    static uint8_t writeEnableCmd[] = {0x06};
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
    HAL_SPI_Transmit(&hspi1, writeEnableCmd, 1, HAL_MAX_DELAY);
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);

    // 2. Erase sector
    static uint8_t sectorEraseCmd[4];
    sectorEraseCmd[0] = 0x20;
    sectorEraseCmd[1] = sectorAddr[0]; sectorEraseCmd[2] = sectorAddr[1]; sectorEraseCmd[3] = sectorAddr[2];
    // for (int ii = 0; ii < 3; ++ii) sectorEraseCmd[ii + 1] = sectorAddr[ii]; // for loop is slow
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
    HAL_SPI_Transmit(&hspi1, sectorEraseCmd, 4, HAL_MAX_DELAY);
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);
    HAL_Delay(100);

    // 3. Write enable
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
    HAL_SPI_Transmit(&hspi1, writeEnableCmd, 1, HAL_MAX_DELAY);
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);

    // 4. Program page
    static uint8_t pageProgCmd[5];
    pageProgCmd[0] = 0x02;
    pageProgCmd[1] = sectorAddr[0]; pageProgCmd[2] = sectorAddr[1]; pageProgCmd[3] = sectorAddr[2];
    // for (int ii = 0; ii < 3; ++ii) pageProgCmd[ii + 1] = sectorAddr[ii]; // for loop is slow
    pageProgCmd[4] = ledState;
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
    HAL_SPI_Transmit(&hspi1, pageProgCmd, 5, HAL_MAX_DELAY);
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);
    HAL_Delay(10);
}
```
