/* 

   The data is based on 

	Concrete Compressive Strength Data Set, copyright I-Cheng Yeh, https://archive.ics.uci.edu/ml/datasets/Concrete+Compressive+Strength, 
		originally from I-Cheng Yeh, "Modeling of strength of high performance concrete using artificial neural networks," Cement and Concrete Research, 
		Vol. 28, No. 12, pp. 1797-1808 (1998).

	published on

  	Dua, D. and Karra Taniskidou, E. (2017). UCI Machine Learning Repository [http://archive.ics.uci.edu/ml]. Irvine, CA: University of California, 
		School of Information and Computer Science.

   The data in concreteratios.csv divides the concrete components by the water content to specify component content as a ratio to water content. 
   The variables are

	Cement/Water ratio
 	Blast Furnace Slag/Water ratio
    Fly Ash/Water ratio
    Superplasticizer/Water ratio
	Coarse Aggregate/Water ratio
	Fine Aggregate/Water ratio
	Age (days)
	Concrete compressive strength (MPa, megapascals)

*/

data concreterats;
	infile "/home/u62100191/concreteratios.csv" dlm=",";
	input cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	agegroup= 6;
	if age<7 then agegroup=1;
	if 7<=age<28 then agegroup=2;
	if 28<=age<56 then agegroup=3;
	if 56<=age<90 then agegroup=4;
	if 90<=age<180 then agegroup=5;
run;

/* Topic 1 */
proc sort data=concreterats;
  by agegroup;
run;
proc means data=concreterats;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength ;
	by agegroup;
run;
proc univariate data=concreterats normaltest;
  var compressivestrength;
  histogram compressivestrength /normal;
  by agegroup; 
  ods select Histogram;
run;
proc sgplot data=concreterats;
  scatter y=compressivestrength x=age;
  reg y=compressivestrength x=age;
run;

/* Topic 2 */
proc cluster data=concreterats method=average ccc pseudo outtree=concreteratsAVG print=15 plots=all;
   var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age;
   copy compressivestrength agegroup;
   ods select ClusterHistory Dendrogram CccPsfAndPsTSqPlot;
run;
proc tree data=concreteratsAVG noprint ncl=10 out=out;
   copy cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength age agegroup;
run;
proc sort data=out;
 by cluster;
run;
proc anova data=out;
  class cluster;
  model compressivestrength=cluster;
  means cluster/ hovtest cldiff;
  ods select OverallANOVA CLDiffs HOVFTest;
run;
proc freq data=out;
  tables cluster*agegroup/ nopercent norow nocol;
run;
* do means analysis on variables by cluster;
proc means data=out;
 var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age;
 by cluster;
run;

/* Topic 3 */
data interestData;
  set concreterats;
  if age >= 90;
run;
proc reg data=interestData;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater/ selection=stepwise sle=.05 sls=.05;
run;
proc reg data=interestData;
	model compressivestrength = cementwater slagwater flyashwater finewater;
run;

/* Topic 4 */
data interestData2;
  set concreterats;
  if age >= 90 AND age <= 100;
run;
data interestData3;
  set interestData2;
  if compressivestrength >= 50 then GoodStrength = 1;
  if compressivestrength < 50 then GoodStrength = 0;
run;
proc logistic data=interestData3 desc;
	model GoodStrength = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater/selection=backward ;
run;

/* Topic 5 */
proc stepdisc data=concreterats sle=.05 sls=.05;
   	class agegroup;
    var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
   	ods select Summary;
run;
proc discrim data=concreterats pool=test crossvalidate;
   class agegroup;
   var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
   priors proportional;
   ods select ChiSq ClassifiedCrossVal ErrorCrossVal;
run;