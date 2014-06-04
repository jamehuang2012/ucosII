 .equ SRCPND ,  0x4a000000    @ Source pending
 .equ INTPND ,  0x4a000010    @ Interrupt rest status
 .equ rEINTPEND ,    0x560000a8
 .equ INTOFFSET  ,   0x4a000014
 .equ USERMODE     , 	0x10
 .equ FIQMODE      ,	0x11
 .equ IRQMODE      ,	0x12
 .equ SVCMODE      ,	0x13
 .equ ABORTMODE    ,	0x17
 .equ UNDEFMODE    ,	0x1b
 .equ MODEMASK     ,	0x1f
 .equ NOINT        ,	0xc0
 .equ IRQ_STARTADDRESS,  0x33ffff00
	.extern  OSRunning
	.extern  OSTCBCur
	.extern  OSTCBHighRdy
	.extern  OSPrioCur
	.extern  OSPrioHighRdy
	.extern  OSIntNesting
	.extern LedControl

	.extern  OSIntEnter
	.extern  OSIntExit
	.extern  OSTaskSwHook
	.extern  OSTimeTick


	.global  OSStartHighRdy
	.global  OSCtxSw
	.global  OSTickISR
	.global  OSIntCtxSw

	.global  OSCPUSaveSR
	.global  OSCPURestoreSR

	.global  OS_CPU_IRQ_ISR



OSStartHighRdy:

	MSR     CPSR_cxsf,#SVCMODE|NOINT     @Switch to SVC mode with IRQ&FIQ disable

	@BL		OSTaskSwHook            @Call user define Task switch hook

	LDR		R0, =OSRunning          @ OSRunning =TRUE
	MOV		R1, #1
	STRB 	R1, [R0]

	@----------------------------------------------------------------------------------
	@ 		SP = OSTCBHighRdy->OSTCBStkPtr@
	@----------------------------------------------------------------------------------
	LDR 	R0, =OSTCBHighRdy
	LDR 	R0, [R0]
	LDR 	SP, [R0]

	@----------------------------------------------------------------------------------
	LDMFD 	SP!, {R0}
	MSR 	SPSR_cxsf, R0
	LDMFD 	SP!, {R0-R12, LR, PC}^

OSCtxSw:

	STMFD	SP!, {LR}           @PC
	STMFD	SP!, {R0-R12, LR}   @R0-R12 LR
	MRS		R0,  CPSR       @Push CPSR
	STMFD	SP!, {R0}

	@----------------------------------------------------------------------------------
	@ 		OSTCBCur->OSTCBStkPtr = SP
	@----------------------------------------------------------------------------------
	LDR		R0, =OSTCBCur
	LDR		R0, [R0]
	STR		SP, [R0]

	@----------------------------------------------------------------------------------
	@ OSTaskSwHook()@
	@---------------------------------------------------------------------------------
	@BL 		OSTaskSwHook

	@----------------------------------------------------------------------------------
	@ OSTCBCur = OSTCBHighRdy@
	@----------------------------------------------------------------------------------
	LDR		R0, =OSTCBHighRdy
	LDR		R1, =OSTCBCur
	LDR		R0, [R0]
	STR		R0, [R1]

	@----------------------------------------------------------------------------------
	@ OSPrioCur = OSPrioHighRdy@
	@----------------------------------------------------------------------------------
	LDR		R0, =OSPrioHighRdy
	LDR		R1, =OSPrioCur
	LDRB	R0, [R0]
	STRB	R0, [R1]

	@----------------------------------------------------------------------------------
	@  OSTCBHighRdy->OSTCBStkPtr@
	@----------------------------------------------------------------------------------
	LDR		R0, =OSTCBHighRdy
	LDR		R0, [R0]
	LDR		SP, [R0]

	@----------------------------------------------------------------------------------
	@Restore New task context
	@----------------------------------------------------------------------------------
	LDMFD 	SP!, {R0}		@POP CPSR
	MSR 	SPSR_cxsf, R0
	LDMFD   SP!, {R0-R12, LR, PC}^
OSTickISR:
	MOV     R5,LR
	MOV 	R1, #1
	MOV	R1, R1, LSL #10		@ Timer0 Source Pending Reg.
	LDR 	R0, =SRCPND
	LDR     R2, [R0]
	ORR     R2, R1,R2
	STR 	R2, [R0]

	LDR	R0, =INTPND
	LDR	R2, [R0]
	ORR     R2, R1,R2
	STR	R2, [R0]

	@----------------------------------------------------------------------------------
	@ OSTimeTick()@
	@----------------------------------------------------------------------------------
	BL	OSTimeTick
	MOV    	PC, R5


OSIntCtxSw:
	@----------------------------------------------------------------------------------
	@ Call OSTaskSwHook)(
	@----------------------------------------------------------------------------------
	@BL 		OSTaskSwHook

	@----------------------------------------------------------------------------------
	@ OSTCBCur = OSTCBHighRdy@
	@----------------------------------------------------------------------------------
	LDR		R0, =OSTCBHighRdy
	LDR		R1, =OSTCBCur
	LDR		R0, [R0]
	STR		R0, [R1]

	@----------------------------------------------------------------------------------
	@ OSPrioCur = OSPrioHighRdy@
	@----------------------------------------------------------------------------------
	LDR		R0, =OSPrioHighRdy
	LDR		R1, =OSPrioCur
	LDRB	R0, [R0]
	STRB	R0, [R1]

	@----------------------------------------------------------------------------------
	@ 		SP = OSTCBHighRdy->OSTCBStkPtr@
	@----------------------------------------------------------------------------------
	LDR		R0, =OSTCBHighRdy
	LDR		R0, [R0]
	LDR		SP, [R0]

	@----------------------------------------------------------------------------------
	@ Restore New Task context
	@----------------------------------------------------------------------------------
	LDMFD 	SP!, {R0}              @POP CPSR
	MSR 	SPSR_cxsf, R0
	LDMFD 	SP!, {R0-R12, LR, PC}^

OS_CPU_IRQ_ISR:

	STMFD   SP!, {R1-R3}			@ We will use R1-R3 as temporary registers
	MOV     R1, SP
	ADD     SP, SP, #12             @Adjust IRQ stack pointer
	SUB     R2, LR, #4              @Adjust PC for return address to task

	MRS     R3, SPSR				@ Copy SPSR (Task CPSR)

	MSR     CPSR_cxsf, #SVCMODE|NOINT  @ to SVC mode

	STMFD   SP!, {R2}				@ Push task''s PC
	STMFD   SP!, {R4-R12, LR}		@ Push task''s LR,R12-R4

	LDMFD   R1!, {R4-R6}			@ Load Task''s R1-R3 from IRQ stack
	STMFD   SP!, {R4-R6}			@ Push Task''s R1-R3 to SVC stack
	STMFD   SP!, {R0}			    @ Push Task''s R0 to SVC stack

	STMFD   SP!, {R3}				@ Push task''s CPSR
	LDR     R0,=OSIntNesting        @OSIntNesting++
	LDRB    R1,[R0]
	ADD     R1,R1,#1
	STRB    R1,[R0]

	CMP     R1,#1                   @if(OSIntNesting==1){
	BNE     1f

	LDR     R4,=OSTCBCur            @OSTCBHighRdy->OSTCBStkPtr=SP@
	LDR     R5,[R4]
 	STR     SP,[R5]  
1:
	MSR    CPSR_c,#IRQMODE|NOINT   @ tox use IRQ stack to handle interrupt
	LDR     R0, =INTOFFSET
        LDR     R0, [R0]
	CMP	R0, #0xa
	BNE	2f
	
   	LDR     R1, =IRQ_STARTADDRESS
	MOV     LR, PC
        LDR     PC, [R1, R0, LSL #2]

2:
	LDR     R0, =INTOFFSET
        LDR     R0, [R0]
	MOV     R1, #1
	MOV     R1, R1, LSL R0
	LDR     R0, =SRCPND				
	STR     R1, [R0]
	LDR     R0, =INTPND	
	STR     R1, [R0]	
	
	MSR		CPSR_c,#SVCMODE|NOINT
    	BL 		OSIntExit

    	LDMFD   SP!,{R4}
    	MSR	     SPSR_cxsf,R4
    	LDMFD   SP!,{R0-R12,LR,PC}^	   @POP new Task''s context

OSCPUSaveSR:
	MRS     R0, CPSR				@ Set IRQ and FIable all interrupts
	ORR     R1, R0, #0xC0
	MSR     CPSR_c, R1
	MRS     R1, CPSR				@ Confirm that Cpt disable flags
	AND     R1, R1, #0xC0
	CMP     R1, #0xC0
	BNE     OSCPUSaveSR				@ Not properly dsabled (try again)
	MOV     PC, LR					@ Disabled, return thcontents in R0

OSCPURestoreSR:
	MSR     CPSR_c, R0
	MOV     PC, LR
