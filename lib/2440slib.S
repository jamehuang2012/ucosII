@**************************************************************
@ File Name : 2440slib.s
@ Function  : S3C2440  (Assembly)
@ Date      : March 09, 2002
@ Revision	: Programming start (February 26,2002) -> SOP
@ Revision	: 03.11.2003 ver 0.0	Attatched for 2440
@**************************************************************

#include "s3c2440s.h"

@**************************************************************
@Workaround of problem between LCD and Framebuffer
@**************************************************************
	.global	SDRAMtest
SDRAMtest:
    ldr r0,=0x31000000
   	ldr r1,=0x80000
   	mov r2,#0xf000000f
LB2:
	str r2,[r0],#4
	str r2,[r0],#4
   	subs r1,r1,#4
   	bne LB2
   	mov pc,lr


@**************************************************************
@ CPSR I,F bit
@This function works only if the processor is in previliged mode.
@int SET_IF(void)@
@The return value is current CPSR.
@**************************************************************
	.global	SET_IF
SET_IF:
	mrs r0,cpsr
	mov r1,r0
	orr r1,r1,#NOINT
	msr cpsr_cxsf,r1
	mov pc ,lr

@**************************************************************
@void WR_IF(int cpsrValue)@
@This function works only if the processor is in previliged mode.
@**************************************************************
   .global WR_IF
WR_IF:
 	 msr cpsr_cxsf,r0
	 mov pc ,lr


@**************************************************************
@void CLR_IF(void)@
@This function works only if the processor is in previliged mode.
@**************************************************************
   .global  CLR_IF
CLR_IF:
   mrs r0,cpsr
   bic r0,r0,#NOINT
   msr cpsr_cxsf,r0
   mov pc ,lr

@**************************************************************
@ MMU Cache/TLB/etc on/off functions
@**************************************************************
.equ 	R1_I	,	1<<12
.equ 	R1_C	,	1<<2
.equ 	R1_A	,	1<<1
.equ 	R1_M    ,	1
@.equ 	R1_iA	,  	1<<31
@.equ 	R1_nF 	, 	1<<30
.equ 	BUS_M, 	3<<30
@**************************************************************
@void MMU_EnableICache(void)
@**************************************************************
   .global MMU_EnableICache
MMU_EnableICache:
   mrc p15,0,r0,c1,c0,0
   orr r0,r0,#R1_I
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_DisableICache(void)
@**************************************************************
   .global MMU_DisableICache
MMU_DisableICache:
   mrc p15,0,r0,c1,c0,0
   bic r0,r0,#R1_I
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_EnableDCache(void)
@**************************************************************
   .global MMU_EnableDCache
MMU_EnableDCache:
   mrc p15,0,r0,c1,c0,0
   orr r0,r0,#R1_C
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_DisableDCache(void)
@**************************************************************
   .global MMU_DisableDCache
MMU_DisableDCache:
   mrc p15,0,r0,c1,c0,0
   bic r0,r0,#R1_C
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_EnableAlignFault(void)
@**************************************************************
   .global MMU_EnableAlignFault
MMU_EnableAlignFault:
   mrc p15,0,r0,c1,c0,0
   orr r0,r0,#R1_A
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_DisableAlignFault(void)
@**************************************************************
   .global MMU_DisableAlignFault
MMU_DisableAlignFault:
   mrc p15,0,r0,c1,c0,0
   bic r0,r0,#R1_A
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_EnableMMU(void)
@**************************************************************
   .global MMU_EnableMMU
MMU_EnableMMU:
   mrc p15,0,r0,c1,c0,0
   orr r0,r0,#R1_M
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_DisableMMU(void)
@**************************************************************
   .global MMU_DisableMMU
MMU_DisableMMU:
   mrc p15,0,r0,c1,c0,0
   bic r0,r0,#R1_M
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_SetFastBusMode(void)
@ FCLK:HCLK= 1:1
@**************************************************************
  .global MMU_SetFastBusMode
MMU_SetFastBusMode:
   mrc p15,0,r0,c1,c0,0
   bic r0,r0,#BUS_M     @modify #R1_iA:OR:R1_nF
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_SetAsyncBusMode(void)
@ FCLK:HCLK= 1:2
@**************************************************************
   .global MMU_SetAsyncBusMode
MMU_SetAsyncBusMode:
   mrc p15,0,r0,c1,c0,0
   orr r0,r0,#BUS_M    @R1_nF :OR: R1_iA
   mcr p15,0,r0,c1,c0,0
   mov pc ,lr

@**************************************************************
@ Set TTBase
@ ro=TTBase
@void MMU_SetTTBase(int base)
@**************************************************************
   .global MMU_SetTTBase
MMU_SetTTBase:
   mcr p15,0,r0,c2,c0,0
   mov pc ,lr

@**************************************************************
@ Set Domain
@void MMU_SetDomain(int domain)
@ro=domain
@**************************************************************
   .global MMU_SetDomain
MMU_SetDomain:
   mcr p15,0,r0,c3,c0,0
   mov pc ,lr

@**************************************************************
@ ICache/DCache functions
@void MMU_InvalidateIDCache(void)
@**************************************************************
   .global MMU_InvalidateIDCache
MMU_InvalidateIDCache:
   mcr p15,0,r0,c7,c7,0
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateICache(void)
@**************************************************************
   .global MMU_InvalidateICache
MMU_InvalidateICache:
   mcr p15,0,r0,c7,c5,0
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateICacheMVA(U32 mva)
@r0=mva
@**************************************************************
   .global MMU_InvalidateICacheMVA
MMU_InvalidateICacheMVA:
   mcr p15,0,r0,c7,c5,1
   mov pc ,lr

@**************************************************************
@void MMU_PrefetchICacheMVA(U32 mva)
@r0=mva
@**************************************************************
   .global MMU_PrefetchICacheMVA
MMU_PrefetchICacheMVA:
   mcr p15,0,r0,c7,c13,1
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateDCache(void)
@**************************************************************
   .global MMU_InvalidateDCache
MMU_InvalidateDCache:
   mcr p15,0,r0,c7,c6,0
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateDCacheMVA(U32 mva)
@**************************************************************
   .global MMU_InvalidateDCacheMVA
MMU_InvalidateDCacheMVA:
   @r0=mva
   mcr p15,0,r0,c7,c6,1
   mov pc ,lr

@**************************************************************
@void MMU_CleanDCacheMVA(U32 mva)
@**************************************************************
   .global MMU_CleanDCacheMVA
MMU_CleanDCacheMVA:
   @r0=mva
   mcr p15,0,r0,c7,c10,1
   mov pc ,lr

@**************************************************************
@void MMU_CleanInvalidateDCacheMVA(U32 mva)
@r0=mva
@**************************************************************
   .global MMU_CleanInvalidateDCacheMVA
MMU_CleanInvalidateDCacheMVA:
   mcr p15,0,r0,c7,c14,1
   mov pc ,lr

@**************************************************************
@void MMU_CleanDCacheIndex(U32 index)
@r0=index
@**************************************************************
   .global MMU_CleanDCacheIndex
MMU_CleanDCacheIndex:
   mcr p15,0,r0,c7,c10,2
   mov pc ,lr

@**************************************************************
@void MMU_CleanInvalidateDCacheIndex(U32 index)
@r0=index
@**************************************************************
   .global MMU_CleanInvalidateDCacheIndex
MMU_CleanInvalidateDCacheIndex:
   mcr p15,0,r0,c7,c14,2
   mov pc ,lr

@**************************************************************
@void MMU_WaitForInterrupt(void)
@**************************************************************
   .global MMU_WaitForInterrupt
MMU_WaitForInterrupt:
   mcr p15,0,r0,c7,c0,4
   mov pc ,lr

@**************************************************************
@ TLB functions
@voic MMU_InvalidateTLB(void)
@**************************************************************
   .global MMU_InvalidateTLB
MMU_InvalidateTLB:
   mcr p15,0,r0,c8,c7,0
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateITLB(void)
@**************************************************************
   .global MMU_InvalidateITLB
MMU_InvalidateITLB:
   mcr p15,0,r0,c8,c5,0
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateITLBMVA(U32 mva)
@ro=mva
@**************************************************************
   .global MMU_InvalidateITLBMVA
MMU_InvalidateITLBMVA:
   mcr p15,0,r0,c8,c5,1
   mov pc ,lr

@**************************************************************
@void MMU_InvalidateDTLB(void)
@**************************************************************
	.global MMU_InvalidateDTLB
MMU_InvalidateDTLB:
	mcr p15,0,r0,c8,c6,0
	mov pc ,lr

@**************************************************************
@void MMU_InvalidateDTLBMVA(U32 mva)
@r0=mva
@**************************************************************
	.global MMU_InvalidateDTLBMVA
MMU_InvalidateDTLBMVA:
	mcr p15,0,r0,c8,c6,1
	mov pc ,lr

@**************************************************************
@ Cache lock down
@void MMU_SetDCacheLockdownBase(U32 base)
@r0= victim & lockdown base
@**************************************************************
   .global MMU_SetDCacheLockdownBase
MMU_SetDCacheLockdownBase:
   mcr p15,0,r0,c9,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_SetICacheLockdownBase(U32 base)
@r0= victim & lockdown base
@**************************************************************
   .global MMU_SetICacheLockdownBase
MMU_SetICacheLockdownBase:
   mcr p15,0,r0,c9,c0,1
   mov pc ,lr

@**************************************************************
@ TLB lock down
@void MMU_SetDTLBLockdown(U32 baseVictim)
@r0= baseVictim
@**************************************************************
   .global MMU_SetDTLBLockdown
MMU_SetDTLBLockdown:
   mcr p15,0,r0,c10,c0,0
   mov pc ,lr

@**************************************************************
@void MMU_SetITLBLockdown(U32 baseVictim)
@r0= baseVictim
@**************************************************************
   .global MMU_SetITLBLockdown
MMU_SetITLBLockdown:
   mcr p15,0,r0,c10,c0,1
   mov pc ,lr

@**************************************************************
@ Process ID
@void MMU_SetProcessId(U32 pid)
@r0= pid
@**************************************************************
   .global MMU_SetProcessId
MMU_SetProcessId:
   mcr p15,0,r0,c13,c0,0
   mov pc ,lr


