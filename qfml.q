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














\d .zz
//=============================jzt数据读写=============================
/jzt代码转换： .zz.jztsym2sym[`ZJIF01]  .zz.jztsym2sym[`SZ000001]   .zz.sym2jztsym[`IF01.CFE]  .zz.sym2jztsym[`000001.SZ]
jztsym2sym:{[x]mktmap:("ZJ";"SQ";"ZQ";"DQ";"WH")!("CFE";"SHF";"CZC";"DCE";"FX"); mkt:2#string[x];mkt2:mktmap mkt;:$[""~mkt2;`$(2_string[x]),".",mkt;`$(2_string[x]),".",mkt2];};  
sym2jztsym:{[x]mktmap:("CFE";"SHF";"CZC";"DCE";"FX")!("ZJ";"SQ";"ZQ";"DQ";"WH"); s:upper string x; mktlen:(reverse s)?".";mkt:(neg mktlen)#s;if[mkt in key mktmap;mkt:mktmap[mkt]];  :`$mkt,(neg mktlen+1)_s;};  
/读取JZT DAD数据 , 用法  .zz.getjztbar[  `$":d:/test.DAD"]   getjztbar[  `$":d:/FE/data/jzt5s.DAD"] 
getjztbar:{[x]if[not (-11h=type key x);:()]; jztbar:();  filelen:hcount x;  pos:53j;
  flag:first first(enlist "x";enlist(1)) 1:(x;pos;1); pos+:1;  mysize:$[flag=0x04;86400i;flag=0x9D;300i;flag=0x9C;60i;flag=0xA1;5i;flag=0x9E;999999i;999999i];
  while[filelen - pos;  sec:`sym`num!("si";(12;4)) 1:(x;pos;16); mysym:first sec[`sym];recnum:first sec[`num];
  pos+:16; jztbar,: update sym:mysym,dt:`datetime$dt-36526 from flip `dt`open`high`low`close`openint`volume`amount`ups`dns`deals`openvolume`openamount!("feeeeeeehhhee";(8,(7#4),(3#2),(2#4)))1:(x;pos;50*recnum) ;
  pos+:50*recnum];
  $[mysize=86400i; :select date:`date$dt,time:00:00:00.000,sym:.zz.jztsym2sym each sym,size:mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint:?[sym like "S[HZ]*";amount;openint] from jztbar ;
    mysize in (300i;60i;5i);:select date:`date$dt,time:(-1000i*mysize)+`time$dt,sym:.zz.jztsym2sym each sym,size:mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint:?[sym like "S[HZ]*";amount;openint] from jztbar;
    :select date:`date$dt,time:`time$dt,sym:.zz.jztsym2sym each sym,size:mysize,open,high,low,close,volume:?[sym like "S[HZ]*";`real$volume*100;volume],openint:?[sym like "S[HZ]*";amount;openint] from jztbar];
   };
/生成JZT DAD文件: mkt:jzt市场代码，若为`，需sym字段必须以mkt开头;size-秒数只能为5/60/300/86400/999999;srctbl表须含有date/time/sym/size/open/high/low/close/volume/openint字段且time是bar的起始时间不是结束时间： setjztbar[`FE;60i;`:d:/test.dad;bar]
setjztbar:{[mkt;size;dadfile;srctbl]  bt:{reverse  0x0 vs x}; mysize:`int$size; if[not mysize in (5i;60i;300i;86400i;999999i);:`size_wrong];
   dadfile 1: 0x64000000;  h:hopen dadfile; h 49#"金字塔决策交易系统 2013 (V2.98)",49#"\000"; //文件头.   若文件已存在，则覆盖
   h $[mysize=5i;0xA1;mysize=60i;0x9C;mysize=300i;0x9D;mysize=86400;0x04;0x9E];  // 数据周期0xA1/0x9C/0x9D/0x04/0x9E
   symlist:exec distinct sym from srctbl where size=mysize;   sc:count symlist; isc:0;
   do[sc;s:symlist[isc];s_num:`int$count mybar:`date`time xasc update dt:`float$((`datetime$date+time+?[mysize<86400;mysize*1000i;0i]) - 1899.12.30T00:00:00.000),ups:`short$count i,dns:`short$count i,deals:`short$count i,amount:?[sym like "*.S[HZ]";openint;0e],openint:?[sym like "*.S[HZ]";0e;openint],openvolume:0e,openamount:0e from select from srctbl where sym=s,size=mysize;
   h (`byte$12#(string upper mkt),(string s),12#"\000"),(bt s_num),raze raze exec   (( bt each dt),' (bt each open),' (bt each high),' (bt each  low) ,' (bt each close),' (bt each openint),' (bt each volume),' (bt each amount),' (bt each ups),' (bt each dns),' (bt each deals),'(bt each openvolume),'(bt each openamount)  ) from mybar;
   isc+:1];   hclose h;};
/生成jzt代码表文件,srctbl含sym/name字段，若无name，则name取sym:     setjztsyms[`FE;`:d:/fe.snt;bar]
setjztsyms:{[mkt;sntfile;srctbl]
    $[`name in cols srctbl;
    sntfile 1: "Stock Name Table\n",(string mkt),"\n",raze exec ((string sym),'("\011"),'(string name),'"\n")  from select distinct sym,name from srctbl; 
    sntfile 1: "Stock Name Table\n",(string mkt),"\n",raze exec ((string sym),'("\011"),'(string sym),'"\n") from select distinct sym from srctbl];  };
/读取JZT除权文件*.PWR    getjztcq `:d:/jzt/temp/power.pwr    getjztcq `:d:/jzt/temp/gppower.pwr
getjztcq:{[x]if[not (-11h=type key x);:()]; jztdata:();  filelen:hcount x;  pos:53j;
  flag:first first(enlist "x";enlist(1)) 1:(x;pos;1); pos+:1;  
  while[filelen - pos;  sec:`sym`num!("sh";(12;2)) 1:(x;pos;14); mysym:first sec[`sym];recnum:first sec[`num];
  pos+:14; jztdata,: update sym:mysym,dt:`datetime$dt-36526 from flip `dt`sg`pg`f1`pgjg`fh`f2!("ffffeee";(8,8,8,8,4,4,4))1:(x;pos;44*recnum) ;
  pos+:44*recnum];
  :select date:`date$dt,sym:.zz.jztsym2sym each sym,sg,pg,pgjg,fh from jztdata;
   };
/读取JZT除权文件*.TXT
getjztcscq:{[x]:select .zz.jztsym2sym each sym,date,fh%10,sgbl%10,pgbl%10,pgjg from `sym`date`sgbl`pgbl`pgjg`fh xcol ("SDFFFF";enlist "\t") 0: x}; 
/读取JZT财务文件
getjztcscw:{: update .zz.jztsym2sym each sym from (`sym`date,`$"f",/:string 1+til 56) xcol t: ("SD",56#"F";enlist "\t") 0: x;}; 
/将复权因子转换为送股比例并保存为文本文件，可供JZT导入： setjztcq[`:d:/fe/data/jztcq.txt;`cfcq]
setjztcq:{[dstfile;srctbl]dstfile 0: (enlist "证券代码\t时间\t红股(10送)\t配股(10配)\t配股价\t红利(10送)"), 1_"\t" 0:{select sym:.zz.sym2jztsym each sym,date:{`$ssr[string x;".";""]} each date,sg,0f,0f,0f from x where sg<>0}ungroup select date,sg:10*-1+1^af%prev af by sym from `sym`date xasc select from srctbl;};  /srctbl字段：`sym`date`af等

//=============================tdx数据读写=============================

tdxsym2sym:{[x]mktmap:("SH";"SZ")!("SH";"SZ"); mkt:2#string[x];mkt2:mktmap mkt;:$[""~mkt2;`$(2_string[x]),".",mkt;`$(2_string[x]),".",mkt2];};  
sym2tdxsym:{[x]mktmap:("SH";"SZ")!("SH";"SZ"); s:upper string x; mktlen:(reverse s)?".";mkt:(neg mktlen)#s;if[mkt in key mktmap;mkt:mktmap[mkt]];  :`$mkt,(neg mktlen+1)_s;}; 
gettdxbar:{[x]tt:flip `date1`open`high`low`close`amount`volume`openint!("iiiiieii";4 4 4 4 4 4 4 4 ) 1: `$(":",x);sym1:(upper x (first x ss "s[hz][0-9][0-9][0-9][0-9][0-9][0-9]") + til 8);:update .zz.tdxsym2sym each sym from select date:"D"$string date1,sym:`$sym1,size:86400i,`real$open%100,`real$high%100,`real$low%100,`real$close%100, `real$volume,openint:`real$amount from tt;};
//读取所有A股基金的日线数据，若没有路径参数，则为`:d:/tdx:     .zz.gettdxcsbar1d[]
gettdxcsbar1d:{[tdxpath]if[null tdxpath;tdxpath:`:d:/tdx];if[-11h<>type tdxpath;'para_error];:raze{sym1:-8#-4 _string x;sym1:`$(-6#sym1),".",(2#sym1);select date:"D"$string date1,sym:sym1,`real$open%100,`real$high%100,`real$low%100,`real$close%100,`real$volume from 
        flip `date1`open`high`low`close`volume!("iiiii i ";8#4) 1: x}
   each raze{[dir]file:upper key dir;file:file[where (file like "SH000*.DAY")or(file like "SH510*.DAY")or(file like "SH6*.DAY")or(file like "SZ[03]0*.DAY")or(file like "SZ159*.DAY")or(file like "SZ399*.DAY")];
        :(` sv)each dir,/:file} each (` sv)each tdxpath,/:(`vipdoc`sh`lday;`vipdoc`sz`lday);
  };
//从完整的文件名读取通达信扩展日线行情数据:   .zz.gettdxbar2["D:/TDX/Vipdoc/ds/lday/47#IFL8.day"]
gettdxbar2:{[x]tt:flip `date1`open`high`low`close`openint`volume`settle!("ieeeeiie";8#4) 1: `$(":",x);sym1:upper -4_(1+first x ss "#") _ x;:select date:"D"$string date1,sym:`$sym1,size:86400i,open,high,low,close,`real$volume,`real$openint from tt;};
//从完整文件名读取股票分钟数据。
gettdxbarm:{[x]tt:flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":",x);sym1:$[x like "*/s[hz]/*";(upper x (first x ss "s[hz][0-9][0-9][0-9][0-9][0-9][0-9]") + til 8);upper -4_(1+first x ss "#") _ x];mysize:$[x like "*.lc5";300i;x like "*.lc1";60i;0i];:select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[mysize*1000]+`time$time1*60000,sym:`$sym1,size:mysize,open,high,low,close,`real$volume,openint:`real$amount from tt;};
//读取5分钟股票数据,假设tdx目录为d:\tdx， .zz.gettdxcsbar5m[`000001.SZ]
gettdxcsbar5m:{[x]tt:flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":d:/tdx/vipdoc/",(-2#string[x]),"/fzline/",(-2#string[x]),(-3_string[x]),".lc5");:select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[300*1000]+`time$time1*60000,sym:x,open,high,low,close,`real$volume,openint:`real$amount from tt;};
//读取1分钟股票数据,假设tdx目录为d:\tdx， .zz.gettdxcsbar1m[`000001.SZ]
gettdxcsbar1m:{[x]tt:flip `date1`time1`open`high`low`close`openint`volume`amount!("hheeeeiie";2 2,7#4) 1: `$(":d:/tdx/vipdoc/",(-2#string[x]),"/minline/",(-2#string[x]),(-3_string[x]),".lc1");:select date:{"D"$string[2004+floor[x%2048]],-4#"00",string x mod 2048}each date1,time:neg[ 60*1000]+`time$time1*60000,sym:x,open,high,low,close,`real$volume,openint:`real$amount from tt;};

//写tdx本地日线数据,用法： .zz.settdxcsbar1d[`:d:/tdx;`000001.SZ;tbl]; tbl字段：date,open,high,low,close,volume,openint; 写入后可能需要重启tdx，并脱机运行。
settdxcsbar1d:{[tdxdir;mysym;tbl]
  dscfile1:` sv(tdxdir;`vipdoc;`$(-2#string mysym);`lday;`$string[.zz.sym2tdxsym mysym],".day");0N!(.z.T;dscfile1);
    dscfile1 1: ();fh:hopen dscfile1;if[fh<=0;0N!(.z.T;dscfile1;`cannot_created);:()];  //delete first and create 
    {[fh;x]fh each value x;}[fh;] each select date1:{"I"$string[x]_/4 6}each date,`int$open*100,`int$high*100,`int$low*100,`int$close*100,amount:`real$openint,`int$volume,openint:0i from `date xasc select from tbl;
    hclose fh;
  };   
//写tdx本地5分钟数据,用法： .zz.settdxcsbar5m[`:d:/tdx;`000001.SZ;tbl];   日期格式：2个字节的后11位为月日，前5位+2004为年;
settdxcsbar5m:{[tdxdir;mysym;tbl]
  dscfile1:` sv(tdxdir;`vipdoc;`$(-2#string mysym);`fzline;`$string[.zz.sym2tdxsym mysym],".lc5");0N!(.z.T;dscfile1);
    dscfile1 1: ();fh:hopen dscfile1;if[fh<=0;0N!(.z.T;dscfile1;`cannot_created);:()];  //delete first and create 
    {[fh;x]fh each value x;}[fh;] each select date1:`short$(2048*neg[2004]+`year$date)+(100*`mm$date)+`dd$date,time1:`short$(time+300000)%60000,`real$open,`real$high,`real$low,`real$close,openint:0i,`int$volume,amount:`real$openint from `date`time xasc select from tbl;
    hclose fh;
  };  
//写tdx本地1分钟数据,用法： .zz.settdxcsbar5m[`:d:/tdx;`000001.SZ;tbl];   日期格式：2个字节的后11位为月日，前5位+2004为年;
settdxcsbar1m:{[tdxdir;mysym;tbl]
  dscfile1:` sv(tdxdir;`vipdoc;`$(-2#string mysym);`minline;`$string[.zz.sym2tdxsym mysym],".lc1");0N!(.z.T;dscfile1);
    dscfile1 1: ();fh:hopen dscfile1;if[fh<=0;0N!(.z.T;dscfile1;`cannot_created);:()];  //delete first and create 
    {[fh;x]fh each value x;}[fh;] each select date1:`short$(2048*neg[2004]+`year$date)+(100*`mm$date)+`dd$date,time1:`short$(time+60000)%60000,`real$open,`real$high,`real$low,`real$close,openint:0i,`int$volume,amount:`real$openint from `date`time xasc select from tbl;
    hclose fh;
  };  
\d .
