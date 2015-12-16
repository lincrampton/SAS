%let myFolder = %str(/folders/myfolders/Final);
libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);
	%let dfilein=%str(&myFolder/&xlsxFileIn);
	proc import 
	datafile="&dfileIn" 
    out=&dFileOut
    dbms=xlsx 
    replace;
    getnames=yes; 
    run;
    proc contents data = &dFileOut; run;
%mend readXlsx;

%macro obscnt(dsn);		/* count observations in dataset */
	%local nobs dsnid;
	%let nobs=.;=
	%let dsnid = %sysfunc(open(&dsn));
	%if &dsnid %then %do;
		%let nobs=%sysfunc(attrn(&dsnid,nlobs));
		%let rc  =%sysfunc(close(&dsnid));
	%end;
	%else %do;
		%put Unable to open &dsn - %sysfunc(sysmsg());
	%end;
	&nobs
%mend obscnt;

/* import SurveyResults.xlsx into SurveyR */
%readXlsx(SurveyR, SurveyResults.xlsx)

/* import APIs.xlsx into APIs */
%readXlsx(APIs, APIs.xlsx)

/* merge APIs into SurveyResults pivoting on SchoolName */
/* remove entries where Q1 value missing */
/* check to ensure 347 observations */
proc sort data=APIs; 	/* sort b4 merge */
  by SchoolName; 
run; 
proc sort data=SurveyR; /* sort b4 merge */
  by SchoolName; 
run; 

data ex2df ; 	/* merge sorted data into exercise1 datafila */ 
	merge SurveyR APIs; 
	BY SchoolName;
	if q1 = . then delete;
	 
	newQ2 = input(q2,8.0);   /* q2 needs to be numeric */
	drop q2; 
	rename newQ2=q2;

	/*q3ah = mean(OF q3a-q3h);*/ /* not working */
	q3ah=mean(q3a,q3b,q3c,q3d,q3e,q3f,q3g,q3h);
	/* q8ae = mean(OF q8a-q8e); */ /* my SAS 9.4 spits up on this */
	q8ae = mean(q8a,q8b,q8c,q8d,q8e);
	rcq4 = 4 - q4;
	rcq7 = 4 - q7;
run; 

proc contents data=ex2df;run;
%put number of obs is %obscnt(ex2df);

proc iml;
	use ex2df;
	read all ;
	show names;

	/* impute three missing values for q2 by mean of column */
	q2mean=q2[:];
	l=loc(q2=.);

	do i=1 to ncol(l);
		q2(|l[i]|)= q2mean;
	end;
	print q2 q2mean; 

	/* compute Total=q1+q2+mean(OF q3a-q3h)+reverse-coded-q4+a5+q6+reverseCodedq7+mean(OF q8a-q8e) */
	Total=q1 + q2 + q3ah + rcq4 + q5 + q6 + rcq7 + q8ae;
	show names;
	
	/* plot total v API */
	title1 "Total v API";
	options nonumber nodate;
	ods rtf file = "&myfolder/ex2.rtf";
	ods pdf file = "&myfolder/ex2.pdf";
	run Scatter(Total, API)  
		option="markerattrs=(symbol=DiamondFilled color=blue size=4)"  
		group=Origin
		label={"Total" "API"}
		procopt="noautolegend"    /* proc option */
		;
	ods pdf close; ods rtf close;
	
	title1 'Totals';
	print Total;
	title1;
	
	create ex2mat var {SchoolName API Total}; /** exercise1 matrix **/
	append;       /** write data in vectors **/
	close ex2mat; /** close the data set **/
	
	close ex2df;  /* close the datafile */
	title1;
quit;

/* print SchoolName, API and Total for top 10 schools */
title1 'Top 10 Schools with Highest API Scores'; 
proc sort data=ex2mat out=sorted;
by descending API;
run;
proc print data=sorted (obs=10) noobs;  run;

title1;
%let myFolder = %str(/folders/myfolders/Final);
libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);
	%let dfilein=%str(&myFolder/&xlsxFileIn);
	proc import 
	datafile="&dfileIn" 
    out=&dFileOut
    dbms=xlsx 
    replace;
    getnames=yes; 
    run;
    proc contents data = &dFileOut; run;
%mend readXlsx;

%macro obscnt(dsn);		/* count observations in dataset */
	%local nobs dsnid;
	%let nobs=.;=
	%let dsnid = %sysfunc(open(&dsn));
	%if &dsnid %then %do;
		%let nobs=%sysfunc(attrn(&dsnid,nlobs));
		%let rc  =%sysfunc(close(&dsnid));
	%end;
	%else %do;
		%put Unable to open &dsn - %sysfunc(sysmsg());
	%end;
	&nobs
%mend obscnt;

/* import SurveyResults.xlsx into SurveyR */
%readXlsx(SurveyR, SurveyResults.xlsx)

/* import APIs.xlsx into APIs */
%readXlsx(APIs, APIs.xlsx)

/* merge APIs into SurveyResults pivoting on SchoolName */
/* remove entries where Q1 value missing */
/* check to ensure 347 observations */
proc sort data=APIs; 	/* sort b4 merge */
  by SchoolName; 
run; 
proc sort data=SurveyR; /* sort b4 merge */
  by SchoolName; 
run; 

data ex2df ; 	/* merge sorted data into exercise1 datafila */ 
	merge SurveyR APIs; 
	BY SchoolName;
	if q1 = . then delete;
	 
	newQ2 = input(q2,8.0);   /* q2 needs to be numeric */
	drop q2; 
	rename newQ2=q2;

	/*q3ah = mean(OF q3a-q3h);*/ /* not working */
	q3ah=mean(q3a,q3b,q3c,q3d,q3e,q3f,q3g,q3h);
	/* q8ae = mean(OF q8a-q8e); */ /* my SAS 9.4 spits up on this */
	q8ae = mean(q8a,q8b,q8c,q8d,q8e);
	rcq4 = 4 - q4;
	rcq7 = 4 - q7;
run; 

proc contents data=ex2df;run;
%put number of obs is %obscnt(ex2df);

proc iml;
	use ex2df;
	read all ;
	show names;

	/* impute three missing values for q2 by mean of column */
	q2mean=q2[:];
	l=loc(q2=.);

	do i=1 to ncol(l);
		q2(|l[i]|)= q2mean;
	end;
	print q2 q2mean; 

	/* compute Total=q1+q2+mean(OF q3a-q3h)+reverse-coded-q4+a5+q6+reverseCodedq7+mean(OF q8a-q8e) */
	Total=q1 + q2 + q3ah + rcq4 + q5 + q6 + rcq7 + q8ae;
	show names;
	
	/* plot total v API */
	title1 "Total v API";
	options nonumber nodate;
	ods rtf file = "&myfolder/ex2.rtf";
	ods pdf file = "&myfolder/ex2.pdf";
	run Scatter(Total, API)  
		option="markerattrs=(symbol=DiamondFilled color=blue size=4)"  
		group=Origin
		label={"Total" "API"}
		procopt="noautolegend"    /* proc option */
		;
	ods pdf close; ods rtf close;
	
	title1 'Totals';
	print Total;
	title1;
	
	create ex2mat var {SchoolName API Total}; /** exercise1 matrix **/
	append;       /** write data in vectors **/
	close ex2mat; /** close the data set **/
	
	close ex2df;  /* close the datafile */
	title1;
quit;

/* print SchoolName, API and Total for top 10 schools */
title1 'Top 10 Schools with Highest API Scores'; 
proc sort data=ex2mat out=sorted;
by descending API;
run;
proc print data=sorted (obs=10) noobs;  run;

title1;
%let myFolder = %str(/folders/myfolders/Final);
libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);
	%let dfilein=%str(&myFolder/&xlsxFileIn);
	proc import 
	datafile="&dfileIn" 
    out=&dFileOut
    dbms=xlsx 
    replace;
    getnames=yes; 
    run;
    proc contents data = &dFileOut; run;
%mend readXlsx;

%macro obscnt(dsn);		/* count observations in dataset */
	%local nobs dsnid;
	%let nobs=.;=
	%let dsnid = %sysfunc(open(&dsn));
	%if &dsnid %then %do;
		%let nobs=%sysfunc(attrn(&dsnid,nlobs));
		%let rc  =%sysfunc(close(&dsnid));
	%end;
	%else %do;
		%put Unable to open &dsn - %sysfunc(sysmsg());
	%end;
	&nobs
%mend obscnt;

/* import SurveyResults.xlsx into SurveyR */
%readXlsx(SurveyR, SurveyResults.xlsx)

/* import APIs.xlsx into APIs */
%readXlsx(APIs, APIs.xlsx)

/* merge APIs into SurveyResults pivoting on SchoolName */
/* remove entries where Q1 value missing */
/* check to ensure 347 observations */
proc sort data=APIs; 	/* sort b4 merge */
  by SchoolName; 
run; 
proc sort data=SurveyR; /* sort b4 merge */
  by SchoolName; 
run; 

data ex2df ; 	/* merge sorted data into exercise1 datafila */ 
	merge SurveyR APIs; 
	BY SchoolName;
	if q1 = . then delete;
	 
	newQ2 = input(q2,8.0);   /* q2 needs to be numeric */
	drop q2; 
	rename newQ2=q2;

	/*q3ah = mean(OF q3a-q3h);*/ /* not working */
	q3ah=mean(q3a,q3b,q3c,q3d,q3e,q3f,q3g,q3h);
	/* q8ae = mean(OF q8a-q8e); */ /* my SAS 9.4 spits up on this */
	q8ae = mean(q8a,q8b,q8c,q8d,q8e);
	rcq4 = 4 - q4;
	rcq7 = 4 - q7;
run; 

proc contents data=ex2df;run;
%put number of obs is %obscnt(ex2df);

proc iml;
	use ex2df;
	read all ;
	show names;

	/* impute three missing values for q2 by mean of column */
	q2mean=q2[:];
	l=loc(q2=.);

	do i=1 to ncol(l);
		q2(|l[i]|)= q2mean;
	end;
	print q2 q2mean; 

	/* compute Total=q1+q2+mean(OF q3a-q3h)+reverse-coded-q4+a5+q6+reverseCodedq7+mean(OF q8a-q8e) */
	Total=q1 + q2 + q3ah + rcq4 + q5 + q6 + rcq7 + q8ae;
	show names;
	
	/* plot total v API */
	title1 "Total v API";
	options nonumber nodate;
	ods rtf file = "&myfolder/ex2.rtf";
	ods pdf file = "&myfolder/ex2.pdf";
	run Scatter(Total, API)  
		option="markerattrs=(symbol=DiamondFilled color=blue size=4)"  
		group=Origin
		label={"Total" "API"}
		procopt="noautolegend"    /* proc option */
		;
	ods pdf close; ods rtf close;
	
	title1 'Totals';
	print Total;
	title1;
	
	create ex2mat var {SchoolName API Total}; /** exercise1 matrix **/
	append;       /** write data in vectors **/
	close ex2mat; /** close the data set **/
	
	close ex2df;  /* close the datafile */
	title1;
quit;

/* print SchoolName, API and Total for top 10 schools */
title1 'Top 10 Schools with Highest API Scores'; 
proc sort data=ex2mat out=sorted;
by descending API;
run;
proc print data=sorted (obs=10) noobs;  run;

title1;
%let myFolder = %str(/folders/myfolders/Final);
libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);
	%let dfilein=%str(&myFolder/&xlsxFileIn);
	proc import 
	datafile="&dfileIn" 
    out=&dFileOut
    dbms=xlsx 
    replace;
    getnames=yes; 
    run;
    proc contents data = &dFileOut; run;
%mend readXlsx;

%macro obscnt(dsn);		/* count observations in dataset */
	%local nobs dsnid;
	%let nobs=.;=
	%let dsnid = %sysfunc(open(&dsn));
	%if &dsnid %then %do;
		%let nobs=%sysfunc(attrn(&dsnid,nlobs));
		%let rc  =%sysfunc(close(&dsnid));
	%end;
	%else %do;
		%put Unable to open &dsn - %sysfunc(sysmsg());
	%end;
	&nobs
%mend obscnt;

/* import SurveyResults.xlsx into SurveyR */
%readXlsx(SurveyR, SurveyResults.xlsx)

/* import APIs.xlsx into APIs */
%readXlsx(APIs, APIs.xlsx)

/* merge APIs into SurveyResults pivoting on SchoolName */
/* remove entries where Q1 value missing */
/* check to ensure 347 observations */
proc sort data=APIs; 	/* sort b4 merge */
  by SchoolName; 
run; 
proc sort data=SurveyR; /* sort b4 merge */
  by SchoolName; 
run; 

data ex2df ; 	/* merge sorted data into exercise1 datafila */ 
	merge SurveyR APIs; 
	BY SchoolName;
	if q1 = . then delete;
	 
	newQ2 = input(q2,8.0);   /* q2 needs to be numeric */
	drop q2; 
	rename newQ2=q2;

	/*q3ah = mean(OF q3a-q3h);*/ /* not working */
	q3ah=mean(q3a,q3b,q3c,q3d,q3e,q3f,q3g,q3h);
	/* q8ae = mean(OF q8a-q8e); */ /* my SAS 9.4 spits up on this */
	q8ae = mean(q8a,q8b,q8c,q8d,q8e);
	rcq4 = 4 - q4;
	rcq7 = 4 - q7;
run; 

proc contents data=ex2df;run;
%put number of obs is %obscnt(ex2df);

proc iml;
	use ex2df;
	read all ;
	show names;

	/* impute three missing values for q2 by mean of column */
	q2mean=q2[:];
	l=loc(q2=.);

	do i=1 to ncol(l);
		q2(|l[i]|)= q2mean;
	end;
	print q2 q2mean; 

	/* compute Total=q1+q2+mean(OF q3a-q3h)+reverse-coded-q4+a5+q6+reverseCodedq7+mean(OF q8a-q8e) */
	Total=q1 + q2 + q3ah + rcq4 + q5 + q6 + rcq7 + q8ae;
	show names;
	
	/* plot total v API */
	title1 "Total v API";
	options nonumber nodate;
	ods rtf file = "&myfolder/ex2.rtf";
	ods pdf file = "&myfolder/ex2.pdf";
	run Scatter(Total, API)  
		option="markerattrs=(symbol=DiamondFilled color=blue size=4)"  
		group=Origin
		label={"Total" "API"}
		procopt="noautolegend"    /* proc option */
		;
	ods pdf close; ods rtf close;
	
	title1 'Totals';
	print Total;
	title1;
	
	create ex2mat var {SchoolName API Total}; /** exercise1 matrix **/
	append;       /** write data in vectors **/
	close ex2mat; /** close the data set **/
	
	close ex2df;  /* close the datafile */
	title1;
quit;

/* print SchoolName, API and Total for top 10 schools */
title1 'Top 10 Schools with Highest API Scores'; 
proc sort data=ex2mat out=sorted;
by descending API;
run;
proc print data=sorted (obs=10) noobs;  run;

title1;
%let myFolder = %str(/folders/myfolders/Final);
libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);
	%let dfilein=%str(&myFolder/&xlsxFileIn);
	proc import 
	datafile="&dfileIn" 
    out=&dFileOut
    dbms=xlsx 
    replace;
    getnames=yes; 
    run;
    proc contents data = &dFileOut; run;
%mend readXlsx;

%macro obscnt(dsn);		/* count observations in dataset */
	%local nobs dsnid;
	%let nobs=.;=
	%let dsnid = %sysfunc(open(&dsn));
	%if &dsnid %then %do;
		%let nobs=%sysfunc(attrn(&dsnid,nlobs));
		%let rc  =%sysfunc(close(&dsnid));
	%end;
	%else %do;
		%put Unable to open &dsn - %sysfunc(sysmsg());
	%end;
	&nobs
%mend obscnt;

/* import SurveyResults.xlsx into SurveyR */
%readXlsx(SurveyR, SurveyResults.xlsx)

/* import APIs.xlsx into APIs */
%readXlsx(APIs, APIs.xlsx)

/* merge APIs into SurveyResults pivoting on SchoolName */
/* remove entries where Q1 value missing */
/* check to ensure 347 observations */
proc sort data=APIs; 	/* sort b4 merge */
  by SchoolName; 
run; 
proc sort data=SurveyR; /* sort b4 merge */
  by SchoolName; 
run; 

data ex2df ; 	/* merge sorted data into exercise1 datafila */ 
	merge SurveyR APIs; 
	BY SchoolName;
	if q1 = . then delete;
	 
	newQ2 = input(q2,8.0);   /* q2 needs to be numeric */
	drop q2; 
	rename newQ2=q2;

	/*q3ah = mean(OF q3a-q3h);*/ /* not working */
	q3ah=mean(q3a,q3b,q3c,q3d,q3e,q3f,q3g,q3h);
	/* q8ae = mean(OF q8a-q8e); */ /* my SAS 9.4 spits up on this */
	q8ae = mean(q8a,q8b,q8c,q8d,q8e);
	rcq4 = 4 - q4;
	rcq7 = 4 - q7;
run; 

proc contents data=ex2df;run;
%put number of obs is %obscnt(ex2df);

proc iml;
	use ex2df;
	read all ;
	show names;

	/* impute three missing values for q2 by mean of column */
	q2mean=q2[:];
	l=loc(q2=.);

	do i=1 to ncol(l);
		q2(|l[i]|)= q2mean;
	end;
	print q2 q2mean; 

	/* compute Total=q1+q2+mean(OF q3a-q3h)+reverse-coded-q4+a5+q6+reverseCodedq7+mean(OF q8a-q8e) */
	Total=q1 + q2 + q3ah + rcq4 + q5 + q6 + rcq7 + q8ae;
	show names;
	
	/* plot total v API */
	title1 "Total v API";
	options nonumber nodate;
	ods rtf file = "&myfolder/ex2.rtf";
	ods pdf file = "&myfolder/ex2.pdf";
	run Scatter(Total, API)  
		option="markerattrs=(symbol=DiamondFilled color=blue size=4)"  
		group=Origin
		label={"Total" "API"}
		procopt="noautolegend"    /* proc option */
		;
	ods pdf close; ods rtf close;
	
	title1 'Totals';
	print Total;
	title1;
	
	create ex2mat var {SchoolName API Total}; /** exercise1 matrix **/
	append;       /** write data in vectors **/
	close ex2mat; /** close the data set **/
	
	close ex2df;  /* close the datafile */
	title1;
quit;

/* print SchoolName, API and Total for top 10 schools */
title1 'Top 10 Schools with Highest API Scores'; 
proc sort data=ex2mat out=sorted;
by descending API;
run;
proc print data=sorted (obs=10) noobs;  run;

title1;
%let myFolder = %str(/folders/myfolders/Final);
libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);
	%let dfilein=%str(&myFolder/&xlsxFileIn);
	proc import 
	datafile="&dfileIn" 
    out=&dFileOut
    dbms=xlsx 
    replace;
    getnames=yes; 
    run;
    proc contents data = &dFileOut; run;
%mend readXlsx;

%macro obscnt(dsn);		/* count observations in dataset */
	%local nobs dsnid;
	%let nobs=.;=
	%let dsnid = %sysfunc(open(&dsn));
	%if &dsnid %then %do;
		%let nobs=%sysfunc(attrn(&dsnid,nlobs));
		%let rc  =%sysfunc(close(&dsnid));
	%end;
	%else %do;
		%put Unable to open &dsn - %sysfunc(sysmsg());
	%end;
	&nobs
%mend obscnt;

/* import SurveyResults.xlsx into SurveyR */
%readXlsx(SurveyR, SurveyResults.xlsx)

/* import APIs.xlsx into APIs */
%readXlsx(APIs, APIs.xlsx)

/* merge APIs into SurveyResults pivoting on SchoolName */
/* remove entries where Q1 value missing */
/* check to ensure 347 observations */
proc sort data=APIs; 	/* sort b4 merge */
  by SchoolName; 
run; 
proc sort data=SurveyR; /* sort b4 merge */
  by SchoolName; 
run; 

data ex2df ; 	/* merge sorted data into exercise1 datafila */ 
	merge SurveyR APIs; 
	BY SchoolName;
	if q1 = . then delete;
	 
	newQ2 = input(q2,8.0);   /* q2 needs to be numeric */
	drop q2; 
	rename newQ2=q2;

	/*q3ah = mean(OF q3a-q3h);*/ /* not working */
	q3ah=mean(q3a,q3b,q3c,q3d,q3e,q3f,q3g,q3h);
	/* q8ae = mean(OF q8a-q8e); */ /* my SAS 9.4 spits up on this */
	q8ae = mean(q8a,q8b,q8c,q8d,q8e);
	rcq4 = 4 - q4;
	rcq7 = 4 - q7;
run; 

proc contents data=ex2df;run;
%put number of obs is %obscnt(ex2df);

proc iml;
	use ex2df;
	read all ;
	show names;

	/* impute three missing values for q2 by mean of column */
	q2mean=q2[:];
	l=loc(q2=.);

	do i=1 to ncol(l);
		q2(|l[i]|)= q2mean;
	end;
	print q2 q2mean; 

	/* compute Total=q1+q2+mean(OF q3a-q3h)+reverse-coded-q4+a5+q6+reverseCodedq7+mean(OF q8a-q8e) */
	Total=q1 + q2 + q3ah + rcq4 + q5 + q6 + rcq7 + q8ae;
	show names;
	
	/* plot total v API */
	title1 "Total v API";
	options nonumber nodate;
	ods rtf file = "&myfolder/ex2.rtf";
	ods pdf file = "&myfolder/ex2.pdf";
	run Scatter(Total, API)  
		option="markerattrs=(symbol=DiamondFilled color=blue size=4)"  
		group=Origin
		label={"Total" "API"}
		procopt="noautolegend"    /* proc option */
		;
	ods pdf close; ods rtf close;
	
	title1 'Totals';
	print Total;
	title1;
	
	create ex2mat var {SchoolName API Total}; /** exercise1 matrix **/
	append;       /** write data in vectors **/
	close ex2mat; /** close the data set **/
	
	close ex2df;  /* close the datafile */
	title1;
quit;

/* print SchoolName, API and Total for top 10 schools */
title1 'Top 10 Schools with Highest API Scores'; 
proc sort data=ex2mat out=sorted;
by descending API;
run;
proc print data=sorted (obs=10) noobs;  run;

title1;

