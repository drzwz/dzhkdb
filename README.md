# dzhkdb
call kdb+/q from DZH formulas

## dzhkdb����

    ʵ�ִ��ǻ�(DZH)���(<http://www.gw.com.com>)��dll��ʽ����DZH���ݴ���kdb���㲢���ؽ��������ʵ�ָ��ӵļ��㡣

## ʹ�÷���

1�����ذ�װkdb+/q��

2���鿴���޸�qfml.q��ĺ�����

3����qfml.q���Ƶ�qĿ¼������q qfml.q -p 5001  �� �������q�û���֤����Ҫ���û������ļ�����qusers�ļ���������û����룺fml:input_fml_pwd��

4����c.dll���Ƶ�dzh��װĿ¼����d:\dzh365����

5��win7����ϵͳ����dzhkdb.dll���Ƶ�dzhĿ¼������֧��XP����

6����DZH�н���һ��ʽ���磺  

mktid:=STRFIND('`SH`SZ`SF`HK`SS`B$`OF`$$`SG`SC`ZC`DC`FI`ZI`IX`HS`BO`SW`NS`NY`DJ`DA`FT`FR`SP`FX`IC`SM`LM`NX`CB`CX`IB`Z$`ZZ',MARKETLABEL,1);

RET:"dzhkdb@CALC"(mktid,5001,1.2);  {�ڶ�������Ϊ������qfml.q��kdb�Ķ˿ںţ�����������Ϊ.fml.f�����������ţ���ʾҪ����.fml.f[1.2]����}

## ע��

������д�ڶ���ǰ��δ��DZH���°���ԣ�ֻҪDZH DLL�ӿڹ淶û�б仯��Ӧ���ǿ��õġ�
