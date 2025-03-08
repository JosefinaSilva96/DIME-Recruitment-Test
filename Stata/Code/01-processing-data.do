/*******************************************************************************
						 Processing Data Do.file-Josefina Silva							   
*******************************************************************************/
*-------------------------------------------------------------------------------	
* Loading data
*------------------------------------------------------------------------------- 	
	*First we are going to start with the GEM_Baseline data set	
	
	* Load GEM_Baseline.dta
	
	use "${data}/GEM_Baseline.dta", clear //1,295 obs
	
*-------------------------------------------------------------------------------	
* Checking for unique ID and fixing duplicates
*------------------------------------------------------------------------------- 		

	* Identify duplicates 
	
	duplicates report HHID
	
	duplicates report HHID q102_age q103_a_religion q131_residence w01_worked_ye~o
	
	duplicates drop HHID q102_age q103_a_religion q131_residence w01_worked_ye~o, force //3 observations deleted
	
				
	
*-------------------------------------------------------------------------------	
* Define locals to store variables for each level
*------------------------------------------------------------------------------- 							
	
	* Household ID
	
    local ids HHID

    * Household-level variables 
	
    local hh_vars q131_residence q134_a_electr~y s01_savings_f~y

    * Household-member-level variables 
	
    local hh_mem q102_age q103_a_religion q107_years_fo~n w01_worked_yesno

*-------------------------------------------------------------------------------	
* Now I will see if my data is in a tidy level format
*------------------------------------------------------------------------------- 		 

  /*Now I'm going to see if the data is in a Tidy Format

   - All variables have the same unit of observation: YES
   
   - There are multiple variables represented in a single column: NO
   
   - Each observation is separated into multiple rows: YES
   
   We can conclude that our data set is tidy so me can continue with the data cleaning
   process
   
*/	
	
*-------------------------------------------------------------------------------	
* Saving Data 
*------------------------------------------------------------------------------- 	
  
  save "${data}/GEM_baseline_analysis.dta", replace
  
  
 *-------------------------------------------------------------------------------	
* Loading data
*------------------------------------------------------------------------------- 	
	*Now we are going to start with the GEM_Treatment_Status.dta data set	
	
	* Load GEM_Baseline.dta
	
	use "${data}/GEM_Treatment_Status.dta", clear //1,296
	
*-------------------------------------------------------------------------------	
* Checking for unique ID and fixing duplicates
*------------------------------------------------------------------------------- 		

	* Identify duplicates 
	
	duplicates report HHID // no duplicates 
	
	
*-------------------------------------------------------------------------------	
* Saving Data 
*------------------------------------------------------------------------------- 	
  
  save "${data}/GEM_treatment_status_analysis.dta", replace
  
	
 	
	
****************************************************************************end!