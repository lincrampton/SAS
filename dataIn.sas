libname hw1 '/folders/myfolders/hw1/'; /* ~/SAS/SASUniversity/myfolders/hw1 */
data hw1.q1a;  /* save the data so that can read it back in */
input Team$ 1-13    Attendance   Price;
cards;
Atlanta      13993 20.06
Boston       14916 22.54
Charlotte    23901 17
Chicago      18404 21.98
Cleveland    16969 19.63
Dallas       16868 17.05
Denver       12668 17.4
Detroit      21454 24.42
Golden State 15025 17.04
Houston      15846 17.56
Indiana      12885 13.77
LA Clippers  11869 21.95
LA Lakers    17378 29.18
Miami        15008 17.6
Milwaukee    16088 14.08
Minnesota    26160 10.92
New Jersey   12160 13.31
New York     17815 22.7
Orlando      15606 20.47
Philadelphia 14017 19.04
Phoenix      14114 16.59
Portland     12884 22.19
Sacramento   17014 16.96
San Antonio  14722 16.79
Seattle      12244 18.11
Utah         12616 18.41
Washington   11565 14.55
;

run;

/* print the data out */
proc print data=hw1.q1a label;
label Price="Price ($)";
var Team;  var Attendance / style=[just=center];  var Price;
footnote1 " 30Aug2015      csulb-stats475      hw1-prob1(a)     lincramp10"; 
title 'NBA Attendance and Ticket Prices (1989-1990 season)';
run;

libname hw1 '/folders/myfolders/hw1/';
proc import datafile="/folders/myfolders/hw1/NBA.xls" 
			out=hw1.q1cNBA
        	dbms=xls replace;
        	getnames=yes;  /* headers */
run;

/* see what was really read in */
proc contents data=hw1.q1cNBA ;

/* print the output nicely */
proc print data=hw1.q1cNBA NOOBS label;
	format Price dollar6.2;
	var Team / style(data)={just=l} style(header)={background=yellow};
	var Attendance / style(data)={just=c} style(header)={background=yellow};
	var Price / style(data)={TAGATTR='format:0.00'} style(header)={background=yellow}; 
	label   Price='Price ($)'; /* redundant because data output in dollar format */
	title 'NBA Attendance and Ticket Prices (1989-1990 season)';
	footnote1 "HW1 Problem 1c";
	footnote2 "Stats 475 CSULB Prof. Korosteleva";
	footnote3 "Lin Crampton           &sysdate9 &systime";
run;

libname hw1 '/folders/myfolders/hw1/';  
 /* working directory is ~/SAS/SASUniversity/myfolders/hw1 */

/* read in the data for HW1, Exercise 2, Stats 475 CSULB */

data hw1.ex2;

	do counter=1 to 26; Response='yes'; Group='surgical'; output; end;
	do counter=1 to 19; Response='yes'; Group='nonsurgical'; output; end;
	do counter=1 to 1260; Response='no'; Group='surgical'; output; end;
	do counter=1 to 802; Response='no'; Group='nonsurgical'; output; end;


/* print the entire dataset */
proc print data=hw1.ex2;
	title "Table of Group by Response";
run;

/* using contents to figure out what loaded in */
proc contents data=hw1.ex2; run;

/* printing last 10 observations  because I cannot figure out how to grab them from the screen */
data last10;
do j=obs-9 to obs;
   set hw1.ex2 nobs=obs point=j;
   output;
end;
stop;
run;

proc print data= last10;
title "Table of Group by response - Last 10";
run;

/* frequency table */
proc freq data=hw1.ex2 order=data;
	tables Group*Response / norow nocol nopercent;
	title "Frequency Table Output";
run;


