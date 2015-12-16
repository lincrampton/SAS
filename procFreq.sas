libname midterm '/folders/myfolders/midterm';  /* data lives here*/
/* yellow and blue template */
proc template;
        define style Styles.yellowNblueborder;
        parent = Styles.Default;
        style Table from Output /
         cellpadding = 5
         borderspacing = 2
         bordercolordark = blue
         bordercolorlight = yellow
         borderwidth = 4;
     end;
run;

/* read in data and validate */
data midterm.ex2;
	infile "/folders/myfolders/midterm/Exam_Ex2.dat" FIRSTOBS=2;
	input @1 ID $3. typeA $4. typeB$;
	ID=ID;
run;
proc print data=midterm.ex2 noobs;
	title1 'just the data';
run;

/* format for output */
title1 'Frequency Tables A v B';
footnote1 font=arial height=8pt color=blue "Exercise 2 Fall 2015 Midterm";
footnote2 font=arial height=8pt color=blue "Stats 475 CSULB Prof. Korosteleva";
footnote3 font=arial height=8pt color=blue "Lin Crampton           &sysdate9 &systime";

/* write to both hmtl and rtf */
ods html file='/folders/myfolders/midterm/Exam_Ex2.html' style=yellowNblueborder;
ods rtf file='/folders/myfolders/midterm/Exam_Ex2.rtf' style=yellowNblueborder;

/*****************************************************************************/
/********* frequency tables necessary to answer midterm questions *********/
proc freq data=midterm.ex2;
   tables typeB*typeA / out=xlistAvB crosslist;
run;
proc print data=xlistAvB noobs; 
	title1 'TypeA vs TypeB Freq Table'; 
run;
/****** end frequency tables necessary to answer midterm questions *********/
/******************************************************************************/

/* housekeeping */
ods html close;
ods rtf close;
title1;
footnote1;
