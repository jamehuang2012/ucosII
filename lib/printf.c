#include "vsprintf.h"
#include "printf.h"
#include "string.h"
#include "appdef.h"

extern void putc(unsigned char c);
extern unsigned char getc(void);

#define	OUTBUFSIZE	512	
#define	INBUFSIZE	1024



int printf(const char *fmt, ...)
{
	int i;
	int len;
	va_list args;
	char OutBuf[OUTBUFSIZE];

	va_start(args, fmt);
	len = vsprintf(OutBuf,fmt,args);
	va_end(args);
	for (i = 0; i < strlen(OutBuf); i++)
	{
		putc((byte)OutBuf[i]);
	}
	return len;
}



int scanf(const char * fmt, ...)
{
	int i = 0;
	unsigned char c;
	va_list args;
	char InBuf[INBUFSIZE];
	
	while(1)
	{
		c = getc();
		if((c == 0x0d) || (c == 0x0a))
		{
			InBuf[i] = '\0';
			break;
		}
		else
		{
			InBuf[i++] = c;
		}
	}
	
	va_start(args,fmt);
	i = vsscanf(InBuf,fmt,args);
	va_end(args);

	return i;
}

