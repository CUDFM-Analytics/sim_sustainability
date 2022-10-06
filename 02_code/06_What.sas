%let root = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;
libname sust "&root./01_SAS_SourceCode_Datasets";

proc contents data = sust.atlas;
run;

proc export data = sust.atlas 
    outfile = "&root./atlas.xlsx"
    dbms = xlsx replace;
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Whats
01  what_all_improves
----------------------------------------------------------------------------------*/

*S00.1a     only fixed, ref's 1;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_all_improves(Event='1') = location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_all_improves> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;


/*--------------------------------------------------------------------------------
GLIMMIX: Whats
02  what_commnty_relxns
----------------------------------------------------------------------------------*/

*2a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_commnty_relxns(Event='1') = location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_commnty_relxns> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Whats
03  what_dataehr_improves
----------------------------------------------------------------------------------*/

*03a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_dataehr_improves(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_dataehr_improves> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;



/*--------------------------------------------------------------------------------
GLIMMIX: Whats
04  what_ibh
----------------------------------------------------------------------------------*/

*04a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_ibh(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_ibh> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Whats
05  what_pt_centered
----------------------------------------------------------------------------------*/

*05a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_pt_centered(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_pt_centered> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;


/*--------------------------------------------------------------------------------
GLIMMIX: Whats
06  what_unknown
----------------------------------------------------------------------------------*/

*06a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_unknown(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_unknown> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;

/*--------------------------------------------------------------------------------
GLIMMIX: Whats
07 what_workflows
----------------------------------------------------------------------------------*/

*07a;
proc glimmix data = sust.atlas;
class pracid size(ref='Small') orgTyp(ref='FQHC') location(ref='Rural') ageTyp(ref='GIM');
model what_workflows(Event='1')= location orgTyp ageTyp  size /dist=binary solution;
title 'glimmix results for <what_workflows> Refs, IVs: Small, FQHC, Rural, GIM; Ref DV: yes';
run;
















proc export data = sust.atlas 
    outfile = "&root./atlas.xlsx"
    dbms = xlsx replace;
run;


