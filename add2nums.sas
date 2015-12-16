/* compute sum of two numbers */
%let assignment= HW5;     
%let myFullName= Lin Crampton;
%let myLastName= %scan(&myFullName,2);

title1 "Add Two Numbers";
footnote1 font=Arial height=8pt "SAS475 &assignment, Exercise 1.";
footnote2 font=Arial height=8pt "Assignment is completed by &myLastName";
footnote3 font=Arial height=8pt "SAS Session initiated on  &sysday, &sysdate9, at &systime UTC.";

%macro addNums(a, b);
data _null_ ;
file print ;
	%let y=%sysevalf(&a+&b); 
	
	/* values to logfile */
	%put Calculating &a + &b;
	%put Using a plain SYSEVALF: &y;
	%put SYSEVALF with an INTEGER option: %sysevalf(&a +&b, integer);
	%put SYSEVALF using a BOOLEAN option: %sysevalf(&a +&b, boolean);
	%put SYSEVALF using a CEIL: %sysevalf(&a +&b, ceil), or FLOOR option: %sysevalf(&a +&b, floor);
	
	/* printing values to output window */
	put "Calculating &a + &b";
	put +5 "Using a plain SYSEVALF: &y";
	put +5 "SYSEVALF with an INTEGER option: %sysevalf(&a +&b, integer)";
	put +5 "SYSEVALF using a BOOLEAN option: %sysevalf(&a +&b, boolean)";
	put +5 "SYSEVALF using a CEIL: %sysevalf(&a +&b, ceil), or FLOOR option: %sysevalf(&a +&b, floor)";
stop;
run;
%mend addNums;
%addNums(1,1)  /* add whatever numbers you want to add */



