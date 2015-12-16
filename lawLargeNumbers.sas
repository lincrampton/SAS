%let myfolder=%str(/folders/myfolders/HW5);
libname HW5 "&myfolder";

%macro proveLLN(p, n);	/* prove law of large numbers */
proc iml;
	/* vectorMean generates means through the vector - like dplyr in R */
	start vectorMean(x);  /* running vector mean - just like its done in R */
		return( cusum(x)/(1:ncol(x)) );
	finish; 
 
 	/* generate a rowVector of randomMeans and a rowVector of 1...n */
	call randseed(2016); 
	x = j(1,&n);   /* initialize a vector of size [1,n] */
	call randgen(x,"Ber", &p); /* fill with Bernoulli RV */
	runMean = vectorMean(x); /* runMean now contains a vector of all the means */
	Nvalue=1:&n;  /* Nvalue is a vector of the counts of means */

	/* plot the samples to demonstrate the Law of Large Numbers */
	title1 "&n Bernoulli Samples at Probability &p";
	title3 "[Data Points in Red, Initial Bernoulli Probably in Blue]";
	ods graphics / width=600px height=250px;  /* want 3 short/wide graphs on one page */
	run Scatter(Nvalue, runMean)  
		option="markerattrs=(symbol=DiamondFilled color=red size=4)"  
		group=Origin
		lineparm={0 &p 0} /* initial Bernoulli Probability */
		label={"Number of Means" "Mean"}
		yvalues=do(0,1,0.1) /* should generate an axis from 0-1 with ticks at .1 */
		/*other="refline 0 1 / axis=y" /* add reference line */
		procopt="noautolegend"    /* PROC option */
        		;
quit;

%mend proveLLN;

options nonumber nodate;
ods rtf file = "&myfolder/ex2.rtf";
ods pdf file = "&myfolder/ex2.pdf";
%proveLLN(0.5,25)
%proveLLN(0.5,250)
%proveLLN(0.5,2500)
ods _all_ close;
