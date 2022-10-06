%let root = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;

libname in "&root./Data_Raw";
libname sust "&root./01_SAS_SourceCode_Datasets";

/*--------------------------------------------------------------------------------
S02 Proc Means
----------------------------------------------------------------------------------*/
*size;

proc means data = sust.atlas mean maxdec=2 noprint;
var need: what: why: ;
class size;
output out = sust.means_size (drop=_type_ _freq_) mean= /autoname;
run;

proc transpose data = sust.means_size out=sust.means_size(drop = _label_ 
                                                        rename=(col1=Mean))
                                        name = VAR_NAME
                                        ;
by size;
run;

data sust.means_size;
set sust.means_size;
Mean = round(Mean, 0.01);
if size = ' ' then size = "TotalAvg";
run;
proc sort data = sust.means_size;
by Var_name;
run;

*agetyp;
proc means data = sust.atlas noprint;
var need: what: why: ;
class ageTyp;
output out = sust.means_age (drop=_type_ _freq_) mean= /autoname;
run;

proc transpose data = sust.means_age out=sust.means_age(drop = _label_ 
                                                        rename=(col1=Mean))
                                        name = VAR_NAME
                                        ;
by ageTyp;
run;

data sust.means_age;
set sust.means_age;
Mean = round(Mean, 0.01);
if ageTyp = ' ' then agetyp = "TotalAvg";
run;

proc sort data = sust.means_age;
by Var_name ageTyp;
run;



*orgTyp;
proc means data = sust.atlas mean maxdec=2 noprint;
var need: what: why: ;
class OrgTyp;
output out = sust.means_OrgTyp (drop=_type_ _freq_) mean= /autoname;
run;

proc transpose data = sust.means_OrgTyp out=sust.means_OrgTyp(drop = _label_ 
                                                        rename=(col1=Mean))
                                        name = VAR_NAME
                                        ;
by OrgTyp;
run;

data sust.means_OrgTyp;
set sust.means_OrgTyp;
Mean = round(Mean, 0.01);
if OrgTyp = ' ' then OrgTyp = "TotalAvg";
run;

proc sort data = sust.means_OrgTyp;
by Var_name;
run;




*location;
proc means data = sust.atlas mean maxdec=2 noprint;
var need: what: why: ;
class location;
output out = sust.means_location (drop=_type_ _freq_) mean= /autoname;
run;

proc transpose data = sust.means_location out=sust.means_location(drop = _label_ 
                                                        rename=(col1=Mean))
                                        name = VAR_NAME
                                        ;
by location;
run;

data sust.means_location;
set sust.means_location;
Mean = round(Mean, 0.01);
if location = ' ' then location = "TotalAvg";
run;

proc sort data = sust.means_location;
by Var_name;
run;


/*--------------------------------------------------------------------------------
SECTION 02 //  Export (run all below at once)
----------------------------------------------------------------------------------*/

ods excel file = "&root./AtlasMeans1.xlsx" options(sheet_name = "Needs_All" sheet_interval = "none");

%tablen (data = sust.atlas,
         var = need_better_ehr
                need_facil_support
                need_finance_support
                need_stable_staff
                need_sys_support
                need_workflows,
         type = 2,
         EXCEL_SHEETNAME = Needs_All,
         split = none,
         DIS_DISPLAY = N,
         DIS_ORDER = 2  | 2  |2  |2  |2  |2  |);

ods excel options(sheet_interval= "now" sheet_name = "What_All"); 

%tablen (data = sust.atlas,
         var = what_all_improves
                what_commnty_relxns
                what_dataehr_improves
                what_ibh
                what_pt_centered
                what_unknown,
         type = 2,
         EXCEL_SHEETNAME = What_All,
         split = none,
         DIS_DISPLAY = N,
         DIS_ORDER = 2  | 2  |2  |2  |2  |2  |);

ods excel options(sheet_interval= "now" sheet_name = "Why_All"); 

%tablen (data = sust.atlas,
         var = Why_finances_working
                why_good_capability
                why_ibh_before_sim
                why_new_normal
                why_not_need_external
                Why_other_initiatives
                why_strong_culture
                why_sys_supportive
                why_transform_supports,
             EXCEL_SHEETNAME = Why_All,
             type = 2,
             split = none,
             DIS_DISPLAY = N,
             DIS_ORDER = 2  | 2  |2  |2  |2  |2  |2  |2  |2  |);

ods excel options(sheet_interval= "now" sheet_name = "AgeTyp_Means"); 

proc print data = sust.means_age; run;

ods excel options(sheet_interval= "now" sheet_name = "size_Means"); 

proc print data = sust.means_size; run;

ods excel options(sheet_interval= "now" sheet_name = "location_Means"); 

proc print data = sust.means_location; run;

ods excel options(sheet_interval= "now" sheet_name = "OrgTyp_Means"); 

proc print data = sust.means_orgTyp; run;



run;

ods excel close;
run;
