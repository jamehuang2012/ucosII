@****************************************************************
@ NAME: 2440INIT.S
@ DESC: C start up codes
@       Configure memory, ISR ,stacks
@	Initialize C-variables
@ HISTORY:
@ 2002.02.25:kwtark: ver 0.0
@ 2002.03.20:purnnamu: Add some functions for testing STOP,Sleep mode
@ 2003.03.14:DonGo: Modified for 2440.
@ 2008.03.28:sjj0412:Modified for 2440ucos
@ 2013.05.04:shichaoxu:Modified for gun-mini2440
@****************************************************************

#include "s3c2440s.h"

	.extern  OS_CPU_IRQ_ISR @uCOS_II IrqISR
	.extern nand_read_ll
	.global _start 
	.global PrintChar
	.global LedControl
_start:

@****************************************************************
@1)The code, which converts to Big-endian, should be in little endian code.
@2)The following little endian code will be compiled in Big-Endian mode.
@  The code byte order should be changed as the memory bus width.
@3)The pseudo instruction,DCD can not be used here because the linker generates error.
@****************************************************************

	b	ResetHandler
	b	.	@handler for Undefined mode
	b	.	    @handler for SWI interrupt
	b	.	@handler for PAbort
	b	.	@handler for DAbort
	b	.		        @reserved
	b      OS_CPU_IRQ_ISR 	@handler for IRQ interrupt
	b	.	@handler for FIQ interrupt
@ 0x20: magic number so we can verify that we only put
	.long   0
@ 0x24:
	.long   0
@ 0x28: 
	.long  _start 
@ 0x2C: this contains the platform, cpu and machine id
	.long   2440
@ 0x30: capabilities
	.long   0
@ 0x34:
	b   	.

@****************************************************************
@ intvector setup with macro
@****************************************************************

HandleFIQ:
	ldr pc,=main
HandleIRQ:
	ldr pc,=main
HandleUndef:
         b     .
HandleSWI:
	ldr pc,=main
HandleDabort:
	ldr pc,=main
HandlePabort:
	ldr pc,=main

@****************************************************************
@             ResetHandler fuction
@****************************************************************

ResetHandler:
       	@ disable watch dog timer
	mov	r1, #0x53000000
	mov	r2, #0x0
	str	r2, [r1]

	@ disable all interrupts
	mov	r1, #INT_CTL_BASE
	mov	r2, #0xffffffff
	str	r2, [r1, #oINTMSK]
	ldr	r2, =0x7ff
	str	r2, [r1, #oINTSUBMSK]

	@ initialise system clocks
	mov	r1, #CLK_CTL_BASE
	mvn	r2, #0xff000000
	str	r2, [r1, #oLOCKTIME]

	mov	r1, #CLK_CTL_BASE
	ldr	r2, clkdivn_value
	str	r2, [r1, #oCLKDIVN]

	mrc	p15, 0, r1, c1, c0, 0		@ read ctrl register
	orr	r1, r1, #0xc0000000		@ Asynchronous
	mcr	p15, 0, r1, c1, c0, 0		@ write ctrl register

	mov	r1, #CLK_CTL_BASE
	@ldr	r2, mpll_value			@ clock default
	ldr 	r2, =0x5c011			@mpll_value_USER 	@ clock user set
	str	r2, [r1, #oMPLLCON]
	bl	memsetup

	@ LED initial
	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_B
	ldr	r2,=0x00555555
	str	r2, [r1, #oGPIO_CON]
	ldr     r2,=0x01ff
	str	r2, [r1, #oGPIO_UP]
	mov 	r0,#1
	bl  	LedControl
#if 0
	@ SVC
	mrs	r0, cpsr
	bic	r0, r0, #0xdf
	orr	r1, r0, #0xd3
	msr	cpsr_all, r1
#endif
	@ set GPIO for UART
	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_H
	ldr	r2, gpio_con_uart
	str	r2, [r1, #oGPIO_CON]
	ldr	r2, gpio_up_uart
	str	r2, [r1, #oGPIO_UP]
	mov 	r0,#2
	bl   	LedControl
	bl	InitUART

@#ifdef  CONFIG_DEBUG_LL
#if 1
	@ Print current Program Counter
	ldr	r1, SerBase
	mov	r0, #'\r'
	bl	PrintChar
	mov	r0, #'\n'
	bl	PrintChar
	mov	r0, #'@'
	bl	PrintChar
@	mov	r0, pc
@	bl	PrintHexWord
	mov	r0, #'@'
	bl	PrintChar
#endif
	mov 	r0,#2
	bl   	LedControl

@	bl	copy_myself

#if 1
	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_F
	mov	r2, #0x00
	str	r2, [r1, #oGPIO_DAT]
#endif

	bl 	IrqSetup
	bl 	InitStacks
	mov 	r0,#5
	bl   	LedControl
	ldr 	r0,=0x30100000
	ldr 	r1,=0x34000000
@	bl      mem_clear
	bl	main			@ call main
	b 	.

@****************************************************************
@ control led
@ r0 =
@****************************************************************

LedControl:
	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_B
	mov	r0, r0,LSL#5
	@mov 	r0, 0x60
	str	r0, [r1, #oGPIO_DAT]
	mov 	pc,lr
@****************************************************************
@ Initialize UART
@ r0 = number of UART port
@****************************************************************

IrqSetup:
	ldr	r0,=HandleIRQ       @This routine is needed
	ldr	r1, =OS_CPU_IRQ_ISR @modify by txf, for ucos
	str	r1,[r0]
	mov 	pc,lr

@****************************************************************
@ Initialize UART
@ r0 = number of UART port
@****************************************************************

InitUART:
	ldr	r1, SerBase
	mov	r2, #0x0
	str	r2, [r1, #oUFCON]
	str	r2, [r1, #oUMCON]
	mov	r2, #0x3
	str	r2, [r1, #oULCON]
	ldr	r2, =0x245
	str	r2, [r1, #oUCON]
#define UART_BRD ((UART_PCLK  / (UART_BAUD_RATE * 16)) - 1)
	mov	r2, #UART_BRD
	str	r2, [r1, #oUBRDIV]

	mov	r3, #100
	mov	r2, #0x0
1:	sub	r3, r3, #0x1
	tst	r2, r3
	bne	1b

#if 0
	mov	r2, #'U'
	str	r2, [r1, #oUTXHL]

1:	ldr	r3, [r1, #oUTRSTAT]
	and	r3, r3, #UTRSTAT_TX_EMPTY
	tst	r3, #UTRSTAT_TX_EMPTY
	bne	1b

	mov	r2, #'0'
	str	r2, [r1, #oUTXHL]

1:	ldr	r3, [r1, #oUTRSTAT]
	and	r3, r3, #UTRSTAT_TX_EMPTY
	tst	r3, #UTRSTAT_TX_EMPTY
	bne	1b
#endif

	mov	pc, lr

@****************************************************************
@ PrintFaultAddr: Print falut address
@ r12: contains address of instruction + 4
@****************************************************************

PrintFaultAddr:
	mov	r0, r12			@ Print address of instruction + 4
	ldr	r1, SerBase
	bl	PrintHexWord
	mrc	p15, 0, r0, c6, c0, 0	@ Read fault virtual address
	ldr	r1, SerBase
	bl	PrintHexWord
	mov	pc, lr

@***************************************************************
@ PrintHexNibble : prints the least-significant nibble in R0 as a
@ hex digit
@   r0 contains nibble to write as Hex
@   r1 contains base of serial port
@   writes ro with XXX, modifies r0,r1,r2
@   TODO : write ro with XXX reg to error handling
@   Falls through to PrintChar
@****************************************************************

PrintHexNibble:
	ldr	r2, =HEX_TO_ASCII_TABLE
	and	r0, r0, #0xF
	ldr	r0, [r2, r0]	@ convert to ascii
	b	PrintChar

@***************************************************************
@ PrintChar : prints the character in R0
@   r0 contains the character
@   r1 contains base of serial port
@   writes ro with XXX, modifies r0,r1,r2
@   TODO : write ro with XXX reg to error handling
@***************************************************************

PrintChar:
TXBusy:
	ldr	r2, [r1, #oUTRSTAT]
	and	r2, r2, #UTRSTAT_TX_EMPTY
	tst	r2, #UTRSTAT_TX_EMPTY
	beq	TXBusy
	str	r0, [r1, #oUTXHL]
	mov	pc, lr

@***************************************************************
@ PrintWord : prints the 4 characters in R0
@   r0 contains the binary word
@   r1 contains the base of the serial port
@   writes ro with XXX, modifies r0,r1,r2
@   TODO : write ro with XXX reg to error handling
@***************************************************************

PrintWord:
	mov	r3, r0
	mov	r4, lr
	bl	PrintChar

	mov	r0, r3, LSR #8		/* shift word right 8 bits */
	bl	PrintChar

	mov	r0, r3, LSR #16		/* shift word right 16 bits */
	bl	PrintChar

	mov	r0, r3, LSR #24		/* shift word right 24 bits */
	bl	PrintChar

	mov	r0, #'\r'
	bl	PrintChar

	mov	r0, #'\n'
	bl	PrintChar

	mov	pc, r4

@***************************************************************
@ PrintHexWord : prints the 4 bytes in R0 as 8 hex ascii characters
@   followed by a newline
@   r0 contains the binary word
@   r1 contains the base of the serial port
@   writes ro with XXX, modifies r0,r1,r2
@   TODO : write ro with XXX reg to error handling
@***************************************************************

PrintHexWord:
	mov	r4, lr
	mov	r3, r0
	mov	r0, r3, LSR #28
	bl	PrintHexNibble
	mov	r0, r3, LSR #24
	bl	PrintHexNibble
	mov	r0, r3, LSR #20
	bl	PrintHexNibble
	mov	r0, r3, LSR #16
	bl	PrintHexNibble
	mov	r0, r3, LSR #12
	bl	PrintHexNibble
	mov	r0, r3, LSR #8
	bl	PrintHexNibble
	mov	r0, r3, LSR #4
	bl	PrintHexNibble
	mov	r0, r3
	bl	PrintHexNibble
	mov	r0, #'\r'
	bl	PrintChar
	mov	r0, #'\n'
	bl	PrintChar
	mov	pc, r4

@***************************************************************
@ initialise the static memory
@ set memory control registers
@***************************************************************

memsetup:
	mov	r1, #MEM_CTL_BASE
	adrl	r2, mem_cfg_val
	add	r3, r1, #52
1:	ldr	r4, [r2], #4
	str	r4, [r1], #4
	cmp	r1, r3
	bne	1b
	mov	pc, lr

@***************************************************************
@ clear memory
@ r0: start address
@ r1: length
@***************************************************************

mem_clear:
	mov r2,#0
1:	str r2,[r0],#4
	cmp r0,r1
	bne 1b
	mov pc,lr

@***************************************************************
@                       堆栈初始化
@***************************************************************

InitStacks:
    	mov r2,lr
	mrs	r0,cpsr
	bic	r0,r0,#MODEMASK
	orr	r1,r0,#UNDEFMODE|NOINT
	msr	cpsr_cxsf,r1		@UndefMode
	ldr	sp,=UndefStack		@ UndefStack=0x33FF_5C00

	orr	r1,r0,#ABORTMODE|NOINT
	msr	cpsr_cxsf,r1		@AbortMode
	ldr	sp,=AbortStack		@ AbortStack=0x33FF_6000

	orr	r1,r0,#IRQMODE|NOINT
	msr	cpsr_cxsf,r1		@IRQMode
	ldr	sp,=IRQStack		@ IRQStack=0x33FF_7000

	orr	r1,r0,#FIQMODE|NOINT
	msr	cpsr_cxsf,r1		@FIQMode
	ldr	sp,=FIQStack		@ FIQStack=0x33FF_8000

	bic	r0,r0,#MODEMASK|NOINT
	orr	r0,r0,#0xc0		@ we don't allow int,fast int here!!!
	orr	r1,r0,#SVCMODE
	msr	cpsr_cxsf,r1		@SVCMode
	ldr	sp,=SVCStack		@ SVCStack=0x33FF_5800
	mov	pc,r2
@***************************************************************
@                      copyself
@***************************************************************


copy_myself:
	mov	r10, lr
	@ reset NAND
	mov	r1, #NAND_CTL_BASE
	ldr	r2, =( (7<<12)|(7<<8)|(7<<4)|(0<<0) )
	str	r2, [r1, #oNFCONF]
	ldr	r2, [r1, #oNFCONF]

	ldr	r2, =( (1<<4)|(0<<1)|(1<<0) ) @ Active low CE Control
	str	r2, [r1, #oNFCONT]
	ldr	r2, [r1, #oNFCONT]

	ldr	r2, =(0x6)		@ RnB Clear
	str	r2, [r1, #oNFSTAT]
	ldr	r2, [r1, #oNFSTAT]

	mov	r2, #0xff		@ RESET command
	strb	r2, [r1, #oNFCMD]
	mov	r3, #0			@ wait
1:	add	r3, r3, #0x1
	cmp	r3, #0xa
	blt	1b
2:	ldr	r2, [r1, #oNFSTAT]	@ wait ready
	tst	r2, #0x4
	beq	2b

	ldr	r2, [r1, #oNFCONT]
	orr	r2, r2, #0x2		@ Flash Memory Chip Disable
	str	r2, [r1, #oNFCONT]

	@ get read to call C functions (for nand_read())
	ldr	sp, DW_STACK_START	@ setup stack pointer
	mov	fp, #0			@ no previous frame, so fp=0

	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_F
	mov	r2, #0xe0
	str	r2, [r1, #oGPIO_DAT]


	@ copy ucos to RAM
	ldr	r0, =TEST_RAM
	mov     r1, #0x0
	mov	r2, #0x100000
	@bl	nand_read_ll

#if 1
	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_F
	mov	r2, #0xb0
	str	r2, [r1, #oGPIO_DAT]
#endif


	tst	r0, #0x0
	beq	ok_nand_read
#ifdef CONFIG_DEBUG_LL
bad_nand_read:
	ldr	r0, STR_FAIL
	ldr	r1, SerBase
	bl	PrintWord
1:	b	1b		@ infinite loop
#endif

ok_nand_read:
	@ verify
	mov	r0, #0
	ldr	r1, =TEST_RAM
	mov	r2, #0x200	@ 4 bytes * 1024 = 4K-bytes
go_next:
	ldr	r3, [r0], #4
	ldr	r4, [r1], #4
	teq	r3, r4
	bne	notmatch
	subs	r2, r2, #4
	beq	done_nand_read
	bne	go_next
notmatch:
#ifdef CONFIG_DEBUG_LL
@	sub	r0, r0, #4
@	ldr	r1, SerBase
@	bl	PrintHexWord
@	ldr	r0, STR_FAIL
@	ldr	r1, SerBase
@	bl	PrintWord
#endif
1:	b	1b
done_nand_read:

#ifdef CONFIG_DEBUG_LL
	ldr	r0, STR_OK
	ldr	r1, SerBase
	bl	PrintWord
#endif

#if 1
	mov	r1, #GPIO_CTL_BASE
	add	r1, r1, #oGPIO_F
	mov	r2, #0x70
	str	r2, [r1, #oGPIO_DAT]
#endif

	mov	pc, r10


@***************************************************************
@ Data Area
@ Memory configuration values
@***************************************************************

.align 4
mem_cfg_val:
	.long	vBWSCON
	.long	vBANKCON0
	.long	vBANKCON1
	.long	vBANKCON2
	.long	vBANKCON3
	.long	vBANKCON4
	.long	vBANKCON5
	.long	vBANKCON6
	.long	vBANKCON7
	.long	vREFRESH
	.long	vBANKSIZE
	.long	vMRSRB6
	.long	vMRSRB7


@ Processor clock values
.align 4
clock_locktime:
	.long	vLOCKTIME
@mpll_value:
@	.long	vMPLLCON_NOW
mpll_value_USER:
	.long   vMPLLCON_NOW_USER
clkdivn_value:
	.long	vCLKDIVN_NOW

@ initial values for serial
uart_ulcon:
	.long	vULCON
uart_ucon:
	.long	vUCON
uart_ufcon:
	.long	vUFCON
uart_umcon:
	.long	vUMCON
@ inital values for GPIO
gpio_con_uart:
	.long	vGPHCON
gpio_up_uart:
	.long	vGPHUP

	.align	2
DW_STACK_START:
 .word	STACK_BASE-4
	.align	2
HEX_TO_ASCII_TABLE:
	.ascii	"0123456789ABCDEF"
STR_STACK:
	.ascii	"STKP"
STR_UNDEF:
	.ascii	"UNDF"
STR_SWI:
	.ascii	"SWI "
STR_PREFETCH_ABORT:
	.ascii	"PABT"
STR_DATA_ABORT:
	.ascii	"DABT"
STR_IRQ:
	.ascii	"IRQ "
STR_FIQ:
	.ascii	"FIQ"
STR_NOT_USED:
	.ascii	"NUSD"
	.align 2
STR_OK:
	.ascii	"OK  "
STR_FAIL:
	.ascii	"FAIL"
STR_CR:
	.ascii  "\r\n"

.align 4
SerBase:
#if defined(CONFIG_SERIAL_UART0)
	.long UART0_CTL_BASE
#elif defined(CONFIG_SERIAL_UART1)
	.long UART1_CTL_BASE
#elif defined(CONFIG_SERIAL_UART2)
	.long UART2_CTL_BASE
#else
#error not defined base address of serial
#endif

#ifdef CONFIG_PM
.align 4
PMCTL0_ADDR:
	.long 0x4c00000c
PMCTL1_ADDR:
	.long 0x56000080
PMST_ADDR:
	.long 0x560000B4
PMSR0_ADDR:
	.long 0x560000B8
REFR_ADDR:
	.long 0x48000024
#endif
