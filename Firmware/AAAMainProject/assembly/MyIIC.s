;���ļ�������R0Ĭ�ϴ���c�����м���Ĳ���
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
    PUSH    {LR}                        ; ���淵�ص�ַ

    ; ʹ��ʱ�� RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOB, ENABLE)
    LDR     R0, =RCC_AHB1Periph_GPIOB    ; ����GPIOB��ʱ��ʹ�ܼĴ�����ַ
    LDR     R1, [R0]                     ; ��ȡGPIOB��ʱ��ʹ��ֵ
    ORR     R1, R1, #RCC_AHB1Periph_GPIOB ; ����GPIOB��ʱ��ʹ��λ
    STR     R1, [R0]                     ; д��GPIOB��ʱ��ʹ��ֵ

    ; ��SCL SDA����Ϊ��©���ģʽ�����Ҷ���Ϊ�ߵ�ƽ
    LDR R1, =GPIO_Pin_8 | GPIO_Pin_9
    MOV R2, #GPIO_Speed_100MHz
    MOV R3, #GPIO_Mode_OUT
    MOV R4, #GPIO_OType_OD
    LDR R0, =GPIOB
    BL GPIO_Init
    
    LDR R0, =GPIO_Pin_8 | GPIO_Pin_9
    BL GPIO_SetBits
    
    POP {LR} ; �ָ�lr�Ĵ���
  

MyIIC_W_SCL
    PUSH {R3, LR}                ; ����Ĵ��� R3 �� LR
    LDR R3, =SCL_PORT            ; ���� SCL_PORT �ĵ�ַ�� R3
    LDRB R0, [R3]                ; �� SCL_PORT ��ȡֵ�� R0
    LDR R1, =SCL_PIN             ; ���� SCL_PIN �ĵ�ַ�� R1
    MOV R2, #0x01                ; ���س��� 0x01 �� R2
    AND R2, R2, R0               ; �� R0 �� R2 �İ�λ�����洢�� R2
    LSLS R2, R2, #1              ; �� R2 ���� 1 λ
    STR R2, [R1]                 ; �� R2 ��ֵд�� SCL_PIN

    LDR R0, =10                  ; ���س��� 10 �� R0
    BL Delay_us                  ; ������ʱ���� Delay_us����ʱ 10 ΢��

    POP {R3, PC}                 ; �ָ��Ĵ��� R3 �� PC��������
  


MyIIC_W_SDA 
    PUSH {R3, LR}                ; ����Ĵ��� R3 �� LR

    LDR R3, =SDA_PORT            ; ���� SDA_PORT �ĵ�ַ�� R3
    LDRB R0, [R3]                ; �� SDA_PORT ��ȡֵ�� R0
    LDR R1, =SDA_PIN             ; ���� SDA_PIN �ĵ�ַ�� R1
    MOV R2, #0x01                ; ���س��� 0x01 �� R2
    AND R2, R2, R0               ; �� R0 �� R2 �İ�λ�����洢�� R2
    LSLS R2, R2, #1              ; �� R2 ���� 1 λ
    STR R2, [R1]                 ; �� R2 ��ֵд�� SDA_PIN

    LDR R0, =10                  ; ���س��� 10 �� R0
    BL Delay_us                  ; ������ʱ���� Delay_us����ʱ 10 ΢��

    POP {R3, PC}                 ; �ָ��Ĵ��� R3 �� PC��������


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
    PUSH {LR}                ; ���淵�ص�ַ
    MOV R2, #0              ; ��ʼ�������� i = 0
    MOV R3, #0x80           ; �������룬��ʼΪ 0x80
Loop1
    LSR R1, R3, R2          ; �������� R3������Ϊ������ R2 ��ֵ����������洢�ڼĴ��� R1 ��
    AND R1, R1, R0          ; �߼���������� R1 �Ͳ��� Byte ���а�λ�룬��������洢�� R1 ��
    BL MyIIC_W_SDA          ; ���� MyIIC_W_SDA �������� R1 ���ݸ�����
	MOV R1, #1
    BL MyIIC_W_SCL          ; ���� MyIIC_W_SCL ������������ 1 ���ݸ�����
	MOV R1, #0
    BL MyIIC_W_SCL          ; ���� MyIIC_W_SCL ������������ 0 ���ݸ�����
    ADD R2, R2, #1          ; ������ i �� 1
    CMP R2, #8              ; �Ƚϼ����� R2 �������� 8
    BNE Loop1                ; �������ȣ�����ת�� Loop ��ǩ������ѭ��

    POP {PC}                ; �ָ����ص�ַ������
	
	
MyIIC_ReceiveByte
	PUSH {LR}
	MOV R0,#0x00
	MOV R1,#1
	BL MyIIC_W_SDA
Loop2
	MOV R1,#1
	BL MyIIC_W_SCL
	BL MyIIC_R_SDA          ; ���� MyIIC_R_SDA ������������ֵ�洢�ڼĴ��� r0 ��
	CMP R3, #1              ; �ȽϼĴ��� R3 �������� 1
	MOV R4, #0x80           ; �������룬��ʼΪ 0x80
	LSR R1, R4, R2          ; �������� R4������Ϊ������ R2 ��ֵ����������洢�ڼĴ��� R1 ��
	ORR R0, R0, R1          ; ִ��λ����������Ĵ��� R1 �ͱ���byte����λ�򣬲�������洢�� R0 ��
	ADD R2, R2, #1          ; ������ i �� 1
    CMP R2, #8              ; �Ƚϼ����� R2 �������� 8
    BNE Loop2                ; �������ȣ�����ת�� Loop ��ǩ������ѭ��
	POP {PC}

	
	
MyIIC_SendACK
    PUSH {LR}               ; ���淵�ص�ַ
    MOV R1, R0              ; �� AckBit �����ƶ����Ĵ��� R1
    BL MyIIC_W_SDA          ; ���� MyIIC_W_SDA ����
    MOV R2, #1              ; �������� 1 �ƶ����Ĵ��� R2
    BL MyIIC_W_SCL          ; ���� MyIIC_W_SCL ����
    MOV R2, #0              ; �������� 0 �ƶ����Ĵ��� R2
    BL MyIIC_W_SCL          ; ���� MyIIC_W_SCL ����
    POP {PC}                ; �ָ����ص�ַ������
	

MyIIC_ReceiveACK
    PUSH {LR}               ; ���淵�ص�ַ
    MOV R0, #1              ; ��SDA�øߵ�ƽ
    BL MyIIC_W_SDA          ; ���� MyIIC_W_SDA ����
    MOV R0, #1              ; ��SCL�õ͵�ƽ
    BL MyIIC_W_SCL          ; ���� MyIIC_W_SCL ����
    BL MyIIC_R_SDA          ; ���� MyIIC_R_SDA ������������ֵ�洢�� R1 ��
    MOV R0, R1              ; �� R1 �е�ֵ�ƶ��� R0������ AckBit ���� R0
    MOV R1, #0              ; ��SCL�õ͵�ƽ
    BL MyIIC_W_SCL          ; ���� MyIIC_W_SCL ����
    POP {PC}                ; �ָ����ص�ַ������

	
    END