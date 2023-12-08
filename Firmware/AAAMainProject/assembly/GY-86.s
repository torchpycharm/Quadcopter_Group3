MPU6050_ADDRESS               EQU 0xD0
HMC5883L_ADDRESS              EQU 0x3C
MS5611_ADDRESS                EQU 0xEC
MPU6050_SMPLRT_DIV	       EQU 0x19
MPU6050_CONFIG		       EQU 0x1A
MPU6050_GYRO_CONFIG	       EQU 0x1B
MPU6050_ACCEL_CONFIG	   EQU 0x1C
MPU6050_ACCEL_XOUT_H	   EQU 0x3B
MPU6050_ACCEL_XOUT_L	   EQU 0x3C
MPU6050_ACCEL_YOUT_H	   EQU 0x3D
MPU6050_ACCEL_YOUT_L	   EQU 0x3E
MPU6050_ACCEL_ZOUT_H	   EQU 0x3F
MPU6050_ACCEL_ZOUT_L	   EQU 0x40
MPU6050_TEMP_OUT_H		   EQU 0x41
MPU6050_TEMP_OUT_L		   EQU 0x42
MPU6050_GYRO_XOUT_H		   EQU 0x43
MPU6050_GYRO_XOUT_L		   EQU 0x44
MPU6050_GYRO_YOUT_H		   EQU 0x45
MPU6050_GYRO_YOUT_L		   EQU 0x46
MPU6050_GYRO_ZOUT_H		   EQU 0x47
MPU6050_GYRO_ZOUT_L		   EQU 0x48
MPU6050_PWR_MGMT_1		   EQU 0x6B
MPU6050_PWR_MGMT_2		   EQU 0x6C
MPU6050_WHO_AM_I		   EQU 0x75
MPU6050_INT_PIN_CFG           EQU 0x37
MPU6050_USER_CTRL             EQU 0x6A

HMC5883L_CR_A                 EQU 0x00
HMC5883L_CR_B                 EQU 0x01
HMC5883L_MODE                 EQU 0x02
HMC5883L_GA_XOUT_H            EQU 0x03
HMC5883L_GA_XOUT_L            EQU 0x04
HMC5883L_GA_YOUT_H            EQU 0x05
HMC5883L_GA_YOUT_L            EQU 0x06
HMC5883L_GA_ZOUT_H            EQU 0x07
HMC5883L_GA_ZOUT_L            EQU 0x08
HMC5883L_STATUS               EQU 0x09
HMC5883L_IDENTIFY_A           EQU 0x0A
HMC5883L_IDENTIFY_B           EQU 0x0B
HMC5883L_IDENTIFY_C           EQU 0x0C

MS5611_RESET                  EQU 0x1E
MS5611_D1_OSR_256             EQU 0x40
MS5611_D1_OSR_512             EQU 0x42
MS5611_D1_OSR_1024            EQU 0x44
MS5611_D1_OSR_2048            EQU 0x46
MS5611_D1_OSR_4096            EQU 0x48
MS5611_D2_OSR_256             EQU 0x50
MS5611_D2_OSR_512             EQU 0x52
MS5611_D2_OSR_1024            EQU 0x54
MS5611_D2_OSR_2048            EQU 0x56
MS5611_D2_OSR_4096            EQU 0x58
MS5611_ADC_READ               EQU 0x00
MS5611_PROM_RESERVED          EQU 0xA0
MS5611_PROM_COEFFICIENT_1     EQU 0xA2
MS5611_PROM_COEFFICIENT_2     EQU 0xA4
MS5611_PROM_COEFFICIENT_3     EQU 0xA6
MS5611_PROM_COEFFICIENT_4     EQU 0xA8
MS5611_PROM_COEFFICIENT_5     EQU 0xAA
MS5611_PROM_COEFFICIENT_6     EQU 0xAC
MS5611_PROM_CRC               EQU 0xAE
	


	
	  AREA GY86,CODE,READONLY
	  IMPORT MyIIC_Init
      IMPORT MyIIC_W_SCL
      IMPORT MyIIC_W_SDA 
      IMPORT MyIIC_R_SCL
	  IMPORT MyIIC_R_SDA
	  IMPORT MyIIC_Start
	  IMPORT MyIIC_Stop
	  IMPORT MyIIC_SendByte
	  IMPORT MyIIC_ReceiveByte
	  IMPORT MyIIC_SendACK
	  IMPORT MyIIC_ReceiveACK
		  
	EXPORT MPU6050_init
	EXPORT HMC5883L_init
	EXPORT MS5611_init
	EXPORT GY86_WriteRegister
	EXPORT GY86_ReadRegister
	EXPORT MS5611_SendCommand
	EXPORT MS5611_ReadADC
	EXPORT MS5611_ReadC_x
	EXPORT MS5611_GetTemperature
	EXPORT MS5611_GetPressure

	  ENTRY
	  
.global SENS_T1
.global OFF_T1
.global TCS
.global TCO
.global T_REF
.global TEMPSENS
.global D1_Pressur
.global D2_Temperature
.global dT
.global TEMP_100times
.global OFF1
.global SENS
.global P_100times

.data
SENS_T1
    .word 0
OFF_T1
    .word 0
TCS
    .double 0
TCO
    .double 0
T_REF
    .word 0
TEMPSENS
    .double 0
D1_Pressur
    .word 0
D2_Temperature
    .word 0
dT
    .word 0
TEMP_100times
    .word 0
OFF1
    .word 0
SENS
    .word 0
P_100times
    .word 0
	  
	  
GY86_init
	BL MyIIC_Init
	BL MPU6050_init
	BL HMC5883L_init
	BL MS5611_init
	
           ;                 
MPU6050_init
				BL MyIIC_Init
				LDR R0,=MPU6050_PWR_MGMT_1
				LDR R1,=0X01
				BL GY86_WriteRegister
				LDR R0,=MPU6050_PWR_MGMT_2
				LDR R1,=0x00
				BL GY86_WriteRegister
				LDR R0,=MPU6050_SMPLRT_DIV
				LDR R1,=0x09
				BL GY86_WriteRegister
				LDR R0,=MPU6050_CONFIG
				LDR R1,=0x06
				BL GY86_WriteRegister
				LDR R0,=MPU6050_GYRO_CONFIG
				LDR R1,=0x18
				BL GY86_WriteRegister
				LDR R0,=MPU6050_ACCEL_CONFIG
				LDR R1,=0x18
				BL GY86_WriteRegister
				MOV PC,LR

HMC5883L_init
				BL MyIIC_init
				LDR R0,=HMC5883L_CR_A 
				LDR R1,=0x70
				BL GY86_WriteRegister
				LDR R0,=HMC5883L_CR_B
				LDR R1,=0x20
			    BL GY86_WriteRegister
				LDR R0,=HMC5883L_MODE
				LDR R1,=0x00
				MOV PC,LR
				
				
MS5611_init
				LDR R0,=MS5611_RESET
				BL MS5611_SendCommand
			
				; SENS_T1 = MS5611_ReadC_x(MS5611_PROM_COEFFICIENT_1) << 15;
				LDR r1, =MS5611_PROM_COEFFICIENT_1
				BL MS5611_ReadC_x
				LSL r1, r1, #15
				
				; OFF_T1 = MS5611_ReadC_x(MS5611_PROM_COEFFICIENT_2) << 16;
				LDR r2, =MS5611_PROM_COEFFICIENT_2
				BL MS5611_ReadC_x
				LSL r2, r2, #16
				
				; TCS = MS5611_ReadC_x(MS5611_PROM_COEFFICIENT_3) / 256.0;
				LDR r3, =MS5611_PROM_COEFFICIENT_3
				BL MS5611_ReadC_x
				MOV r0, #256
				SMMUL r3, r3, r0
			
				
				; TCO = MS5611_ReadC_x(MS5611_PROM_COEFFICIENT_4) / 128.0 ;
				LDR r4, =MS5611_PROM_COEFFICIENT_4
				BL MS5611_ReadC_x
				MOV r0, #128
				SMMUL r4, r4, r0
			
				
				; T_REF = MS5611_ReadC_x(MS5611_PROM_COEFFICIENT_5) << 8 ;
				LDR r5, =MS5611_PROM_COEFFICIENT_5
				BL MS5611_ReadC_x
				LSL r5, r5, #8
			
	
				; TEMPSENS = MS5611_ReadC_x(MS5611_PROM_COEFFICIENT_6) / 8388608.0;
				LDR r6, =MS5611_PROM_COEFFICIENT_6
				BL MS5611_ReadC_x
				MOV r0, #8388608
				SMMUL r6, r6, r0
			
	            MOV PC,LR




GY86_GetData
				PUSH {LR}  ; ���淵�ص�ַ
				
				; ��ȡ���ٶȼ�X������-------------------------------------------------------------------------------
				PUSH {R0, R1}  ; ������Ҫʹ�õļĴ���
				
				; ����GY86_ReadRegister������ȡ�Ĵ���ֵ
				LDR R0, =MPU6050_ADDRESS  ; ��MPU6050��ַ���ص�R0
				LDR R1, =MPU6050_ACCEL_XOUT_H  ; �����ٶȼ�X���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataH������
				STRH R0, [SP, #4] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��4��λ��
				
				; ��ȡ���ٶȼ�X�����ݵĵ�λ
				LDR R0, =MPU6050_ADDRESS  ; ��MPU6050��ַ���ص�R0
				LDR R1, =MPU6050_ACCEL_XOUT_L  ; �����ٶȼ�X���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataL������
				STRH R0, [SP, #6] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��6��λ��
				
				; ��DataH��DataL�ϲ�Ϊ16λ��AXֵ
				LDRH R0, [SP, #4] ; ��ջ�е�ƫ��4��λ�ü���DataH�ĵ�16λ��R0
				LSL R0, R0, #8 ; ��R0��ֵ����8λ
				LDRH R1, [SP, #6] ; ��ջ�е�ƫ��6��λ�ü���DataL�ĵ�16λ��R1
				ORR R0, R0, R1 ; ��R0��R1���а�λ���������������洢��Original_Data_List->AX
				
				POP {R0, R1} ; �ָ��Ĵ���
				
				; ��ȡ���ٶȼ�Y������------------------------------------------------------------------------------
				PUSH {R0, R1}  ; ������Ҫʹ�õļĴ���
				
				; ����GY86_ReadRegister������ȡ�Ĵ���ֵ
				LDR R0, =MPU6050_ADDRESS  ; ��MPU6050��ַ���ص�R0
				LDR R1, =MPU6050_ACCEL_YOUT_H  ; �����ٶȼ�Y���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataH������
				STRH R0, [SP, #4] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��4��λ��
				
				; ��ȡ���ٶȼ�Y�����ݵĵ�λ
				LDR R0, =MPU6050_ADDRESS  ; ��MPU6050��ַ���ص�R0
				LDR R1, =MPU6050_ACCEL_YOUT_L  ; �����ٶȼ�Y���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataL������
				STRH R0, [SP, #6] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��6��λ��
				
				; ��DataH��DataL�ϲ�Ϊ16λ��AYֵ
				LDRH R0, [SP, #4] ; ��ջ�е�ƫ��4��λ�ü���DataH�ĵ�16λ��R0
				LSL R0, R0, #8 ; ��R0��ֵ����8λ
				LDRH R1, [SP, #6] ; ��ջ�е�ƫ��6��λ�ü���DataL�ĵ�16λ��R1
				ORR R0, R0, R1 ; ��R0��R1���а�λ���������������洢��Original_Data_List->AY
				
				POP {R0, R1} ; �ָ��Ĵ���
				
				; ��ȡ���ٶȼ�Z������---------------------------------------------------------------------------
				PUSH {R0, R1}  ; ������Ҫʹ�õļĴ���
				
				; ����GY86_ReadRegister������ȡ�Ĵ���ֵ
				LDR R0, =MPU6050_ADDRESS  ; ��MPU6050��ַ���ص�R0
				LDR R1, =MPU6050_ACCEL_ZOUT_H  ; �����ٶȼ�Z���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataH������
				STRH R0, [SP, #4] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��4��λ��
				
				; ��ȡ���ٶȼ�Z�����ݵĵ�λ
				LDR R0, =MPU6050_ADDRESS  ; ��MPU6050��ַ���ص�R0
				LDR R1, =MPU6050_ACCEL_ZOUT_L  ; �����ٶȼ�Z���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataL������
				STRH R0, [SP, #6] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��6��λ��
				
				; ��DataH��DataL�ϲ�Ϊ16λ��AZֵ
				LDRH R0, [SP, #4] ; ��ջ�е�ƫ��4��λ�ü���DataH�ĵ�16λ��R0
				LSL R0, R0, #8 ; ��R0��ֵ����8λ
				LDRH R1, [SP, #6] ; ��ջ�е�ƫ��6��λ�ü���DataL�ĵ�16λ��R1
				ORR R0, R0, R1 ; ��R0��R1���а�λ���������������洢��Original_Data_List->AZ
				
				POP {R0, R1} ; �ָ��Ĵ���
				
				
				
				; ��ȡ������X������-------------------------------------------------------------------------
				PUSH {R0, R1}  ; ������Ҫʹ�õļĴ���
				
				; ����GY86_ReadRegister������ȡ�Ĵ���ֵ
				LDR R0, =HMC5883L_ADDRESS  ; ��HMC5883L��ַ���ص�R0
				LDR R1, =HMC5883L_GA_XOUT_H  ; ��������X���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataH������
				STRH R0, [SP, #4] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��4��λ��
				
				; ��ȡ������X�����ݵĵ�λ
				LDR R0, =HMC5883L_ADDRESS  ; ��HMC5883L��ַ���ص�R0
				LDR R1, =HMC5883L_GA_XOUT_L  ; ��������X���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataL������
				STRH R0, [SP, #6] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��6��λ��
				
				; ��DataH��DataL�ϲ�Ϊ16λ��GaXֵ
				LDRH R0, [SP, #4] ; ��ջ�е�ƫ��4��λ�ü���DataH�ĵ�16λ��R0
				LSL R0, R0, #8 ; ��R0��ֵ����8λ
				LDRH R1, [SP, #6] ; ��ջ�е�ƫ��6��λ�ü���DataL�ĵ�16λ��R1
				ORR R0, R0, R1 ; ��R0��R1���а�λ���������������洢��Original_Data_List->GaX
				
				POP {R0, R1} ; �ָ��Ĵ���
				
				; ��ȡ������Y������--------------------------------------------------------------------------
				PUSH {R0, R1}  ; ������Ҫʹ�õļĴ���
				
				; ����GY86_ReadRegister������ȡ�Ĵ���ֵ
				LDR R0, =HMC5883L_ADDRESS  ; ��HMC5883L��ַ���ص�R0
				LDR R1, =HMC5883L_GA_YOUT_H  ; ��������Y���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataH������
				STRH R0, [SP, #4] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��4��λ��
				
				; ��ȡ������X�����ݵĵ�λ
				LDR R0, =HMC5883L_ADDRESS  ; ��HMC5883L��ַ���ص�R0
				LDR R1, =HMC5883L_GA_YOUT_L  ; ��������Y���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataL������
				STRH R0, [SP, #6] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��6��λ��
				
				; ��DataH��DataL�ϲ�Ϊ16λ��GaYֵ
				LDRH R0, [SP, #4] ; ��ջ�е�ƫ��4��λ�ü���DataH�ĵ�16λ��R0
				LSL R0, R0, #8 ; ��R0��ֵ����8λ
				LDRH R1, [SP, #6] ; ��ջ�е�ƫ��6��λ�ü���DataL�ĵ�16λ��R1
				ORR R0, R0, R1 ; ��R0��R1���а�λ���������������洢��Original_Data_List->GaY
				
				POP {R0, R1} ; �ָ��Ĵ���
				
				; ��ȡ������Z������-------------------------------------------------------------------
				PUSH {R0, R1}  ; ������Ҫʹ�õļĴ���
				
				; ����GY86_ReadRegister������ȡ�Ĵ���ֵ
				LDR R0, =HMC5883L_ADDRESS  ; ��HMC5883L��ַ���ص�R0
				LDR R1, =HMC5883L_GA_ZOUT_H  ; ��������Z���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataH������
				STRH R0, [SP, #4] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��4��λ��
				
				; ��ȡ������X�����ݵĵ�λ
				LDR R0, =HMC5883L_ADDRESS  ; ��HMC5883L��ַ���ص�R0
				LDR R1, =HMC5883L_GA_ZOUT_L  ; ��������X���λ�Ĵ�����ַ���ص�R1
				BL GY86_ReadRegister  ; ����GY86_ReadRegister����
				
				; ������ֵ�洢��DataL������
				STRH R0, [SP, #6] ; ��R0�ĵ�16λ�洢��ջ�е�ƫ��6��λ��
				
				; ��DataH��DataL�ϲ�Ϊ16λ��GaXֵ
				LDRH R0, [SP, #4] ; ��ջ�е�ƫ��4��λ�ü���DataH�ĵ�16λ��R0
				LSL R0, R0, #8 ; ��R0��ֵ����8λ
				LDRH R1, [SP, #6] ; ��ջ�е�ƫ��6��λ�ü���DataL�ĵ�16λ��R1
				ORR R0, R0, R1 ; ��R0��R1���а�λ���������������洢��Original_Data_List->GaX
				
				POP {R0, R1} ; �ָ��Ĵ���
				
				; ����MS5611_GetPressure������ȡ��ѹֵ-------------------------------------------------------------------
				LDR R0, =MS5611_D2_OSR_4096  ; ��MS5611_D2_OSR_4096���ص�R0
				BL MS5611_GetPressure  ; ����MS5611_GetPressure����
				
				; ������ֵ�洢��P_100times������
				STR R0, [SP, #4] ; ��R0��ֵ�洢��ջ�е�ƫ��4��λ��
				
				; �洢���ݵ�Original_Data_List�ṹ��
				LDR R0, =Original_Data_List  ; ��Original_Data_List�ĵ�ַ���ص�R0
				
				; �洢GaYֵ
				LDR R1, [SP, #8]  ; ��ջ�е�ƫ��8��λ�ü���GaY��ֵ��R1
				STRH R1, [R0, #12] ; ��R1�ĵ�16λ�洢��Original_Data_List->GaY��ƫ��12��λ��
				
				; �洢GaZֵ
				LDR R1, [SP, #12] ; ��ջ�е�ƫ��12��λ�ü���GaZ��ֵ��R1
				STRH R1, [R0, #14] ; ��R1�ĵ�16λ�洢��Original_Data_List->GaZ��ƫ��14��λ��
				
				; �洢Heightֵ
				LDR R1, [SP, #4]  ; ��ջ�е�ƫ��4��λ�ü���Height��ֵ��R1
				STR R1, [R0, #16] ; ��R1��ֵ�洢��Original_Data_List->Height��ƫ��16��λ��


				POP {PC}  ; ���غ������õĵ�ַ

/*	��һ�����⣬ʹ�úܶ�Ĵ���ȥ����ֵ��û������ջ						
GY86_GetData
                PUSH{R3,R4,R5,R6,R7,R8,R9,R10,R11,PC}
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_ACCEL_XOUT_H
				BL GY86_ReadRegister
				LSL R3, R0, #8 
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_ACCEL_XOUT_L
				BL GY86_ReadRegister				
				ORR r3, r0, r3 
				
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_ACCEL_YOUT_H
				BL GY86_ReadRegister
				LSL R4, R0, #8 
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_ACCEL_YOUT_L
				BL GY86_ReadRegister				
				ORR R4, r0, R4 
				
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_TEMP_OUT_H
				BL GY86_ReadRegister
				LSL R5, R0, #8 
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_TEMP_OUT_L
				BL GY86_ReadRegister				
				ORR R5, r0, R5 
				
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_GYRO_XOUT_H
				BL GY86_ReadRegister
				LSL R6, R0, #8 
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_GYRO_XOUT_L
				BL GY86_ReadRegister				
				ORR R6, r0, R6 
				
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_GYRO_YOUT_H
				BL GY86_ReadRegister
				LSL R7, R0, #8 
				LDR R1,=MPU6050_ADDRESS
				LDR R2,=MPU6050_GYRO_YOUT_L
				BL GY86_ReadRegister				
				ORR R7, r0, R7 
				
				LDR R1,=HMC5883L_ADDRESS
				LDR R2,=HMC5883L_GA_XOUT_H
				BL GY86_ReadRegister
				LSL R8, R0, #8 
				LDR R1,=HMC5883L_ADDRESS
				LDR R2,=HMC5883L_GA_XOUT_L
				BL GY86_ReadRegister				
				ORR R8, r0, R8 
				
				LDR R1,=HMC5883L_ADDRESS
				LDR R2,=HMC5883L_GA_YOUT_H
				BL GY86_ReadRegister
				LSL R9, R0, #8 
				LDR R1,=HMC5883L_ADDRESS
				LDR R2,=HMC5883L_GA_YOUT_L
				BL GY86_ReadRegister				
				ORR R9, r0, R9 
				
				LDR R1,=HMC5883L_ADDRESS
				LDR R2,=HMC5883L_GA_ZOUT_H
				BL GY86_ReadRegister
				LSL R10, R0, #8 
				LDR R1,=HMC5883L_ADDRESS
				LDR R2,=HMC5883L_GA_ZOUT_L
				BL GY86_ReadRegister				
				ORR R10, r0, R10 
				
				LDR R1,=MS5611_D2_OSR_4096
				BL MS5611_GetPressure
				MOV R11, R0
				POP{R3,R4,R5,R6,R7,R8,R9,R10,LR}
		*/
GY86_WriteRegister
                PUSH{R0,R1,LR} 
				BL MyIIC_Start
				PUSH{R4,LR}
				MOV R4, #0x00
				ORR r0, r0, r4
				BL MyIIC_SendByte
				POP{R4,PC}
				BL MyIIC_ReceiveACK
				PUSH{R1}
				BL MyIIC_SendByte
				POP{R1}
				BL MyIIC_ReceiveACK
				PUSH{R2}
				BL MyIIC_SendByte
				POP{R2}
				BL MyIIC_ReceiveACK
				BL MyIIC_Stop
				POP{R0,R1,PC}
				
				
GY86_ReadRegister
                PUSH{R0,R1,LR}
		        BL MyIIC_Start
				PUSH{R4,LR}
				MOV R4,#0x00
				ORR R0,R0,R4
				POP{R4,PC}
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				BL MyIIC_Start
				PUSH{R4,LR}
				MOV R4,#0x00
				ORR R0,R0,R4
				POP{R1,PC}
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				BL MyIIC_ReceiveByte
				MOV R4,#1
				BL MyIIC_SendACK
				BL MyIIC_Stop
				POP {R0,R1,PC}


MS5611_SendCommand
                PUSH{R0,LR}
				BL MyIIC_Start
				LDR R4,=MS5611_ADDRESS
				MOV R5,#0x00
				ORR R4,R4,R5
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				PUSH{R0}
				BL MyIIC_SendByte
				POP{R0}
				BL MyIIC_ReceiveACK
				BL MyIIC_Stop
				
MS5611_ReadADC
				BL MyIIC_Start
				LDR R4,=MS5611_ADDRESS
				MOV R5,#0x00
				ORR R4,R4,R5
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				LDR R4,=MS5611_ADC_READ
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				BL MyIIC_Start
				LDR R4,=MS5611_ADDRESS
				MOV R5,#0x00
				ORR R4,R4,R5
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				BL MyIIC_ReceiveByte
				LSL R0, R0, #8
				MOV R4,#1
				BL MyIIC_SendACK
				BL MyIIC_ReceiveByte
				LSL R0, R0, #8
				MOV R4,#0
				BL MyIIC_SendACK
				BL MyIIC_Stop
				BX LR
				
				


MS5611_ReadC_x
				; �������
				PUSH {R0,LR}           
				; ���ʹ��豸��ַ
				BL MyIIC_Start
				LDR r1, =MS5611_ADDRESS
				ORR r1, r1, #0x00   
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				
				;�������ݵ�ַ
				PUSH{R0}
				BL MyIIC_SendByte
				POP{R0}
				BL MyIIC_ReceiveACK
				
				;��ʼ��ȡ����
				BL MyIIC_Start
				LDR r1, =MS5611_ADDRESS
				ORR r1, r1, #0x01   
				BL MyIIC_SendByte
				BL MyIIC_ReceiveACK
				BL MyIIC_ReceiveByte
				LSL r0, r0, #8     
				MOV R1,#1
				BL MyIIC_SendACK
				BL MyIIC_ReceiveByte
				LSL r0, r0, #8    
				MOV R1,#0	
				BL MyIIC_SendACK
				BL MyIIC_Stop   
				
				POP {PC} 

MS5611_GetTemperature	
				PUSH {r4, lr}
				SUB sp, sp, #8
				STR r0, [sp, #4]

				LDR r0, [sp, #4]
				BL MS5611_SendCommand
				MOV r0, #10
				BL Delay_ms
				BL MS5611_ReadADC
				STR r0, [sp]

				LDR r0, [sp]
				LDR r1, =T_REF
				LDR r1, [r1]
				SUB r0, r0, r1
				STR r0, =dT

				LDR r0, =dT
				LDR r0, [r0]
				LDR r1, =TEMPSENS
				LDR r1, [r1]
				MUL r0, r0, r1
				LDR r1, =2000
				ADD r0, r0, r1
				STR r0, =TEMP_100times

				ADD sp, sp, #8
				POP {r4, pc}
				END

							



