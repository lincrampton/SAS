libname midterm '/folders/myfolders/midterm';  /*where the code&data live */

/****** data input *******/
data knees_wide;
	input ID$ 1-2 KneeNum$ 4 PreOp  Day1  Week1  Month1;
	datalines;
01 1 0   5  7 10
02 1 0  10 15 15
02 2 3   5  8 10
03 1 0   3  3  3
03 2 0   6  9  9
04 1 0   4 10 10
; 
run;

/****** Exercise 3a *******/
data knee1 (keep=ID Visit Score);
	set knees_wide;
  		array kneeScore{4}_numeric_;
    		if (kneeNum=1) then do Visit=1 to 4;
					Score=kneeScore{Visit};
	 		output;
	 		by ID;
		end;
run;

/****** Exercise 3b *******/
data knee2 (keep=ID Visit Score);
	set knees_wide;
  		array kneeScore{4}_numeric_;
    		if (kneeNum=2) then do Visit=1 to 4;
					Score=kneeScore{Visit};
	 		output;
	 		by ID;
		end;
run;

