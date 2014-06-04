//**********************************************************************************
//杨屹    2002/08/20    第一版
//词法分析程序（取词）
//联系方法：gdtyy@ri.gdt.com.cn（2003/07/31以前有效）
//**********************************************************************************
#include "word.h"

int GetWord(unsigned char *ComBuf,WORDTABLE *WordTable)
{
	int i=0;	/*ComBuf String pointer*/
	int j=0;	/*Length of Word */
	int k=-1;	/*The number of WordTable*/
	int StrFlag=0;	/*There is "0-9/a-z/A-Z" before " ,()"*/
	int SentenceEndFlag=0;	/*Sentence end*/
	char ch;

	WordTable->Num=0;
	WordTable->LeftCurveNum=0;
	WordTable->RightCurveNum=0;

	ch=ComBuf[0];
	while(!SentenceEndFlag&&i<MaxLenComBuf){
		if((ch>='0'&&ch<='9')||(ch>='a'&&ch<='z')||(ch>='A'&&ch<='Z')||(ch=='.')){
			if(StrFlag==0){
				StrFlag=1;k=k+1;j=0;
				if(k>=MaxLenWordTable) return 0;
				WordTable->wt[k].Str[j]=ch;
				WordTable->Num=k+1;
			}
			else{
				j=j+1;
				if(j>=MaxLenWord) return 0;
            	WordTable->wt[k].Str[j]=ch;
			}
		}
		else if(ch==' '||ch==','||ch=='('||ch==')'||ch=='\0'){
			if(ch=='(') WordTable->LeftCurveNum++;
			if(ch==')') WordTable->RightCurveNum++;
			if(StrFlag==1){
				StrFlag=0;j=j+1;
				WordTable->wt[k].Str[j]='\0';
				WordTable->wt[k].Length=j;
			}
			if(ch=='\0') SentenceEndFlag=1;
		}
		else{
			return 0;
		}
		i=i+1;
		ch=ComBuf[i];
	}
	if(i<MaxLenComBuf||ComBuf[MaxLenComBuf]=='\0'){
		if(WordTable->LeftCurveNum==WordTable->RightCurveNum) return 1;
		else return 0;
	}
	else{
		return 0;
	}
}
