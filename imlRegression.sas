proc iml;
	matX = {	1 -3,
				1  0,
				1  2,
				1  4,
				1  7};
	vecY = {	-2, 4, 8, 12, 18};
	betaVec =  inv(matX` * matX) * (matX` * vecY);   /* slope */
	vecYhat = matX * betaVec; 
	residVec = vecY - vecYhat;      /* intercept */
	*print , "My Answers Are",, betaVec residVec;
	
	MXplusBvec = matX * betaVec + residVec;
	*print ,, "Verify y = mX + B",, vecY MXplusBvec;
	title1 'Exercise 5 - Regression';
	print "Computed value for a" (betaVec[1,1]) [format=3.];
	print "Computed value for b" (betaVec[2,1]) [format=3.];
quit; title1;
