/*1 why_finances_working */
/*2 why_good_capability */
/*3 why_ibh_before_sim */
/*4 why_new_normal*/
/*5 why_not_need_external */
/*6 why_other_initiatives */
/*7 why_strong_culture */
/*8 why_sys_supportive */
/*9 why_transform_supports */

%let root = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;
libname sust "&root./01_SAS_SourceCode_Datasets";


/*--------------------------------------------------------------------------------
GLIMMIX: Why's
01 why_finances_working
----------------------------------------------------------------------------------*/
*01a;

proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_finances_working(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Finances Working (References @ level 1)";
run;



/*--------------------------------------------------------------------------------
GLIMMIX: Why's
02 why_good_capability
----------------------------------------------------------------------------------*/
*02a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_good_capability(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Good Capability (References @ level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
03 why_good_capability
----------------------------------------------------------------------------------*/
*03a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_ibh_before_sim(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: IBH Before SIM (References @ level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
04 why_new_normal
----------------------------------------------------------------------------------*/
*04a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_new_normal(Event='1') = location orgTyp ageTyp  size /dist=binary solution;
title "Why: New Normal (References @ level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
05 why_not_need_external
----------------------------------------------------------------------------------*/
*05a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_not_need_external(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Not Need External (References @ level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
06 why_other_initiatives
----------------------------------------------------------------------------------*/
*06a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_other_initiatives(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Other Incentives (References @ level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
07 why_strong_culture
----------------------------------------------------------------------------------*/
*07a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_strong_culture(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Strong Culture (References @ level 1)";

run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
08 why_sys_supportive
----------------------------------------------------------------------------------*/
*08a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_sys_supportive(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Other Incentives (references level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
09 why_sys_supportive
----------------------------------------------------------------------------------*/
*09a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_sys_supportive(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Supportive System (references @ level 1)";
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Why's
10 why_transform_supports
----------------------------------------------------------------------------------*/
*10a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model why_transform_supports(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title "Why: Transformative Supports (references @ level 1)";
run;


