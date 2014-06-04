//**********************************************************************************
//杨屹    2002/08/21    第一版
//我的主程序（SNMP网管板）
//联系方法：gdtyy@ri.gdt.com.cn（2003/07/31以前有效）
//**********************************************************************************

#include  "ucos_ii.h"
#include "word.h"
#include "yyshell.h"
#include "vsprintf.h"
#include "printf.h"
#include "string.h"
#include "appdef.h"

#include "mystring.h"

extern void putc(unsigned char c);

extern unsigned char getc(void);
static unsigned char ComTable[MaxComNum][MaxLenCom+1]={"help"};			
			
int State=StatInputCom;
unsigned char ch;
int ShellEnd=0;		/*Shell end flag*/
unsigned char ComBuf[MaxLenComBuf+1];	/*store '\0'*/
int i=-1;			/*ComBuf pointer*/
int tem;			/*Temp variable*/
int ComMatchFlag=0;		/*Command match flag*/

WORDTABLE WordTable;
	
int Matched=0;	/*Match flag*/

	
#if 0
void main(void)
{
    OSInit();
    
    InitTimer0();
    InitSerial();
    InitSerialBuffer();
    
    //初始化网络参数
    IPadrToHEX("172.18.92.87",&my_ip_address.bytes[0]);
    IPadrToHEX("255.255.255.0",&mask_ip_address.bytes[0]);
    IPadrToHEX("172.18.91.5",&gateway_ip_address.bytes[0]);    
    
    OSTaskCreate(yyshell, (void *)0, &yyshellStk[0],8);    
    
    OSStart();
}
#endif

void help(void) 
{

	printf("\r\n***********************************************\r\n");
	printf("*                   UCOS II SHELL             *\r\n");
	printf("*  Support commands: help                     *\r\n");
	printf("***********************************************\r\n\n");
	
	
}
void yyshell(void *yydata) 
{
	yydata=yydata;
	printf("\r\n***********************************************\r\n");
	printf("*         Welcom to use this program          *\r\n");
	printf("*                   Author:YangYi 20020715    *\r\n");
	printf("***********************************************\r\n\n");
		
	/*Login & Password*/

	printf("State=%d\r\n", State);
	printf("%% ");
	while(1){
		switch(State){
			case StatInputCom:{
				if((ch=getc())){
					if(ch==13)	/*Enter return key*/
					{
						printf("\r\n");
						ComBuf[i+1]='\0';					
						if(i+1==0) printf("%% ");
						else					
						State=StatExeCom;
					}
					else{
						i=i+1;
						if((i>=MaxLenComBuf)&&(ch!=8)){
							i=MaxLenComBuf-1;
						}
						else{
							if(ch==8){
								i=i-2;
								if(i<-1) {i=-1;}
								else{
									putc(' ');
								}
							}
							else{
								putc(ch);
								ComBuf[i]=ch;
							}
						}
					}
					break;
				}
				else{
					//OSTimeDly(10);
					break;
				}
			}
			case StatExeCom:{
				if(GetWord(ComBuf,&WordTable)==1&&WordTable.Num!=0){
					yystrlwr(WordTable.wt[0].Str);
					for(tem=0;tem<MaxComNum&&!ComMatchFlag;tem++)
						if(strcmp((char *)WordTable.wt[0].Str,(char *)ComTable[tem])==0) ComMatchFlag=1;
					if(ComMatchFlag){
						tem--;
						switch(tem){
							case 0:
							{	
								help();
								break;
							}
							case 1:{break;}
							case 2:{break;}
							case 3:{break;}
							case 4:{break;}
                           				case 5:{break;}
							case 6:{break;}							
                            				case 7:{
								//ShellEnd=1;
								printf("\r\nThis Command is limited!\r\n");
								break;
							}
							case 8:{break;}
							case 9:{break;}
							case 10:{break;}
						}							
					}
					else
						printf("    Bad command!\r\n");
				}
				else{
					if(WordTable.Num) printf("    Bad command!\r\n");
				}

				ComMatchFlag=0;
				State=StatInputCom;
				if(ShellEnd) {printf("\r\n");}
				else printf("% ");
				i=-1;
				break;
			}
			default:{
				//ShellEnd=1;
				printf("System fatal error!\r\n");
			}
		}
	}
}
