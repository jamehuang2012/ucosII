//**********************************************************************************
//杨屹    2002/08/20    第一版
//字符串操作函数
//联系方法：gdtyy@ri.gdt.com.cn（2003/07/31以前有效）
//**********************************************************************************
//与标准库函数用法相同。
//**********************************************************************************
void yystrlwr(unsigned char *str);//将字符串全部转换成小写格式
char yystrcmp(unsigned char *stra,unsigned char *strb);//比较a和b两个字符串的大小，a>b 1 a=b 0 a<b -1
unsigned int yystrlen(unsigned char *Str);//计算字符串长度，不包括'\0'标志。
int StrToNum(unsigned char *Str,long int *Num);//字符串转换成数值（自动区分十进制“无前缀”和十六进制“0x”）
int StrToHEX(unsigned char *Str,long int *Num);//字符串转换成数值（默认字符串为十六进制数值表示）
