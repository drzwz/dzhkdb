//=============================jzt/dzh公式=============================
.fml.f:()!();
.fml.calc:{[x].fml.x::x; :`real$@[.fml.f[x[`para3]];x;x[`n]#0e];};    / test :   .fml.calc:{[x].fml.x::x; :`real$ .fml.f[1.01e] [x];};
.fml.savebar:{`.fml.bar upsert update sym:.fml.getsym[x] from x[`bar];};    /sym为jzt sym
.fml.savebar2:{`.fml.bar upsert update sym:.fml.getfesym[x] from x[`bar];};   /sym为推算的最新交易代码
.fml.mkts:()!();
.fml.mkts[`dzh]:(`SH;`SZ;`CF;`HK;`SS;`$"B$";`OF;`$"$$";`SG;`SF;`ZF;`DF;`FI;`ZI;`IX;`HS;`BO;`SW;`NS;`NY;`DJ;`DA;`FT;`FR;`SP;`FX;`IC;`SM;`LM;`NX;`CB;`CX;`IB;`$"Z$";`ZZ);  ////与DZH的市场代码不一定要相同，但位置须一一对应:
.fml.mkts[`jzt]:(`XX;`SH;`SZ;`CF;`SF;`SF;`DF;`ZF;`FX;`HZ;`HK;`CB;`CM;`AR;`NM;`NB;`SG;`KS;`IP;`LF;`LS;`DT;`MO;`SN;`TQ;`TJ;`TW;`ML;`NE;`XH;`$"$$";`FE);  ////与JZT的市场代码不一定要相同，但位置须一一对应:
.fml.getsym:{:`$(string .fml.mkts[x[`from]][`int$floor (first x[`para1])%3]),(string upper x[`sym]) };   // .fml.getsym[.fml.x]
.fml.getfesym:{mkt:(string .fml.mkts[x[`from]][`int$floor (first x[`para1])%3]);sym0:-2 _ string upper x[`sym];mysym:upper x[`sym];prod:`$(mkt,sym0);
         :$[not((`$mkt) in `CF`SF`DF`ZF);`$mkt,string mysym;
                not(-2#string x[`sym])~(-2#string x[`name]);`$mkt,(string mysym),"00";    /连续合约、指数等,统一加00
                prod in `SFBUX`SFBUY`DFAX`DFAY`ZFSRX`ZFSRY`ZFWSX`ZFWSY;`$mkt,(-1_sym0),-4#string x[`name];
                (-2#string x[`sym])~(-2#string x[`name]);`$mkt,sym0,-4#string x[`name];`$mkt,string mysym  ];};   // .fml.getfesym[.fml.x] 推算最新交易代码
//下面是具体函数 
// x[`sym]:证券代码（不含市场代码）
// x[`isindex]:是否是指数，1为指数
// x[`datatype]:数据类型，分时线=1,分笔成交=2,1分钟线=3,5分钟线=4,15分钟线=5,30分钟线=6,60分钟线=7,日线=8,周线=9,月线=10,多日线=11,年线=12,季线=13,半年线=14，dzh不支持12/13/14。
// x[`size]: 周期秒数，对于多日线等不规则用负数表示
// x[`bar]: K线数据表
// x[`n]:k线数量
// x[`para1]:公式参数1，为real型数组或第一个参数值
// x[`para2]:公式参数2
// x[`para3]:公式参数3
// x[`para4]:公式参数4。该参数被设定为索引值，用来区分不同函数，是real型哦。也就是说公式参数4如果为1.23，那么将执行.fml.f[1.23e]函数，需要事先定义函数.fml.f[1.23e]:{.....}。
// x[`from]: jzt或dzh
// x[`name]: jzt证券简称,dzh不传送证券简称用证券代码替换
.fml.bar:([date:`date$();time:`time$();sym:`$();size:`int$()]open:`real$();high:`real$();low:`real$();close:`real$();volume:`real$();openint:`real$() );   //对于规则周期date/time是bar的起始时间，否则是jzt bar的结束日期！！！
.fml.f[1.1e]:{0N!x[`sym`datatype];.fml.savebar[x];  :enlist 1;}; /保存数据
.fml.f[1.2e]:{0N!x[`sym`datatype];.fml.savebar[x];  :exec close*1.1 from x[`bar];};  //例子：返回close*1.1

//=============================tdx公式(与dzh/jzt公式不同)=============================
.fml.tdxdate2qdate:{"D"$string[`long$x+19000000]};   //公式的DATE序列转为q的date list
.fml.qdate2tdxdate:{{`float$neg[19000000]+"J"$string[x]_/4 6}each x};  //q的date list转为公式的DATE序列
.fml.tdxtime2qtime:{"T"$string[x],\:"00"}; //tdx的TIME序列转为q的time list
.fml.qtime2tdxtime:{{"F"$4#string[x]_/2 5}each x}; //q的time list转为tdx的TIME序列
.fml.tdxtime22qtime:{"T"$string[x]}; //tdx的TIME2序列转为q的time list
.fml.qtime2tdxtime2:{{"F"$6#string[x]_/2 4}each x}; //q的time list转为tdx的TIME2序列
//注意：jztkdbPORT.dll放在tdx\T002\dlls下，c.dll放在tdx目录！！！
// TDXDLL1(1,...)调用.fml.tdxkdb1, TDXDLL1(2,...)调用.fml.tdxkdb2,…………
.fml.tdxkdb1:{[p1;p2;p3]P1::p1;0N!(.z.T;`.fml.tdxkdb1;count p1;count p2;count p3);:p3};
.fml.tdxkdb2:{[p1;p2;p3]P2::p2;0N!(.z.T;`.fml.tdxkdb2;count p1;count p2;count p3);:.fml.qtime2tdxtime .fml.tdxtime2qtime p2};
.fml.tdxkdb3:{[p1;p2;p3]P3::p3;0N!(.z.T;`.fml.tdxkdb3;count p1;count p2;count p3);:.fml.qtime2tdxtime2 .fml.tdxtime22qtime p3};
.fml.tdxkdb4:{[p1;p2;p3]0N!(.z.T;`.fml.tdxkdb4;count p1;count p2;count p3);:p3+1};
.fml.tdxkdb5:{[p1;p2;p3]0N!(.z.T;`.fml.tdxkdb5;count p1;count p2;count p3);:p3+1};

