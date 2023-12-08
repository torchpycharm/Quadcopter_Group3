;本文件代码中R0默认代表c语言中假设的参数
RCC_AHB1Periph_GPIOB EQU 0x00000002
GPIOB                EQU 0X44020000
GPIO_Pin_8           EQU 0x0100
GPIO_Pin_9           EQU 0x0200
GPIO_Mode_OUT        EQU 0x01
GPIO_OType_OD        EQU 0x01
GPIO_Speed_100MHz    EQU 0x03
SCL_PORT             EQU 0X44020000
SCL_PIN              EQU 0x0100
SDA_PORT             EQU 0X44020000
SDA_PIN              EQU 0x0200
	  AREA          MyIIC,CODE,READONLY
	  IMPORT GPIO_ReadInputDataBit
	  IMPORT Delay_us
	  IMPORT GPIO_Init
	  IMPORT GPIO_SetBits
	  EXPORT MyIIC_Init
      EXPORT MyIIC_W_SCL
      EXPORT MyIIC_W_SDA 
      EXPORT MyIIC_R_SCL
	  EXPORT MyIIC_R_SDA
	  EXPORT MyIIC_Start
	  EXPORT MyIIC_Stop
	  EXPORT MyIIC_SendByte
	  EXPORT MyIIC_ReceiveByte
	  EXPORT MyIIC_SendACK
	  EXPORT MyIIC_ReceiveACK
	 
      ENTRY
MyIIC_Init
    PUSH    {LR}                        ; 保存返回地址

    ; 使能时钟 RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE)
    LDR     R0, =RCC_AHB1Periph_GPIOB    ; 加载GPIOB的时钟使能寄存器地址
    LDR     R1, [R0]                     ; 读取GPIOB的时钟使能值
    ORR     R1, R1, #RCC_AHB1Periph_GPIOB ; 设置GPIOB的时钟使能位
    STR     R1, [R0]                     ; 写回GPIOB的时钟使能值

    ; 将SCL SDA设置为开漏输出模式，并且都置为高电平
    LDR R1, =GPIO_Pin_8 | GPIO_Pin_9
    MOV R2, #GPIO_Speed_100MHz
    MOV R3, #GPIO_Mode_OUT
    MOV R4, #GPIO_OType_OD
    LDR R0, =GPIOB
    BL GPIO_Init
    
    LDR R0, =GPIO_Pin_8 | GPIO_Pin_9
    BL GPIO_SetBits
    
    POP {LR} ; 恢复lr寄存器
  

MyIIC_W_SCL
    PUSH {R3, LR}                ; 保存寄存器 R3 和 LR
    LDR R3, =SCL_PORT            ; 加载 SCL_PORT 的地址到 R3
    LDRB R0, [R3]                ; 从 SCL_PORT 读取值到 R0
    LDR R1, =SCL_PIN             ; 加载 SCL_PIN 的地址到 R1
    MOV R2, #0x01                ; 加载常数 0x01 到 R2
    AND R2, R2, R0               ; 将 R0 和 R2 的按位与结果存储到 R2
    LSLS R2, R2, #1              ; 将 R2 左移 1 位
    STR R2, [R1]                 ; 将 R2 的值写入 SCL_PIN

    LDR R0, =10                  ; 加载常数 10 到 R0
    BL Delay_us                  ; 调用延时函数 Delay_us，延时 10 微秒

    POP {R3, PC}                 ; 恢复寄存器 R3 和 PC，并返回
  


MyIIC_W_SDA 
    PUSH {R3, LR}                ; 保存寄存器 R3 和 LR

    LDR R3, =SDA_PORT            ; 加载 SDA_PORT 的地址到 R3
    LDRB R0, [R3]                ; 从 SDA_PORT 读取值到 R0
    LDR R1, =SDA_PIN             ; 加载 SDA_PIN 的地址到 R1
    MOV R2, #0x01                ; 加载常数 0x01 到 R2
    AND R2, R2, R0               ; 将 R0 和 R2 的按位与结果存储到 R2
    LSLS R2, R2, #1              ; 将 R2 左移 1 位
    STR R2, [R1]                 ; 将 R2 的值写入 SDA_PIN

    LDR R0, =10                  ; 加载常数 10 到 R0
    BL Delay_us                  ; 调用延时函数 Delay_us，延时 10 微秒

    POP {R3, PC}                 ; 恢复寄存器 R3 和 PC，并返回


MyIIC_R_SCL
	PUSH {LR}

	LDR R1, =SCL_PORT
	LDR R2, =SCL_PIN
	MOV R3, R1
	MOV R4, R2
	BL GPIO_ReadInputDataBit
	MOV R1,R0
	LDR R2, =10
	BL Delay_us
	POP{LR}
	BX LR


MyIIC_R_SDA
    PUSH{LR}
	LDR R3, =SDA_PORT
	LDR R4, =SDA_PIN
	BL GPIO_ReadInputDataBit
	MOV R0,R1
	POP{LR}



MyIIC_Start
    PUSH{LR}
	MOV R1,#1
	BL MyIIC_W_SDA
	MOV R1,#1
	BL MyIIC_W_SCL
	MOV R1,#0
	BL MyIIC_W_SDA
	MOV R1,#0
	BL MyIIC_W_SCL
	POP{LR}
	
	
MyIIC_Stop
    MOV R1,#0
	BL MyIIC_W_SDA
	MOV R1,#1
	BL MyIIC_W_SCL
	MOV R1,#1
	BL MyIIC_W_SDA
	
	
MyIIC_SendByte
    PUSH {LR}                ; 保存返回地址
    MOV R2, #0              ; 初始化计数器 i = 0
    MOV R3, #0x80           ; 设置掩码，初始为 0x80
Loop1
    LSR R1, R3, R2          ; 右移掩码 R3，次数为计数器 R2 的值，并将结果存储在寄存器 R1 中
    AND R1, R1, R0          ; 逻辑与操作，将 R1 和参数 Byte 进行按位与，并将结果存储在 R1 中
    BL MyIIC_W_SDA          ; 调用 MyIIC_W_SDA 函数，将 R1 传递给函数
	MOV R1, #1
    BL MyIIC_W_SCL          ; 调用 MyIIC_W_SCL 函数，将参数 1 传递给函数
	MOV R1, #0
    BL MyIIC_W_SCL          ; 调用 MyIIC_W_SCL 函数，将参数 0 传递给函数
    ADD R2, R2, #1          ; 计数器 i 加 1
    CMP R2, #8              ; 比较计数器 R2 和立即数 8
    BNE Loop1                ; 如果不相等，则跳转到 Loop 标签处继续循环

    POP {PC}                ; 恢复返回地址并返回
	
	
MyIIC_ReceiveByte
	PUSH {LR}
	MOV R0,#0x00
	MOV R1,#1
	BL MyIIC_W_SDA
Loop2
	MOV R1,#1
	BL MyIIC_W_SCL
	BL MyIIC_R_SDA          ; 调用 MyIIC_R_SDA 函数，将返回值存储在寄存器 r0 中
	CMP R3, #1              ; 比较寄存器 R3 和立即数 1
	MOV R4, #0x80           ; 设置掩码，初始为 0x80
	LSR R1, R4, R2          ; 右移掩码 R4，次数为计数器 R2 的值，并将结果存储在寄存器 R1 中
	ORR R0, R0, R1          ; 执行位或操作，将寄存器 R1 和变量byte进行位或，并将结果存储在 R0 中
	ADD R2, R2, #1          ; 计数器 i 加 1
    CMP R2, #8              ; 比较计数器 R2 和立即数 8
    BNE Loop2                ; 如果不相等，则跳转到 Loop 标签处继续循环
	POP {PC}

	
	
MyIIC_SendACK
    PUSH {LR}               ; 保存返回地址
    MOV R1, R0              ; 将 AckBit 参数移动到寄存器 R1
    BL MyIIC_W_SDA          ; 调用 MyIIC_W_SDA 函数
    MOV R2, #1              ; 将立即数 1 移动到寄存器 R2
    BL MyIIC_W_SCL          ; 调用 MyIIC_W_SCL 函数
    MOV R2, #0              ; 将立即数 0 移动到寄存器 R2
    BL MyIIC_W_SCL          ; 调用 MyIIC_W_SCL 函数
    POP {PC}                ; 恢复返回地址并返回
	

MyIIC_ReceiveACK
    PUSH {LR}               ; 保存返回地址
    MOV R0, #1              ; 给SDA置高电平
    BL MyIIC_W_SDA          ; 调用 MyIIC_W_SDA 函数
    MOV R0, #1              ; 给SCL置低电平
    BL MyIIC_W_SCL          ; 调用 MyIIC_W_SCL 函数
    BL MyIIC_R_SDA          ; 调用 MyIIC_R_SDA 函数，将返回值存储在 R1 中
    MOV R0, R1              ; 将 R1 中的值移动到 R0，即将 AckBit 赋给 R0
    MOV R1, #0              ; 给SCL置低电平
    BL MyIIC_W_SCL          ; 调用 MyIIC_W_SCL 函数
    POP {PC}                ; 恢复返回地址并返回

	
    END