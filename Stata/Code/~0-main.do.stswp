/*******************************************************************************
						 Main do-file-Josefina Silva							   
*******************************************************************************/

	* Set version
	*version 18

	* Set project global(s)	
	
	* Store username in a local macro
	
    global onedrive "C:/Users/wb631166/OneDrive - WBG/Desktop/DIME Recruitment Test"
    global github   "C:/WBG/GitHub/DIME-Recruitment-Test/Stata"
	
	* Set globals for sub-folders 
	global data 	"${onedrive}/Data"
	global code 	"${github}/Code"
	global outputs 	"${github}/Outputs"
	
	sysdir set PLUS "C:/WBG/GitHub/DIME-Recruitment-Test/Stata/Code/ado" // change path



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
	if (0) do "${code}/01-processing-data.do"
	if (1) do "${code}/02-constructing-data.do"
	if (0) do "${code}/03-analyzing-data.do"


* End of do-file!	