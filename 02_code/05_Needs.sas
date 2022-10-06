/*--------------------------------------------------------------------------------
Program Name    :       Sustainability Analysis Dichotomous Atlas 
Owner           :       KW

SECTIONS
S00          Import and Shape
S01          Logistics (Not used, just inspected)
*S02          Proc means MOVED TO file 05a_atlasmeans
S03          GLIMMIX - USED for analyses
----------------------------------------------------------------------------------*/

proc format; 
    value binary_
    1 = "Yes"
    0 = "No";
run;

%let root = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;

libname in "&root./Data_Raw";
libname sust "&root./01_SAS_SourceCode_Datasets";

/*Survey Results file from Doug Fernald*/
%let file = SIM_SUST_CODING-8FEB2022;

/*Section S00 Files*/
/*See Readme.txt for root dir and folder contents*/
/*--------------------------------------------------------------------------------
SECTION 1 //  Import

1a  atlas00       import coded file [320, 40]    
1b  atlas01       merge with pracchar
FINAL   
----------------------------------------------------------------------------------*/

PROC IMPORT DATAFILE="&root./Data_Raw/&file" OUT=atlas00 
DBMS= xlsx REPLACE;
GETNAMES=Yes;
RUN;

data atlas01;
set atlas00;
new = input(pracid, 8.);
drop pracid;
rename new = pracid;
run;
proc sql;
    create table sust.atlas as
    select t.*
        , t2.*
    from sust.sustain_practices as t
    left join atlas01 as t2
    on t.pracid = t2.pracid;
quit;

data sust.atlas;
set sust.atlas;
drop cohort1 cohort2 cohort3;
run;

proc freq data = sust.atlas;
tables need: ;
run;

proc sgplot data = sust.atlas;
  vbar size / group = need_better_ehr groupdisplay = cluster;
run;

proc sgplot data = sust.atlas;
  vbar ageTyp / group = need_better_ehr groupdisplay = cluster;
run;

proc sgplot data = sust.atlas;
  vbar size / group = need_better_ehr groupdisplay = cluster;
run;

proc sgplot data = sust.atlas;
  vbar orgTyp / group = need_better_ehr groupdisplay = cluster;
run;

proc sgplot data = sust.atlas;
  vbar location / group = need_better_ehr groupdisplay = cluster;
run;

/*--------------------------------------------------------------------------------
SECTION S01 Logistics
----------------------------------------------------------------------------------*/

proc logistic data = sust.atlas descending;
    class size orgTyp location ageTyp /param=glm;
    model need_better_ehr = size orgTyp location ageTyp;
run;

proc logistic data = sust.atlas descending;
    class size (ref='Large') orgTyp location ageTyp /param=glm;
    model need_better_ehr = size orgTyp location ageTyp;
run;

proc logistic data = sust.atlas descending;
    class size (ref='Medium') orgTyp location ageTyp /param=glm;
    model need_better_ehr = size orgTyp location ageTyp;
run;


/*--------------------------------------------------------------------------------
GLIMMIX
S03.1   need_better_ehr
----------------------------------------------------------------------------------*/
*S03.1a     need_better_ehr     with pracID random intercept; 
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_better_ehr(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
random intercept / sub=pracid type = un;
run; *Converged but no p-values presented bc too much - not significant outcome on pracid (Est/SE = .252/.6190 = .41 not significant)

*S03.1b     removed type = un;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_better_ehr(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
random intercept / sub=pracid; *type = cs;
run;

*S03.1c     removed Random intercept;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_better_ehr(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
/*random intercept / sub=pracid; *type = cs;*/
run;


/*--------------------------------------------------------------------------------
GLIMMIX
S03.2   need_facil_support
----------------------------------------------------------------------------------*/
*S03.2a     need_better_ehr     with pracID random intercept; 
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_facil_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
random intercept / sub=pracid type = un;
run; *Converged but no p-values presented bc too much - not significant outcome on pracid (Est/SE = .252/.6190 = .41 not significant)

*S03.2a1    removed type = un;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_facil_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
random intercept / sub=pracid; *type = cs;
ods output parameterestimates = p1;
run;

proc print data = p1; 
var; 
run;


*S03.2b   removed Random intercept;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_facil_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
/*random intercept / sub=pracid; *type = cs;*/
run;
*S03.2c     change ref a few times for ageTypnum;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='2');
model need_facil_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
/*random intercept / sub=pracid; *type = cs;*/
run;
*S03.2d     change ref a few times for ageTypnum;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='3');
model need_facil_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
/*random intercept / sub=pracid; *type = cs;*/
run;

/*--------------------------------------------------------------------------------
GLIMMIX
S03.3   need_finance_support
----------------------------------------------------------------------------------*/

*S03.3a     only fixed, ref's 1;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_finance_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

*S03.3b     change ref a few times for ageTypnum;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='2') locationnum(ref='1') ageTypnum(ref='1');
model need_finance_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

*S03.3c    change ref a few times for ageTypnum;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='3') locationnum(ref='1') ageTypnum(ref='1');
model need_finance_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

*S03.3d    change ref a few times for ageTypnum;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='4') locationnum(ref='1') ageTypnum(ref='1');
model need_finance_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

/*--------------------------------------------------------------------------------
GLIMMIX
S03.4   need_stable_staff
----------------------------------------------------------------------------------*/

*S03.4a     only fixed, ref's 1;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_stable_staff(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;


*S03.4a     only fixed, ref's 1;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_stable_staff = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

/*--------------------------------------------------------------------------------
GLIMMIX
S03.5   need_sys_support
----------------------------------------------------------------------------------*/

*S03.5a     only fixed, ref's 1;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_sys_support(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

proc freq data = sust.atlas;
tables location locationnum size sizenum rural agetyp agetypnum orgTyp orgTypNum;
run;

proc freq data = sust.atlas;
tables need: ;
run;

/*--------------------------------------------------------------------------------
GLIMMIX
S03.6   need_workflows
----------------------------------------------------------------------------------*/

*S03.6a     only fixed, ref's 1;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='1') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_workflows(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

*S03.6b     only fixed, size ref = 2;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='2') orgTypnum(ref='2') locationnum(ref='2') ageTypnum(ref='2');
model need_workflows(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;

*S03.6c     only fixed, size ref =3;
proc glimmix data = sust.atlas;
class pracid sizenum(ref='3') orgTypnum(ref='1') locationnum(ref='1') ageTypnum(ref='1');
model need_workflows(Event='1') = locationnum orgTypnum ageTypnum  sizenum /dist=binary solution;
run;



