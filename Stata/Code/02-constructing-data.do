/*******************************************************************************
						 Constructing Data Do.file-Josefina Silva							   
*******************************************************************************/
*-------------------------------------------------------------------------------	
* Data construction
*------------------------------------------------------------------------------- 
    *Load data set 
	
	
	use "${data}/GEM_baseline_analysis.dta", clear
	
	*Rename variables 
	
	rename 	HHID id 
	
	rename q102_age age 
	
	rename q103_a_religion religion
	
	rename q104_a_tribe tribe 
	
	rename q105_attend_school school 
	
	rename q107_years_formal_education years_educ
	
	rename q122_father_attend_school father_school
	
	rename q124_father_years_of_education father_yeareduc
	
	rename q126_mother_attend_school mother_school
	
	rename q128_mother_years_of_education mother_yeareduc
	
	rename q130_a_husband husband
	
	rename q130_b_boyfriend boyfriend
	
	rename q130_c_father father 
	
	rename q130_d_mother mother 
	
	rename q130_e_stepfather stepfather
	
	rename q130_f_stepmother stepmother
	
	rename q130_g_father_in_law father_law
	
	rename q130_h_mother_in_law mother_law
	
	rename q130_i_own_children own_child
	
	rename q130_j_grandparents grand_parents
	
	rename q130_k_brothers brothers
	
	rename q130_l_sisters sisters
	
	rename q131_residence residence 
	
	rename q132_rent_paid rent_paid
	
	rename q134_a_electricity electricity 
	
	rename q134_b_radio radio
	
	rename q134_c_television tv
	
	rename w02_paid_in_cash paid_cash
	
	rename w02_paid_in_cash_job1 paid_cash_job1
	
	rename w02_paid_in_cash_job2 paid_cash_job2
	
	rename w02_paid_in_cash_job3 paid_cash_job3
	
	rename w07_hours_job1 hours_job1
	
	rename w07_hours_job2 hours_job2
	
	rename w07_hours_job3 hours_job3
	
	rename s02_cash_savings cash_savings
	
	rename s04_jewellery_savings_value jewellery_savings
	
	*See variables missing values
	
	tab years_educ //  we see that 2 people have 98 years of education
	
	tab hours_job1 // we see 1 obs that have -67 hrs
	
	tab hours_job2 //  we see 1 obs that have -50 hrs
	
	tab cash_savings // we see negative values 
	
	tab jewellery_savings // we see negative values
	
	*Histogram for checking variables 
	
	histogram age, title("Histogram Age") xtitle("Age") ytitle("Frequency")
	
	histogram years_educ, title("Histogram Years Education") xtitle("Years") ytitle("Frequency")
		
	histogram rent_paid, title("Histogram Rent Paid") xtitle("Amount") ytitle("Frequency")
	
	histogram hours_job1, title("Hours Job 1") xtitle("Hours") ytitle("Frequency")
	
	histogram hours_job2, title("Hours Job 2") xtitle("Hours") ytitle("Frequency")
	
	
    *Replace negative values with missing 
	
	replace years_educ=. if years_educ==98
	
	replace hours_job1=. if hours_job1 < 0
	
	replace hours_job2=. if hours_job2 < 0
	
	replace jewellery_savings=. if jewellery_savings<0
	
	*Generate a numeric variable for cash savings 
	
	gen cash_savings_num = real(cash_savings)
	
    replace cash_savings_num = . if cash_savings_num < 0
	
	* Winsorize variables with outliers 
	
	local winvars cash_savings_num jewellery_savings hours_job1 hours_job2
	
	foreach win_var of local winvars {
		
		local `win_var'_lab: variable label `win_var'
		
		winsor 	`win_var', p(0.05) high gen(`win_var'_w)
		order 	`win_var'_w, after(`win_var')
		lab var `win_var'_w "``win_var'_lab' (Winsorized 0.05)"
		
	}
	
	tempfile	 hh
	save 		`hh'
	
	
	*Labelling variables 
	
	*Household id 
	
	label var id "Household id"
	
	*Age 
	
	label var age "Age HH"
	
	*Religion
	
	gen type_religion=religion
	
	label var type_religion "Type of religion"
	
	la de lbltype_religion 1 "Catholic" 2 "Protestant/Other Christian" 3 "Traditional" 4 "Muslim" 5 "No religion" 6 "Other"	
	
	label values type_religion lbltype_religion
	
	*Years of education 
	
	label var years_educ "Years Education"
	
	*Jewellery Savings 
	
	label var jewellery_savings "Jewellery Savings"
	
	*Cash Savings 
	
	label var cash_savings_num "Cash Savings"
	
*Now I'm going to create a variable that combined total savings from cash and jewerly
 
   gen total_savings_cash_jewellery= cash_savings_num_w+jewellery_savings_w
   
   sum total_savings_cash_jewellery
  	
/*Now I have to transform   
    
	    - cash_savings
		- jewellery_savings
		- total_savings_cash_jewellery
		
Into US dollars- 1 US Dollar= 135 Kenyan Shillings */

  * Consumption in usd
	global usd 135
	
	foreach cons_var in cash_savings_num_w jewellery_savings_w total_savings_cash_jewellery {
    
    * Save original variable label
    local cons_var_lab: variable label `cons_var'
    
    * Generate new variable in USD
    gen `cons_var'_usd = `cons_var' / $usd

    * Move new variable next to the original
    order `cons_var'_usd, after(`cons_var')

    * Apply labels to new variables
    label var `cons_var'_usd "`cons_var_lab' (USD)"
}

*-------------------------------------------------------------------------------	
* Save data set: 
*------------------------------------------------------------------------------- 	

   save "${data}/GEM_baseline_constructing.dta", replace

*-------------------------------------------------------------------------------	
* Data construction: Treatment status
*------------------------------------------------------------------------------- 	

   use "${data}/GEM_treatment_status_analysis.dta", replace
	
	*Rename variables 
	
	rename HHID id

	* Add labels
	lab var id	"Household id"
	lab var treatment "treatment status"
	
*-------------------------------------------------------------------------------	
* Save data set: 
*------------------------------------------------------------------------------- 	

   save "${data}/GEM_treatment_status_constructing.dta", replace
	
	
*-------------------------------------------------------------------------------	
* Data construction: merge all hh datasets
*------------------------------------------------------------------------------- 	
	
	* Load GEM Baseline
	
	use "${data}/GEM_baseline_constructing.dta", replace
	
	*Destring id
	
	 destring id, replace 
	
	* merge treatment data 
	
	merge m:1 id using "${data}/GEM_treatment_status_constructing.dta"
	
	keep if _merge==3
	
*-------------------------------------------------------------------------------	
* Save data set: 
*------------------------------------------------------------------------------- 		
	
	save "${data}/GEM_analysis.dta", replace

	
*************************************************************************** end!
	