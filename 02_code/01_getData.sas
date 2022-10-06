/*--------------------------------------------------------------------------------
Program Name    :       Sustainability Get Data
Owner           :       KW
Requestor       :       Doug Fernald

Section 00  Files Libnames 
Section 01  Processing > pracs 51 / 128 changes (see analytic plan email section)
                        create unique prac file 

FINAL DATASETS
sustain_raw     > raw import for ref
sustain_final   > final dataset for analysis, all responses (obs=545)
sustain_practices   > final dataset for practice characteristics, table one unique practices (obs=318)

Change Log
2022-02-23  Kim Wiggins    created program
2022-03-15 KWiggins renamed roots and files after finishing to debug/ finalize before sharing
----------------------------------------------------------------------------------*/

/*Section 00 Files*/
/*See Readme.txt for root dir and folder contents*/
%let root = C:/Users/wigginki/The University of Colorado Denver/Sustainability - Documents/Datasets & Source Code;

libname in "&root./Data_Raw";
libname sust "&root./01_SAS_SourceCode_Datasets";

/*Survey Results file from Doug Fernald*/
%let file = c1c2c3FinalProgress;


/*--------------------------------------------------------------------------------
SECTION 1 //  Processing File
Copied most recent file of pracchar10222 for pracid 128 / 51 (see email section analytic plan) 
used for reference just to get size for 51... just confirmed and added data in 
    1a  sustain0        Isolated columns needed per Analytic plan [OBS 545 VAR 17]
    1c  sustain1        
FINAL   
----------------------------------------------------------------------------------*/
*1a                             [OBS 545 VAR 12];
data sust.sustain_raw;
set in.&file (keep= filter__
                    Q1_7BHImprovementsSustainability
                    Q1_12HITImprovementsSustainabili
                    Q1_18AdditionalImprovementsSusta
                    ageTyp
                    ageTypNum
                    location
                    locationNum
                    orgtyp
                    orgtypnum
                    size
                    sizenum
                    pracid);
where filter__ = 1; 
rename Q1_7BHImprovementsSustainability=BH
        Q1_12HITImprovementsSustainabili=HIT
        Q1_18AdditionalImprovementsSusta=Addtl;
drop filter__;
run;

*1c                             [OBS 545 VAR 12];
data sustain_raw1;
set sust.sustain_raw;
if pracid = 51 then size = "Small";
if pracid = 51 then sizenum = 1;
if pracid = 128 then delete;
run;
/*                          [545, 12]*/
data sust.sustain_final;
set sustain_raw1;
run;

/*Create file with unique pracs for prac characteristics*/
/*1 Remove DV's             [545, 9]*/
data sustain_pracs0;
set sust.sustain_final;
drop BH HIT Addtl;
run;

/*2 Remove duplicates        [318, 9]   */
proc sort data = sustain_pracs0 out=sust.sustain_practices nodupkey;
by _ALL_;
run;
