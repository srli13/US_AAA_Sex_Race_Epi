/*************************
Katie Reitz, Jason Kennedy, and Shimena Li 4-5-2021 

Analysis of Race- and Sex-Specific AAA Hospitalizations in the NIS
1) Merge NIS data files for each year and append files prior to ICD10 and create variables
2) Merge NIS data files for 2015 (Dataset and ICD transition) and create variables
3) Merge NIS data files for each year an append files after ICD10 transition and create variables
4) Append all years together and remove any unneeded variables

Note: All PMhx variables are generated from secondary diagnoses and defined by Elixhauser variables for ICD10 codes and using the severity file for the ICD9 codes, as suggested by the NIS. Smoking and Connective tissue disorders are not elixhauser or servierty file variables and were defined per the manuscript references. 

*************************/

*************************
*************************
*Making 2012-2014:
*************************
*************************
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/NIS AAA Disparaties 2012-14 - Analysis log V3 Full Dataset.log", replace

**YEARS before ICD10 coding - creating datasets for each year:
/*use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2012/NIS_2012_Core.dta", clear
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2012/NIS_2012_Severity.dta", nogen
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2012/NIS_2012_Hospital.dta", nogen
drop dxccs1-e_ccs4 prccs1-prday15
save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2012 - Analysis V2.dta", replace 

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2013/NIS_2013_Core.dta", clear
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2013/NIS_2013_Severity.dta", nogen
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2013/NIS_2013_Hospital.dta",nogen 
drop dxccs1-e_ccs4 prccs1-prday15
save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2013 - Analysis V2.dta", replace 

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2014/NIS_2014_Core.dta", clear
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2014/NIS_2014_Severity.dta", nogen
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2014/NIS_2014_Hospital.dta",nogen
drop dxccs1-e_ccs4 prccs1-prday15
save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2014 - Analysis V2.dta", replace */

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2014 - Analysis V2.dta", clear 

*Bring all datasets together using ICD9 codes
append using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2013 - Analysis V2.dta"
append using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2012 - Analysis V2.dta"

foreach num of numlist 1/30 {
rename dx`num' i10_dx`num' 
}

**Making variables for AAA ID -- key only use the i1-0dx1 for hospitalization causes.
foreach var of varlist  i10_dx1{ 
gen `var'_aaa_rupture = 0 if `var'!=""
replace `var'_aaa_rupture = 1 if `var'=="4413" 
}

foreach var of varlist  i10_dx1{ 
gen `var'_aaa_intact = 0 if `var'!=""
replace `var'_aaa_intact = 1 if `var'=="4414" 
}

gen i10_dx1_aaa_rupture_intact = 0 if i10_dx1_aaa_intact==0 | i10_dx1_aaa_rupture==0
replace i10_dx1_aaa_rupture_intact = 1 if i10_dx1_aaa_intact==1 | i10_dx1_aaa_rupture==1

*Making CT disease variable:
gen cm_ctdz_notelixhauser = 0
foreach num of numlist 2/30 {
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "75982" , "75683" , "Q8740" , "Q87400" )
	*replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q87410", "Q87418", "Q87420", "Q8742" )
	*replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q8743", "Q87430" , "Q796", "Q7960", "Q7961") 
	*replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q79610", "Q7962", "Q79620", "Q7963", "Q79630")
	*replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q7969", "Q79690")
}
	
*Making smoking variable:
gen cm_smoke_notelixhuaser = 0
foreach num of numlist 2/30 {
replace cm_smoke_notelixhuaser = 1 if inlist(i10_dx`num', "Z87891", "F17200", "F17200", "F17201", "F17203") | inlist(i10_dx`num', "F17208", "F17209", "F17210", "F17211", "F17213") | inlist(i10_dx`num', "F17218", "F17219", "F17220", "F17290", "F17299") | inlist(i10_dx`num', "3051", "V1582",  "6490" , "98984") | inlist(i10_dx`num', "T65211A", "T65221A" , "T65211S", "T65221S", "T65211D", "T65221D")
}
drop i10_dx1-i10_dx30

*Making procedure variables: 
gen proc_aaa_open = 0 
gen proc_aaa_evar = 0 
foreach var of varlist pr1-pr15 {
replace  proc_aaa_open =1 if inlist(`var', "04R007Z", "04R00JZ", "04R00KZ", "04U00JZ", "04U00KZ") | inlist(`var', "04V00DZ", "3834", "3864" , "3844")   

replace proc_aaa_evar = 1 if inlist(`var',  "04H03DZ", "04R047Z", "04R04JZ", "04R04KZ", "04U037Z", "04U03JZ") | inlist(`var', "04U03KZ", "04U047Z", "04U04JZ", "3971" )  | inlist(`var', "04V04DZ", "04V04Z6", "04Q03ZZ", "04Q04ZZ", "04U04KZ") | inlist(`var', "04V03D6", "04V03DZ", "04V03Z6") 
}
drop npr-pr15

save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2012-2014 - Analysis V3.dta", replace

log close

*************************
*************************
*Making 2015 -- this year uses ICD9 for earlier quarters and ICD10 for later quaters. Code written to account for this. 
*************************
*************************
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/NIS AAA Disparaties 2015 - Analysis log V3 Full Dataset.log", replace

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2015/NIS_2015_Core.dta", clear
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2015/NIS_2015_Hospital.dta", nogen update
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2015/NIS_2015Q1Q3_DX_PR_GRPS.dta", nogen update
foreach num of numlist 1/30 {
rename dx`num' i10_dx`num' 
}
foreach num of numlist 1/15 {
rename pr`num' i10_pr`num' 
}
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2015/NIS_2015Q4_DX_PR_GRPS-KatieReitz.dta", nogen update

*not needed data (to minimize file size)
drop prccs1-prmccs1 orproc-pclass15 e_ccs1-ecode4 dxccs1-dxccs30 bodysystem1-chron30
drop i10_ecause1-prday15

*adding in the severity file 
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2015/NIS_2015Q4_Severity.dta", nogen update

*Creating variables to match the severity files
foreach new of newlist cm_dm cm_dmcx  cm_htn_c cm_chf cm_renlfail cm_perivasc cm_smoke_notelixhuaser cm_chrnlung cm_neuro {
gen `new'=0
}

*Making CT disease variable (this is not a variable w definitions in elixhauser)
gen cm_ctdz_notelixhauser = 0
foreach num of numlist 2/30 {
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "75982" , "75683" , "Q8740" , "Q87400" )
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q87410", "Q87418", "Q87420", "Q8742" )
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q8743", "Q87430" , "Q796", "Q7960", "Q7961") 
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q79610", "Q7962", "Q79620", "Q7963", "Q79630")
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q7969", "Q79690")
}

*Making chronic lung variable
foreach num of numlist 2/30 { 
replace cm_chrnlung = 1 if inlist(i10_dx`num', "J410", "J411", "J418", "J42", "J430") | inlist(i10_dx`num', "J431", "J432", "J438", "J439", "J440") | inlist(i10_dx`num', "J441", "J449", "J4520", "J4521", "J4522") | inlist(i10_dx`num', "J4530", "J4531", "J4532", "J4540", "J4541") | inlist(i10_dx`num', "J4542", "J4550", "J4551", "J4552", "J45901") | inlist(i10_dx`num', "J45902", "J45909", "J45990", "J45991", "J45998") | inlist(i10_dx`num', "J470", "J471", "J479", "J60", "J61") | inlist(i10_dx`num', "J620", "J628", "J630", "J631", "J632") | inlist(i10_dx`num', "J633", "J634", "J635", "J636", "J64") | inlist(i10_dx`num', "J65", "J660", "J661", "J662", "J668") | inlist(i10_dx`num', "J670", "J671", "J672", "J673", "J674") | inlist(i10_dx`num', "J675", "J676", "J677", "J678", "J679") | inlist(i10_dx`num', "J684", "J701", "J703")
}

*Making CHF variable
foreach num of numlist 2/30 {
replace cm_chf = 1 if inlist(i10_dx`num', "I0981", "I110", "I130", "I132", "I501") | inlist(i10_dx`num', "I5020", "I5021", "I5022", "I5023", "I5030") | inlist(i10_dx`num', "I5031", "I5032", "I5033", "I5040", "I5041") | inlist(i10_dx`num', "I5042", "I5043", "I50810", "I50811", "I50812") | inlist(i10_dx`num', "I50813", "I50814", "I5082", "I5083", "I5084") | inlist(i10_dx`num', "I5089", "I509", "I5181", "I97130", "I97131") | inlist(i10_dx`num', "O29121", "O29122", "O29123", "O29129", "R570") | inlist(i10_dx`num', "Z95811", "Z95812")
}

*Making uncomplicated diabetes variable
foreach num of numlist 2/30 {
replace cm_dm = 1 if inlist(i10_dx`num', "E0821", "E0822", "E0829", "E08311", "E08319") | inlist(i10_dx`num', "E08321", "E083211", "E083212", "E083213", "E083219") | inlist(i10_dx`num', "E08329", "E083291", "E083292", "E083293", "E083299") | inlist(i10_dx`num', "E08331", "E083311", "E083312", "E083313", "E083319") | inlist(i10_dx`num', "E08339", "E083391", "E083392", "E083393", "E083399") | inlist(i10_dx`num', "E08341", "E083411", "E083412", "E083413", "E083419") | inlist(i10_dx`num', "E08349", "E083491", "E083492", "E083493", "E083499") | inlist(i10_dx`num', "E08351", "E083511", "E083512", "E083513", "E083519") | inlist(i10_dx`num', "E083521", "E083522", "E083523", "E083529", "E083531") | inlist(i10_dx`num', "E083532", "E083533", "E083539", "E083541", "E083542") | inlist(i10_dx`num', "E083543", "E083549", "E083551", "E083552", "E083553") | inlist(i10_dx`num', "E083559", "E08359", "E083591", "E083592", "E083593") | inlist(i10_dx`num', "E083599", "E0836", "E0837X1", "E0837X2", "E0837X3") | inlist(i10_dx`num', "E0837X9", "E0839", "E0840", "E0841", "E0842") | inlist(i10_dx`num', "E0843", "E0844", "E0849", "E0851", "E0852") | inlist(i10_dx`num', "E0859", "E08610", "E08618", "E08620", "E08621") | inlist(i10_dx`num', "E08622", "E08628", "E08630", "E08638", "E08641") | inlist(i10_dx`num', "E08649", "E0865", "E0869", "E088", "E0921") | inlist(i10_dx`num', "E0922", "E0929", "E09311", "E09319", "E09321") | inlist(i10_dx`num', "E093211", "E093212", "E093213", "E093219", "E09329") | inlist(i10_dx`num', "E093291", "E093292", "E093293", "E093299", "E09331") | inlist(i10_dx`num', "E093311", "E093312", "E093313", "E093319", "E09339") | inlist(i10_dx`num', "E093391", "E093392", "E093393", "E093399", "E09341") | inlist(i10_dx`num', "E093411", "E093412", "E093413", "E093419", "E09349") | inlist(i10_dx`num', "E093491", "E093492", "E093493", "E093499", "E09351") | inlist(i10_dx`num', "E093511", "E093512", "E093513", "E093519", "E093521") | inlist(i10_dx`num', "E093522", "E093523", "E093529", "E093531", "E093532") | inlist(i10_dx`num', "E093533", "E093539", "E093541", "E093542", "E093543") | inlist(i10_dx`num', "E093549", "E093551", "E093552", "E093553", "E093559") | inlist(i10_dx`num', "E09359", "E093591", "E093592", "E093593", "E093599") | inlist(i10_dx`num', "E0936", "E0937X1", "E0937X2", "E0937X3", "E0937X9") | inlist(i10_dx`num', "E0939", "E0940", "E0941", "E0942", "E0943") | inlist(i10_dx`num', "E0944", "E0949", "E0951", "E0952", "E0959") | inlist(i10_dx`num', "E09610", "E09618", "E09620", "E09621", "E09622") | inlist(i10_dx`num', "E09628", "E09630", "E09638", "E09641", "E09649") | inlist(i10_dx`num', "E0965", "E0969", "E098", "E1021", "E1022") | inlist(i10_dx`num', "E1029", "E10311", "E10319", "E10321", "E103211") | inlist(i10_dx`num', "E103212", "E103213", "E103219", "E10329", "E103291") | inlist(i10_dx`num', "E103292", "E103293", "E103299", "E10331", "E103311") | inlist(i10_dx`num', "E103312", "E103313", "E103319", "E10339", "E103391") | inlist(i10_dx`num', "E103392", "E103393", "E103399", "E10341", "E103411") | inlist(i10_dx`num', "E103412", "E103413", "E103419", "E10349", "E103491") | inlist(i10_dx`num', "E103492", "E103493", "E103499", "E10351", "E103511") | inlist(i10_dx`num', "E103512", "E103513", "E103519", "E103521", "E103522") | inlist(i10_dx`num', "E103523", "E103529", "E103531", "E103532", "E103533") | inlist(i10_dx`num', "E103539", "E103541", "E103542", "E103543", "E103549") | inlist(i10_dx`num', "E103551", "E103552", "E103553", "E103559", "E10359") | inlist(i10_dx`num', "E103591", "E103592", "E103593", "E103599", "E1036") | inlist(i10_dx`num', "E1037X1", "E1037X2", "E1037X3", "E1037X9", "E1039") | inlist(i10_dx`num', "E1040", "E1041", "E1042", "E1043", "E1044") | inlist(i10_dx`num', "E1049", "E1051", "E1052", "E1059", "E10610") | inlist(i10_dx`num', "E10618", "E10620", "E10621", "E10622", "E10628") | inlist(i10_dx`num', "E10630", "E10638", "E10641", "E10649", "E1065") | inlist(i10_dx`num', "E1069", "E108", "E1121", "E1122", "E1129") | inlist(i10_dx`num', "E11311", "E11319", "E11321", "E113211", "E113212") | inlist(i10_dx`num', "E113213", "E113219", "E11329", "E113291", "E113292") | inlist(i10_dx`num', "E113293", "E113299", "E11331", "E113311", "E113312") | inlist(i10_dx`num', "E113313", "E113319", "E11339", "E113391", "E113392") | inlist(i10_dx`num', "E113393", "E113399", "E11341", "E113411", "E113412") | inlist(i10_dx`num', "E113413", "E113419", "E11349", "E113491", "E113492") | inlist(i10_dx`num', "E113493", "E113499", "E11351", "E113511", "E113512") | inlist(i10_dx`num', "E113513", "E113519", "E113521", "E113522", "E113523") | inlist(i10_dx`num', "E113529", "E113531", "E113532", "E113533", "E113539") | inlist(i10_dx`num', "E113541", "E113542", "E113543", "E113549", "E113551") | inlist(i10_dx`num', "E113552", "E113553", "E113559", "E11359", "E113591") | inlist(i10_dx`num', "E113592", "E113593", "E113599", "E1136", "E1137X1") | inlist(i10_dx`num', "E1137X2", "E1137X3", "E1137X9", "E1139", "E1140") | inlist(i10_dx`num', "E1141", "E1142", "E1143", "E1144", "E1149") | inlist(i10_dx`num', "E1151", "E1152", "E1159", "E11610", "E11618") | inlist(i10_dx`num', "E11620", "E11621", "E11622", "E11628", "E11630") | inlist(i10_dx`num', "E11638", "E11641", "E11649", "E1165", "E1169") | inlist(i10_dx`num', "E118", "E1321", "E1322", "E1329", "E13311") | inlist(i10_dx`num', "E13319", "E13321", "E133211", "E133212", "E133213") | inlist(i10_dx`num', "E133219", "E13329", "E133291", "E133292", "E133293") | inlist(i10_dx`num', "E133299", "E13331", "E133311", "E133312", "E133313") | inlist(i10_dx`num', "E133319", "E13339", "E133391", "E133392", "E133393") | inlist(i10_dx`num', "E133399", "E13341", "E133411", "E133412", "E133413") | inlist(i10_dx`num', "E133419", "E13349", "E133491", "E133492", "E133493") | inlist(i10_dx`num', "E133499", "E13351", "E133511", "E133512", "E133513") | inlist(i10_dx`num', "E133519", "E133521", "E133522", "E133523", "E133529") | inlist(i10_dx`num', "E133531", "E133532", "E133533", "E133539", "E133541") | inlist(i10_dx`num', "E133542", "E133543", "E133549", "E133551", "E133552") | inlist(i10_dx`num', "E133553", "E133559", "E13359", "E133591", "E133592") | inlist(i10_dx`num', "E133593", "E133599", "E1336", "E1337X1", "E1337X2") | inlist(i10_dx`num', "E1337X3", "E1337X9", "E1339", "E1340", "E1341") | inlist(i10_dx`num', "E1342", "E1343", "E1344", "E1349", "E1351") | inlist(i10_dx`num', "E1352", "E1359", "E13610", "E13618", "E13620") | inlist(i10_dx`num', "E13621", "E13622", "E13628", "E13630", "E13638") | inlist(i10_dx`num', "E13641", "E13649", "E1365", "E1369", "E138")
}

*Making complicated diabetes variable
foreach num of numlist 2/30 {
replace cm_dmcx = 1 if inlist(i10_dx`num', "E0800", "E0801", "E0810", "E0811", "E089") | inlist(i10_dx`num', "E0900", "E0901", "E0910", "E0911", "E099") | inlist(i10_dx`num', "E1010", "E1011", "E109", "E1100", "E1101") | inlist(i10_dx`num', "E1110", "E1111", "E119", "E1300", "E1301") | inlist(i10_dx`num', "E1310", "E1311", "E139", "O24011", "O24012") | inlist(i10_dx`num', "O24013", "O24019", "O2402", "O2403", "O24111") | inlist(i10_dx`num', "O24112", "O24113", "O24119", "O2412", "O2413") | inlist(i10_dx`num', "O24311", "O24312", "O24313", "O24319", "O2432") | inlist(i10_dx`num', "O2433", "O24410", "O24414", "O24415", "O24419") | inlist(i10_dx`num', "O24420", "O24424", "O24425", "O24429", "O24430") | inlist(i10_dx`num', "O24434", "O24435", "O24439", "O24811", "O24812") | inlist(i10_dx`num', "O24813", "O24819", "O2482", "O2483", "O24911") | inlist(i10_dx`num', "O24912", "O24913", "O24919", "O2492", "O2493")
}

*Making HTN variable (complicated and not complicated despite the _c)
foreach num of numlist 2/30 {
replace cm_htn_c = 1 if inlist(i10_dx`num', "H35031", "H35032", "H35033", "H35039", "I110") | inlist(i10_dx`num', "I119", "I120", "I129", "I130", "I1310") | inlist(i10_dx`num', "I1311", "I132", "I150", "I151", "I152") | inlist(i10_dx`num', "I158", "I159", "I161", "I674", "O10111") | inlist(i10_dx`num', "O10112", "O10113", "O10119", "O1012", "O1013") | inlist(i10_dx`num', "O10211", "O10212", "O10213", "O10219", "O1022") | inlist(i10_dx`num', "O1023", "O10311", "O10312", "O10313", "O10319") | inlist(i10_dx`num', "O1032", "O1033", "O10411", "O10412", "O10413") | inlist(i10_dx`num', "O10419", "O1042", "O1043", "O10911", "O10912") | inlist(i10_dx`num', "O10913", "O10919", "O1092", "O1093", "O111") | inlist(i10_dx`num', "O112", "O113", "O114", "O115", "O119") | inlist(i10_dx`num', "O161", "O162", "O163", "O164", "O165") | inlist(i10_dx`num', "O169") | inlist(i10_dx`num', "I10", "I160", "I169", "O10011", "O10012") | inlist(i10_dx`num', "O10013", "O10019", "O1002", "O1003")  
}

*Making renal failure variable
foreach num of numlist 1/30 {
replace cm_renlfail = 1 if inlist(i10_dx`num', "N183", "N1830", "N1831", "N1832", "N189") | inlist(i10_dx`num', "N19", "I120", "I1311", "I132", "N184") | inlist(i10_dx`num', "N185", "N186", "Z4901", "Z4902", "Z4931") | inlist(i10_dx`num', "Z4932", "Z9115", "Z940", "Z992")
}

*Making peripheral vascular disease varaible
foreach num of numlist 2/30 {
replace cm_perivasc = 1 if inlist(i10_dx`num', "A5200", "A5201", "A5202", "A5209", "I700") | inlist(i10_dx`num', "I701", "I70201", "I70202", "I70203", "I70208") | inlist(i10_dx`num', "I70209", "I70211", "I70212", "I70213", "I70218") | inlist(i10_dx`num', "I70219", "I70221", "I70222", "I70223", "I70228") | inlist(i10_dx`num', "I70229", "I70231", "I70232", "I70233", "I70234") | inlist(i10_dx`num', "I70235", "I70238", "I70239", "I70241", "I70242") | inlist(i10_dx`num', "I70243", "I70244", "I70245", "I70248", "I70249") | inlist(i10_dx`num', "I7025", "I70261", "I70262", "I70263", "I70268") | inlist(i10_dx`num', "I70269", "I70291", "I70292", "I70293", "I70298") | inlist(i10_dx`num', "I70299", "I70301", "I70302", "I70303", "I70308") | inlist(i10_dx`num', "I70309", "I70311", "I70312", "I70313", "I70318") | inlist(i10_dx`num', "I70319", "I70321", "I70322", "I70323", "I70328") | inlist(i10_dx`num', "I70329", "I70331", "I70332", "I70333", "I70334") | inlist(i10_dx`num', "I70335", "I70338", "I70339", "I70341", "I70342") | inlist(i10_dx`num', "I70343", "I70344", "I70345", "I70348", "I70349") | inlist(i10_dx`num', "I7035", "I70361", "I70362", "I70363", "I70368") | inlist(i10_dx`num', "I70369", "I70391", "I70392", "I70393", "I70398") | inlist(i10_dx`num', "I70399", "I70401", "I70402", "I70403", "I70408") | inlist(i10_dx`num', "I70409", "I70411", "I70412", "I70413", "I70418") | inlist(i10_dx`num', "I70419", "I70421", "I70422", "I70423", "I70428") | inlist(i10_dx`num', "I70429", "I70431", "I70432", "I70433", "I70434") | inlist(i10_dx`num', "I70435", "I70438", "I70439", "I70441", "I70442") | inlist(i10_dx`num', "I70443", "I70444", "I70445", "I70448", "I70449") | inlist(i10_dx`num', "I7045", "I70461", "I70462", "I70463", "I70468") | inlist(i10_dx`num', "I70469", "I70491", "I70492", "I70493", "I70498") | inlist(i10_dx`num', "I70499", "I70501", "I70502", "I70503", "I70508") | inlist(i10_dx`num', "I70509", "I70511", "I70512", "I70513", "I70518") | inlist(i10_dx`num', "I70519", "I70521", "I70522", "I70523", "I70528") | inlist(i10_dx`num', "I70529", "I70531", "I70532", "I70533", "I70534") | inlist(i10_dx`num', "I70535", "I70538", "I70539", "I70541", "I70542") | inlist(i10_dx`num', "I70543", "I70544", "I70545", "I70548", "I70549") | inlist(i10_dx`num', "I7055", "I70561", "I70562", "I70563", "I70568") | inlist(i10_dx`num', "I70569", "I70591", "I70592", "I70593", "I70598") | inlist(i10_dx`num', "I70599", "I70601", "I70602", "I70603", "I70608") | inlist(i10_dx`num', "I70609", "I70611", "I70612", "I70613", "I70618") | inlist(i10_dx`num', "I70619", "I70621", "I70622", "I70623", "I70628") | inlist(i10_dx`num', "I70629", "I70631", "I70632", "I70633", "I70634") | inlist(i10_dx`num', "I70635", "I70638", "I70639", "I70641", "I70642") | inlist(i10_dx`num', "I70643", "I70644", "I70645", "I70648", "I70649") | inlist(i10_dx`num', "I7065", "I70661", "I70662", "I70663", "I70668") | inlist(i10_dx`num', "I70669", "I70691", "I70692", "I70693", "I70698") | inlist(i10_dx`num', "I70699", "I70701", "I70702", "I70703", "I70708") | inlist(i10_dx`num', "I70709", "I70711", "I70712", "I70713", "I70718") | inlist(i10_dx`num', "I70719", "I70721", "I70722", "I70723", "I70728") | inlist(i10_dx`num', "I70729", "I70731", "I70732", "I70733", "I70734") | inlist(i10_dx`num', "I70735", "I70738", "I70739", "I70741", "I70742") | inlist(i10_dx`num', "I70743", "I70744", "I70745", "I70748", "I70749") | inlist(i10_dx`num', "I7075", "I70761", "I70762", "I70763", "I70768") | inlist(i10_dx`num', "I70769", "I70791", "I70792", "I70793", "I70798") | inlist(i10_dx`num', "I70799", "I708", "I7090", "I7091", "I7092") | inlist(i10_dx`num', "I7100", "I7101", "I7102", "I7103", "I711") | inlist(i10_dx`num', "I712", "I713", "I714", "I715", "I716") | inlist(i10_dx`num', "I718", "I719", "I720", "I721", "I722") | inlist(i10_dx`num', "I723", "I724", "I725", "I726", "I728") | inlist(i10_dx`num', "I729", "I7301", "I731", "I7381", "I7389") | inlist(i10_dx`num', "I739", "I7401", "I7409", "I7410", "I7411") | inlist(i10_dx`num', "I7419", "I742", "I743", "I744", "I745") | inlist(i10_dx`num', "I748", "I749", "I75011", "I75012", "I75013") | inlist(i10_dx`num', "I75019", "I75021", "I75022", "I75023", "I75029") | inlist(i10_dx`num', "I7581", "I7589", "I770", "I771", "I772") | inlist(i10_dx`num', "I773", "I774", "I775", "I776", "I7770") | inlist(i10_dx`num', "I7771", "I7772", "I7773", "I7774", "I7775") | inlist(i10_dx`num', "I7776", "I7777", "I7779", "I77810", "I77811") | inlist(i10_dx`num', "I77812", "I77819", "I7789", "I779", "I780") | inlist(i10_dx`num', "I781", "I788", "I789", "I790", "I791") | inlist(i10_dx`num', "I798", "I998", "I999", "K31811", "K31819") | inlist(i10_dx`num', "K551", "K558", "K559", "Z95820", "Z95828") 
}

*Adding in the severity file for the PHMx available with the ICD9 codes (not available for hte ICD10 data)
merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2015/NIS_2015Q1Q3_Severity.dta", nogen update

*Make procedure variables
gen proc_aaa_open = 0 
gen proc_aaa_evar = 0 
foreach var of varlist i10_pr1-i10_pr15 {
replace  proc_aaa_open =1 if inlist(`var', "04R007Z", "04R00JZ", "04R00KZ", "04U00JZ", "04U00KZ") | inlist(`var', "04V00DZ", "3834", "3864" , "3844" ) 

replace proc_aaa_evar = 1 if inlist(`var',  "04H03DZ", "04R047Z", "04R04JZ", "04R04KZ", "04U037Z", "04U03JZ") | inlist(`var', "04U03KZ", "04U047Z", "04U04JZ", "3971" )  | inlist(`var', "04V04DZ", "04V04Z6", "04Q03ZZ", "04Q04ZZ", "04U04KZ") | inlist(`var', "04V03D6", "04V03DZ", "04V03Z6") 
}
drop i10_pr1-i10_pr15

**Making variables for AAA ID -- key only use the dx1 for hospitalization causes (this is the primary diagnosis).
foreach var of varlist  i10_dx1{ 
gen `var'_aaa_rupture = 0 if `var'!=""
replace `var'_aaa_rupture = 1 if `var'=="I713" | `var'=="4413"
}
foreach var of varlist  i10_dx1{ 
gen `var'_aaa_intact = 0 if `var'!=""
replace `var'_aaa_intact = 1 if `var'=="I714" |`var'=="4414"
}

gen i10_dx1_aaa_rupture_intact = 0 if i10_dx1_aaa_intact==0 | i10_dx1_aaa_rupture==0
replace i10_dx1_aaa_rupture_intact = 1 if i10_dx1_aaa_intact==1 | i10_dx1_aaa_rupture==1

*Make smoking variable
foreach num of numlist 2/30 {
replace cm_smoke_notelixhuaser = 1 if inlist(i10_dx`num', "Z87891", "F17200", "F17200", "F17201", "F17203") | inlist(i10_dx`num', "F17208", "F17209", "F17210", "F17211", "F17213") | inlist(i10_dx`num', "F17218", "F17219", "F17220", "F17290", "F17299") | inlist(i10_dx`num', "3051", "V1582",  "6490" , "98984") | inlist(i10_dx`num', "T65211A", "T65221A" , "T65211S", "T65221S", "T65211D", "T65221D")
}

*not needed data (to minimize file size)
drop i10_dx1-i10_dx30 cm_aids cm_alcohol cm_anemdef cm_arth cm_bldloss cm_coag cm_depress cm_drug cm_hypothy cm_liver cm_lymph cm_lytes cm_mets cm_para cm_psych cm_pulmcirc cm_tumor cm_ulcer cm_valve cm_wghtloss

save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2015 - Analysis V3.dta", replace

log close

/*************************
*************************
*Making 2016-2018
*************************
*************************/
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/NIS AAA Disparaties 2016-18 - Analysis log V2b Full Dataset.log", replace

/* use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2016/NIS_2016_Core.dta", clear
*merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2016/NIS_2016_Severity.dta", nogen
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2016/NIS_2016_Hospital.dta", nogen
drop  prday1-prday15
save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2016 - Analysis V2.dta", replace 

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2017/NIS_2017_Core.dta", clear
*merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2017/NIS_2017_Severity.dta", nogen
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2017/NIS_2017_Hospital.dta", nogen
drop  prday1-prday15
save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2017 - Analysis V2.dta", replace 

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2018/NIS_2018_Core.dta", clear
*merge 1:1 key_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2018/NIS_2018_Severity.dta", nogen
merge m:1 hosp_nis using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Raw Data/2018/NIS_2018_Hospital.dta", nogen

drop  prday1-prday15
save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2018 - Analysis V2.dta", replace */

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2018 - Analysis V2.dta", clear

append using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2017 - Analysis V2.dta" 
append using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2016 - Analysis V2.dta" 

*Make procedure variable
gen proc_aaa_open = 0 
gen proc_aaa_evar = 0 
foreach var of varlist i10_pr1-i10_pr15 {
replace  proc_aaa_open =1 if inlist(`var', "04R007Z", "04R00JZ", "04R00KZ", "04U00JZ", "04U00KZ") | inlist(`var', "04V00DZ", "3834", "3864" , "3844" ) 

replace proc_aaa_evar = 1 if inlist(`var',  "04H03DZ", "04R047Z", "04R04JZ", "04R04KZ", "04U037Z", "04U03JZ") | inlist(`var', "04U03KZ", "04U047Z", "04U04JZ", "3971" )  | inlist(`var', "04V04DZ", "04V04Z6", "04Q03ZZ", "04Q04ZZ", "04U04KZ") | inlist(`var', "04V03D6", "04V03DZ", "04V03Z6") 
}
drop i10_pr1-i10_pr25


**Making variables for AAA ID -- key only use the idx1 for hospitalization causes (Primary diagnosis).
foreach var of varlist  i10_dx1{ 
gen `var'_aaa_rupture = 0 if `var'!=""
replace `var'_aaa_rupture = 1 if `var'=="I713"
}
foreach var of varlist  i10_dx1{ 
gen `var'_aaa_intact = 0 if `var'!=""
replace `var'_aaa_intact = 1 if `var'=="I714"
}

gen i10_dx1_aaa_rupture_intact = 0 if i10_dx1_aaa_intact==0 | i10_dx1_aaa_rupture==0
replace i10_dx1_aaa_rupture_intact = 1 if i10_dx1_aaa_intact==1 | i10_dx1_aaa_rupture==1

*Creating comboridities variables
foreach new of newlist cm_dm cm_dmcx  cm_htn_c cm_chf cm_renlfail cm_perivasc cm_obese cm_smoke_notelixhuaser cm_chrnlung cm_neuro {
gen `new'=0
}


*Making CT disease variable
gen cm_ctdz_notelixhauser = 0
foreach num of numlist 2/40 {
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "75982" , "75683" , "Q8740" , "Q87400" )
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q87410", "Q87418", "Q87420", "Q8742" )
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q8743", "Q87430" , "Q796", "Q7960", "Q7961") 
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q79610", "Q7962", "Q79620", "Q7963", "Q79630")
	replace cm_ctdz_notelixhauser = 1 if inlist(i10_dx`num', "Q7969", "Q79690")
}


*Make smoking variable
foreach num of numlist 2/40 {
replace cm_smoke_notelixhuaser = 1 if inlist(i10_dx`num', "Z87891", "F17200", "F17200", "F17201", "F17203") | inlist(i10_dx`num', "F17208", "F17209", "F17210", "F17211", "F17213") | inlist(i10_dx`num', "F17218", "F17219", "F17220", "F17290", "F17299") | inlist(i10_dx`num', "3051", "V1582",  "6490" , "98984") | inlist(i10_dx`num', "T65211A", "T65221A" , "T65211S", "T65221S", "T65211D", "T65221D")
}
*Making chronic lung variable
foreach num of numlist 2/40 { 
replace cm_chrnlung = 1 if inlist(i10_dx`num', "J410", "J411", "J418", "J42", "J430") | inlist(i10_dx`num', "J431", "J432", "J438", "J439", "J440") | inlist(i10_dx`num', "J441", "J449", "J4520", "J4521", "J4522") | inlist(i10_dx`num', "J4530", "J4531", "J4532", "J4540", "J4541") | inlist(i10_dx`num', "J4542", "J4550", "J4551", "J4552", "J45901") | inlist(i10_dx`num', "J45902", "J45909", "J45990", "J45991", "J45998") | inlist(i10_dx`num', "J470", "J471", "J479", "J60", "J61") | inlist(i10_dx`num', "J620", "J628", "J630", "J631", "J632") | inlist(i10_dx`num', "J633", "J634", "J635", "J636", "J64") | inlist(i10_dx`num', "J65", "J660", "J661", "J662", "J668") | inlist(i10_dx`num', "J670", "J671", "J672", "J673", "J674") | inlist(i10_dx`num', "J675", "J676", "J677", "J678", "J679") | inlist(i10_dx`num', "J684", "J701", "J703")
} 
*Making CHF variable
foreach num of numlist 2/40 {
replace cm_chf = 1 if inlist(i10_dx`num', "I0981", "I110", "I130", "I132", "I501") | inlist(i10_dx`num', "I5020", "I5021", "I5022", "I5023", "I5030") | inlist(i10_dx`num', "I5031", "I5032", "I5033", "I5040", "I5041") | inlist(i10_dx`num', "I5042", "I5043", "I50810", "I50811", "I50812") | inlist(i10_dx`num', "I50813", "I50814", "I5082", "I5083", "I5084") | inlist(i10_dx`num', "I5089", "I509", "I5181", "I97130", "I97131") | inlist(i10_dx`num', "O29121", "O29122", "O29123", "O29129", "R570") | inlist(i10_dx`num', "Z95811", "Z95812")
}
*Making diabetes variable
foreach num of numlist 2/40 {
replace cm_dm = 1 if inlist(i10_dx`num', "E0821", "E0822", "E0829", "E08311", "E08319") | inlist(i10_dx`num', "E08321", "E083211", "E083212", "E083213", "E083219") | inlist(i10_dx`num', "E08329", "E083291", "E083292", "E083293", "E083299") | inlist(i10_dx`num', "E08331", "E083311", "E083312", "E083313", "E083319") | inlist(i10_dx`num', "E08339", "E083391", "E083392", "E083393", "E083399") | inlist(i10_dx`num', "E08341", "E083411", "E083412", "E083413", "E083419") | inlist(i10_dx`num', "E08349", "E083491", "E083492", "E083493", "E083499") | inlist(i10_dx`num', "E08351", "E083511", "E083512", "E083513", "E083519") | inlist(i10_dx`num', "E083521", "E083522", "E083523", "E083529", "E083531") | inlist(i10_dx`num', "E083532", "E083533", "E083539", "E083541", "E083542") | inlist(i10_dx`num', "E083543", "E083549", "E083551", "E083552", "E083553") | inlist(i10_dx`num', "E083559", "E08359", "E083591", "E083592", "E083593") | inlist(i10_dx`num', "E083599", "E0836", "E0837X1", "E0837X2", "E0837X3") | inlist(i10_dx`num', "E0837X9", "E0839", "E0840", "E0841", "E0842") | inlist(i10_dx`num', "E0843", "E0844", "E0849", "E0851", "E0852") | inlist(i10_dx`num', "E0859", "E08610", "E08618", "E08620", "E08621") | inlist(i10_dx`num', "E08622", "E08628", "E08630", "E08638", "E08641") | inlist(i10_dx`num', "E08649", "E0865", "E0869", "E088", "E0921") | inlist(i10_dx`num', "E0922", "E0929", "E09311", "E09319", "E09321") | inlist(i10_dx`num', "E093211", "E093212", "E093213", "E093219", "E09329") | inlist(i10_dx`num', "E093291", "E093292", "E093293", "E093299", "E09331") | inlist(i10_dx`num', "E093311", "E093312", "E093313", "E093319", "E09339") | inlist(i10_dx`num', "E093391", "E093392", "E093393", "E093399", "E09341") | inlist(i10_dx`num', "E093411", "E093412", "E093413", "E093419", "E09349") | inlist(i10_dx`num', "E093491", "E093492", "E093493", "E093499", "E09351") | inlist(i10_dx`num', "E093511", "E093512", "E093513", "E093519", "E093521") | inlist(i10_dx`num', "E093522", "E093523", "E093529", "E093531", "E093532") | inlist(i10_dx`num', "E093533", "E093539", "E093541", "E093542", "E093543") | inlist(i10_dx`num', "E093549", "E093551", "E093552", "E093553", "E093559") | inlist(i10_dx`num', "E09359", "E093591", "E093592", "E093593", "E093599") | inlist(i10_dx`num', "E0936", "E0937X1", "E0937X2", "E0937X3", "E0937X9") | inlist(i10_dx`num', "E0939", "E0940", "E0941", "E0942", "E0943") | inlist(i10_dx`num', "E0944", "E0949", "E0951", "E0952", "E0959") | inlist(i10_dx`num', "E09610", "E09618", "E09620", "E09621", "E09622") | inlist(i10_dx`num', "E09628", "E09630", "E09638", "E09641", "E09649") | inlist(i10_dx`num', "E0965", "E0969", "E098", "E1021", "E1022") | inlist(i10_dx`num', "E1029", "E10311", "E10319", "E10321", "E103211") | inlist(i10_dx`num', "E103212", "E103213", "E103219", "E10329", "E103291") | inlist(i10_dx`num', "E103292", "E103293", "E103299", "E10331", "E103311") | inlist(i10_dx`num', "E103312", "E103313", "E103319", "E10339", "E103391") | inlist(i10_dx`num', "E103392", "E103393", "E103399", "E10341", "E103411") | inlist(i10_dx`num', "E103412", "E103413", "E103419", "E10349", "E103491") | inlist(i10_dx`num', "E103492", "E103493", "E103499", "E10351", "E103511") | inlist(i10_dx`num', "E103512", "E103513", "E103519", "E103521", "E103522") | inlist(i10_dx`num', "E103523", "E103529", "E103531", "E103532", "E103533") | inlist(i10_dx`num', "E103539", "E103541", "E103542", "E103543", "E103549") | inlist(i10_dx`num', "E103551", "E103552", "E103553", "E103559", "E10359") | inlist(i10_dx`num', "E103591", "E103592", "E103593", "E103599", "E1036") | inlist(i10_dx`num', "E1037X1", "E1037X2", "E1037X3", "E1037X9", "E1039") | inlist(i10_dx`num', "E1040", "E1041", "E1042", "E1043", "E1044") | inlist(i10_dx`num', "E1049", "E1051", "E1052", "E1059", "E10610") | inlist(i10_dx`num', "E10618", "E10620", "E10621", "E10622", "E10628") | inlist(i10_dx`num', "E10630", "E10638", "E10641", "E10649", "E1065") | inlist(i10_dx`num', "E1069", "E108", "E1121", "E1122", "E1129") | inlist(i10_dx`num', "E11311", "E11319", "E11321", "E113211", "E113212") | inlist(i10_dx`num', "E113213", "E113219", "E11329", "E113291", "E113292") | inlist(i10_dx`num', "E113293", "E113299", "E11331", "E113311", "E113312") | inlist(i10_dx`num', "E113313", "E113319", "E11339", "E113391", "E113392") | inlist(i10_dx`num', "E113393", "E113399", "E11341", "E113411", "E113412") | inlist(i10_dx`num', "E113413", "E113419", "E11349", "E113491", "E113492") | inlist(i10_dx`num', "E113493", "E113499", "E11351", "E113511", "E113512") | inlist(i10_dx`num', "E113513", "E113519", "E113521", "E113522", "E113523") | inlist(i10_dx`num', "E113529", "E113531", "E113532", "E113533", "E113539") | inlist(i10_dx`num', "E113541", "E113542", "E113543", "E113549", "E113551") | inlist(i10_dx`num', "E113552", "E113553", "E113559", "E11359", "E113591") | inlist(i10_dx`num', "E113592", "E113593", "E113599", "E1136", "E1137X1") | inlist(i10_dx`num', "E1137X2", "E1137X3", "E1137X9", "E1139", "E1140") | inlist(i10_dx`num', "E1141", "E1142", "E1143", "E1144", "E1149") | inlist(i10_dx`num', "E1151", "E1152", "E1159", "E11610", "E11618") | inlist(i10_dx`num', "E11620", "E11621", "E11622", "E11628", "E11630") | inlist(i10_dx`num', "E11638", "E11641", "E11649", "E1165", "E1169") | inlist(i10_dx`num', "E118", "E1321", "E1322", "E1329", "E13311") | inlist(i10_dx`num', "E13319", "E13321", "E133211", "E133212", "E133213") | inlist(i10_dx`num', "E133219", "E13329", "E133291", "E133292", "E133293") | inlist(i10_dx`num', "E133299", "E13331", "E133311", "E133312", "E133313") | inlist(i10_dx`num', "E133319", "E13339", "E133391", "E133392", "E133393") | inlist(i10_dx`num', "E133399", "E13341", "E133411", "E133412", "E133413") | inlist(i10_dx`num', "E133419", "E13349", "E133491", "E133492", "E133493") | inlist(i10_dx`num', "E133499", "E13351", "E133511", "E133512", "E133513") | inlist(i10_dx`num', "E133519", "E133521", "E133522", "E133523", "E133529") | inlist(i10_dx`num', "E133531", "E133532", "E133533", "E133539", "E133541") | inlist(i10_dx`num', "E133542", "E133543", "E133549", "E133551", "E133552") | inlist(i10_dx`num', "E133553", "E133559", "E13359", "E133591", "E133592") | inlist(i10_dx`num', "E133593", "E133599", "E1336", "E1337X1", "E1337X2") | inlist(i10_dx`num', "E1337X3", "E1337X9", "E1339", "E1340", "E1341") | inlist(i10_dx`num', "E1342", "E1343", "E1344", "E1349", "E1351") | inlist(i10_dx`num', "E1352", "E1359", "E13610", "E13618", "E13620") | inlist(i10_dx`num', "E13621", "E13622", "E13628", "E13630", "E13638") | inlist(i10_dx`num', "E13641", "E13649", "E1365", "E1369", "E138")
}
*Making complicated DM variable
foreach num of numlist 2/40 {
replace cm_dmcx = 1 if inlist(i10_dx`num', "E0800", "E0801", "E0810", "E0811", "E089") | inlist(i10_dx`num', "E0900", "E0901", "E0910", "E0911", "E099") | inlist(i10_dx`num', "E1010", "E1011", "E109", "E1100", "E1101") | inlist(i10_dx`num', "E1110", "E1111", "E119", "E1300", "E1301") | inlist(i10_dx`num', "E1310", "E1311", "E139", "O24011", "O24012") | inlist(i10_dx`num', "O24013", "O24019", "O2402", "O2403", "O24111") | inlist(i10_dx`num', "O24112", "O24113", "O24119", "O2412", "O2413") | inlist(i10_dx`num', "O24311", "O24312", "O24313", "O24319", "O2432") | inlist(i10_dx`num', "O2433", "O24410", "O24414", "O24415", "O24419") | inlist(i10_dx`num', "O24420", "O24424", "O24425", "O24429", "O24430") | inlist(i10_dx`num', "O24434", "O24435", "O24439", "O24811", "O24812") | inlist(i10_dx`num', "O24813", "O24819", "O2482", "O2483", "O24911") | inlist(i10_dx`num', "O24912", "O24913", "O24919", "O2492", "O2493")
}
*Making HTN variable - including complicated and uncomplicated
foreach num of numlist 2/40 {
replace cm_htn_c = 1 if inlist(i10_dx`num', "H35031", "H35032", "H35033", "H35039", "I110") | inlist(i10_dx`num', "I119", "I120", "I129", "I130", "I1310") | inlist(i10_dx`num', "I1311", "I132", "I150", "I151", "I152") | inlist(i10_dx`num', "I158", "I159", "I161", "I674", "O10111") | inlist(i10_dx`num', "O10112", "O10113", "O10119", "O1012", "O1013") | inlist(i10_dx`num', "O10211", "O10212", "O10213", "O10219", "O1022") | inlist(i10_dx`num', "O1023", "O10311", "O10312", "O10313", "O10319") | inlist(i10_dx`num', "O1032", "O1033", "O10411", "O10412", "O10413") | inlist(i10_dx`num', "O10419", "O1042", "O1043", "O10911", "O10912") | inlist(i10_dx`num', "O10913", "O10919", "O1092", "O1093", "O111") | inlist(i10_dx`num', "O112", "O113", "O114", "O115", "O119") | inlist(i10_dx`num', "O161", "O162", "O163", "O164", "O165") | inlist(i10_dx`num', "O169") | inlist(i10_dx`num', "I10", "I160", "I169", "O10011", "O10012") | inlist(i10_dx`num', "O10013", "O10019", "O1002", "O1003")  
}
*Making renal failure variable
foreach num of numlist 1/40 {
replace cm_renlfail = 1 if inlist(i10_dx`num', "N183", "N1830", "N1831", "N1832", "N189") | inlist(i10_dx`num', "N19", "I120", "I1311", "I132", "N184") | inlist(i10_dx`num', "N185", "N186", "Z4901", "Z4902", "Z4931") | inlist(i10_dx`num', "Z4932", "Z9115", "Z940", "Z992")
}
*PVD variable
foreach num of numlist 2/40 {
replace cm_perivasc = 1 if inlist(i10_dx`num', "A5200", "A5201", "A5202", "A5209", "I700") | inlist(i10_dx`num', "I701", "I70201", "I70202", "I70203", "I70208") | inlist(i10_dx`num', "I70209", "I70211", "I70212", "I70213", "I70218") | inlist(i10_dx`num', "I70219", "I70221", "I70222", "I70223", "I70228") | inlist(i10_dx`num', "I70229", "I70231", "I70232", "I70233", "I70234") | inlist(i10_dx`num', "I70235", "I70238", "I70239", "I70241", "I70242") | inlist(i10_dx`num', "I70243", "I70244", "I70245", "I70248", "I70249") | inlist(i10_dx`num', "I7025", "I70261", "I70262", "I70263", "I70268") | inlist(i10_dx`num', "I70269", "I70291", "I70292", "I70293", "I70298") | inlist(i10_dx`num', "I70299", "I70301", "I70302", "I70303", "I70308") | inlist(i10_dx`num', "I70309", "I70311", "I70312", "I70313", "I70318") | inlist(i10_dx`num', "I70319", "I70321", "I70322", "I70323", "I70328") | inlist(i10_dx`num', "I70329", "I70331", "I70332", "I70333", "I70334") | inlist(i10_dx`num', "I70335", "I70338", "I70339", "I70341", "I70342") | inlist(i10_dx`num', "I70343", "I70344", "I70345", "I70348", "I70349") | inlist(i10_dx`num', "I7035", "I70361", "I70362", "I70363", "I70368") | inlist(i10_dx`num', "I70369", "I70391", "I70392", "I70393", "I70398") | inlist(i10_dx`num', "I70399", "I70401", "I70402", "I70403", "I70408") | inlist(i10_dx`num', "I70409", "I70411", "I70412", "I70413", "I70418") | inlist(i10_dx`num', "I70419", "I70421", "I70422", "I70423", "I70428") | inlist(i10_dx`num', "I70429", "I70431", "I70432", "I70433", "I70434") | inlist(i10_dx`num', "I70435", "I70438", "I70439", "I70441", "I70442") | inlist(i10_dx`num', "I70443", "I70444", "I70445", "I70448", "I70449") | inlist(i10_dx`num', "I7045", "I70461", "I70462", "I70463", "I70468") | inlist(i10_dx`num', "I70469", "I70491", "I70492", "I70493", "I70498") | inlist(i10_dx`num', "I70499", "I70501", "I70502", "I70503", "I70508") | inlist(i10_dx`num', "I70509", "I70511", "I70512", "I70513", "I70518") | inlist(i10_dx`num', "I70519", "I70521", "I70522", "I70523", "I70528") | inlist(i10_dx`num', "I70529", "I70531", "I70532", "I70533", "I70534") | inlist(i10_dx`num', "I70535", "I70538", "I70539", "I70541", "I70542") | inlist(i10_dx`num', "I70543", "I70544", "I70545", "I70548", "I70549") | inlist(i10_dx`num', "I7055", "I70561", "I70562", "I70563", "I70568") | inlist(i10_dx`num', "I70569", "I70591", "I70592", "I70593", "I70598") | inlist(i10_dx`num', "I70599", "I70601", "I70602", "I70603", "I70608") | inlist(i10_dx`num', "I70609", "I70611", "I70612", "I70613", "I70618") | inlist(i10_dx`num', "I70619", "I70621", "I70622", "I70623", "I70628") | inlist(i10_dx`num', "I70629", "I70631", "I70632", "I70633", "I70634") | inlist(i10_dx`num', "I70635", "I70638", "I70639", "I70641", "I70642") | inlist(i10_dx`num', "I70643", "I70644", "I70645", "I70648", "I70649") | inlist(i10_dx`num', "I7065", "I70661", "I70662", "I70663", "I70668") | inlist(i10_dx`num', "I70669", "I70691", "I70692", "I70693", "I70698") | inlist(i10_dx`num', "I70699", "I70701", "I70702", "I70703", "I70708") | inlist(i10_dx`num', "I70709", "I70711", "I70712", "I70713", "I70718") | inlist(i10_dx`num', "I70719", "I70721", "I70722", "I70723", "I70728") | inlist(i10_dx`num', "I70729", "I70731", "I70732", "I70733", "I70734") | inlist(i10_dx`num', "I70735", "I70738", "I70739", "I70741", "I70742") | inlist(i10_dx`num', "I70743", "I70744", "I70745", "I70748", "I70749") | inlist(i10_dx`num', "I7075", "I70761", "I70762", "I70763", "I70768") | inlist(i10_dx`num', "I70769", "I70791", "I70792", "I70793", "I70798") | inlist(i10_dx`num', "I70799", "I708", "I7090", "I7091", "I7092") | inlist(i10_dx`num', "I7100", "I7101", "I7102", "I7103", "I711") | inlist(i10_dx`num', "I712", "I713", "I714", "I715", "I716") | inlist(i10_dx`num', "I718", "I719", "I720", "I721", "I722") | inlist(i10_dx`num', "I723", "I724", "I725", "I726", "I728") | inlist(i10_dx`num', "I729", "I7301", "I731", "I7381", "I7389") | inlist(i10_dx`num', "I739", "I7401", "I7409", "I7410", "I7411") | inlist(i10_dx`num', "I7419", "I742", "I743", "I744", "I745") | inlist(i10_dx`num', "I748", "I749", "I75011", "I75012", "I75013") | inlist(i10_dx`num', "I75019", "I75021", "I75022", "I75023", "I75029") | inlist(i10_dx`num', "I7581", "I7589", "I770", "I771", "I772") | inlist(i10_dx`num', "I773", "I774", "I775", "I776", "I7770") | inlist(i10_dx`num', "I7771", "I7772", "I7773", "I7774", "I7775") | inlist(i10_dx`num', "I7776", "I7777", "I7779", "I77810", "I77811") | inlist(i10_dx`num', "I77812", "I77819", "I7789", "I779", "I780") | inlist(i10_dx`num', "I781", "I788", "I789", "I790", "I791") | inlist(i10_dx`num', "I798", "I998", "I999", "K31811", "K31819") | inlist(i10_dx`num', "K551", "K558", "K559", "Z95820", "Z95828") 
}

save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2016-2018 - Analysis V2b.dta", replace

log close

*************************/
*************************
*************************
*************************
*PUTTING EVERYTING BACK TOGETHER (all years)
*************************
*************************
*************************
*************************

log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/NIS AAA Disparaties 2012-2018- Analysis log V3 Full Dataset.log", replace

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2016-2018 - Analysis V2b.dta", clear
append using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2012-2014 - Analysis V3.dta"
append using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/Data Analysis/Temp Data Files - AAA project Merging Severity files/NIS AAA Disparaties 2015 - Analysis V3.dta"

*Do not need
drop  i10_dx31-i10_dx40 prday16-prday25 i10_ecause1-i10_necause cm_arth cm_bldloss cm_coag cm_depress cm_drug cm_hypothy cm_liver cm_lymph cm_lytes cm_mets cm_para cm_psych cm_pulmcirc cm_tumor cm_ulcer cm_valve cm_wghtloss 

****DEFINING VARIABLES
gen age_cat = 0
foreach n of numlist 10(10)60 {
replace age_cat = `n' if age >=20+`n' & age<30+`n'
}
replace age_cat = 70 if age >=90 

label define age_cat 0 "18-29" 10 "30-39" 20 "40-49" 30 "50-59" 40 "60-69" 50 "70-79" 60 "80-89" 70 ">90", replace
label value age_cat age_cat

replace race = 7 if race ==.
label define race 1 "White" 2 "Black" 3 "Hispanic" 4 "Asian or Pacific Islander" 5 "Native American" 6 "Other" 7 "Missing", replace
label value race race 

gen race_short = 0 if race==1
replace race_short = 1 if race==2
replace race_short = 2 if race==3
label define race_short 0 "White" 1 "Black" 2 "Hispanic", replace
label value race_short race_short

****DEFINE OTHER VARIABLES
replace hosp_bedsize = 4 if hosp_bedsize==.
label define hosp_bedsize 1 "small" 2 "medium" 3 "large" 4 "missing", replace
label value hosp_bedsize hosp_bedsize

label define hosp_division 1 "New England" 2 "Middle Atlantic" 3 "East North Central" 4 "West North Central" 5 "South Atlantic" 6 "East South Central" 7 "West South Central" 8 "Mountain" 9 "Pacific", replace

replace hosp_locteach = 4 if hosp_locteach==. 
label define hosp_locteach 1 "rural" 2 "urban non teaching" 3 "urban teaching" 4 "missing"
label value hosp_locteach hosp_locteach

label define hosp_region 1 "Northeast" 2 "Midwest" 3 "South" 4 "West" 
label value hosp_region hosp_region

label define pay1 1 "Medicare" 2 "Medicaid" 3 "Private" 4 "self-pay" 5 "no charge" 6 "other" 7 "missing"
label value pay1 pay1


*OTHER VARIABLES
gen white = 0 
replace white = 1 if race_short ==0
gen black = 0 
replace black = 1 if race_short ==1
gen asian = 0 
replace asian = 1 if race ==4
gen race_other = 0 
replace race_other = 1 if inlist(race, 2, 5, 6)
gen race_otherwasian = 0 
replace race_otherwasian = 1 if inlist(race, 2, 5, 6, 4)
gen race_missing = 0 
replace race_missing =1 if race==7

gen male = 0 if female==1
replace male = 1 if female ==0

gen aaa_repair = .
replace aaa_repair = 1 if proc_aaa_evar == 1
replace aaa_repair = 2 if proc_aaa_open == 1
replace aaa_repair = 3 if (proc_aaa_evar !=1 & proc_aaa_open !=1) & i10_dx1_aaa_rupture_intact==1
label define aaa_repair 1 "EVAR" 2 "OSR" 3 "No Repair"
label value aaa_repair aaa_repair

foreach n of numlist 1/4 {
gen income_q`n' = 0
replace income_q`n' = 1 if zipinc_qrt==`n'
}

foreach n of numlist 1/4 {
gen hosp_region`n' = 0
replace hosp_region`n' = 1 if hosp_region==`n'
} 

foreach num of numlist 1/6 {
	gen pay1_`num' =0
	replace pay1_`num' = 1 if pay1==`num'
	}
	
	foreach num of numlist 0/2 {
	gen tranin_`num' =0
	replace tranin_`num' = 1 if tran_in==`num'
	}
	
gen dispo = 0 if dispuniform ==1 
replace dispo = 1 if dispuniform ==3
replace dispo = 2 if dispuniform ==6
replace dispo = 3 if inlist(2, 7, 99)
replace dispo = 4 if dispuniform ==.

label define dispo 0 "Home or self care" 1 "Skilled Nursing Facility" 2 "Home Health Care" 3 "Other" 4 "Missing", replace
label value dispo dispo

	
	foreach num of numlist 0/5 {
	gen dispo`num' =0
	replace dispo`num' = 1 if dispo==`num'
	}
	
	foreach num of numlist 0/2 {
	gen aaa_type`num' =0
	replace aaa_type`num' = 1 if aaa_type==`num'
	}
	
*Creating a diabetes variable, categorical 
gen cm_dm_cat = 0
replace cm_dm_cat = 1 if cm_dm ==1
replace cm_dm_cat = 2 if cm_dmcx==1
label define cm_dm_cat 0 "None" 1 "Diabetes" 2 "Diabetes with complications" , replace
label value cm_dm_cat cm_dm_cat 

gen cm_dm_bin = 0
replace cm_dm_bin = 1 if cm_dm_cat>0

*Creating the AAA admission type into a categorical varaible 
gen i10_dx1_aaa_cat = .
replace i10_dx1_aaa_cat = 0 if i10_dx1_aaa_intact==1
replace i10_dx1_aaa_cat = 1 if i10_dx1_aaa_rupture ==1 
label define i10_dx1_aaa_cat 0 "Intact" 1 "Rutpure"
label value  i10_dx1_aaa_cat i10_dx1_aaa_cat

*Creating the AAA repair as a categorical variable
gen aaa_type = 0 if proc_aaa_evar==1
replace aaa_type = 1 if proc_aaa_open==1
replace aaa_type = 2 if proc_aaa_evar!=1 & proc_aaa_open!=1
label define aaa_type 0 "EVAR" 1 "Open" 2 "No intervention"
label value aaa_type aaa_type

*************
*CREATING THE INCDENCES:
gen rup_intact = i10_dx1_aaa_rupture_intact
gen rup = i10_dx1_aaa_rupture
gen intact = i10_dx1_aaa_intact

gen dm = cm_dm_bin
gen ctdz = cm_ctdz_notelixhauser 
gen chrnlung = cm_chrnlung 
gen smoke = cm_smoke_notelixhuaser 
gen perivasc = cm_perivasc 
gen renlfail = cm_renlfail 
gen htn = cm_htn_c

gen age_less65 = 0 
replace age_less65 = 1 if age<65
gen age_65_75 = 0
replace age_65_75=1 if age<75 & age>=65
gen age_gr75 = 0 
replace age_gr75 =1 if age>75 & age!=.

foreach var of varlist dm ctdz chrnlung smoke perivasc renlfail htn {
	gen n`var'=`var'
	recode n`var' (0=1) (1=0)
}

foreach var of varlist rup_intact  intact rup { 
	foreach v of varlist female male black white asian race_other race_missing  dm ctdz chrnlung smoke perivasc renlfail htn ndm nctdz nchrnlung nsmoke nperivasc nrenlfail nhtn age_less65 age_65_75 age_gr75 {
	gen i10_`var'_`v'=0
	replace i10_`var'_`v'=1 if `v'==1 & `var'==1
	}
}

*Creating age categories to match the US Census categories
gen age_cat4 = .
foreach n of numlist  24  34  44  54  64  74  84 {
replace age_cat4 = `n'  if age<=(`n') & age_cat4>`n'
}
replace age_cat4 = 85 if age>84 & age!=.
replace age_cat4 = . if age_cat4==24 & age<20

save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3.dta", replace 

log close


