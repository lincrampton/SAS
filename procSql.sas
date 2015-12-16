%let myFolder = %str(/folders/myfolders/Final);

libname Final "&myFolder";

%macro readXlsx(dFileOut, xlsxFileIn);  /* read xlsx file in */
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

%macro prFirstLastN(inFile, numObs);  /* print first N and last N observations */
data _null_;
  if 0 then set &inFile nobs=totobs; 
  call symputx('start',put(totobs-&numObs+1,15.));
  stop;
run;
proc print data=&inFile (obs=&numObs); run; title1;
proc print data=&inFile (firstobs=&start); run;
%mend prFirstLastN;

%readXlsx(ex1data, SnowStationsData.xlsx)
/*
/* 1. How many lines does the file contain? */
title1 'Number of lines in file';
proc sql noprint;
   select count(*) 
   into : numObs
   from ex1data;
quit;
%put 'Observations in data set:' &numObs;

proc sql;
 create table ex1table as
 select STATION_ID, STATION_NAME, REGION, YEAR, YEAR_RECORD_BEGAN, YEAR_RECORD_ENDS, LATITUDE, LONGITUDE, 
 VAR4 as SWE,
 ELEVATION_IN_FEET_ as ELEVATION
 from ex1data;
 describe table ex1table;
quit;
proc sql;
	describe table ex1table;
quit;

/* How many different snow stations are the data given for? */
proc sql noprint;
title1 'Number of different snow stations';
	select count(unique(STATION_NAME)) into : numStations
from ex1table;
quit;
%put 'Unique Stations:' &numStations;

/* How many years have been the data recorded for each station? */
title1 'Years per Station';
proc sql /*outobs=10*/ noprint ;
create table yearsPerStation as 
	select STATION_NAME, count(YEAR) as YearCount
	from ex1table
	group by STATION_NAME
	order by STATION_NAME
	;
quit;
%prFirstLastN(yearsPerStation,10);

/* 5. Make an ordered list of years and give the number of stations that had measurements that year. */
title1 'Number of Stations Each Year';
proc sql ;
	create table stationsPerYear as
	select YEAR, count(unique(STATION_NAME)) as StationCount
	from ex1table
	group by YEAR
	order by YEAR
	;
quit;
%prFirstLastN(stationsPerYear,10);

/* Compute the highest value of max_SWE for each station. (Note: max_SWE=maximum annual Snow Water Equivalent). Order by station name. */
title1 'Highest MAX_SWE per Station';
proc sql;
	create table maxSWEper as
		select STATION_NAME, /*max(VAR4) as */ MAX(SWE) as MAX_SWE 'Max Snow Water Equivalent'
		from ex1table
		group by STATION_NAME
		order by STATION_NAME
		;
quit;
%prFirstLastN(maxSWEper,10);

/* 7. You might have noticed by now that a station name ‘ADIN MOUNTAIN’
is misspelled as ‘ADIN MOUTAIN’. Fix this typo (Hint: use a data step). */

data ex1table;
	set ex1table;
	STATION_NAME=tranwrd(STATION_NAME, "ADIN MOUTAIN", "ADIN MOUNTAIN");
run;

/* 8. How many different regions are involved in snow data collection? */
proc sql;
title1 'Number of Levels of Categorical Variable REGION';
select count(unique(REGION)) as numRegions
from ex1table;
quit;

/*9. How many stations are there in each region? */
title1 "Number of Stations in Each Region ";
proc sql ;
	select REGION, count(unique(STATION_NAME)) as NumStations
	from ex1table
	group by REGION
	order by REGION;
quit;

/*10. Create a data set that contains variables STATION_ID, STATION_NAME, TOTAL_MAX_SWE, REGION, ELEVATION, LATITUDE, and LONGITUDE, and which entries are the snow stations that had been in operation for the most recent 50 years (from 1963 to 2012). Take the stations that have records from 1963 to 2012, and compute the highest max_SWE values
 (call them TOTAL_MAX_SWE) over the duration of these 50 years.*/
title1 'Total Max SWE for Stations with Records from 1963-2012';
*proc contents data=ex1table; run; 
proc sql;
	create table ex10 as
	select STATION_NAME, STATION_ID, MAX(SWE) as TOTAL_MAX_SWE, 
		REGION, ELEVATION, LATITUDE, LONGITUDE
	from ex1table
	where	YEAR_RECORD_BEGAN <= 1963 and
			YEAR_RECORD_ENDS >= 2012
	group by STATION_NAME
	order by STATION_NAME
	;
quit;

proc sql;
	create table uniqueStations as select distinct (STATION_NAME), STATION_ID, REGION, TOTAL_MAX_SWE, 
		ELEVATION, LATITUDE, LONGITUDE 
	from ex10
	;
quit;
%prFirstLastN(uniqueStations,10);
