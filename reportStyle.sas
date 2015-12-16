/****                         Exercise2       Stats475    ladCrampton                                ****/
/* ColumnLabels in Exam_Ex2.xls (input file) modified to ensure compliance with SAS */
/*	'State Name' -> 'StateName'
	'State Abbrev.' -> 'StateAbbrev'
	'Postal Abbrev.' -> 'PostalAbbrev'
	'Area (Sq Mi)' -> 'AreaSqMi'                                   */
	
libname hw2 '/folders/myfolders/hw2/';  /* helps to remember where stuff saved */

/** must use proc import (rather than libfilename) because on a linux system **/
proc import 
	datafile="/folders/myfolders/hw2/Exam_Ex2.xls" 
	out=hw2.ex2
	dbms=xls 
	replace;
   	getnames=yes;  /* headers */
run;

options nonumber nodate;

ods rtf close;
ods rtf file='/folders/myfolders/hw2/hw2bigHeadSkip.rtf' /* rtf is viewable in word */
	author='Lin'; 

proc report data=hw2.ex2 nowd headline headskip out=x
style(report)=[cellspacing=0 
	borderwidth=0 borderleftwidth=0 borderrightwidth=0
	borderrightcolor=white borderleftcolor=white bordertopcolor=white 
	borderbottomcolor=black]
style(header)=[ color=black 
	fontfamily=helvetica fontweight=bold fontsize=3 
	borderrightcolor=white borderleftcolor=white bordertopcolor=white
	borderbottomcolor=black borderbottomwidth=2];          
column StateName StateAbbrev PostalAbbrev AreaSqMi Population;
  define StateName / '/State Name' width=20 left
   	style=[just=left]
  	style(column)=[borderleftcolor=white borderrightcolor=white borderbottomcolor=white
		fontweight=medium fontsize=2 cellheight=.17in vjust=m
		PROTECTSPECIALCHARS=off]
  	style(header)=[background=white just=left];
  define StateAbbrev / 'State/Abbrev.' width=10 center
   	style(column)=[borderrightcolor=white borderbottomcolor=white
		PROTECTSPECIALCHARS=off]
  	style(header)=[background=white];
  define PostalAbbrev / 'Postal/Abbrev.' width=15 center
   	style(column)=[borderrightcolor=white borderbottomcolor=white cellwidth=10%
		PROTECTSPECIALCHARS=off]
  	style(header)=[background=white];
  define AreaSqMi / 'Area / (Sq Mi)' width=8 right
   	style(column)=[borderrightcolor=white borderbottomcolor=white width=10%
		PROTECTSPECIALCHARS=off]
  	style(header)=[background=white]
  	format=comma11.;
  define Population / '/Population' width=20 right
   	style(column)=[borderrightcolor=white borderbottomcolor=white cellwidth=1in
		PROTECTSPECIALCHARS=off]  /* helps with spacing */
  	style(header)=[background=white]
  	format=comma15.;	
  		  		
  compute before  / /* headskip not working in rtf proc report */
        	style=[fontstyle=roman fontsize=2 cellspacing=0 framespacing=0 backgroundcolor=white 
          		borderrightcolor=white borderbottomcolor=white borderleftcolor=white 
      		color=white];
			line '';
endcomp;
run;
ods rtf close;
