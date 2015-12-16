%let myfolder=%str(/folders/myfolders/HW4);
libname HW4 "&myfolder";

%macro readXls(dfile);
	%let dfilein=%str(/folders/myfolders/HW4/&dfile);
	proc import datafile="&dfilein" 
    	out=&dfile
    	dbms=xls replace;
    	getnames=yes; 
    run;
    title1 "&dfile";
%mend;

%macro nterSec2(dsetA, dsetB, dsetOut); /* datasetA, datasetB, datasetOut */
proc sql;
	create table &dsetOut as
		select a.id, a.grade as &dsetA, 
			b.id, b.grade as &dsetB
			from &dsetA as a, &dsetB as b
			where a.id = b.id
			order by a.id;
quit;
run;
%mend;

%macro nterSec3(dsetA, dsetB, dsetC, dsetOut); /* Trifecta -- datasetA, datasetB, datasetC, datasetOut */
proc sql;
	create table &dsetOut as
		select a.id, a.grade as &dsetA, 
			b.id, b.grade as &dsetB,
			c.id, c.grade as &dsetC
			from &dsetA as a, &dsetB as b, &dsetC as c
			where a.id = b.id and b.id = c.id
			order by a.id;
quit;
run;
%mend;

%macro document(exTitle, exNum);  /* headers/footers for each section */
	title1 underlin=1 "&exTitle";
	footnote1 font=Arial height=8pt "Stats475 CSULB Prof. Korosteleva";
	footnote2 font=Arial height=8pt "Lin Crampton     HW4      &sysdate9 &systime";
	footnote3 font=Arial height=8pt "&exNum";
%mend;

%readXls(grades484);
%readXls(grades550);
%readXls(grades695);
/* (a) How many students took STAT550 and STAT484? What were their grades in these courses? List their id’s and respective grades.*/
%nterSec2(grades484,grades550, g484_550); 
%document(Students in both 484 and 550, Exercise 1(a));
proc print data=g484_550 noobs;  run;

/*(b) How many students took STAT550 and STAT695? What were their grades in these courses? List their id’s and respective grades. */
%nterSec2(grades695,grades550, g695_550);
%document(Students in both 695 and 550, Exercise 1(b));
proc print data=g695_550 noobs;  run;

/* (c) How many students took STAT484 and STAT695? What were their grades in these courses? List their id’s and respective grades.*/
%nterSec2(grades484,grades695, g484_695);
%document(Students in both 484 and 695, Exercise 1(c));
proc print data=g484_695 noobs;  run;

/* (d) How many students took all three courses? What were their grades in these courses? List their id’s and respective grades. */
%nterSec3(grades484,grades550,grades695, g_all);
%document(Students in 484+550+695, Exercise 1(d));
proc print data=g_all noobs;  run;
title1;
