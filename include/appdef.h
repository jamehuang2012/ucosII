/*
this is the datatype used by the application
	don't use the datatype defined by the kernel
	gudujian
		2013.5.6
*/


#ifndef __DEF_H__H
#define __DEF_H__H

typedef	unsigned int	uint32;
typedef	unsigned short	uint16;
typedef	int		int32;
typedef	short	int	int16;
typedef	unsigned char	byte;
typedef	char		int8;

#define TRUE 	1   
#define FALSE 	0
#define OK	1
#define FAIL	0


#ifndef NULL
#define         NULL    0
#endif

typedef	unsigned int	UINT32;
typedef	unsigned short	UINT16;
typedef	unsigned char	UINT8;

typedef unsigned int size_t;

#define INT_MAX		((int)(~0U>>1))
#define INT_MIN		(-INT_MAX - 1)
#define UINT_MAX	(~0U)
#define LONG_MAX	((long)(~0UL>>1))
#define LONG_MIN	(-LONG_MAX - 1)
#define ULONG_MAX	(~0UL)


#define ESC_KEY	('q')	// 0x1b
#endif /*__DEF_H__*/

