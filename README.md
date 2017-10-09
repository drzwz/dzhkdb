# dzhkdb
call kdb+/q from DZH formulas

## dzhkdb功能

    实现大智慧(DZH)软件(<http://www.gw.com.com>)的dll公式，将DZH数据传到kdb计算并返回结果，可以实现复杂的计算。

## 使用方法

1、下载安装kdb+/q。

2、查看并修改qfml.q里的函数。

3、把qfml.q复制到q目录。启动q qfml.q -p 5001  。 如果启用q用户验证，需要在用户密码文件（如qusers文件）中添加用户密码：fml:input_fml_pwd。

4、把c.dll复制到dzh安装目录（如d:\dzh365）。

5、win7以上系统，把dzhkdb.dll复制到dzh目录。（不支持XP）。

6、在DZH中建立一公式，如：  

mktid:=STRFIND('`SH`SZ`SF`HK`SS`B$`OF`$$`SG`SC`ZC`DC`FI`ZI`IX`HS`BO`SW`NS`NY`DJ`DA`FT`FR`SP`FX`IC`SM`LM`NX`CB`CX`IB`Z$`ZZ',MARKETLABEL,1);

RET:"dzhkdb@CALC"(mktid,5001,1.2);  {第二个参数为加载了qfml.q的kdb的端口号，第三个参数为.fml.f函数的索引号，表示要调用.fml.f[1.2]函数}

## 注意

本代码写于多年前，未在DZH最新版测试，只要DZH DLL接口规范没有变化，应该是可用的。
