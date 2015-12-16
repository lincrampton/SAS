
/****                                         Midterm                                                 ****/
/* For the data set in file ‘Exam_Ex1.xls’, produce a report identical (data-wise) to the one stored in file ‘Report_Ex1.html’. */
/*                                                                                                                 */

libname midterm '/folders/myfolders/midterm/';  /* helps to remember where stuff saved */
options validvarname=any;
 
/** must use proc import (rather than libfilename) because on a linux system **/
proc import 
	datafile="/folders/myfolders/midterm/Exam_Ex1.xls" 
	out=midterm.ex1
	dbms=xls 
	replace;
	getnames=yes;  /* headers */
run;

/*****************************/
/****** Blue & Gold *******/ 
/******** Template ********/
proc template;
	define table base.template.table;
		cellstyle mod(_row_, 2) and
 			^(_style_ like '%Header') as {backgroundcolor=verylightblue},
 			^(mod(_row_, 2)) and
			^(_style_ like '%Header') as {backgroundcolor=yellow};
     end;
run;

/**************************/
/***** Proc Means *****/ 
/**************************/
options nonumber nodate;
title1 height=6pt "The SAS System";
footnote1 font=arial height=8pt color=blue "Stats 475 - CSULB - Prof. Korosteleva";
footnote2 font=arial height=8pt color=blue "Lin Crampton           &sysdate9 &systime";
footnote3 font=arial height=8pt color=blue "Exercise 1 Fall 2015 Midterm";

ods listing close;
ods html body='/folders/myfolders/midterm/crampton_ex1.html';

proc means n mean median std min max range data=midterm.ex1 maxdec=2;
class Group;
run;
ods html close;
ods listing;
proc contents data=midterm.ex1 ;
run;

