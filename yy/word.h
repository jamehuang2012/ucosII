//**********************************************************************************
//杨屹    2002/08/20    第一版
//词法分析程序（取词）
//联系方法：gdtyy@ri.gdt.com.cn（2003/07/31以前有效）
//**********************************************************************************
#define MaxLenWord	200	/*20*/      //单词最大长度
#define MaxLenWordTable	100	/*10*/      //词表最大长度

#define MaxLenComBuf	256	/*256*/     //命令缓冲区最大长度

#define MaxComNum	30                  //最大命令种类数
#define MaxLenCom	10                  //命令最大长度

typedef struct{
		int Num;
		int LeftCurveNum,RightCurveNum;
		struct{
			int Length;
			unsigned char Str[MaxLenWord+1];	/*for '\0'*/
		} wt[MaxLenWordTable];
} WORDTABLE;

int GetWord(unsigned char *ComBuf,WORDTABLE *WordTable);
