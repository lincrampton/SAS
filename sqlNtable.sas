bname HW4 "&myfolder";
%let dfilein=%str(&myfolder/glaucoma.xls);

%macro document(exTitle, exNum);  /* headers/footers for each section */
	title1 underlin=1 "&exTitle";
	footnote1 font=Arial height=8pt "Stats475 CSULB Prof. Korosteleva";
	footnote2 font=Arial height=8pt "Lin Crampton     HW4      &sysdate9 &systime";
	footnote3 font=Arial height=8pt "&exNum";
%mend;

/* file structure:  ID Group NumberMeds PrevMedTim Sex Age GlaucomaType*/
proc import datafile="&dfilein"
	dbms=xls
	out=glaucomaX; /*glaucoma from Xls */
run;

proc sql;
	create table glauco as
		select ID, 
			NumberMeds, 
			PrevMedTim, 
			Sex, 
			Age, 
			GlaucomaType
		from glaucomaX
			where group='Tx'  /* only choosing treatment group */
		;
quit;

/*(a) How many patients were in the study? */
%document(Number of Patients, Exercise 2(a));
proc sql feedback;
        select count(distinct ID) as Total
        from glauco
        ;
quit;

/*(b) How many patients were currently on medication? How many were 
currently off medication or medication-naïve (never took medication)?*/
%document(Patients on Meds, Exercise 2(b)Part 1);
proc sql;
	create table glauOnMeds as
		select Count(distinct ID) as OnMeds
		from glaucomaX
		where Group='Tx' and NumberMeds>0
		;
quit;
proc print data=glauOnMeds noobs;run;

%document(Patients NO Meds, Exercise 2(b)Part 2);
proc sql;
	create table glauNoMeds as
		select Count(distinct ID) as NOmeds
		from glaucomaX
		where Group='Tx' and NumberMeds<1
		;
quit;
proc print data=glauNoMeds noobs;run;

/*(c) What were the mean, standard deviation, min, and max of the time
previously on medication? Exclude medication-naïve patients. */
%document (Mean StdDev Min Max of Time on Medication, Exercise 2(c));
proc sql outobs=1;
	create table glauMeds (drop=ID NumberMeds PrevMedTim) as
		select 
			avg(PrevMedTim) as meanMedTime,
			std(PrevMedTim) as stdDevMedTime,
			max(PrevMedTim) as maxMedTime,
			min(PrevMedTim) as minMedTime
		from glaucomaX
		where Group='Tx' and NumberMeds>0
		;
quit;
proc print data=glauMeds noobs; run;

/*(d) How many males and how many females were in the study? */
%document(Distribution of Males/Females in Study, Exercise 2(d));
proc sql;
   select 
   		sum(case when Sex = "M" then 1 else 0 end) as Male,
   		sum(case when Sex = "F" then 1 else 0 end) as Female
      from glauco
      ;
quit;
/*(e) How many patients were in the study by type of glaucoma? */
%document(Patients - by Type of Glaucoma, Exercise 2(e));
proc sql;
	select GlaucomaType,
	count (*) as Number
	from glauco
	group by GlaucomaType
	order by GlaucomaType
	;
quit;

/*(f) What was the mean age by gender and type of glaucoma? */
%document(Mean Age by Gender and Glaucoma Type, Exercise 2(f));
proc tabulate data=glauco;
	class Sex GlaucomaType;
	var Age;
	table Sex*GlaucomaType, Age*(n mean min max);
	keylabel n='Number'
 		mean='Average'
 		min='Minimum'
 		max='Maximum';
run;  
title1;
