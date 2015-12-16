/* many thanks to Chris Yindra, C. Y. Training Associates for the paper on advanced macro techniques , which inspired this code */

libname Final '/folders/myfolders/Final';

data one;
input x;
cards;
1
2
3
;
data two;
input y$;
cards;
A
B
C
;
data three;
input z$;
cards;
a
b
c
;

options symbolgen mprintnest mlogic;

%let data1 = One;
%let data2 = Two;
%let data3 = Three;

%macro linprint(n,endnum);
	%do n = 1 %TO &endnum;
		%let procprint&n = %str(proc print data = &&data&n; run;);
 		title1 "This is data '&&data&n'";
		&&procprint&n
	%end;
%mend linprint;
%linprint(1,3)
