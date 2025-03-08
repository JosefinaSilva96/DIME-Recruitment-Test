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
				
				
	* Model 1: Regress of food consumption value on treatment
	regress food_cons_usd_w treatment
	eststo mod1		// store regression results
	
	estadd local clustering "No" 
	
	* Model 2: Add controls 
	reg food_cons_usd_w treatment crop_damage drought_flood
	eststo mod2
	
	estadd local clustering "No" 
	
	* Model 3: Add clustering by village
	reg food_cons_usd_w treatment crop_damage drought_flood, vce(cluster vid)
	eststo mod3
	
	estadd local clustering "Yes" 
	
	* Export results in tex
	esttab 	mod1 mod2 mod3 ///
			using "$outputs/regressions.tex" , ///
			label ///
			b(%9.2f) se(%9.2f) ///
			nomtitles ///
			mgroup("Food consumption (USD)", pattern(1 0 0 ) span) ///
			scalars("clustering Clustering") ///
			replace
			
*-------------------------------------------------------------------------------			
* Graphs 
*-------------------------------------------------------------------------------	

	* Bar graph by treatment for all districts 
	gr bar 	area_acre_w, ///
			over(treatment) ///
			by(	district, row(1) note("") ///
				 legend(pos(6)) ///
				 title("Area cultivated by treatment assignemnt across districts")) ///
			asy ///
			legend(rows(1) order(0 "Assignment:" 1 "Control" 2 "Treatment") ) ///
			subtitle(,pos(6) bcolor(none)) ///
			blabel(total, format(%9.1f)) ///
			ytitle("Average area cultivated (Acre)") name(g1, replace)
			
	gr export "$outputs/fig1.png", replace				
			
	* Distribution of non food consumption by female headed hhs with means
	forvalues f = 0/1 {
		
		sum nonfood_cons_usd_w if female_head == `f'
		local mean_`f' = r(mean)
		
	}

	twoway	(kdensity nonfood_cons_usd_w if female_head==0, color(grey)) ///
			(kdensity nonfood_cons_usd_w if female_head==1, color(red)) , ///
			xline(`mean_0', lcolor(grey) 	lpattern(dash)) ///
			xline(`mean_1', lcolor(red) 	lpattern(dash)) ///
			leg(order(0 "Household Head:" 1 "Male" 2 "Female" ) row(1) pos(6)) ///
			xtitle("Distribution of non food consumption") ///
			ytitle("Density") ///
			title("Distribution of non food consumption") ///
			note("Dashed lines represent the averages")
			
	gr export "$outputs/fig2.png", replace				
			
*-------------------------------------------------------------------------------			
* Graphs: Secondary data
*-------------------------------------------------------------------------------			
			
	use "${data}/Final/TZA_amenity_analysis.dta", clear
	
	* createa  variable to highlight the districts in sample
	gen in_sample = inlist(district, 1, 3, 6)
	
	* Separate indicators by sample
	separate n_school	, by(in_sample)
	separate n_medical	, by(in_sample)
	
	* Graph bar for number of schools by districts
	gr hbar 	n_school0 n_school1, ///
				nofill ///
				over(district, sort(n_school)) ///
				legend(order(0 "Sample:" 1 "Out" 2 "In") row(1)  pos(6)) ///
				ytitle("No. of Schools") ///
				name(g1, replace)
				
	* Graph bar for number of medical facilities by districts				
	gr hbar 	n_medical0 n_medical1, ///
				nofill ///
				over(district, sort(n_medical)) ///
				legend(order(0 "Sample:" 1 "Out" 2 "In") row(1)  pos(6)) ///
				ytitle("No. of Medical Facilities") ///
				name(g2, replace)
				
	grc1leg2 	g1 g2, ///
				row(1) legend(g1) ///
				ycommon xcommon ///
				title("School and Medical facilities by District", size(medsmall))
			
	
	gr export "$outputs/fig3.png", replace			

****************************************************************************end!
	