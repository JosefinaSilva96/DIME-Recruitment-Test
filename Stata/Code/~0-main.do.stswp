/*******************************************************************************
						 Main do-file							   
*******************************************************************************/

	* Set version
	*version 18

	* Set project global(s)	
	// User: you 
	display "`c(username)'" 	//Check username and copy to set project globals by user
	
	* Add file paths to DataWork folder and the Github folder for RRF2024
	if "`c(username)'" == "wb636611" {
        global onedrive "C:\Users\wb631166\OneDrive - WBG\Desktop\Taxes\G2Px\Deliverables as of Dec 20"
		global github 	"C:\WBG\GitHub\Devolve-G2PX"
    }
	
	
	* Set globals for sub-folders 
	global code 	"${github}\Code\Stata"
	global outputs 	"${github}\Outputs"
	
	sysdir set PLUS "C:\WBG\GitHub\Devolve-G2PX\Code\ado" // change path



	* Install packages 
	local user_commands	ietoolkit iefieldkit winsor sumstats estout keeporder grc1leg2  asdoc shp2dta spmap asdoc labutil

	foreach command of local user_commands {
	   capture which `command'
	   if _rc == 111 {
		   ssc install `command'
	   }
	}

	* Run do files 
	* Switch to 0/1 to not-run/run do-files 
	if (0) do "${code}\01-processing-data.do"
	if (1) do "${code}\02-analyzing-data.do"
	


* End of do-file!	