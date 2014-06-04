//**********************************************************************************
//杨屹    2002/08/20    第一版
//字符串操作函数
//联系方法：gdtyy@ri.gdt.com.cn（2003/07/31以前有效）
//**********************************************************************************
//使用方法：
//自包含
//与标准库函数用法相同。
//**********************************************************************************
#include "mystring.h"

void yystrlwr(unsigned char *str)//将字符串全部转换成小写格式
{
	int i;
	unsigned char ch;
	for(i=0;1;i++){
		ch=*(str+i);
		if(ch=='\0') break;
		else if(ch>='A'&&ch<='Z') *(str+i)=ch-'A'+'a';
	}	
}

char yystrcmp(unsigned char *stra,unsigned char *strb)//比较a和b两个字符串的大小，a>b 1 a=b 0 a<b -1
{
	int i;
	unsigned char cha,chb;
	for(i=0;1;i++){
		cha=*(stra+i);
		chb=*(strb+i);
		if(cha=='\0'&&chb=='\0') return 0;
		else if(cha>chb) return 1;
		else if(cha<chb) return -1;
	}	
}

unsigned int yystrlen(unsigned char *str)//计算字符串长度，不包括'\0'标志。
{
	unsigned int i=0;

	while(*str++!='\0'){
		i++;
	}
		
	return i;
}

const int MaxLenStr = 128;

int StrToNum(unsigned char *Str,long int *Num)//字符串转换成数值（自动区分十进制“无前缀”和十六进制“0x”）
{
	int i=0;
	unsigned char ch;
	long int x=0;

	if(Str[0]=='0'&&(Str[1]=='x'|| Str[1]=='X')){
		i=2;
		ch=Str[i];
		while(ch!='\0'&&i<MaxLenStr){
			if((ch<'0'||ch>'9')&&(ch<'a'||ch>'z')&&(ch<'A'||ch>'Z')) return 0;
			else{
				if(ch>='0'&&ch<='9') x=x*16+(ch-'0');
				else if(ch>='a'&&ch<='z') x=x*16+(ch-'a'+10);
				else x=x*16+(ch-'A'+10);
				//x=x*10+(ch-'0');
			}
			i=i+1;
			ch=Str[i];
		}
		if(i<MaxLenStr||Str[MaxLenStr]=='\0'){
			*Num=x;
			return 1;
		}
		else return 0;
	}
	else{
		i=0;
		ch=Str[i];
		while(ch!='\0'&&i<MaxLenStr){
			if(ch<'0'||ch>'9') return 0;
			else x=x*10+(ch-'0');
			i=i+1;
			ch=Str[i];
		}
		if(i<MaxLenStr||Str[MaxLenStr]=='\0'){
			*Num=x;
			return 1;
		}
		else return 0;
	}
}

int StrToHEX(unsigned char *Str,long int *Num)//字符串转换成数值（默认字符串为十六进制数值表示）
{
	int i=0;
	unsigned char ch;
	long int x=0;

	ch=Str[i];
	while(ch!='\0'&&i<MaxLenStr){
		if((ch<'0'||ch>'9')&&(ch<'a'||ch>'z')&&(ch<'A'||ch>'Z')) return 0;
		else{
			if(ch>='0'&&ch<='9') x=x*16+(ch-'0');
			else if(ch>='a'&&ch<='z') x=x*16+(ch-'a'+10);
			else x=x*16+(ch-'A'+10);
		}
		i=i+1;
		ch=Str[i];
	}
	if(i<MaxLenStr||Str[MaxLenStr]=='\0'){
		*Num=x;
		return 1;
	}
	else return 0;

}
