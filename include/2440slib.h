//===================================================================
// File Name : 2440slib.h
// Function  : S3C2440 
// Date      : February 20, 2002
// Version   : 0.0
// History
//   0.0 : Programming start (February 20,2002) -> SOP
//===================================================================

#ifndef __2440slib_h__
#define __2440slib_h__

#ifdef __cplusplus
extern "C" {
#endif

void SDRAMtest(void);
int SET_IF(void);
void WR_IF(int cpsrValue);
void CLR_IF(void);

void MMU_EnableICache(void);
void MMU_DisableICache(void);
void MMU_EnableDCache(void);
void MMU_DisableDCache(void);
void MMU_EnableAlignFault(void);
void MMU_DisableAlignFault(void);
void MMU_EnableMMU(void);
void MMU_DisableMMU(void);
void MMU_SetTTBase(uint32 base);
void MMU_SetDomain(uint32 domain);

void MMU_SetFastBusMode(void);  //GCLK=HCLK
void MMU_SetAsyncBusMode(void); //GCLK=FCLK @(FCLK>=HCLK)

void MMU_InvalidateIDCache(void);
void MMU_InvalidateICache(void);
void MMU_InvalidateICacheMVA(uint32 mva);
void MMU_PrefetchICacheMVA(uint32 mva);
void MMU_InvalidateDCache(void);
void MMU_InvalidateDCacheMVA(uint32 mva);
void MMU_CleanDCacheMVA(uint32 mva);
void MMU_CleanInvalidateDCacheMVA(uint32 mva);
void MMU_CleanDCacheIndex(uint32 index);
void MMU_CleanInvalidateDCacheIndex(uint32 index);	
void MMU_WaitForInterrupt(void);
	
void MMU_InvalidateTLB(void);
void MMU_InvalidateITLB(void);
void MMU_InvalidateITLBMVA(uint32 mva);
void MMU_InvalidateDTLB(void);
void MMU_InvalidateDTLBMVA(uint32 mva);

void MMU_SetDCacheLockdownBase(uint32 base);
void MMU_SetICacheLockdownBase(uint32 base);

void MMU_SetDTLBLockdown(uint32 baseVictim);
void MMU_SetITLBLockdown(uint32 baseVictim);

void MMU_SetProcessId(uint32 pid);

#ifdef __cplusplus
}
#endif

#endif   //__2440slib_h__
