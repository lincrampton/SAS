 docvisits; 
input ID$ weekday$ score; 
cards; 
101 Monday 10 
101 Friday 15 
112 Tuesday 11 
123 Monday 9 
123 Tuesday 10 
 123 Friday 9 
104 Friday 23 
104 Saturday 20 
157 Tuesday 10 
157 Thursday 18 
157 Saturday 21 
; 
proc sql; /* (a) Compute the number of patients */ 
create table hw3q1a as
	select count(distinct ID) as patientCount
		from docvisits;
quit;
/*********************************************************************************************************************************************/

proc sql;  /* (b) List patient IDs and the total number of visits for each patient. */
	create table hw3q1b as
	select ID, count(ID) as Visits
		from docvisits
	group by ID;
quit;
/*********************************************************************************************************************************************/

proc sql;  /* (c) List days of week and total number of visits per day */
	create table hw3q1c as
	select weekday, count(weekday) as numOnDay
		from docVisits
		group by weekDay;
quit;
/*********************************************************************************************************************************************/



/********************************************** Printing in Halloweeen Colours **********************************************************/
ODS LISTING CLOSE;
ODS HTML BODY ='/folders/myfolders/HW3/hw31.html'; 
ODS RTF /*STYLE=Gears*/ FILE='/folders/myfolders/HW3/hw31.rtf'; 
ODS PDF FILE='/folders/myfolders/HW3/hw31.pdf';
title1 color=brown underlin=1 "Number of Patients";
footnote1 font=Arial height=8pt color=brown "Stats 475 CSULB Prof. Korosteleva";
footnote2 font=Arial height=8pt color=brown "Lin Crampton           &sysdate9 &systime";
footnote3 font=Arial height=8pt color=brown "Exercise 1a Fall 2015 HW3";
proc print data=hw3q1a 
	noobs /*style=gears */
	style(column)=[just=center color=brown bordercolor=Chartreuse] 
	style(header)=[just=center color=brown backgroundcolor = gold]
	style(header)={font_size=9pt cellheight=0.2in }
	label split='/';
label patientCount='Patients';
run;

title1 color=brown underlin=1'Visits Per Patient';
footnote3 font=Arial height=8pt color=brown "Exercise 1b Fall 2015 HW3";
proc print data=hw3q1b
	noobs 
	style(column)=[just=center color=brown bordercolor= Chartreuse] 
	style(header)=[just=center color=brown backgroundcolor = gold]
	style(header)={font_size=9pt cellheight=0.2in } ;
	/*label 
	split='/'; 
	label visitsPerPatient = 'Number of/Visits per Patient'; */
run;

title1 color=brown underlin=1 'Visits per Weekday';
footnote3 font=Arial height=8pt color=brown "Exercise 1c Fall 2015 HW3";
proc print data=hw3q1c
	noobs 
	/*style=gears */
	style(column)=[just=center color=brown bordercolor=Chartreuse] 
	style(header)=[just=center color=brown backgroundcolor = gold]
	style(header)={font_size=9pt cellheight=0.2in /* vjust=top */ } 
	label split='/';
label weekday='Day';
label numOnDay='Visits';
run;

/* housekeeping */
title;
footnote;
ODS _ALL_ CLOSE;
ODS LISTING; 
