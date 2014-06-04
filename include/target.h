#ifndef  Target_H
#define  Target_H

void TargetInit(void);
void Rtc_Init(void);
void Time0Init(void);
void TickIsrInit(void);
void Timer0Init(void);
void TickISRInit(void);
void MMU_DisableICache(void);
void MMU_DisableDCache(void);
void MMU_Init(void);



#define RGB(r,g,b)   		(uint32 )( (r << 16) + (g << 8) + b )
#define FROM_BCD(n)		((((n) >> 4) * 10) + ((n) & 0xf))
#define TO_BCD(n)		((((n) / 10) << 4) | ((n) % 10))


#endif
