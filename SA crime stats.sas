proc import OUT = police 
FILE ='/home/u62791206/SAcrimeStats/South Africa crime data - South Africa crime data.csv'
DBMS = CSV
REPLACE;
run;
proc print data = police;
run;


proc sgplot data=WORK.POLICE;
	title height=14pt 
		"Province with the highest number of crimes reported in 2005";
	vbar Province / response='Year_2005'n datalabel;
	yaxis grid;
run;

ods graphics / reset;
title;


/* Province with the highest number crimes reported in the year 2015 */

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.POLICE;
	title height=14pt 
		"Province with the highest number of crimes reported in 2015";
	vbar Province / response='Year_2015'n datalabel;
	yaxis grid;
run;

/* All theft not mentioned elsewhere in each province */
DATA WORK.Crime;
SET WORK.POLICE (WHERE=(Category = 'All theft not mentioned elsewhere'));
RUN;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Total number of times this crime has been reported  " / textattrs=(size=14);
		layout region;
		piechart category=Province / group=Category groupgap=2% stat=pct 
			datalabellocation=inside;
		endlayout;
		endgraph;
	end;
run;


DATA WORK.Crime;
SET WORK.POLICE (WHERE=(Category = 'Burglary at residential premises'));
RUN;
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Total number of times this crime has been reported  " / textattrs=(size=14);
		layout region;
		piechart category=Province / group=Category groupgap=3% stat=pct 
			datalabellocation=inside;
		endlayout;
		endgraph;
	end;
run;
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Total number of times All theft not mention elsewhere 
		has been reported  " / textattrs=(size=14);
		layout region;
		piechart category=Province / group=Category groupgap=2% stat=pct 
			datalabellocation=inside;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.CRIME;
run;

ods graphics / reset;

ods graphics / reset;
title;
/* The differnces in years */
proc sgplot data=WORK.POLICE;
title height=14pt "Crimes committed over 10 years  ";
	yaxis grid;
	vline Province / response='Year_2005'n;
	yaxis grid;
	vline Province / response='Year_2006'n;
	yaxis grid;
	vline Province / response='Year_2007'n;
	yaxis grid;
	vline Province / response='Year_2008'n;
	yaxis grid;
	vline Province / response='Year_2009'n;
	yaxis grid;
	vline Province / response='Year_2010'n;
	yaxis grid;
	vline Province / response='Year_2011'n;
	yaxis grid;
	vline Province / response='Year_2012'n;
	yaxis grid;
	vline Province / response='Year_2013'n;
	yaxis grid;
	vline Province / response='Year_2014'n;
	yaxis grid;
	vline Province / response='Year_2015'n;
	yaxis grid;
run;

/* Crimes reported in the year 2005 */
proc sgplot data=WORK.POLICE;
	hbar Category / response='Year_2005'n datalabel stat=sum;
	xaxis valuesrotate=vertical;
	title height=14pt "Total number of crimes commited in 2005";
	yaxis grid;
	label;
run;
/* Crimes reported  in the year 2015 */
proc sgplot data=WORK.POLICE;
	title height=14pt "Total number of crimes commited in 2015-2016";
	hbar Category / response='Year_2015'n datalabel stat=sum;
	xaxis valuesrotate=vertical;
	yaxis grid;
	label;
run;




proc sgplot data=WORK.POLICE (obs=10);
	title height=14pt "Top 10 Stations" ;
	hbar Station / response='Year_2005'n datalabel stat=sum;
	xaxis valuesrotate=vertical;
	yaxis grid;
	label;
run;



%MACRO crimes(id =,Province=, Station=, Category=, Year_2005 =, Year_2006=, Year_2007=, Year_2008=, Year_2009=, Year_2010=, Year_2011=, Year_2012=, Year_2013=, Year_2014=, Year_2015=);
%put Province = &Province;
%put Station= &Station;
%put Category = &Category;
%put Year_2005 = &Year_2005;
%put Year_2006 = &Year_2006;
%put Year_2007 = &Year_2007;
%put Year_2008 = &Year_2008;
%put Year_2009 = &Year_2009;
%put Year_2010 = &Year_2010;
%put Year_2011 = &Year_2011;
%put Year_2012 = &Year_2012;
%put Year_2013 = &Year_2013;
%put Year_2014 = &Year_2014;
%put Year_2015 = &Year_2015;


	data temp;
	 Province = &Province;
	 Station = &Station;
	 Category = &Category;
	 Year_2005= & Year_2005;
	 Year_2007 = &Year_2006;
	 Year_2008 = &Year_2007;
     Year_2009 = &Year_2008;
	 Year_2010 = &Year_2009;
	 Year_2011 = &Year_2010;
	 Year_2012 = &Year_2012;
	 Year_2013 = &Year_2013;
	 Year_2014 = &Year_2014;
	 Year_2015 = &Year_2015;
	   
	 set crimes;
	 if Province ='Gauteng' then delete
	run;
	proc print data = temp;
	where Province = &Province and Category=&Category;
run;
%MEND crimes;
%crimes(Province=Western Cape ,Station=CapeCape Town Central,Category=All theft not mentioned elsewhere,_2005-_2006=6692);

/*SEARCH function*/
%macro search(filter,x);
  %put x= &x;
   %put filter= &filter;
  
  %if &filter = id %then;
     %do;  
    data CRIMES;
      set POLICE;
      search_count = serach_count + 1;
      run;
     data result;
      set POLICE;
      where id= 1;
      run;
  %end;
       
       
 proc print data=result ;
 run;
 %mend search;
 %search(id,1);
 
 proc print data=POLICE  (obs=10);
 var Province Station Category;
 run;
/*Search Function*/
 %macro search(filter,x);
  %put x= &x;
   %put filter= &filter;
  
  %if &filter = id %then;
     %do;  
    data CRIMES;
      set POLICE;
      search_count = serach_count + 1;
      run;
     data result;
      set POLICE;
      where id= 1;
      run;
  %end;
       
  /*DELETE Function*/     
 proc print data=result ;
 run;
 %mend search;
 %search(id,1);
 
 proc print data=POLICE  (obs=10);
 var Province Station Category;
 run;




 