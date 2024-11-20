---
---

### I2C总线

IIC (Inter-Integrated Circuit)

#### 电路

半双工通信，主从模式，总线协议，同步通信

- SCL (Serial Clock)：串行时钟线
- SDA (Serial Data)：串行数据线
- 上拉电阻：4.7k，分别连接SCL、SDA
  - 默认状态：上拉为高电平
- 开漏输出：SCL、SDA
  - 本质是实现逻辑与运算：所有从设备断开（写1，输出高阻抗，相当于开路）时，上拉输出1

#### 通讯过程

1. 起始位：在SCL高电压时，向SDA发送下降沿
2. 主机向总线发送从机地址：SCL同步、SDA发送数据
   1. 7位/10位地址
   2. R/W#：0写1读；之后释放SDA
   3. ACK/NACK：地址错/从机忙/从机故障
3. 数据传输：每读/写1个字节，对方发送ACK
   1. 时钟低电平时主机写
   2. 时钟高电平时从机读：读上升沿对应的数据
4. 停止位：在SCL高电压时，向SDA发送上升沿

#### 传输速度

波特率：每秒钟传输的位数

- 标准模式（Sm, Standard mode）：<=100kbps
- 快速模式（Fm, Fast mode）：<=400kbps
- 快速增强模式（Fm+, Fast mode plus）：<=1Mbps
- 高速模式（HSm, High Speed mode）：<=3.4Mbps
- 超快模式（UFm, Ultra Fast mode）：<=5Mbps

快速模式的时钟信号占空比

- $T_{low}/T_{high} = 2/1$, $T_{low}/T_{high} = 16/9$

### SSD 1306

Slave address bit (SA0)

|||||||||
|-|-|-|-|-|-|-|-|
| $b_7$ | $b_6$ | $b_5$ | $b_4$ | $b_3$ | $b_2$ | $b_1$ | $b_0$ |
| 0 | 1 | 1 | 1 | 1 | 0 | SA0 | R/W# |

- “SA0” bit provides an extension bit for the slave address. Either “0111100” (0x78) or “0111101” (0x7A), can be selected as the slave address of SSD1306.
  - D/C# pin acts as SA0 for slave address selection.
  - 接低电压：SA0 = 0；接高电压：SA0 = 1
- “R/W#” bit is used to determine the operation mode of the I2C-bus interface.
  - R/W#=1, it is in read mode. R/W#=0, it is in write mode.

### 实验：点亮OLED

1. SYS/Debug: Serial Wire
2. PC13: GPIO_Output
   1. GPIO mode: Output Open Drain
   2. GPIO output level: High
   3. Maximum output speed: Low
3. I2C2/Mode: I2C
   1. Parameter Settings/Master features
      1. I2C Speed Mode: Fast Mode
      2. I2C Clock Speed: 400000
      3. Fast Mode Duty Cycle: Duty cycle Tlow/Thigh = 2
   2. (Optional) GPIO Settings
      1. PB6/I2C1_SCL, PB7/I2C1_SDA
         1. Maximum output speed: Low
4. RCC
   1. Mode/High Speed Clock (HSE): Crystal/Ceramic Resonator
      1. Clock Configuration/HCLK: 72

```c
const uint16_t oledAddr = 0x78;
uint8_t commands[] = {
    0x00,       //
    0x8d, 0x14, // Set Charge Pump (5V internal VCC circuit)
    0xaf,       // Display ON in normal mode
    0xa5        // Entire display ON, Output ignores RAM content
};

HAL_I2C_Master_Transmit(&hi2c2, oledAddr, commands, sizeof(commands)/sizeof(commands[0]), HAL_MAX_DELAY);

uint8_t dataRcvd = 0;

HAL_I2C_Master_Receive(&hi2c2, oledAddr, &dataRcvd, 1, HAL_MAX_DELAY);

if (0 == (dataRcvd & (0x01 << 6)))
{
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_RESET);
} else {
    HAL_GPIO_WritePin(GPIOC, GPIO_PIN_13, GPIO_PIN_SET);
}
```

```c
HAL_Delay(20);
OLED_Init();
while (1)
{
   OLED_NewFrame();
   OLED_DrawImage(0, 0, &px64Img, OLED_COLOR_NORMAL);
   OLED_PrintString(66, 2, "胖熊", &font30x30, OLED_COLOR_NORMAL);
   OLED_PrintString(66, 34, "科技", &font30x30, OLED_COLOR_NORMAL);
   OLED_ShowFrame();
   HAL_Delay(100);
}
```
