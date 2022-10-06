/*--------------------------------------------------------------------------------
Program Name    :       EDA // Sustainability
Owner           :       KW
Requestor       :       Doug Fernald    
Program Descr   :       Check counts, general EDA, Frequencies

Section 00  Files
Section 01  TableOne: Unique Practices
Section 02  TableOne: Responses, DV

Audit trail     :
 2022-02-23  Kim Wiggins    created program
 2022-03-16 Kwiggins re-ran to check before sharing, debug / refactor
----------------------------------------------------------------------------------*/

/*Section 00 Files*/
/*See Readme.txt for root dir and folder contents*/

%let root = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;

libname out "&root./01_SAS_SourceCode_Datasets";

/*macro for frequencies and table one*/
filename tabn "H:/kwMacros/tablen_web_20210718.sas";
%include tabn;


%include "H:/kwMacros/data_specs_072020_web.sas";

/*Checking for 318 unique practices*/
proc sql;
    select count( distinct pracid)
    from out.sustain_final;
quit;
/*TABLE ONEs: RESPONSES*/
/*ALL respondents [545]*/
title"";
%tablen(data = out.sustain_final,
        var = BH HIT Addtl,
        by = ageTyp,
        type = 2);

%tablen(data = out.sustain_final,
        var = BH HIT Addtl,
        by = orgTyp,
        type = 2);

%tablen(data = out.sustain_final,
        var = BH HIT Addtl,
        by = location,
        type = 2);

%tablen(data = out.sustain_final,
        var = BH HIT Addtl,
        by = size,
        type = 2);

/*Unique practice characteristics*/

%tablen(data = out.sustain_practices,
        var = size location ageTyp orgtyp,
        type = 2);


/*Data Dictionary; out requires full path*/
%data_specs(LIBN=out,
            OUT=C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code/dd.xlsx);
