
-
'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM B_OLD AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE
DIM ����_SPEED  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE
DIM TEMP AS BYTE
DIM X_Pos320 AS BYTE
DIM X_Pos320_OLD AS BYTE
DIM Tilt_F AS BYTE
DIM Tilt_S AS BYTE

DIM X_Size AS BYTE
DIM Angle AS BYTE


DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 2
CONST �¿����AD��Ʈ = 3
CONST ����Ȯ�νð� = 20  'ms


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************
DIM ���ܼ�������  AS BYTE
DIM Infrared_Distance AS BYTE
'*************************************
'*************************************
'***** Setting Constant,Variable*****
'*************************************
DIM turn_delay AS INTEGER
DIM ColorCode AS BYTE
DIM send_code  AS BYTE
DIM ����������Ÿ���  AS BYTE
DIM �����ܰ�   AS BYTE
DIM �Ӹ����ΰ���   AS BYTE

CONST FB_tilt_AD_port = 0
CONST LR_tilt_AD_port = 1

turn_delay = 300

CONST tilt_time_check = 5



CONST CTS_Curve_short_walk_speed = 10

CONST Right_Curve_walk = 100  	'Center = 128
CONST Left_Curve_walk = 156		'Center = 128

CONST Right_Curve_walk_MAX = 78 'Center = 128
CONST Left_Curve_walk_MAX = 188	'Center = 128
CONST START_MAX_VAL = 30 '����Ҷ� ������ �κ��� ������

�����ܰ� = 0

'*********************************************
'*********************************************
'*********************************************
'*********************************************
'*********************************************

�Ӹ����ΰ���  = 29	 ' �⺻=26 ����� ���� ���� ����
CONST ���鿩����Ƚ��  = 22


CONST ��90������60��Ƚ�� = 2
CONST ��������̵庸��Ƚ��  = 12

����������Ÿ��� = 80 '1�� ��������

ColorCode = 0 '0=�����, 1=������, 2=�Ķ���

'*********************************************
' ���ܼ��Ÿ��� = 150 ' About 8cm
' ���ܼ��Ÿ��� = 90 ' About 15cm
' ���ܼ��Ÿ��� = 60 ' About 20cm
' ���ܼ��Ÿ��� = 50 ' About 25cm
' ���ܼ��Ÿ��� = 30 ' About 45cm
' ���ܼ��Ÿ��� = 20 ' About 65cm
' ���ܼ��Ÿ��� = 10 ' About 95cm
'*********************************************


PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON



SERVO 16, 70


GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�

SERVO 11, 100
SERVO 16, �Ӹ����ΰ���


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON


GOSUB All_motor_mode3

'******üũ*****
DELAY 1000
DELAY 1000
DELAY 1000


'


'stop
'*******************************
GOSUB GOSUB_RX_EXIT
start_wait:


    ERX 4800,A,start_wait
    IF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB �⺻�ڼ�
        TEMPO 230
        MUSIC "cdefg"
        GOSUB GOSUB_RX_EXIT
        GOTO start_gogo
    ENDIF


    GOTO start_wait

start_gogo:

    ' GOSUB �߾Ӱ������

    '  GOTO start_gogo
    '**********************
    'GOSUB �������_wait

    ColorCode = 0 '0=�����, 1=������, 2=�Ķ���

    GOSUB CTSColorFind_X_102
    DELAY 30
    GOSUB CTSColorFind_X_102
    DELAY 30
    GOSUB CTSColorFind_X_102
    DELAY 30

    '***** ��ܱ��� ������ ���� **********
    '����Ƚ�� = 18
    'GOSUB Ƚ��_������������


    �����ܰ� = 1
    'GOSUB ��ܴ����ѱ�
    'GOSUB �߾Ӱ������


    ' �����ܰ� = 3
    ' ����������Ÿ��� = 60 '����'

    '*****************************

    GOTO CTS_Curve_short_walk

    GOTO MAIN	'�ø��� ���� ��ƾ���� ����

    '************************************************
�������_wait:

    B = AD(�յڱ���AD��Ʈ)	'���� �յ�
    B_OLD = B

�������_wait_LOOP:

    B = AD(�յڱ���AD��Ʈ)	'���� �յ�

    IF B > B_OLD THEN
        C = B - B_OLD
        IF C > START_MAX_VAL THEN
            MUSIC "CDEF"
            RETURN
        ENDIF
    ELSEIF B_OLD > B THEN
        C =  B_OLD - B
        IF C > START_MAX_VAL THEN
            MUSIC "CDEF"
            RETURN
        ENDIF
    ENDIF

    GOTO �������_wait_LOOP

    '************************************************
�߾Ӱ������_end:

    GOSUB CTSColor_Angle_106

    IF Angle = 0 THEN
        MUSIC "f"
        RETURN
    ELSEIF Angle > 125 THEN
        ����Ƚ�� = 1
        GOSUB ��������3
    ELSEIF Angle > 112 THEN
        ����Ƚ�� = 1
        GOSUB ��������_1
    ELSEIF Angle < 75 THEN
        ����Ƚ�� = 1
        GOSUB ������3
    ELSEIF Angle < 88 THEN
        ����Ƚ�� = 1
        GOSUB ������_1
    ELSE
        GOSUB CTSColorFind_X_102
        IF  X_Pos320 < 95 THEN
            GOSUB ���ʿ�����20
        ELSEIF  X_Pos320 < 110 THEN
            GOSUB ���ʿ�����5
        ELSEIF X_Pos320 > 161 THEN
            GOSUB �����ʿ�����20
        ELSEIF X_Pos320 > 146 THEN
            GOSUB �����ʿ�����5
        ELSE
            MUSIC "CDEF"
            RETURN
        ENDIF
        DELAY 300

    ENDIF
    DELAY 400

    GOTO �߾Ӱ������_end

    '************************************************
�߾Ӱ������:
    ' SPEED 6
    '    MOVE G6C,,  ,  , , 40
    '    WAIT
    '    DELAY 500

    GOSUB CTSColor_Angle_106


    IF Angle = 0 THEN
        MUSIC "f"
        GOSUB ���ʺ���

        GOSUB �����ʺ���

        SERVO 11, 100
        SERVO 16, �Ӹ����ΰ���
        DELAY 300


    ELSEIF Angle > 130 THEN
        ����Ƚ�� = 1
        GOSUB ��������3
    ELSEIF Angle > 108 THEN  '****
        ����Ƚ�� = 1
        GOSUB ��������_1
    ELSEIF Angle < 70 THEN
        ����Ƚ�� = 1
        GOSUB ������3
    ELSEIF Angle < 92 THEN '****
        ����Ƚ�� = 1
        GOSUB ������_1
    ELSE
        GOSUB CTSColorFind_X_102
        IF  X_Pos320 < 65 THEN
            GOSUB ���ʿ�����70
        ELSEIF  X_Pos320 < 95 THEN
            GOSUB ���ʿ�����20
        ELSEIF  X_Pos320 < 110 THEN  '-------------
            GOSUB ���ʿ�����5
        ELSEIF X_Pos320 > 181 THEN
            GOSUB �����ʿ�����70
        ELSEIF X_Pos320 > 161 THEN
            GOSUB �����ʿ�����20
        ELSEIF X_Pos320 > 146 THEN  '-------------
            GOSUB �����ʿ�����5
        ELSE
            MUSIC "CDEF"
            RETURN
        ENDIF
        'DELAY 300

    ENDIF
    DELAY 400

    GOTO �߾Ӱ������

    '************************************************
    '************************************************
    '************************************************
    '************************************************
���ʺ���:

    SPEED 6
    MOVE G6B,,  ,  , , , 55
    WAIT

    DELAY 1000
    GOSUB CTSColorFind_X_102
    IF  X_Pos320 > 1 THEN
        GOSUB ���ʿ�����70
        GOSUB ���ʿ�����70
        GOSUB ���ʿ�����70
    ENDIF
    GOSUB GOSUB_RX_EXIT
    RETURN
    '************************************************
�����ʺ���:

    SPEED 15
    MOVE G6B,,  ,  , , , 145
    WAIT

    DELAY 1000
    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        GOSUB �����ʿ�����70
        GOSUB �����ʿ�����70
        GOSUB �����ʿ�����70
    ENDIF
    GOSUB GOSUB_RX_EXIT
    RETURN

    '************************************************
    '*********************************************
    ' Infrared_Distance = 60 ' About 20cm
    ' Infrared_Distance = 50 ' About 25cm
    ' Infrared_Distance = 30 ' About 45cm
    ' Infrared_Distance = 20 ' About 65cm
    ' Infrared_Distance = 10 ' About 95cm
    '*********************************************
    '************************************************
������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '��ġ���ǵ��
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************
    '***********************************************
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
���̷�ON:


    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0


    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
    RETURN

    '************************************************
�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	
�ٸ��⺻�ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    RETURN

    '************************************************
�⺻�ڼ�:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
�⺻�ڼ�2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN
    '******************************************	
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
�����ڼ�:
    GOSUB ���̷�OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    RETURN
    '******************************************
    '*************************************
    '*********************************************
CTSColorFind_X_102: 'Return: X_Pos320 = 1 ~ 255, NON = 0
    send_code = 102 + ColorCode
    ETX 4800, send_code
    TEMP = 0
CTSColorFind_X_102_WAIT:
    TEMP = TEMP + 1

    IF TEMP > 10 THEN
        X_Pos320 = 0
        GOTO CTSColorFind_X_102_STOP
    ENDIF

    ERX 4800,X_Pos320, CTSColorFind_X_102_WAIT

CTSColorFind_X_102_STOP:

    RETURN
    '*********************************************
    '*********************************************
CTSColor_X_size_104:
    send_code = 104 + ColorCode
    ETX 4800, send_code
    TEMP = 0
CTSColor_X_size_104_WAIT:
    TEMP = TEMP + 1

    IF TEMP > 10 THEN
        X_Size = 0
        GOTO CTSColor_X_size_104_STOP
    ENDIF

    ERX 4800,X_Size, CTSColor_X_size_104_WAIT

CTSColor_X_size_104_STOP:

    RETURN
    '*********************************************
    '*********************************************
CTSColor_Angle_106:
    send_code = 106 + ColorCode
    ETX 4800, send_code
    TEMP = 0
CTSColor_Angle_106_WAIT:
    TEMP = TEMP + 1

    IF TEMP > 10 THEN
        Angle = 0
        GOTO CTSColor_Angle_106_STOP
    ENDIF

    ERX 4800,Angle, CTSColor_Angle_106_WAIT

CTSColor_Angle_106_STOP:

    RETURN
    '****************************************************************

    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
    '**********************************************




    '******************************************
Ƚ��_������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 8
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 146,  93, 101
        MOVE G6D,101,  76, 146,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  76, 146,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������_4
    ENDIF


    '**********************

Ƚ��_������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 146,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


Ƚ��_������������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 146,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        RETURN
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_2_stop

    GOTO Ƚ��_������������_4

Ƚ��_������������_2_stop:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�2

    'DELAY 400
    RETURN


    '*********************************

Ƚ��_������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


Ƚ��_������������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 146,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        RETURN
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_5_stop

    GOTO Ƚ��_������������_1

Ƚ��_������������_5_stop:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�2

    'DELAY 400
    RETURN


    '*************************************

    '*********************************

    GOTO Ƚ��_������������_1

    '******************************************

    '******************************************
������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_4
    ENDIF


    '**********************

������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


������������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_2_stop

    ERX 4800,A, ������������_4
    IF A <> A_old THEN
������������_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


������������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    ' IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_5_stop

    ERX 4800,A, ������������_1
    IF A <> A_old THEN
������������_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO ������������_1

    '******************************************



    '******************************************
    '******************************************

    '******************************************
�����޸���50:
    �Ѿ���Ȯ�� = 0
    GOSUB All_motor_mode3
    ����COUNT = 0
    DELAY 50
    SPEED 12
    HIGHSPEED SETON



    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        WAIT

        MOVE G6A,95,  80, 120, 120, 104
        MOVE G6D,104,  77, 146,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        GOTO �����޸���50_2
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  80, 120, 120, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        GOTO �����޸���50_5
    ENDIF


    '**********************

�����޸���50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


�����޸���50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  78, 147,  90,  100
    WAIT

�����޸���50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 160,  68, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    '����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_3_stop

    ERX 4800,A, �����޸���50_4
    IF A <> A_old THEN
�����޸���50_3_stop:

        MOVE G6D,90,  93, 115, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

�����޸���50_4:
    MOVE G6D,95,  95, 100, 120, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


�����޸���50_5:
    MOVE G6D,95,  75, 122, 120, 104
    MOVE G6A,104,  78, 147,  90,  100
    WAIT


�����޸���50_6:
    MOVE G6D,103,  69, 145, 103,  100
    MOVE G6A, 95, 87, 160,  68, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF
    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_6_stop
    ERX 4800,A, �����޸���50_1
    IF A <> A_old THEN
�����޸���50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    GOTO �����޸���50_1



    '******************************************

    '******************************************
�������������:
    �Ѿ���Ȯ�� = 0

    ����� = 2
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������_4
    ENDIF



    '**********************

�������������_1:
    SPEED 8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


�������������_3:
    SPEED 8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,�������������_4_0

    IF A = 20 THEN
        ����� = 3
    ELSEIF A = 43 THEN
        ����� = 1
    ELSEIF A = 11 THEN
        ����� = 2
    ELSE  '����
        GOTO �������������_3����
    ENDIF

�������������_4_0:

    IF  ����� = 1 THEN'����

    ELSEIF  ����� = 3 THEN'������
        HIGHSPEED SETOFF
        SPEED 8
        MOVE G6D,103,   71, 140, 105,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������_1

    ENDIF



    '*********************************

�������������_4:
    SPEED 8
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


�������������_6:
    SPEED 8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,�������������_1_0

    IF A = 20 THEN
        ����� = 3
    ELSEIF A = 43 THEN
        ����� = 1
    ELSEIF A = 11 THEN
        ����� = 2
    ELSE  '����
        GOTO �������������_6����
    ENDIF

�������������_1_0:

    IF  ����� = 1 THEN'����
        HIGHSPEED SETOFF
        SPEED 8
        MOVE G6A,103,   71, 140, 105,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������_4
    ELSEIF ����� = 3 THEN'������


    ENDIF



    GOTO �������������_1
    '******************************************
    '******************************************
    '*********************************
�������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�
    GOTO MAIN	
    '******************************************
�������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�
    GOTO MAIN	
    '******************************************
    '******************************************

    '************************************************
�����ʿ�����5: '****
    MOTORMODE G6A,3,3,3,3,1
    MOTORMODE G6D,3,3,3,3,1

    SPEED 12
    MOVE G6D, 100,  85, 135, 95, 102, 100
    MOVE G6A,105,  76, 146,  93, 102, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 103, 100
    WAIT

    SPEED 10
    MOVE G6D,99,  76, 145,  93, 99, 100
    MOVE G6A,99,  76, 145,  93, 99, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN
    '*************

���ʿ�����5: '****
    MOTORMODE G6A,3,3,3,3,1
    MOTORMODE G6D,3,3,3,3,1

    SPEED 12
    MOVE G6A, 100,  85, 135, 95, 102, 100
    MOVE G6D,105,  76, 145,  93, 102, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 103, 100
    WAIT

    SPEED 10
    MOVE G6A,99,  76, 145,  93, 99, 100
    MOVE G6D,99,  76, 145,  93, 99, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN

    '**********************************************
    '************************************************
�����ʿ�����20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN
    '*************

���ʿ�����20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN

    '**********************************************
    '******************************************
�����ʿ�����70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

�����ʿ�����70_loop:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT


    '  ERX 4800, A ,�����ʿ�����70����_loop
    '    IF A = A_OLD THEN  GOTO �����ʿ�����70����_loop
    '�����ʿ�����70����_stop:
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************

���ʿ�����70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
���ʿ�����70_loop:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '   ERX 4800, A ,���ʿ�����70����_loop	
    '    IF A = A_OLD THEN  GOTO ���ʿ�����70����_loop
    '���ʿ�����70����_stop:

    GOSUB �⺻�ڼ�2

    RETURN

    '**********************************************
    '************************************************
    '*********************************************

������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������3_LOOP:

    IF ������� = 0 THEN
        ������� = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        ������� = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    GOSUB �⺻�ڼ�2


    RETURN

    '**********************************************
��������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

��������3_LOOP:

    IF ������� = 0 THEN
        ������� = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT



    ELSE
        ������� = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF
    SPEED 12
    GOSUB �⺻�ڼ�2

    RETURN

    '******************************************************
    '**********************************************
������10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB �⺻�ڼ�2
    RETURN
    '**********************************************
��������10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
    '**********************************************
������20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
��������20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************

    '**********************************************	


    '**********************************************
������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2

    RETURN

    '**********************************************
��������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
��������45_LOOP:

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������60_LOOP:

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�2
    RETURN

    '**********************************************
��������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
��������60_LOOP:

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB �⺻�ڼ�2
    RETURN
    '****************************************
    '************************************************
    '**********************************************

    '************************************************
�ڷ��Ͼ��2:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    SERVO 16, �Ӹ����ΰ���
    GOSUB �⺻�ڼ�2

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN


    '**********************************************
    '************************************************

    ''************************************************
    '************************************************
    '************************************************
�ڷ��Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN


    '**********************************************
�������Ͼ��:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************

    '**********************************************
�������Ͼ��2:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset


    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB �⺻�ڼ�
    SERVO 11, 100
    SERVO 16, �Ӹ����ΰ���


    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
    '**********************************************

�Ӹ�����30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,70
    GOTO MAIN

�Ӹ�����45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,55
    GOTO MAIN

�Ӹ�����60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,40
    GOTO MAIN

�Ӹ�����90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,10
    GOTO MAIN

�Ӹ�������30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,130
    GOTO MAIN

�Ӹ�������45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,145
    GOTO MAIN	

�Ӹ�������60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,160
    GOTO MAIN

�Ӹ�������90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,190
    GOTO MAIN

�Ӹ��¿��߾�:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100
    GOTO MAIN

�Ӹ���������:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    GOTO MAIN

    '******************************************
��������80��:

    SPEED 3
    SERVO 16, 80
    ETX 4800,35
    RETURN
    '******************************************
��������60��:

    SPEED 3
    SERVO 16, 65
    ETX 4800,36
    RETURN

    '******************************************
    '******************************************
�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  4800,16
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  4800,15
        GOSUB �������Ͼ��
    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
    ENDIF
    RETURN
    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = ���ڴ���


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    GOSUB SOUND_PLAY_CHK
    PRINT "SND 16 !"
    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN


    '******************************************

    ' ************************************************
���ܼ��Ÿ�����Ȯ��:

    ���ܼ������� = AD(5)
    IF ���ܼ������� > ����������Ÿ��� THEN '50 = ���ܼ��Ÿ��� = 25cm
        MUSIC "C"
        DELAY 200
    ENDIF




    RETURN

    '******************************************

    '******************************************
    '**********************************************
������_1:
    GOSUB ���̷�OFF
    GOSUB Leg_motor_mode1
    HIGHSPEED SETOFF

    FOR i = 1 TO ����Ƚ��

        SPEED 5
        MOVE G6A,100,  89, 145,  99, 100, 100
        MOVE G6D,100,  63, 145,  87, 100, 100
        WAIT

        SPEED 12
        GOSUB �ٸ��⺻�ڼ�
        DELAY 100
    NEXT i

    GOSUB All_motor_mode3
    GOSUB ���̷�ON
    RETURN
    '**********************************************
��������_1:
    GOSUB ���̷�OFF
    GOSUB Leg_motor_mode1
    HIGHSPEED SETOFF

    FOR i = 1 TO ����Ƚ��
        SPEED 5
        MOVE G6D,100,  89, 145,  99, 100, 100
        MOVE G6A,100,  63, 145,  87, 100, 100
        WAIT

        SPEED 12
        GOSUB �ٸ��⺻�ڼ�
        DELAY 100
    NEXT i

    GOSUB All_motor_mode3
    GOSUB ���̷�ON
    RETURN

    '**********************************************




    '********************************************	
    '****** ���� ����********************************
    '************************************************


    '**********************************************
left_turn10:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  30,  80
    WAIT
    'X_Angle = X_Angle + 5
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
right_turn10:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    'X_Angle = X_Angle - 5
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
    '**********************************************
left_turn20:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    ' X_Angle = X_Angle + 10
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
right_turn20:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    'X_Angle = X_Angle - 10
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
left_turn45:
    HIGHSPEED SETOFF

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    'X_Angle = X_Angle + 35
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN

    '**********************************************
right_turn45:

    HIGHSPEED SETOFF

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    MOVE G6C,115
    MOVE G6B,85
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    ' X_Angle = X_Angle - 35
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
left_turn60:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    'X_Angle = X_Angle + 50
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN

    '**********************************************
right_turn60:
    GOSUB Leg_motor_mode2
    HIGHSPEED SETOFF

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100

    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    'X_Angle = X_Angle - 50
    'GOSUB GO_SERVO_X11
    GOSUB �⺻�ڼ�2

    RETURN

    '*************************************
    '*************************************
    '*************************************
    '************************************************
Head_Center:
    MOVE G6B, ,  , , , ,100
    WAIT
    RETURN
    '************************************************
    '*************************************
Line_Search:
    CONST Head_speed = 10

    HIGHSPEED SETOFF

    SPEED Head_speed


    IF X_Pos320_OLD < 50 THEN
        GOTO Line_Search_Right
    ELSEIF X_Pos320_OLD > 200 THEN
        GOTO Line_Search_Left
    ENDIF

Line_Search_Loop:
    GOSUB Head_Center
    GOSUB FB_tilt_check

    '*****************************************
    ' IF �����ܰ� = 0 THEN
    '        �����ܰ� = 1
    '        GOSUB ��ܴ����ѱ�
    '        GOSUB �߾Ӱ������
    '
    '        '�ܳ����ٸ� ��� �κ�
    '        '����Ƚ�� = 30
    '        'GOSUB Ƚ��_������������
    '
    '        '*****************************
    '
    '        GOTO CTS_Curve_short_walk
    '    ENDIF
    '*****************************************
    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************

Line_Search_Left:
    SPEED Head_speed
    MOVE G6B, , , , , ,45
    WAIT
    DELAY turn_delay

    GOSUB FB_tilt_check


    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        GOSUB ������45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************
    SPEED Head_speed
    MOVE G6B, , , , , ,10
    WAIT
    DELAY turn_delay


    GOSUB FB_tilt_check



    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        GOSUB ������45
        GOSUB ������45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************
    SPEED Head_speed
    MOVE G6B, , , , , , 100
    WAIT
    DELAY turn_delay


    GOSUB FB_tilt_check



    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    '***************

    DELAY turn_delay

Line_Search_Right:

    GOSUB FB_tilt_check



    SPEED Head_speed
    MOVE G6B, , , , , ,145
    WAIT
    DELAY turn_delay

    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        GOSUB ��������45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    SPEED Head_speed
    MOVE G6B, , , , , , 180
    WAIT
    DELAY turn_delay


    GOSUB FB_tilt_check



    GOSUB CTSColorFind_X_102
    IF X_Pos320 > 1 THEN
        GOSUB ��������45
        GOSUB ��������45
        SPEED 10
        GOSUB Head_Center
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    DELAY turn_delay



    GOTO Line_Search_Loop

    '*************************************
    '************************************************
FB_tilt_check:

    FOR i = 0 TO COUNT_MAX
        Tilt_F = AD(�յڱ���AD��Ʈ)	'
        IF Tilt_F > 250 OR Tilt_F < 5 THEN RETURN
        IF Tilt_F > MIN AND Tilt_F < MAX THEN RETURN
        DELAY tilt_time_check
    NEXT i

    IF Tilt_F < MIN THEN GOSUB tilt_front
    IF Tilt_F > MAX THEN GOSUB tilt_back

    GOSUB GOSUB_RX_EXIT

    RETURN
    '**************************************************
tilt_front:
    Tilt_F = AD(FB_tilt_AD_port)
    IF Tilt_F < MIN THEN  GOSUB �ڷ��Ͼ��
    RETURN

tilt_back:
    Tilt_F = AD(FB_tilt_AD_port)

    IF Tilt_F > MAX THEN GOSUB �������Ͼ��
    RETURN
    '**************************************************
Side_tilt_check:
    FOR i = 0 TO COUNT_MAX
        Tilt_S = AD(LR_tilt_AD_port)	'
        IF Tilt_S > 250 OR Tilt_S < 5 THEN RETURN
        IF Tilt_S > MIN AND Tilt_S < MAX THEN RETURN
        DELAY tilt_time_check
    NEXT i

    IF Tilt_S < MIN OR Tilt_S > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�2	
        RETURN

    ENDIF
    RETURN
    '**************************************************

    '****************************************************************
    '****************************************************************
CTS_Curve_short_walk:

    GOSUB All_motor_mode3
    GOSUB CTSColorFind_X_102
    IF X_Pos320 = 0 THEN GOTO Line_Search


    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON


    IF ����üũ = 0 THEN
        ����üũ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO CTS_Curve_short_walk_1
    ELSE
        ����üũ = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO CTS_Curve_short_walk_4
    ENDIF


    '**********************

CTS_Curve_short_walk_1:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6A,95,  85, 124, 100, 104
    MOVE G6D,104,  77, 145,  91,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


    'CTS_Curve_short_walk_2:


CTS_Curve_short_walk_3:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6A,103,   78, 139, 98,  100
    MOVE G6D, 95,  84, 145,  85, 102
    WAIT

    GOSUB FB_tilt_check



    ' ���ܼ������� = AD(5)
    '    IF ���ܼ������� > ����������Ÿ��� THEN
    '        GOSUB CTS_Curve_short_walk_6_STOP
    '        GOTO ���������ܼ��Ÿ�������
    '    ENDIF


    GOSUB CTSColorFind_X_102
    IF X_Pos320 = 0 THEN
        GOSUB CTS_Curve_short_walk_3_STOP
        GOTO Line_Search
    ELSEIF X_Pos320 > Left_Curve_walk_MAX  THEN 	'right_turn
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_3_STOP
        GOSUB ��������3
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ELSEIF X_Pos320 < Right_Curve_walk_MAX  THEN	'left_turn
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_3_STOP
        GOSUB ������3
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ELSEIF X_Pos320 > Left_Curve_walk  THEN 	'�����ʰ
        X_Pos320_OLD = X_Pos320	
        HIGHSPEED SETOFF
        SPEED 7
        MOVE G6D,103,   76, 139, 100,  100
        MOVE G6A, 95,  82, 145,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO CTS_Curve_short_walk_1
    ELSEIF X_Pos320 < Right_Curve_walk  THEN	'����
        X_Pos320_OLD = X_Pos320	


    ENDIF


    '*********************************

CTS_Curve_short_walk_4:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6D,95,  85, 124, 100, 104
    MOVE G6A,104,  77, 145,  91,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


    'CTS_Curve_short_walk_5:


CTS_Curve_short_walk_6:
    SPEED CTS_Curve_short_walk_speed
    HIGHSPEED SETON
    MOVE G6D,103,   78, 139, 98,  100
    MOVE G6A, 95,  84, 145,  85, 102
    WAIT


    GOSUB FB_tilt_check



    '   ���ܼ������� = AD(5)
    '    IF ���ܼ������� > ����������Ÿ��� THEN
    '        GOSUB CTS_Curve_short_walk_6_STOP
    '        GOTO ���������ܼ��Ÿ�������
    '    ENDIF


    GOSUB CTSColorFind_X_102
    IF X_Pos320 = 0 THEN
        GOSUB CTS_Curve_short_walk_6_STOP
        GOTO Line_Search

    ELSEIF X_Pos320 > Left_Curve_walk_MAX THEN'��������
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_6_STOP
        GOSUB ��������3
        DELAY turn_delay
        GOTO CTS_Curve_short_walk

    ELSEIF X_Pos320 < Right_Curve_walk_MAX THEN'������
        X_Pos320_OLD = X_Pos320	
        GOSUB CTS_Curve_short_walk_6_STOP
        GOSUB ������3
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ELSEIF X_Pos320 > Left_Curve_walk THEN'�����ʰ
        X_Pos320_OLD = X_Pos320	

    ELSEIF X_Pos320 < Right_Curve_walk THEN'���ʰ
        X_Pos320_OLD = X_Pos320	
        HIGHSPEED SETOFF
        SPEED 7
        MOVE G6A,103,   76, 139, 100,  100
        MOVE G6D, 95,  82, 145,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO CTS_Curve_short_walk_4


    ENDIF



    GOTO CTS_Curve_short_walk_1
    '******************************************
    '******************************************
    '*********************************
CTS_Curve_short_walk_3_STOP:
    MOVE G6D,95,  80, 135, 95, 104
    MOVE G6A,104,  76, 146,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�2
    RETURN
    '******************************************
CTS_Curve_short_walk_6_STOP:
    MOVE G6A,95,  80, 135, 95, 104
    MOVE G6D,104,  76, 146,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************	

    '******************************************************
��ܴ����ѱ�:
    GOSUB ���̷�Off
    SPEED 15
    MOVE G6A,100, 155,  27, 140, 100, 100
    MOVE G6D,100, 155,  27, 140, 100, 100
    MOVE G6B,130,  30,  85, 100,100,100
    MOVE G6C,130,  30,  85, 100,10,100
    WAIT

    SPEED 10	
    MOVE G6A, 100, 165,  55, 165, 100, 100
    MOVE G6D, 100, 165,  55, 165, 100, 100
    MOVE G6B,185,  10, 100
    MOVE G6C,185,  10, 100
    WAIT

    SPEED 10
    MOVE G6A,100, 160, 110, 140, 100, 100
    MOVE G6D,100, 160, 110, 140, 100, 100
    MOVE G6B,140,  70,  20
    MOVE G6C,140,  70,  20
    WAIT

    SPEED 15
    MOVE G6A,100,  56, 110,  26, 100, 100
    MOVE G6D,100, 56, 110,  26, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  15, 100, 100
    MOVE G6D,100,  60, 110,  15, 100, 100
    MOVE G6B,170,  40,  70
    MOVE G6C,170,  40,  70
    WAIT

    SPEED 15
    MOVE G6A,100,  60, 110,  10, 100, 100
    MOVE G6D,100,  60, 110,  10, 100, 100
    MOVE G6B,190,  40,  70
    MOVE G6C,190,  40,  70
    WAIT
    DELAY 150


    SPEED 15
    MOVE G6A,100, 110, 70,  65, 100, 100
    MOVE G6D,100, 110, 70,  65, 100, 100
    MOVE G6B,190, 160, 115
    MOVE G6C,190, 160, 115
    WAIT

    SPEED 10
    MOVE G6A,100, 170,  70,  15, 100, 100
    MOVE G6D,100, 170,  70,  15, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120
    WAIT


    SPEED 6
    MOVE G6A,100, 170,  70,  70, 100, 100
    MOVE G6D,100, 170,  70,  70, 100, 100
    MOVE G6B,190, 155, 120
    MOVE G6C,190, 155, 120
    WAIT


    SPEED 10
    MOVE G6A,100, 170,  30,  110, 100, 100
    MOVE G6D,100, 170,  30,  110, 100, 100
    MOVE G6B,190,  40,  60
    MOVE G6C,190,  40,  60
    WAIT

    SPEED 13
    GOSUB �����ڼ�

    SPEED 8
    GOSUB �⺻�ڼ�


    RETURN

    '**********************************************
    ''*************************************
����������:




    GOSUB �����ʿ�����20
    GOSUB �����ʿ�����20
    'GOSUB �����ʿ�����20

    SPEED 5
    MOVE G6B,145,  20,  70, , ,
    MOVE G6C,145,  20,  70
    WAIT
    DELAY 300


    SPEED 15
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80, , ,
    MOVE G6C,100,  150,  120
    WAIT

    SPEED 6
    MOVE G6B,160,  30,  80, , ,
    MOVE G6C,70,  150,  140
    WAIT
    SPEED 3
    MOVE G6B,160,  30,  80, , ,
    MOVE G6C,50,  150,  140
    WAIT

    SPEED 3
    MOVE G6B,160,  30,  80, , ,
    MOVE G6C,50,  160,  140
    WAIT

    SPEED 10
    MOVE G6A,100, 58, 182, 76, 100, 100
    MOVE G6D,100, 58, 182, 76, 100, 100
    MOVE G6B,160,  30,  80, , ,
    MOVE G6C,20,  190,  160
    WAIT

    SPEED 6
    FOR i = 1 TO 4
        MOVE G6C,10
        WAIT

        MOVE G6C,40
        WAIT
    NEXT i

    DELAY 500
    SPEED 10
    MOVE G6B,160,  30,  80, , ,
    MOVE G6C,100,  170,  160
    WAIT

    GOSUB �⺻�ڼ�

    RETURN
    '**********************************************

    '**********************************************

��������:
    GOSUB All_motor_mode3
    GOSUB GOSUB_RX_EXIT

    GOSUB ���̷�OFF

    SPEED 10

    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,30,  20,  80, , , 100
    MOVE G6C,30,  20,  80, , 110
    WAIT


    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,10,  60,  30, , , 100
    MOVE G6C,10,  60,  30, , 110
    WAIT

    SPEED 15
    MOVE G6A,102, 20,  135, 80, 100,
    MOVE G6D,102, 20,  135, 80, 100,
    MOVE G6B,10,  60,  30, , , 100
    MOVE G6C,10,  60,  30, , 110
    WAIT

    MOTORMODE G6B,1,1,1
    MOTORMODE G6C,1,1,1

    'DELAY 2000


��������_LOOP:

    FOR i = 1 TO ���鿩����Ƚ��
        HIGHSPEED SETON

        SPEED 13
        MOVE G6B,44,  60,  30
        MOVE G6C,43,  60,  30
        WAIT

        HIGHSPEED SETOFF
        SPEED 6
        MOVE G6B,10,  60,  30
        MOVE G6C,10,  60,  30
        WAIT

    NEXT i

    GOSUB �������Ͼ��2


    RETURN
    '******************************************************
    '************************************************
���������ܼ��Ÿ�������:

    ���ܼ������� = AD(5)

    IF ���ܼ������� > ����������Ÿ��� THEN '40 = Infrared_Distance = 35cm
        MUSIC "C"

        FOR i = 1 TO 4
            DELAY 200
            ���ܼ������� = AD(5)
            IF ���ܼ������� < ����������Ÿ��� THEN
                GOTO CTS_Curve_short_walk
            ENDIF
        NEXT i

        '****************************************
        IF �����ܰ� = 1 THEN'�� ���
            GOSUB �߾Ӱ������

            FOR i = 1 TO ��90������60��Ƚ��
                GOSUB ������60
            NEXT i

            GOSUB ������20
            GOSUB ������20
            GOSUB ������20

            FOR i = 1 TO ��������̵庸��Ƚ��
                GOSUB �����ʿ�����70
            NEXT i


            �����ܰ� = 2

            ����������Ÿ��� = 50 '���� '  '�ͳο�
            '****************************************
        ELSEIF �����ܰ� = 2 THEN '�ͳ� ���

            ' GOSUB �߾Ӱ������

            GOSUB ��������

            �����ܰ� = 3
            ����������Ÿ��� = 70 '����'
            '****************************************
        ELSEIF  �����ܰ� = 3 THEN		'��������

            GOSUB �߾Ӱ������

End_loop:
            ����Ƚ�� = 4
            GOSUB Ƚ��_������������

            ColorCode = 1   '������ �ν� ��ȯ

            'F5�� Ű���� �Ӹ� ���� Ȯ��
            SERVO 16, 70  '�Ӹ�����
            SERVO 11, 140 '�Ӹ��¿�

            DELAY 500
            '****************************************



            GOSUB ����������

            '����Ƚ�� = 2
            'GOSUB Ƚ��_������������

            '   STOP

            '  GOSUB CTSColorFind_X_102
            '            IF X_Pos320 = 0 THEN
            '                '
            '           ELSEIF X_Pos320 > Left_Curve_walk_MAX  THEN 	
            '               GOSUB  �����ʿ�����20
            '            ELSEIF X_Pos320 < Right_Curve_walk_MAX  THEN	
            '                GOSUB ���ʿ�����20
            '            ELSEIF X_Pos320 > Left_Curve_walk  THEN 	
            '                GOSUB �����ʿ�����5
            '            ELSEIF X_Pos320 < Right_Curve_walk  THEN	
            '                GOSUB ���ʿ�����5
            '            ELSE
            '                GOSUB ����������
            '            ENDIF
            '
            '             DELAY 400

            GOTO End_loop



            '�̼� ����
            '**************************************************
            '**************************************************
            '****************************************
            '*********************************************
            ' ���ܼ��Ÿ��� = 150 ' About 8cm
            ' ���ܼ��Ÿ��� = 90 ' About 15cm
            ' ���ܼ��Ÿ��� = 60 ' About 20cm
            ' ���ܼ��Ÿ��� = 50 ' About 25cm
            ' ���ܼ��Ÿ��� = 30 ' About 45cm
            ' ���ܼ��Ÿ��� = 20 ' About 65cm
            ' ���ܼ��Ÿ��� = 10 ' About 95cm
            '*********************************************

        ENDIF

    ELSE	
        DELAY turn_delay
        GOTO CTS_Curve_short_walk
    ENDIF

    DELAY 20
    GOTO ���������ܼ��Ÿ�������


    '*************************************
    '*********************************
    '******************************************
    '******************************************	
MAIN: '�󺧼���

    ETX 4800, 38 ' ���� ���� Ȯ�� �۽� ��

MAIN_2:

    ' GOSUB �յڱ�������
    'GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��

    'DELAY 1000
    ' ETX  4800, 250
    ' MUSIC "c"

    ERX 4800,A,MAIN_2	

    A_old = A

    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    IF A > 100 AND A < 110 THEN
        BUTTON_NO = A - 100
        GOSUB Number_Play
        GOSUB SOUND_PLAY_CHK
        GOSUB GOSUB_RX_EXIT


    ELSEIF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB �⺻�ڼ�

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************

KEY1:
    ETX  4800,1
    GOSUB ������10


    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

    '����Ƚ�� = 6
    'GOTO Ƚ��_������������
    'GOSUB ���鿩����

    GOTO RX_EXIT
    '***************
KEY3:
    ETX  4800,3

    GOSUB ��������10

    GOTO RX_EXIT
    '***************
KEY4:
    ETX  4800,4
    GOSUB  ������3

    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    ' J = AD(5)	'���ܼ��Ÿ��� �б�
    '    BUTTON_NO = J
    '    GOSUB Number_Play
    '    GOSUB SOUND_PLAY_CHK
    '    GOSUB GOSUB_RX_EXIT
    '
    GOSUB ����������
    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,6
    GOSUB ��������3


    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOTO ������20

    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8

    GOSUB ��ܴ����ѱ�

    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOSUB ��������20


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    GOTO �����޸���50

    GOTO RX_EXIT
    '***************
KEY11: ' ��
    ETX  4800,11


    GOTO RX_EXIT
    '***************
KEY12: ' ��
    ETX  4800,12


    GOTO RX_EXIT
    '***************
KEY13: '��
    ETX  4800,13
    GOSUB �����ʿ�����70


    GOTO RX_EXIT
    '***************
KEY14: ' ��
    ETX  4800,14
    GOSUB ���ʿ�����70


    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    GOSUB ���ʿ�����20


    GOTO RX_EXIT
    '***************
KEY16: ' POWER
    ETX  4800,16

    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB �����ڼ�	
    GOSUB ������

    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ����ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A
    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
        GOSUB Leg_motor_mode2
        GOSUB �⺻�ڼ�2
        GOSUB ���̷�ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    GOTO �Ӹ�����90��


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	

    GOSUB ���̷�OFF
    GOSUB ������
KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB ���̷�ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************
KEY19: ' P2
    ETX  4800,19
    GOSUB ��������60

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOSUB �����ʿ�����20


    GOTO RX_EXIT
    '***************
KEY21: ' ��
    ETX  4800,21
    GOTO �Ӹ��¿��߾�

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOSUB ������45

    GOTO RX_EXIT
    '***************
KEY23: ' G
    ETX  4800,23
    GOSUB ������
    GOSUB All_motor_mode2
KEY23_wait:


    ERX 4800,A,KEY23_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOTO KEY23_wait


    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOSUB ��������45

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOSUB ������60

    GOTO RX_EXIT
    '***************
KEY26: ' ��
    ETX  4800,26

    SPEED 5
    GOSUB �⺻�ڼ�2	
    TEMPO 220
    MUSIC "ff"
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27



    GOTO RX_EXIT
    '***************
KEY28: ' ��
    ETX  4800,28



    GOTO RX_EXIT
    '***************
KEY29: ' ��
    ETX  4800,29

    GOTO RX_EXIT
    '***************
KEY30: ' ��
    ETX  4800,30


    GOTO RX_EXIT
    '***************
KEY31: ' ��
    ETX  4800,31


    GOTO RX_EXIT
    '***************

KEY32: ' F

    GOTO RX_EXIT
    '***************
