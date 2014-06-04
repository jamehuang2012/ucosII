/* Porocessor memory map */
#ifndef _SMDK2440_H
#define _SMDK2440_H
#include "size.h"
#define ROM_BASE0		0x00000000      /* base address of rom bank 0 */
#define ROM_BASE1		0x08000000      /* base address of rom bank 1 */
#define DRAM_BASE0		0x30000000      /* base address of dram bank 0 */
#define DRAM_BASE1		0x38000000	/* base address of dram bank 1 */

#ifdef CONFIG_MTD_CFI
/* Flash */
#define FLASH_BASE		ROM_BASE0
#define FLASH_SIZE		SZ_32M
#define FLASH_UNCACHED_BASE	0x10000000	/* to mapping flash memory */
#define FLASH_BUSWIDTH		4
/* ROM */
#define VIVI_ROM_BASE		0x00000000
#define VIVI_PRIV_ROM_BASE	0x01FC0000
#endif /* CONFIG_MTD_CFI */
#ifdef CONFIG_S3C2440_NAND_BOOT
/* Flash */
#define FLASH_BASE		ROM_BASE0
#define FLASH_SIZE		SZ_32M
#define FLASH_UNCACHED_BASE	0x10000000	/* to mapping flash memory */
#define FLASH_BUSWIDTH		4
/* ROM */
#define VIVI_ROM_BASE		0x00000000
#define VIVI_PRIV_ROM_BASE	0x01FC0000
#endif /* CONFIG_S3C2440_NAND_BOOT */
#ifdef CONFIG_S3C2440_AMD_BOOT
/* Flash */
#define FLASH_BASE		ROM_BASE0
#define FLASH_SIZE		SZ_1M
#define FLASH_UNCACHED_BASE	0x10000000	/* to mapping flash memory */
#define FLASH_BUSWIDTH		2		/* 16-bit bus */
/* ROM */
#define VIVI_ROM_BASE		0x00000000
#define VIVI_PRIV_ROM_BASE	0x01FC0000
#endif /* CONFIG_S3C2440_AMD_BOOT */

#define DRAM_BASE		DRAM_BASE0
#define DRAM_SIZE		SZ_64M

#define MTD_PART_SIZE		SZ_16K
#define MTD_PART_OFFSET		0x00000000
#define PARAMETER_TLB_SIZE	SZ_16K
#define PARAMETER_TLB_OFFSET	0x00004000
#define LINUX_CMD_SIZE		SZ_16K
#define LINUX_CMD_OFFSET	0x00008000
#define VIVI_PRIV_SIZE		(MTD_PART_SIZE + PARAMETER_TLB_SIZE + LINUX_CMD_SIZE)



/* RAM */
#define	IRQ_STARTADDRESS 	0x33ffff00     
#define HEAP_END                IRQ_STARTADDRESS
#define HEAP_SIZE		SZ_1M
#define HEAP_BASE		(HEAP_END - HEAP_SIZE)
#define MMU_TABLE_SIZE		SZ_16K
#define MMU_TABLE_BASE		0x33ff8000
#define STACK_BASE		MMU_TABLE_BASE
#define STACK_SIZE		SZ_32K
#define RAM_SIZE		(STACK_BASE - DRAM_BASE-STACK_SIZE)
//#define TEST_RAM 	        (STACK_BASE-STACK_SIZE)
#define TEST_RAM 	         0x30000000 
#define RAM_BASE		DRAM_BASE

/*
 * Architecture magic and machine type
 */
#define MACH_TYPE		782	
#define ARCHITECTURE_MAGIC	((ARM_PLATFORM << 24) | (ARM_S3C2440_CPU << 16) | \
				  MACH_TYPE)

#define UART_BAUD_RATE		115200

#define FIN 	(12000000)
//#define FIN		(16934400)
// Main clock
#if FIN==12000000
//#define FCLK 304800000
//#define FCLK 300000000
	//#define FCLK 304800000
#define FCLK 400000000
	//#define FCLK 451200000
	//#define FCLK 532800000
	#if FCLK==271500000
	#define HCLK (FCLK/2)
	#define PCLK (HCLK/2)
	#elif FCLK==304800000
	#define HCLK (FCLK/3)
	#define PCLK (HCLK/2)
	#elif FCLK==300000000
	#define HCLK (FCLK/4)
	#define PCLK (HCLK/2)
	#elif FCLK==400000000
	#define HCLK (FCLK/4)
	#define PCLK (HCLK/2)
	#elif FCLK==451200000
	#define HCLK (FCLK/4)
	#define PCLK (HCLK/2)
	#elif FCLK==532800000
	#define HCLK (FCLK/4)
	#define PCLK (HCLK/2)
	#endif
#else	//FIN=16.9344MHz
#define FCLK 296352000
	#if FCLK==266716800
	#define HCLK (FCLK/2)
	#define PCLK (HCLK/2)
	#elif FCLK==296352000
	#define HCLK (FCLK/3)
	#define PCLK (HCLK/2)
	#elif FCLK==399651840
	#define HCLK (FCLK/3)
	#define PCLK (HCLK/2)
	#elif FCLK==530611200
	#define HCLK (FCLK/4)
	#define PCLK (HCLK/2)
	#elif FCLK==541900800
	#define HCLK (FCLK/4)
	#define PCLK (HCLK/2)
	#endif
#endif

/* CPU clcok */
/* 50.00 MHz */
#define MDIV_50			0x5c
#define PDIV_50			0x4
#define SDIV_50			0x2

/* 200.00 MHz */
#define MDIV_200		0x5c
#define PDIV_200		0x4
#define SDIV_200		0x0

/* 203.20 MHz */
#define MDIV_203		0xf6
#define PDIV_203		0xd
#define SDIV_203		0x0
#define CLKDVIN_203		0x3
#define PCLK_DIV_203		4
#define CPU_CLOCK_203 	       (/**/((MDIV_203 +8)*FIN)/((PDIV_203+2)*(1<<SDIV_203))/**/)
#define UART_PCLK_203 	      	50800000 
#define vREFRESH_203		0x008e04ed


/* 400.00 MHz */
#define MDIV_400_148		0x5c
#define PDIV_400_148		0x1
#define SDIV_400_148		0x0
#define CLKDVIN_400_148		0x5	/* 1:4:8 */
#define UART_PCLK_400_148    	50000000 
#define vREFRESH_400_148	0x008e04eb

/* 400.00 MHz */
#define MDIV_400		0x5c
#define PDIV_400		0x1
#define SDIV_400		0x0
#define CLKDVIN_400		0x7	/* 1:3:6 */
#define PCLK_DIV_400		0x6
/*
#define UART_PCLK_400 	    
((((MDIV_400 +8) *FIN )/((PDIV_400+2)*(1<<SDIV_400)))/PCLK_DIV_400)
*/
#define UART_PCLK_400 	   	66666000 
#define vREFRESH_400		0x008e045D

/* 410.00MHz */
#define MDIV_410		0xc5
#define PDIV_410		0x4
#define SDIV_410		0x0
#define CLKDVIN_410		0x5  /* 1:4:8 */
#define UART_PCLK_410	  	51250000	
#define vREFRESH_410		0x00aC04E1

/* 451.20MHz */
#define MDIV_451		0xb4
#define PDIV_451		0x3
#define SDIV_451		0x0
#define CLKDVIN_451		0x5  /* 1:4:8 */
#define UART_PCLK_451	  	56375000	
#define vREFRESH_451		0x00aC0491

/* 474   MHz */
#define MDIV_474		0x96
#define PDIV_474		0x2
#define SDIV_474		0x0
#define CLKDVIN_474		0x5  /* 1:4:8 */
#define PCLK_DIV_474		0x8
#define UART_PCLK_474	  	59000000	
#define vREFRESH_474		0x00aC0465

/* 508   MHz */
#define MDIV_508		0x77
#define PDIV_508		0x1
#define SDIV_508		0x0
#define CLKDVIN_508		0x5  /* 1:4:8 */
#define PCLK_DIV_508		0x8
#define UART_PCLK_508	  	63000000	
#define vREFRESH_508		0x00aC0423

/* 532.8 MHz */
#define MDIV_533		0xd6
#define PDIV_533		0x3
#define SDIV_533		0x0
#define CLKDVIN_533		0x5  /* 1:4:8 */
#define PCLK_DIV_533		0x8
#define UART_PCLK_533	  	67000000	
#define vREFRESH_533		0x00aC03F4



// laputa clock modify test only 031001 for s3c2440
/* 90MHz */
#define MDIV_090_112        0x57
#define PDIV_090_112        0x0a
#define SDIV_090_112        0x00
#define CLKDVIN_090_112     0x1 /* 1:1:2 */
#define UART_PCLK_090_112    45000000 
#define vREFRESH_090_112    0x008e04eb 

/* 100MHz */
#define MDIV_100_112        0x5c
#define PDIV_100_112        0x0a
#define SDIV_100_112        0x00
#define CLKDVIN_100_112     0x1 /* 1:1:2 */
#define UART_PCLK_100_112    50000000 
#define vREFRESH_100_112    0x008e04eb 

/* 103MHz */
#define MDIV_103_112        0x5f
#define PDIV_103_112        0x0a
#define SDIV_103_112        0x00
#define CLKDVIN_103_112     0x1 /* 1:1:2 */
#define UART_PCLK_103_112    50000000 
#define vREFRESH_103_112    0x008e04eb
 
/* 120-120-61MHz */
#define MDIV_120_112        0x70
#define PDIV_120_112        0x0a
#define SDIV_120_112        0x00
#define CLKDVIN_120_112     0x1 /* 1:1:2 */
#define UART_PCLK_120_112    60000000 
#define vREFRESH_120_112    0x008e04eb

/* 131-131-65.5MHz */
#define MDIV_131_112        0x7b
#define PDIV_131_112        0x0a
#define SDIV_131_112        0x00
#define CLKDVIN_131_112     0x1 /* 1:1:2 */
#define UART_PCLK_131_112    65500000 
#define vREFRESH_131_112    0x008e04eb

/* 133-133-66.5MHz */
#define MDIV_133_112        0x7d
#define PDIV_133_112        0x0a
#define SDIV_133_112        0x00
#define CLKDVIN_133_112     0x1 /* 1:1:2 */
#define UART_PCLK_133_112    66500000 
#define vREFRESH_133_112    0x008e04eb

/* 135-135-67.5MHz */
#define MDIV_135_112        0x7f
#define PDIV_135_112        0x0a
#define SDIV_135_112        0x00
#define CLKDVIN_135_112     0x1 /* 1:1:2 */
#define UART_PCLK_135_112    67500000 
#define vREFRESH_135_112    0x008e04eb

/* 137-137-68.5MHz */
#define MDIV_137_112        0x81
#define PDIV_137_112        0x0a
#define SDIV_137_112        0x00
#define CLKDVIN_137_112     0x1 /* 1:1:2 */
#define UART_PCLK_137_112    68500000 
#define vREFRESH_137_112    0x008e04eb


/* 200MHz - 100MHz */
#define MDIV_200_124        0x7e
#define PDIV_200_124        0x06
#define SDIV_200_124        0x00
#define CLKDVIN_200_124     0x3 /* 1:2:4 */
#define UART_PCLK_200_124    50000000 
#define vREFRESH_200_124    0x008e04eb 

/* 300MHz - 100MHz */
#define MDIV_300_136        0x75
#define PDIV_300_136        0x03
#define SDIV_300_136        0x00
#define CLKDVIN_300_136     0x7 /* 1:3:6 */
#define UART_PCLK_300_136    50000000 
#define vREFRESH_300_136    0x008e04eb 

/* 266MHz - 133MHz */
#define MDIV_266_124        0xaa
#define PDIV_266_124        0x06
#define SDIV_266_124        0x00
#define CLKDVIN_266_124     0x3 /* 1:2:4 */
#define UART_PCLK_266_124   66666666 
#define vREFRESH_266_124    0x008e04eb

/* 400MHz - 133MHz */
#define MDIV_400_136        0x5c
#define PDIV_400_136        0x01
#define SDIV_400_136        0x00
#define CLKDVIN_400_136     0x7 /* 1:3:6 */
#define UART_PCLK_400_136   66666666 
#define vREFRESH_400_136    0x008e04eb

/* 412MHz - 137MHz */
#define MDIV_412_136        0x5d
#define PDIV_412_136        0x01
#define SDIV_412_136        0x00
#define CLKDVIN_412_136     0x7 /* 1:3:6 */
#define UART_PCLK_412_136   68700000 
#define vREFRESH_412_136    0x008e04eb


/* 412MHz - 103MHz */
#define MDIV_412_148        0x5f
#define PDIV_412_148        0x01
#define SDIV_412_148        0x00
#define CLKDVIN_412_148     0x5 /* 1:4:8 */
#define UART_PCLK_412_148   51500000 
#define vREFRESH_412_148    0x008e04eb


/* 440MHz - 148MHz */
#define MDIV_440_148        0x66
#define PDIV_440_148        0x01
#define SDIV_440_148        0x00
#define CLKDVIN_440_148     0x5 /* 1:4:8 */
#define UART_PCLK_440_148   55000000 
#define vREFRESH_440_148    0x008e04eb


/* 474MHz - 148MHz */
#define MDIV_474_148        0x96
#define PDIV_474_148        0x02
#define SDIV_474_148        0x00
#define CLKDVIN_474_148     0x5 /* 1:4:8 */
#define UART_PCLK_474_148   59270000 
#define vREFRESH_474_148    0x008e04eb

/* 500MHz - 124MHz */
#define MDIV_500_148        0xc8
#define PDIV_500_148        0x03
#define SDIV_500_148        0x00
#define CLKDVIN_500_148     0x5 /* 1:4:8 */
#define UART_PCLK_500_148   62400000 
#define vREFRESH_500_148    0x008e04eb


/* 534 MHz */
#define MDIV_533_148        0x4e
#define PDIV_533_148        0x0
#define SDIV_533_148        0x0
#define CLKDVIN_533_148     0x5  /* 1:4:8 */
#define PCLK_DIV_533_148        0x8
#define UART_PCLK_533_148       66800000    
#define vREFRESH_533_148        0x00aC03F4


/* 528 MHz */
#define MDIV_528_148        0xd4
#define PDIV_528_148        0x3
#define SDIV_528_148        0x0
#define CLKDVIN_528_148     0x5  /* 1:4:8 */
#define UART_PCLK_528_148       66000000    
#define vREFRESH_528_148        0x00aC03F4

/* 542 MHz */
#define MDIV_542_148        0xda
#define PDIV_542_148        0x3
#define SDIV_542_148        0x0
#define CLKDVIN_542_148     0x5  /* 1:4:8 */
#define UART_PCLK_542_148       67800000    
#define vREFRESH_542_148        0x00aC03F4

// 031202 recommand freq for sound 44100Hz
/* 203 MHz */
#define MDIV_203_148        0x7f
#define PDIV_203_148        0x02
#define SDIV_203_148        0x01
#define CLKDVIN_203_148     0x3  /* 1:2:4 */
#define UART_PCLK_203_148       50800000    
#define vREFRESH_203_148        0x00aC03F4
/* 304 MHz */
#define MDIV_304_136        0x90
#define PDIV_304_136        0x04
#define SDIV_304_136        0x00
#define CLKDVIN_304_136     0x7  /* 1:3:6 */
#define UART_PCLK_304_136       50700000    
#define vREFRESH_304_136        0x00aC03F4
/* 304d MHz */
#define MDIV_304_136d        0x90
#define PDIV_304_136d        0x01
#define SDIV_304_136d        0x01
#define CLKDVIN_304_136d     0x7  /* 1:3:6 */
#define UART_PCLK_304_136d       50700000    
#define vREFRESH_304_136d        0x00aC03F4
/* 406 MHz */
#define MDIV_406_136        0xc3
#define PDIV_406_136        0x04
#define SDIV_406_136        0x0
#define CLKDVIN_406_136     0x7  /* 1:3:6 */
#define UART_PCLK_406_136       67700000    
#define vREFRESH_406_136        0x00aC03F4
/* 406d MHz */
#define MDIV_406_136d        0x7f
#define PDIV_406_136d        0x02
#define SDIV_406_136d        0x01
#define CLKDVIN_406_136d     0x7  /* 1:3:6 */
#define UART_PCLK_406_136d       67500000    
#define vREFRESH_406_136d        0x00aC03F4
/* 540 MHz */
#define MDIV_540_148        0xac
#define PDIV_540_148        0x2
#define SDIV_540_148        0x0
#define CLKDVIN_540_148     0x5  /* 1:4:8 */
#define UART_PCLK_540_148       67500000    
#define vREFRESH_540_148        0x00aC03F4
//031202 end of recommand
// laputa modify end



/*** Change only This Value ******************/
#if 0
#define UART_PCLK		UART_PCLK_400
#define vMPLLCON_NOW	 	((MDIV_400 << 12) | (PDIV_400 << 4) | (SDIV_400)) 
#define vCLKDIVN_NOW		CLKDVIN_400
#define vREFRESH		vREFRESH_400
#else
#define UART_PCLK           UART_PCLK_400_148
#define vMPLLCON_NOW_USER ((MDIV_400_148 << 12) | (PDIV_400_148 << 4) | (SDIV_400_148))
#define vCLKDIVN_NOW        CLKDVIN_400_148
#define vREFRESH            vREFRESH_400_148
#endif

/* initial values for DRAM */
#define vBWSCON			0x22111110
#define vBANKCON0		0x00000700
#define vBANKCON1		0x00000700
#define vBANKCON2		0x00000700
#define vBANKCON3		0x00000700
#define vBANKCON4		0x00000700
#define vBANKCON5		0x00000700
#define vBANKCON6		0x00018009
#define vBANKCON7		0x00018009

#define vBANKSIZE		0xB2
#define vMRSRB6			0x30
#define vMRSRB7			0x30

#define vLOCKTIME		0x00ffffff	/* It's a default value */
#define vCLKCON			0x0000fff8	/* It's a default value */

#define AC_PCMDATA		0x5b000018      //modify
#define AC_MICDATA		0x5b00001C


/* initial values for serial */
#define vULCON			0x3	/* UART, no parity, one stop bit, 8 bits */
#define vUCON			0x245
#define vUFCON			0x0
#define vUMCON			0x0

/* inital values for GPIOs */
#define vGPACON			0x007fffff
#define vGPBCON			0x00044555
#define vGPBUP			0x000007ff
#define vGPCCON			0xaaaaaaaa
#define vGPCUP			0x0000ffff
#define vGPDCON			0xaaaaaaaa
#define vGPDUP			0x0000ffff
#define vGPECON			0xaaaaaaaa
#define vGPEUP			0x0000ffff
#define vGPFCON			0x000055aa
#define vGPFUP			0x000000ff
#define vGPGCON			0xff95ffba
#define vGPGUP			0x0000ffff
//#define vGPHCON			0x00aaaa
#define vGPHCON			0x0016faaa
#define vGPHUP			0x000007ff
#define vEXTINT0		0x22222222
#define vEXTINT1		0x22222222
#define vEXTINT2		0x22222222
#endif
