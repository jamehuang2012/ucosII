//**********************************************************************************
//����    2002/08/20    ��һ��
//�ʷ���������ȡ�ʣ�
//��ϵ������gdtyy@ri.gdt.com.cn��2003/07/31��ǰ��Ч��
//**********************************************************************************
#define MaxLenWord	200	/*20*/      //������󳤶�
#define MaxLenWordTable	100	/*10*/      //�ʱ���󳤶�

#define MaxLenComBuf	256	/*256*/     //���������󳤶�

#define MaxComNum	30                  //�������������
#define MaxLenCom	10                  //������󳤶�

typedef struct{
		int Num;
		int LeftCurveNum,RightCurveNum;
		struct{
			int Length;
			unsigned char Str[MaxLenWord+1];	/*for '\0'*/
		} wt[MaxLenWordTable];
} WORDTABLE;

int GetWord(unsigned char *ComBuf,WORDTABLE *WordTable);
