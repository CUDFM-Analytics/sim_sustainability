/*--------------------------------------------------------------------------------
SECTION 00 //  FILES
----------------------------------------------------------------------------------*/
proc freq data = out.sustain_final_ORD;
tables BH3lev HIT3lev Addtl3lev;
run;
%let results = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Results;

/*--------------------------------------------------------------------------------
SECTION 01 //  Export
----------------------------------------------------------------------------------*/

ods excel file = "&results./genmod.xlsx" options(sheet_name = "gmparms_BH" sheet_interval = "none");

proc odstext; p "gmparms_BH3level"; run;

proc print data = out.gmparms_BH3level; run;

ods excel options(sheet_interval= "now" sheet_name = "gmparms_HIT"); 

proc odstext; p "gmparms_HIT3level"; run;

proc print data = out.gmparms_HIT3level; run;

ods excel options(sheet_interval= "now" sheet_name = "gmparms_Addtl"); 

proc odstext; p "gmparms_Addtl3level"; run;

proc print data = out.gmparms_Addtl3level; run;

run;

ods excel close;
run;
