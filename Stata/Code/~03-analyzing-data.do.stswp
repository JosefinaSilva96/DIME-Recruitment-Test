/*******************************************************************************
						 Analyzing Data Do.file-Josefina Silva							   
*******************************************************************************/
*-------------------------------------------------------------------------------	
* Load data
*------------------------------------------------------------------------------- 
	
	*load analysis data 
	
	use "${data}/GEM_analysis.dta", replace

*-------------------------------------------------------------------------------	
* Summary stats
*------------------------------------------------------------------------------- 

	* defining globals with variables used for summary
	global sumvars 
						
	* Define summary variables
    global sumvars age religion years_educ rent_paid hours_job1_w hours_job2_w total_savings_cash_jewellery total_savings_cash_jewellery_usd

     * Store summary statistics for the full sample
     eststo all: estpost sum $sumvars

    * Export table to CSV
    esttab all ///  
    using "$outputs/summ_stats.csv", replace ///  
    label ///  
    main(mean %6.2f) aux(sd) ///  
    refcat(hh_size "HH characteristics", nolabel) ///  
    mtitle("Full Sample") ///  
    nonotes addn("Mean with standard deviations in parentheses.")

	
	* Also export in tex for latex
	
	esttab 	all  ///
			using "$outputs/summ_stats.tex", replace ///
			label ///
			main(mean %6.2f) aux(sd) ///
			refcat(hh_size "HH characteristics" , nolabel) ///
			mtitle("Full Sample") ///
			nonotes addn(Mean with standard deviations in parentheses.)

*-------------------------------------------------------------------------------	
* Summary stats savings in cash savings in jewellery and total savings 
*------------------------------------------------------------------------------- 			 * Add labels

	lab var cash_savings_num_w_usd	"Cash savings USD"
	lab var jewellery_savings_w_usd "Jewellery Savings USD"
	lab var total_savings_cash_jewellery_usd "Total Savings USD"
	
	
     * Define savings-related variables
     global savings_vars cash_savings_num_w_usd jewellery_savings_w_usd     total_savings_cash_jewellery_usd

    * Store summary statistics for the full sample for winsorize variables
    eststo all: estpost sum $savings_vars, detail

   * Export table to CSV
    esttab all using "$outputs/savings_summary.csv", replace ///  
    cells("N mean p50 sd min max") ///  
    label ///  
    refcat(hh_size "HH characteristics", nolabel) ///  
    mtitle("Full Sample") ///  
    nonotes addn("Mean, median, standard deviation, min, and max included.")  
	
	
*-------------------------------------------------------------------------------	
* Graphs Breakdown for job type
*------------------------------------------------------------------------------- 	
	
	*Load data set
	
	use "${data}/GEM_analysis_jobtype.dta", replace
	
	*Bar graph
	
	graph bar (mean) hours_job, over(job_type, label(angle(45))) over(treatment) ///
    bar(1, color(navy)) bar(2, color(navy)) ///
    legend(order(0 "Control" 1 "Treatment")) ///
    title("Breakdown of Hours Worked by Job Type and Treatment Status") ///
    ytitle("Average Hours Worked") ///
    blabel(bar, format(%9.2f))
	
	*Save graph 
	
	graph export "$outputs/job_hours.png", replace

   
				
*-------------------------------------------------------------------------------	
* Regressions
*------------------------------------------------------------------------------- 
/*
To analyze what factors affect household savings, I would estimate a linear regression model (OLS) where household savings (in USD) is the dependent variable. 

*/

 *load analysis data 
	
	use "${data}/GEM_analysis.dta", replace
				
			
	* Model 1: Regress of total savings in age
	regress total_savings_cash_jewellery_usd age
	eststo mod1		// store regression results
	
	estadd local clustering "No" 
	
	* Model 2: Add controls 
	reg total_savings_cash_jewellery_usd age years_educ 1.religion
	eststo mod2
	
	estadd local clustering "No" 
	
	*Save tables
	
	esttab mod1 mod2 using "$outputs/savings_regression.csv", replace b(%9.3f) se(%9.3f) star(* 0.1 ** 0.05 *** 0.01) ///
    title("Determinants of Household Savings") mtitles("OLS Regression") ///
    label nonotes addnote("Dependent variable: Total Household Savings in USD")
	
/*

1. What output that would be, and what information would be included in it? The output will be a regression results table that summarizes how different factors impact household savings.Regression Coefficients (β): Shows the direction and magnitude of each factor's effect on savings.
Standard Errors: Measures the precision of the estimated coefficients.
Significance Levels (***, **, *): Indicates whether the effects are statistically significant.
R-squared (R²): Measures how much of the variation in household savings is explained by the independent variables.
Number of Observations (N): Ensures sample size adequacy.
F-statistic & p-value: Tests whether the model as a whole is statistically significant.

2. What specification you would use and why?A linear regression model (OLS) is appropriate if household savings.

3. What Variables Would Be Considered and Why? 
total_savings_cash_jewellery_usd (DV)	Dependent variable: total household savings in USD
age	Older individuals might have accumulated more savings over time.
years_educ	More education can improve financial literacy and savings behavior.
religion	Different religions may have norms around financial behavior, savings, and investment. Some emphasize savings
Additional variables: 
Employment type:	Affects savings stability.
Access to financial services: Easier access to savings mechanisms increases savings.
Household expenditures : High expenses might reduce savings.
			
*/

*-------------------------------------------------------------------------------	
* Save data set
*------------------------------------------------------------------------------- 

save "${data}/GEM_analysis.dta", replace


****************************************************************************end!
	