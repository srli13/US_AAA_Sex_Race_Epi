/*************************Katie Reitz, Jason Kennedy, and Shimena Li 4-5-2021 
Creating Hospitalization Estimations 
1. Generate variables for numerators of interest 
2. Create age groups according to census ages by groups of interest 
3. Run hospitalization estimates using svy command 

*************************/
 use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3.dta", clear

*CREATING THE VARIABLES AND DATASET: 
 keep age white black asian race_other race_missing female male  i10_dx1_aaa_intact  i10_dx1_aaa_rupture year discwt hosp_nis los died

gen age_census_18 = 0
replace age_census_18 = 1 if age>=18 & age<25
label variable age_census_18 "age>= age_census_# to next cat"
foreach num of numlist  25 35 45 55 65 75  {
gen age_census_`num' = 1 if age>=`num' & age<(`num'+10)
replace age_census_`num' = 0 if age_census_`num' ==.
}
gen age_census_85 = 0 
replace age_census_85 = 1 if age>=85 & age!=.
label variable age_census_85 "age>= age_census_# to next cat"

**GENERATING THE NUMERATORS for AAA hospitalizations 
foreach num of numlist 18 25 35 45 55 65 75  85 {
	gen int_bl_`num' = 1 if age_census_`num'==1 & black==1 & i10_dx1_aaa_intact==1
	gen rup_bl_`num' = 1 if age_census_`num'==1 & black==1 & i10_dx1_aaa_rupture==1
	gen int_wh_`num' = 1 if age_census_`num'==1 & white==1 & i10_dx1_aaa_intact==1
	gen rup_wh_`num' = 1 if age_census_`num'==1 & white==1 & i10_dx1_aaa_rupture==1
	gen int_asian_`num' = 1 if age_census_`num'==1 & asian==1 & i10_dx1_aaa_intact==1
	gen rup_asian_`num' = 1 if age_census_`num'==1 & asian==1 & i10_dx1_aaa_rupture==1

	
	gen int_female_`num' = 1 if age_census_`num'==1 & female==1 & i10_dx1_aaa_intact==1
	gen rup_female_`num' = 1 if age_census_`num'==1 & female==1 & i10_dx1_aaa_rupture==1
	
	gen int_male_`num' = 1 if age_census_`num'==1 & male==1 & i10_dx1_aaa_intact==1
	gen rup_male_`num' = 1 if age_census_`num'==1 & male==1 & i10_dx1_aaa_rupture==1
}

**GENERATING THE NUMERATOR for AAA hospitalizations with in-hospital mortality 
foreach num of numlist  18 25 35 45 55 65 75  85 {
	gen int_bl_d`num' = 1 if age_census_`num'==1 & black==1 & i10_dx1_aaa_intact==1 & died==1
	gen rup_bl_d`num' = 1 if age_census_`num'==1 & black==1 & i10_dx1_aaa_rupture==1  & died==1
	gen int_wh_d`num' = 1 if age_census_`num'==1 & white==1 & i10_dx1_aaa_intact==1  & died==1
	gen rup_wh_d`num' = 1 if age_census_`num'==1 & white==1 & i10_dx1_aaa_rupture==1 & died==1
	gen int_asian_d`num' = 1 if age_census_`num'==1 & asian==1 & i10_dx1_aaa_intact==1 & died==1
	gen rup_asian_d`num' = 1 if age_census_`num'==1 & asian==1 & i10_dx1_aaa_rupture==1 & died==1

	
	gen int_female_d`num' = 1 if age_census_`num'==1 & female==1 & i10_dx1_aaa_intact==1 & died==1
	gen rup_female_d`num' = 1 if age_census_`num'==1 & female==1 & i10_dx1_aaa_rupture==1 & died==1
	
	gen int_male_d`num' = 1 if age_census_`num'==1 & male==1 & i10_dx1_aaa_intact==1 & died==1
	gen rup_male_d`num' = 1 if age_census_`num'==1 & male==1 & i10_dx1_aaa_rupture==1 & died==1
}

**Generating groups of interest by AAA hospitalization type, race, sex and age 
foreach var of varlist int_bl_18 rup_bl_18 int_wh_18 rup_wh_18 int_asian_18 rup_asian_18 int_female_18 rup_female_18 int_male_18 rup_male_18 int_bl_25 rup_bl_25 int_wh_25 rup_wh_25 int_asian_25 rup_asian_25 int_female_25 rup_female_25 int_male_25 rup_male_25 int_bl_35 rup_bl_35 int_wh_35 rup_wh_35 int_asian_35 rup_asian_35 int_female_35 rup_female_35 int_male_35 rup_male_35 int_bl_45 rup_bl_45 int_wh_45 rup_wh_45 int_asian_45 rup_asian_45 int_female_45 rup_female_45 int_male_45 rup_male_45 int_bl_55 rup_bl_55 int_wh_55 rup_wh_55 int_asian_55 rup_asian_55 int_female_55 rup_female_55 int_male_55 rup_male_55 int_bl_65 rup_bl_65 int_wh_65 rup_wh_65 int_asian_65 rup_asian_65 int_female_65 rup_female_65 int_male_65 rup_male_65 int_bl_75 rup_bl_75 int_wh_75 rup_wh_75 int_asian_75 rup_asian_75 int_female_75 rup_female_75 int_male_75 rup_male_75 int_bl_85 rup_bl_85 int_wh_85 rup_wh_85 int_asian_85 rup_asian_85 int_female_85 rup_female_85 int_male_85 rup_male_85 int_bl_d18 rup_bl_d18 int_wh_d18 rup_wh_d18 int_asian_d18 rup_asian_d18 int_female_d18 rup_female_d18 int_male_d18 rup_male_d18 int_bl_d25 rup_bl_d25 int_wh_d25 rup_wh_d25 int_asian_d25 rup_asian_d25 int_female_d25 rup_female_d25 int_male_d25 rup_male_d25 {
	replace `var'=0 if `var'==.
}

save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Data/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3 SLIM 5- age cat table.dta", replace
*/

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Data/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3 SLIM 5- age cat table.dta", clear

svyset hosp_nis [pw=discwt], strata(year)

***************************
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Age Cat for Figures - Race.log", replace
***************************
*ALIVE AND TOTAL AAA hospitalizations 
*By Race intact AAA
foreach var of varlist int_bl_18 int_bl_25 int_bl_35 int_bl_45 int_bl_55 int_bl_65 int_bl_75 int_bl_85 int_bl_d18 int_wh_18 int_wh_25 int_wh_35 int_wh_45 int_wh_55 int_wh_65 int_wh_75 int_wh_85 int_asian_18 int_asian_25 int_asian_35 int_asian_45 int_asian_55 int_asian_65 int_asian_75 int_asian_85{
	svy: proportion `var' if age>=18
}
*by Race Ruptured AAA
foreach var of varlist rup_wh_18 rup_wh_25 rup_wh_35 rup_wh_45 rup_wh_55 rup_wh_65 rup_wh_75 rup_wh_85 rup_bl_18 rup_bl_25 rup_bl_35 rup_bl_45 rup_bl_55 rup_bl_65 rup_bl_75 rup_bl_85 rup_asian_18 rup_asian_25 rup_asian_35 rup_asian_45 rup_asian_55 rup_asian_65 rup_asian_75 rup_asian_85{
	svy: proportion `var' if age>=18
}

log close
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Age Cat for Figures - Sex.log", replace

* by Sex intact AAA
foreach var of varlist int_female_18 int_female_25 int_female_35 int_female_45 int_female_55 int_female_65 int_female_75 int_female_85 int_male_18 int_male_25 int_male_35 int_male_45 int_male_55 int_male_65 int_male_75 int_male_85 {
	svy: proportion `var' if age>=18
}
*by Sex Ruptured AAA
foreach var of varlist rup_male_18 rup_male_25 rup_male_35 rup_male_45 rup_male_55 rup_male_65 rup_male_75 rup_male_85 rup_female_18 rup_female_25 rup_female_35 rup_female_45 rup_female_55 rup_female_65 rup_female_75 rup_female_85 {
	svy: proportion `var' if age>=18
}
log close

***************************
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Age Cat for Figures - Race died 2 .log", replace
***************************
*Hospitalizations for AAA with in-hospital mortality 
*By Race intact AAA
foreach var of varlist   int_bl_d45 int_bl_d55 int_bl_d65 int_bl_d75 int_bl_d85  int_wh_d45 int_wh_d55 int_wh_d65 int_wh_d75 int_wh_d85 int_asian_d45 int_asian_d55 int_asian_d65 int_asian_d75 int_asian_d85 {
	svy: proportion `var' if age>=18
}
*by Race Ruptured AAA
foreach var of varlist rup_bl_d35 rup_bl_d45 rup_bl_d55 rup_bl_d65 rup_bl_d75 rup_bl_d85 rup_wh_d35 rup_wh_d45 rup_wh_d55 rup_wh_d65 rup_wh_d75 rup_wh_d85 rup_asian_d35 rup_asian_d45 rup_asian_d55 rup_asian_d65 rup_asian_d75 rup_asian_d85 {
	svy: proportion `var' if age>=18
}
log close

log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Age Cat for Figures - Sex died.log", replace
*by sex intact AAA
foreach var of varlist  int_male_d45 int_male_d55 int_male_d65 int_male_d75 int_male_d85  int_female_d45 int_female_d55 int_female_d65 int_female_d75 int_female_d85  {
	svy: proportion `var' if age>=18
}
*by sex Ruptured AAA
foreach var of varlist  rup_male_d35 rup_male_d45 rup_male_d55 rup_male_d65 rup_male_d75 rup_male_d85  rup_female_d35 rup_female_d45 rup_female_d55 rup_female_d65 rup_female_d75 rup_female_d85 {
	svy: proportion `var' if age>=18
}
log close
