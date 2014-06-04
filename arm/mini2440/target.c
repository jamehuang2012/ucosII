/* ��ʼ��mini2440Ŀ��� 
   1. �趨ϵͳ����ʱ��Ƶ��
   2. �˿ڳ�ʼ��
   3. MMU��ʼ��
   4. ���ڳ�ʼ��
   5. LEDָʾ�Ƴ�ʼ��
 */
#include "2440lib.h"
#include "2440addr.h"
#include "s3c2440s.h"
#include "ucos_ii.h"
#include "target.h"

void TargetInit(void)
{
	int i;
	byte  key;
	uint32		mpll_val=0;

	i = 2 ;	//use 400M!

	switch ( i ) {
		case 0:	//200
			key = 12;
			mpll_val = (92<<12)|(4<<4)|(1);
			break;
		case 1:	//300
			key = 14;
			mpll_val = (67<<12)|(1<<4)|(1);
			break;
		case 2:	//400
			key = 14;
			mpll_val = (92<<12)|(1<<4)|(1);
			break;
		case 3:	//440!!!
			key = 14;
			mpll_val = (102<<12)|(1<<4)|(1);
			break;
		default:
			key = 14;
			mpll_val = (92<<12)|(1<<4)|(1);
			break;
	}

	//init FCLK=400M, so change MPLL first
	//	ChangeMPllValue((mpll_val>>12)&0xff, (mpll_val>>4)&0x3f, mpll_val&3);
	//	ChangeClockDivider(key, 12);    

	//MMU_EnableICache();
	//MMU_EnableDCache();

	MMU_DisableICache();
	MMU_DisableDCache();
	// Port_Init();
	MMU_Init();

	//Delay(0);
	//    Uart_Init(0,115200);
	//Uart_Select(0);
	/*��ʹ��printf��䣬��ʹĿ��������Ӻܶ�*/
	// Uart_Printf("hello,qq2440, printf\n");
	rGPBDAT = 0x02<<5;
	//   rGPBDAT = 0x07ff;
	//  Delay(0);
}

void Rtc_Init(void)
{
	int wYear, wMonth,wDay,wDayOfWeek,wHour,wMinute,wSecond;
	wYear = 2008;
	wMonth = 9;
	wDay = 5;
	wDayOfWeek = 5;
	wHour= 9;
	wMinute = 41;
	wSecond = 30;
	rRTCCON = 1 ;		//RTC read and write enable
	rBCDYEAR = (unsigned char)TO_BCD(wYear%100);	//��
	rBCDMON  = (unsigned char)TO_BCD(wMonth);		//��
	rBCDDAY	 = (unsigned char)TO_BCD(wDay);			//��	
	rBCDDATE = wDayOfWeek+1;				//����
	rBCDHOUR = (unsigned char)TO_BCD(wHour);		//Сʱ
	rBCDMIN  = (unsigned char)TO_BCD(wMinute);		//��
	rBCDSEC  = (unsigned char)TO_BCD(wSecond);		//��

	rRTCCON &= ~1 ;		//RTC read and write disable
}
/*********************************************************************************************************
  Initial Timer0 use for ucos time tick
 ********************************************************************************************************/
void Timer0Init(void)
{
	// ��ʱ������
	rTCON = rTCON & (~0xf) ;			// clear manual update bit, stop Timer0

	rTCFG0 	&= 0xffffff00;					// set Timer 0&1 prescaler 0
	rTCFG0 |= 15;							//prescaler = 15+1

	rTCFG1 	&= 0xfffffff0;					// set Timer 0 MUX 1/4
	rTCFG1  |= 0x00000001;					// set Timer 0 MUX 1/4
	rTCNTB0 = (PCLK / (4 *15* OS_TICKS_PER_SEC)) - 1;

	rTCON = (rTCON & (~0xf)) |0x02;              	// updata 		
	rTCON = (rTCON & (~0xf)) |0x09; 			// star
}

/*********************************************************************************************************
  system IsrInit
 ********************************************************************************************************/
extern void OSTickISR(void);
//INT32U  OSTime;		///	gudujian
extern void CLR_IF(void);

void TickISRInit(void)
{
	// �����жϿ�����
	rPRIORITY = 0x00000000;		// ʹ��Ĭ�ϵĹ̶������ȼ�
	rINTMOD = 0x00000000;		// �����жϾ�ΪIRQ�ж�

	pIRQ_TIMER0=(uint32)OSTickISR;
	rINTMSK &= ~(1<<10);			// ��TIMER0�ж�����
	CLR_IF();
	//	OSTime=0;
}
