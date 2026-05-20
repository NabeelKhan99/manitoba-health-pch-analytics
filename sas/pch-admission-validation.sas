/* ==================================================
   FILE: pch-admission-validation.sas
   PURPOSE: Validate Manitoba Health PCH wait time analysis
   INPUT: Manual data entry from Figures 89-92
   OUTPUT: Regional rankings and comparison to Manitoba benchmark
   AUTHOR: NK-analyst
   DATE: 2026-05-19
   ================================================== */

/* 1. Create dataset from Figure 91: Median wait times by region */
data wait_times;
    length region $30;
    input region $ median_weeks significant $;
    datalines;
Winnipeg 0.9 Yes
Prairie_Mountain 5.4 No
Interlake-Eastern 22.0 Yes
Northern 14.1 Yes
Southern 26.6 Yes
;
run;

/* 2. Print raw data */
proc print data=wait_times;
    title "Figure 91: Median Wait Times for PCH Admission by Region";
run;

/* 3. Calculate Manitoba average (excluding Winnipeg outlier for comparison) */
proc means data=wait_times mean median std;
    var median_weeks;
    title "Summary Statistics: Wait Times Across All Regions";
run;

/* 4. Identify regions above Manitoba benchmark (4.0 weeks) */
data wait_analysis;
    set wait_times;
    manitoba_benchmark = 4.0;
    if median_weeks > manitoba_benchmark then above_benchmark = "Yes";
    else above_benchmark = "No";
    
    /* Create categorical variable for reporting */
    if median_weeks <= 4 then wait_category = "Below or At Benchmark";
    else if median_weeks <= 15 then wait_category = "Moderately Above Benchmark";
    else wait_category = "Severely Above Benchmark";
run;

/* 5. Print analysis results */
proc print data=wait_analysis;
    var region median_weeks manitoba_benchmark above_benchmark wait_category;
    title "Regional Wait Time Analysis vs Manitoba Benchmark (4.0 weeks)";
run;

/* 6. Create frequency report for categories */
proc freq data=wait_analysis;
    tables above_benchmark wait_category;
    title "Distribution: Regions Above Benchmark";
run;

/* 7. Export results for comparison with Python */
proc export data=wait_analysis
    outfile="sas_validation_output.csv"
    dbms=csv replace;
    title "Exported SAS Results for Python Comparison";
run;

/* 8. Generate report summary */
proc report data=wait_analysis nowd;
    column region median_weeks manitoba_benchmark wait_category;
    define region / group width=20;
    define median_weeks / format=5.1;
    define manitoba_benchmark / format=5.1;
    define wait_category / width=30;
    title "FINAL REPORT: Manitoba PCH Wait Time Disparities";
    footnote "Source: Manitoba Health Annual Statistics 2018-2020";
run;