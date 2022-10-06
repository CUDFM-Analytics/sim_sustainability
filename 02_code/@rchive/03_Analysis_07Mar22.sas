/*--------------------------------------------------------------------------------
PROGRAM         Sustainability Study on 3 outcomes // Doug Fernald & Stephanie Gold
PURPOSE         See Analytic plan "C:/Data/Sustainability/AnalyticPlan_Sustainability_25FEb22
PROGRAMMER      KW
PROCESS         Import Files; Transform; Combine into one dataset
FILES IN        out.sustain_final - Do not edit.
FILES OUT       
NOTES           Columns mostly already labeled on import (view > column labels)

Dependencies    Change %let / &path. as needed (before Section 1)

Section      
1: proc mixed on BH as outcome
2: trying multi-LR on BH as outcome w proc genmod

FINAL ProcMixed.xlsx
----------------------------------------------------------------------------------*/
%let path = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;

libname out "&path./01_SAS_SourceCode_Datasets";

/*--------------------------------------------------------------------------------
SECTION 1 //  proc mixed / lsmeans changes
----------------------------------------------------------------------------------*/

/*DV: BH, lsmeans: location*/
PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid location orgTyp ageTyp size; 
    MODEL   BH = location orgTyp ageTyp  size / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location / at means;
title "DV: BH, lsmeans = location";
    RUN;

/*Change reference value - #1*/
PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid location (ref = "Rural") orgTyp (ref = "FQHC") ageTyp (ref = "MPC") size (ref = "Large"); 
    MODEL   BH = location orgTyp ageTyp  size / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location / at means;
title "DV: BH -- ref change1 -- lsmeans = location";
    RUN; *urban sig, Hosp and priv sig";


/*Change reference value - #2 */
PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid location (ref = "Rural") orgTyp (ref = "Hosp") ageTyp (ref = "GIM") size (ref = "Medium"); 
    MODEL   BH = location orgTyp ageTyp  size / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location / at means;
title "DV: BH, changing reference, lsmeans = location";
    RUN; *urban sig, Hosp and priv sig";


/*DV: BH, lsmeans: orgTyp*/
PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid    location orgTyp ageTyp size; 
    MODEL  BH = location orgTyp ageTyp  size  / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans orgTyp / at means;
    title "DV: BH, lsmeans = orgTyp";
    RUN;

/*DV: HIT, lsmeans: location*/

 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid    location orgTyp ageTyp size; 
    MODEL  HIT= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location/at means;
title "DV: HIT -- system references used -- lsmeans = location";
    RUN;


/*change reference value #1*/
 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid  location (ref = "Urban") orgTyp (ref = "FQHC") ageTyp (ref = "MPC") size (ref = "Large"); 
    MODEL  HIT= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location/at means;
title "DV: HIT -- references changed #1 -- lsmeans = location";
    RUN;


/*change reference value #2*/
 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid  location (ref = "Urban") orgTyp (ref = "Hosp") ageTyp (ref = "GIM") size (ref = "Medium"); 
    MODEL  HIT= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location/at means;
title "DV: HIT -- references changed #1 -- lsmeans = location";
    RUN;
/*DV: HIT, lsmeans: orgTyp*/
 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid    location orgTyp ageTyp size; 
    MODEL  HIT= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans orgTyp/at means;
title "DV: HIT, lsmeans = OrgTyp";
    RUN;


/*DV: Addtl, lsmeans: location*/

 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid    location orgTyp ageTyp size; 
    MODEL  Addtl= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location/at means;
title "DV: Additional -- system reference order -- lsmeans = location";
    RUN; 

/*Change reference order #2*/
 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid    location (ref = "Rural") orgTyp (ref = "Hosp") ageTyp (ref = "MPC") size (ref = "Large"); 
    MODEL  Addtl= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location/at means;
title "DV: Additional, lsmeans = location";
    RUN;


/*Change reference order #3*/
 PROC MIXED DATA = out.sustain_final  noclprint covtest;
    CLASS pracid    location (ref = "Rural") orgTyp (ref = "SBC") ageTyp (ref = "GIM") size (ref = "Medium"); 
    MODEL  Addtl= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans location/at means;
title "DV: Additional -- system ref change #3 -- lsmeans = location";
    RUN;
/*DV: Addtl, lsmeans: orgTyp*/
 PROC MIXED DATA = out.sustain_final noclprint covtest;
    CLASS pracid    location orgTyp ageTyp size; 
    MODEL  Addtl= location orgTyp ageTyp  size    
        / S; 
        RANDOM INTERCEPT/ SUB = pracid TYPE= UN;
        lsmeans orgTyp/at means;
title "DV: Additional, lsmeans = OrgTyp";
    RUN;


/*location and org type significant
    We know the dn is crazy so we wouldn't want to report this*/

/*--------------------------------------------------------------------------------
SECTION 2 // multi ord lr 4 levels
    These are not ideal as we don't have proportional odds, however... 
----------------------------------------------------------------------------------*/
/*2a create levels for each variable using format then add columns*/
%include "&path./01_SAS_SourceCode_Datasets/03a_Formats4Analysis_07Mar22.sas";
data out.sustain_final_ORD;
set out.sustain_final;
BH3lev = input(BH, lr3_.);
/*BH4lev = input(BH, lr4_.);*/
/*BH5lev = input(BH, lr5_.);*/
HIT3lev = input(HIT, lr3_.);
/*HIT4lev = input(HIT, lr4_.);*/
/*HIT5lev = input(HIT, lr5_.);*/
Addtl3lev = input(Addtl, lr3_.);
/*Addtl4lev = input(Addtl, lr4_.);*/
/*Addtl5lev = input(Addtl, lr5_.);*/
run;



/*lose pracid (nested) significance and location significance, but ageTyp becomes significant at MPC */

/*Tried with 3 levels
    lost power and significance of the location variable which we know is significant from the first glm model*/

ods trace on;

proc genmod data=out.sustain_final_ORD;
   class  pracid    location orgTyp ageTyp size;
   model  Bh3lev = location orgTyp ageTyp  size/ dist=multinomial
                         link=cumlogit;
    repeated subject=pracid / printmle;
    ods output ParameterEstimates = out.gmparms_BH3level;
        title "proc genmod DV Bh3level";
run;

/*proc genmod data=out.sustain_final1;*/
/*   class  pracid    location orgTyp ageTyp size;*/
/*   model  Bh4lev = location orgTyp ageTyp  size/ dist=multinomial*/
/*                         link=cumlogit;*/
/*    repeated subject=pracid / printmle;*/
/*    ods output ParameterEstimates = gmparms_BH4level;*/
/*        title "proc genmod DV Bh4level";*/
/*run;*/

/*proc genmod data=out.sustain_final1;*/
/*   class  pracid    location orgTyp ageTyp size;*/
/*   model  Bh5lev = location orgTyp ageTyp  size/ dist=multinomial*/
/*                         link=cumlogit;*/
/*    repeated subject=pracid / printmle;*/
/*    ods output ParameterEstimates = gmparms_BH5level;*/
/*        title "proc genmod DV Bh5level";*/
/*run;*/


/*--------------------------------------------------------------------------------
SECTION 3 // trying proc genmod on HIT
----------------------------------------------------------------------------------*/
/*look for proportion*/
/*proc freq data = out.sustain_final_ORD;*/
/*tables HIT: ;*/
/*run; *level 0 has 15% while the other 2 have 40% responses... problematic I think;*/

proc genmod data=out.sustain_final_ORD;
   class  pracid    location orgTyp ageTyp size;
   model  HIT3lev = location orgTyp ageTyp  size/ dist=multinomial
                         link=cumlogit;
    repeated subject=pracid /printmle;
    ods output ParameterEstimates = out.gmparms_HIT3level;
    title "Parameter Estimates: proc genmod DV HIT 3-levels";
run;
/**/
/*proc genmod data=out.sustain_final1;*/
/*   class  pracid    location orgTyp ageTyp size;*/
/*   model  HIT4lev = location orgTyp ageTyp  size/ dist=multinomial*/
/*                         link=cumlogit;*/
/*    repeated subject=pracid /printmle;*/
/*    ods output ParameterEstimates = gmparms_HIT4level;*/
/*    title "Parameter Estimates: proc genmod DV HIT 4-levels";*/
/*run;*/

/*proc genmod data=out.sustain_final1;*/
/*   class  pracid    location orgTyp ageTyp size;*/
/*   model  HIT5lev = location orgTyp ageTyp  size/ dist=multinomial*/
/*                         link=cumlogit;*/
/*    repeated subject=pracid /printmle;*/
/*    ods output ParameterEstimates = gmparms_HIT5level;*/
/*    title "Parameter Estimates: proc genmod DV HIT 5-levels";*/
/*run;*/
/*--------------------------------------------------------------------------------
SECTION 4 // trying proc genmod on Addtl
----------------------------------------------------------------------------------*/

proc genmod data=out.sustain_final_ORD;
   class  pracid    location orgTyp ageTyp size;
   model  Addtl3lev = location orgTyp ageTyp  size/ dist=multinomial
                         link=cumlogit;
    repeated subject=pracid /printmle;
    ods output ParameterEstimates = out.gmparms_Addtl3level;
        title "Parameter Estimates: proc genmod DV HIT 3-levels";
run;

/*proc genmod data=out.sustain_final1;*/
/*   class  pracid    location orgTyp ageTyp size;*/
/*   model  Addtl4lev = location orgTyp ageTyp  size/ dist=multinomial*/
/*                         link=cumlogit;*/
/*    repeated subject=pracid /printmle;*/
/*    ods output ParameterEstimates = gmparms_Addtl4level;*/
/*        title "Parameter Estimates: proc genmod DV HIT 4-levels";*/
/*run;*/

/*proc genmod data=out.sustain_final1;*/
/*   class  pracid    location orgTyp ageTyp size;*/
/*   model  Addtl5lev = location orgTyp ageTyp  size/ dist=multinomial*/
/*                         link=cumlogit;*/
/*    repeated subject=pracid /printmle;*/
/*    ods output ParameterEstimates = gmparms_Addtl5level;*/
/*        title "Parameter Estimates: proc genmod DV HIT 5-levels";*/
/*run;*/


