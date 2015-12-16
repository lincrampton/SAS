
libname midterm '/folders/myfolders/midterm';
/********* Fibonacci Calculations***********/   
data fibonacci;
n = 0;
fibo = 0;
fiboWorking = 1;
do while (newFibo < 1000);
	newFibo=fiboWorking + fibo;
	fibo=fiboWorking;
	fiboWorking=newFibo;
	n=n+1;
	output;
end;
run;

/************ format4print ******************/
title1 'Fibonacci Less Than 1K';
footnote1 font=arial height=8pt color=blue "Stats 475 - CSULB - Prof. Korosteleva";
footnote2 font=arial height=8pt color=blue "Lin Crampton           &sysdate9 &systime";
footnote3 font=arial height=8pt color=blue "Exercise 2.5 Fall 2015 Midterm";

/************* printing ********************/
proc print data=fibonacci noobs label; 
var n / style(header)={background=yellow};
var fibo / style(data)=[just=c] style(header)={background=yellow} ;
label fibo="Fibonacci";
run;
/************* housekeeping ****************/
title1;
footnote1;
