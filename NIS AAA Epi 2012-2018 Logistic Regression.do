/******************
Katie Reitz, Jason Kennedy, Shimena Li 4-14-2021
Generated adjusted odds ratios for iAAA and rAAA hospitalizations in NIS
1) Drop variables not needed to minimize the file size
2) Set survey function 
3) Run main models and interaction terms with linear combinations for the subgroup analysis. 
******************/

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3.dta", clear

*Data not needed
drop i10_rup_intact_female i10_rup_intact_male i10_rup_intact_black i10_rup_intact_white i10_rup_intact_asian i10_rup_intact_race_other i10_rup_intact_race_missing i10_rup_intact_dm i10_rup_intact_ctdz i10_rup_intact_chrnlung i10_rup_intact_smoke i10_rup_intact_perivasc i10_rup_intact_renlfail i10_rup_intact_htn i10_rup_intact_ndm i10_rup_intact_nctdz i10_rup_intact_nchrnlung i10_rup_intact_nsmoke i10_rup_intact_nperivasc i10_rup_intact_nrenlfail i10_rup_intact_nhtn i10_rup_intact_age_less65 i10_rup_intact_age_65_75 i10_rup_intact_age_gr75 i10_intact_female i10_intact_male i10_intact_black i10_intact_white i10_intact_asian i10_intact_race_other i10_intact_race_missing i10_intact_dm i10_intact_ctdz i10_intact_chrnlung i10_intact_smoke i10_intact_perivasc i10_intact_renlfail i10_intact_htn i10_intact_ndm i10_intact_nctdz i10_intact_nchrnlung i10_intact_nsmoke i10_intact_nperivasc i10_intact_nrenlfail i10_intact_nhtn i10_intact_age_less65 i10_intact_age_65_75 i10_intact_age_gr75 i10_rup_female i10_rup_male i10_rup_black i10_rup_white i10_rup_asian i10_rup_race_other i10_rup_race_missing i10_rup_dm i10_rup_ctdz i10_rup_chrnlung i10_rup_smoke i10_rup_perivasc i10_rup_renlfail i10_rup_htn i10_rup_ndm i10_rup_nctdz i10_rup_nchrnlung i10_rup_nsmoke i10_rup_nperivasc i10_rup_nrenlfail i10_rup_nhtn i10_rup_age_less65 i10_rup_age_65_75 i10_rup_age_gr75 i10_dx1_aaa_cat income_q1 income_q2 income_q3 income_q4 hosp_region1 hosp_region2 hosp_region3 hosp_region4 age_neonate amonth aweekend
drop  h_contrl n_disc_u n_hosp_u s_disc_u s_hosp_u dxver prver  nchronic ndx necode neomat serviceline aprdrg aprdrg_risk_mortality aprdrg_severity cm_aids cm_alcohol cm_anemdef pl_nchs2006 dxmccs1 npr

*Cleaning variables for models
gen race_model = . 
replace race_model = 0 if race ==1
replace race_model =1 if race==2
replace race_model = 2 if inlist(race, 4)
replace race_model = 3 if inlist(race, 3,  5, 6)
replace race_model = 4 if race==7
label define race_model 0 "White" 1 "Black" 2 "Asian" 3 "Other" 4 "Unknown" , replace
label value race_model  

label define hosp_locteach 1 "Rural" 2 "Urban nonteaching" 3 "Urban teaching" 4 "Missing", replace
label value hosp_locteach hosp_locteach

label define tran_in 0 "Not transfered in" 1 "Transferred in from a different acute care hospital" 2 "Transferred in from another type of health facility", replace
label value tran_in tran_in 

 gen age_cat_formodel = 0 if age_less65 ==1
  replace age_cat_formodel = 1 if age_65_75 ==1 
  replace age_cat_formodel = 2 if age_gr75==1
  
  gen i10_dx1_aaa_cat = 0 if i10_dx1_aaa_intact==1
  replace i10_dx1_aaa_cat = 1 if  i10_dx1_aaa_rupture==1

save "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Data/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3 SLIM 2.dta", replace

use "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Data/NIS AAA Disparaties 2012-2018 w smoking and ctdz- Analysis V3 SLIM 2.dta", clear

************************
*Odds of HOSPITALIZATION*
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression for AAA hopsitalization -- OVERALL LOG REG.log", replace

***REGRESSION ANALYSIS (Set survey)
svyset hosp_nis [pw=discwt], strata(year)

**Models
*Intact or rupture
svy: logit i10_dx1_aaa_rupture_intact i.race_model female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.year  i.hosp_region  if age>=18 , nolog or
*Intact
svy: logit i10_dx1_aaa_intact i.race_model female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.year  i.hosp_region  if age>=18 , nolog or 
*Rupture
svy: logit i10_dx1_aaa_rupture i.race_model female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.year  i.hosp_region  if age>=18 , nolog or 

log close
************************

************************
*Adjusted odds of Rutpure
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression for AAA hopsitalization -- RUPTURE LOG REG.log", replace

svy: logit i10_dx1_aaa_rupture i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 

	*Added the overall interaction term p-value
*Black vs. White
	foreach var of varlist  female  cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser  {
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.`var'  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#`var'  , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model  , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.`var'  , or

*Asian vs. White
	*VAR0 (asian vs white)
	lincom  2.race_model   , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.`var'  , or
	}

*Black vs. White Zip Income Quartile 
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.zipinc_qrtl  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.zipinc_qrtl  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#2.zipinc_qrtl  , or
	*VAR3 (black vs white)
	lincom  1.race_model + 1.race_model#3.zipinc_qrtl  , or
	
*Black vs. White Hospital Region 
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.hosp_region  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#hosp_region , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.hosp_region  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#2.hosp_region  , or
	*VAR3 (black vs white)
	lincom  1.race_model + 1.race_model#3.hosp_region  , or

*Black vs. white Hospitalization Age category
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.age_cat_formodel  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.age_cat_formodel  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#2.age_cat_formodel  , or
	
*Asian vs. White Zip Income Quartile 
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.zipinc_qrtl  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.zipinc_qrtl  , or
	*VAR2 (asian vs white)
	lincom  2.race_model + 2.race_model#2.zipinc_qrtl  , or
	*VAR3 (asian vs white)
	lincom  2.race_model + 2.race_model#3.zipinc_qrtl  , or

*Asian vs. White Hospital Region 
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.hosp_region  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#hosp_region , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.hosp_region  , or
	*VAR2 (asian vs white)
	lincom  2.race_model + 2.race_model#2.hosp_region  , or
	*VAR3 (asian vs white)
	lincom  2.race_model + 2.race_model#3.hosp_region  , or

*Asian vs. White Hospitalization Age Category 
	svy: logit i10_dx1_aaa_rupture  i.race_model##i.age_cat_formodel  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.age_cat_formodel  , or
	*VAR2 (asian vs white)
	lincom  2.race_model + 2.race_model#2.age_cat_formodel  , or
	
*Female vs. Male 
	foreach var of varlist  race_model  cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser {
	svy: logit i10_dx1_aaa_rupture  female##i.`var' i.race_model  age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser  i.year  i.hosp_region  if age>=18 , nolog or 
	*white (female vs male)
	lincom  1.female   , or
	*black (female vs male)
	lincom  1.female + 1.female#1.`var'  , or
	}
	
	log close
	************************
	
	************************
	log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression for AAA hopsitalization -- RUPTURE LOG REG MISSING FEMALE 5-14.log", replace

*Female vs. Male Zip Income Quartile 
	svy: logit i10_dx1_aaa_rupture  female##i.zipinc_qrtl i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 female vs male)
	lincom  1.female + 1.female#1.zipinc_qrtl  , or
	*Var2 female vs male
	lincom  1.female + 1.female#2.zipinc_qrtl  , or
	*VAR3 (female vs male
	lincom  1.female + 1.female#3.zipinc_qrtl  , or
	*VAR4 (female vs male)
	lincom  1.female + 1.female#4.zipinc_qrtl  , or

*Female vs. Male Hospital Region 
	svy: logit i10_dx1_aaa_rupture  female##i.hosp_region i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#hosp_region , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female + 1.female#1.hosp_region  , or
	*Var2 (female vs male)
	lincom  1.female + 1.female#2.hosp_region  , or
	*VAR3 (female vs male)
	lincom  1.female + 1.female#3.hosp_region  , or
	*VAR4 (female vs male)
	lincom  1.female + 1.female#4.hosp_region  , or
	
*Female vs. Male Hospitalization Age Category		
	svy: logit i10_dx1_aaa_rupture  female##i.age_cat_formodel i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female + 1.female#1.age_cat_formodel  , or
	*VAR2 (female vs male)
	lincom  1.female + 1.female#2.age_cat_formodel  , or

*Female vs. Male Race 
	svy: logit i10_dx1_aaa_rupture  female##i.race_model  i.race_model age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#race_model , overall emptycells(reweight)
	*WHITES (female vs male)
	lincom  1.female    , or
	*BLACKS female vs male)
	lincom  1.female + 1.female#1.race_model  , or
	*ASIANS (female vs male
	lincom  1.female + 1.female#2.race_model  , or
	*lincom  1.female + 1.female#3.race_model  , or
	*lincom  1.female + 1.female#4.race_model  , or
	
	log close
***********************

	
************************
*Adjusted odds INTACT***

log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression for AAA hopsitalization -- INTACT LOG REG.log", replace

*INTACT overall model 
svy: logit i10_dx1_aaa_intact i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 

*Added the overall interaction term p-value
	foreach var of varlist  female  cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser  {
	svy: logit i10_dx1_aaa_intact  i.race_model##i.`var'  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#`var' , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model  , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.`var'  , or

	*VAR0 (asian vs white)
	lincom  2.race_model   , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.`var'  , or
	}

*Black vs. White Hospitalization Age Category
		svy: logit i10_dx1_aaa_intact  i.race_model##i.age_cat_formodel  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.age_cat_formodel  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#2.age_cat_formodel  , or
	
*Asian vs. White Hospitalization Age Category 
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.age_cat_formodel  , or
	*VAR2 (asian vs white)
	lincom  2.race_model + 2.race_model#2.age_cat_formodel  , or

*Female vs. Male Hospitalization Age Category 	
	svy: logit i10_dx1_aaa_intact  female##i.age_cat_formodel i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female + 1.female#1.age_cat_formodel  , or
	*VAR2 (female vs male)
	lincom  1.female + 1.female#2.age_cat_formodel  , or

	
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression for AAA hopsitalization -- INTACT LOG REG - missing interaction data.log", replace

*Black vs. White Zip Income Quartile	
	svy: logit i10_dx1_aaa_intact  i.race_model##i.zipinc_qrtl  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#2.zipinc_qrtl  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#3.zipinc_qrtl  , or
	*VAR3 (black vs white)
	lincom  1.race_model + 1.race_model#4.zipinc_qrtl  , or

*Black vs. White Hospital Region 
	svy: logit i10_dx1_aaa_intact  i.race_model##i.hosp_region  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#hosp_region , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#2.hosp_region  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#3.hosp_region  , or
	*VAR3 (black vs white)
	lincom  1.race_model + 1.race_model#4.hosp_region  , or

*Asian vs. White Zip Income Quartile	
	svy: logit i10_dx1_aaa_intact  i.race_model##i.zipinc_qrtl  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#2.zipinc_qrtl  , or
	*VAR2 (asian vs white)
	lincom  2.race_model + 2.race_model#3.zipinc_qrtl  , or
	*VAR3 (asian vs white)
	lincom  2.race_model + 2.race_model#4.zipinc_qrtl  , or

*Asian vs. White Hospital Region 
	svy: logit i10_dx1_aaa_intact  i.race_model##i.hosp_region  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast race_model#hosp_region , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#2.hosp_region  , or
	*VAR2 (asian vs whitee)
	lincom  2.race_model + 2.race_model#3.hosp_region  , or
	*VAR3 (asian vs white)
	lincom  2.race_model + 2.race_model#4.hosp_region  , or
	
	log close 

log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression for AAA hopsitalization -- INTACT LOG REG female main interactions.log", replace

***REGRESSION ANALYSIS INTACT, Female interactions 
svyset hosp_nis [pw=discwt], strata(year)

foreach var of varlist    cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser {
	svy: logit i10_dx1_aaa_intact  female##i.`var' i.race_model  age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser  i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#`var' , overall emptycells(reweight)
	*V0 (female vs male)
	lincom  1.female   , or
	*V1 (female vs male)
	lincom  1.female + 1.female#1.`var'  , or
	}

*Female vs. Male Race
			svy: logit i10_dx1_aaa_intact  female##i.race_model  i.race_model age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#race_model , overall emptycells(reweight)
	*WHITES (female vs male)
	lincom  1.female    , or
	*BLACKS female vs male)
	lincom  1.female + 1.female#1.race_model  , or
	*ASIANS (female vs male
	lincom  1.female + 1.female#2.race_model  , or
	*ASIANS (female vs male
	lincom  1.female + 1.female#3.race_model  , or
	*ASIANS (female vs male
	lincom  1.female + 1.female#4.race_model  , or

*Female vs. Male Zip Income Quartile	
		svy: logit i10_dx1_aaa_intact  female##i.zipinc_qrtl  i.race_model age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 female vs male)
	lincom  1.female + 1.female#2.zipinc_qrtl  , or
	*VAR2 (female vs male
	lincom  1.female + 1.female#3.zipinc_qrtl  , or
	*VAR3 (female vs male)
	lincom  1.female + 1.female#4.zipinc_qrtl  , or

*Female vs. Male Hospital Region
	svy: logit i10_dx1_aaa_intact  female##i.hosp_region  i.race_model age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#hosp_region , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female + 1.female#2.hosp_region  , or
	*VAR2 (female vs male)
	lincom  1.female + 1.female#3.hosp_region  , or
	*VAR3 (female vs male)
	lincom  1.female + 1.female#4.hosp_region  , or
	
*Female vs. Male Hospitalization Age Category 	
		svy: logit i10_dx1_aaa_intact  female##i.age_cat_formodel i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser   i.year  i.hosp_region  if age>=18 , nolog or 
	contrast female#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female + 1.female#1.age_cat_formodel  , or
	*VAR2 (female vs male)
	lincom  1.female + 1.female#2.age_cat_formodel  , or
	
log close

************************
************************
*PREDICTING MORTALITY
************************
************************
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression - inhosp mort.log" , replace

***REGRESSION ANALYSIS
svyset hosp_nis [pw=discwt], strata(year)

*PREDICTING DEATH MODEL 
svy: logit died  i.race_model  female age i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 

log close

************************
************************
*PREDICTING MORTALITY - RACE SUBGROUPS
************************
************************
log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression - inhosp mort - race.log" , replace

*By race (mortality prediction, intact and ruptured AAA)
foreach var of varlist  female cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i10_dx1_aaa_cat  {
svy: logit died  i.race_model##i.`var'  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#`var' , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model  , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#1.`var'  , or

	*VAR0 (asian vs white)
	lincom  2.race_model   , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.`var'  , or
}

*Black vs. White Zip Income Quartile 
svy: logit died  i.race_model##i.zipinc_qrtl  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs white)
	lincom  1.race_model + 1.race_model#2.zipinc_qrtl  , or
	*VAR2 (black vs white)
	lincom  1.race_model + 1.race_model#3.zipinc_qrtl  , or
	*VAR3 (black vs white)
	lincom  1.race_model + 1.race_model#4.zipinc_qrtl  , or
	
*Asian vs. White Zip Income Quartile 
svy: logit died  i.race_model##i.zipinc_qrtl  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#2.zipinc_qrtl  , or
	*VAR2 (asian vs whitee)
	lincom  2.race_model + 2.race_model#3.zipinc_qrtl  , or
	*VAR3 (asian vs white)
	lincom  2.race_model + 2.race_model#4.zipinc_qrtl  , or
	
*Black vs. White AAA Repair Type 	
svy: logit died  i.race_model##i.aaa_repair  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#aaa_repair , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs whit)
	lincom  1.race_model + 1.race_model#2.aaa_repair  , or
	*VAR2 (black vs whit)
	lincom  1.race_model + 1.race_model#3.aaa_repair  , or
	
*Asian vs. White AAA Repair Type 
svy: logit died  i.race_model##i.aaa_repair  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#aaa_repair , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#1.aaa_repair  , or
	*VAR2 (asian vs whitee)
	lincom  2.race_model + 2.race_model#2.aaa_repair  , or

*Black vs. White Hospital Region 		
		svy: logit died  i.race_model##i.hosp_region  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#hosp_region , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs whit)
	lincom  1.race_model + 1.race_model#2.hosp_region  , or
	*VAR2 (black vs whit)
	lincom  1.race_model + 1.race_model#3.hosp_region  , or
	*VAR3 (black vs whit)
	lincom  1.race_model + 1.race_model#4.hosp_region  , or
	
*Asian vs. White Hospital Region 
	svy: logit died  i.race_model##i.hosp_region  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#hosp_region , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_model#2.hosp_region  , or
	*VAR2 (asian vs whitee)
	lincom  2.race_model + 2.race_model#3.hosp_region  , or
	*VAR3 (asian vs white)
	lincom  2.race_model + 2.race_model#4.hosp_region  , or

*Black vs. White Hospitalization Age Category 
	svy: logit died  i.race_model##i.age_cat_formodel  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (black vs white)
	lincom  1.race_model    , or
	*VAR1 (black vs whit)
	lincom  1.race_model + 1.race_model#1.age_cat_formodel  , or
	*VAR2 (black vs whit)
	lincom  1.race_model + 1.race_model#2.age_cat_formodel  , or
	
*Asian vs. White Hospitalization Age Category 
	svy: logit died  i.race_model##i.age_cat_formodel  female age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region & i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast race_model#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (asian vs white)
	lincom  2.race_model    , or
	*VAR1 (asian vs white)
	lincom  2.race_model + 2.race_modelc#1.age_cat_formodel  , or
	*VAR2 (asian vs whitee)
	lincom  2.race_model + 2.race_model#2.age_cat_formodel  , or
	

log close

************************************************
************************************************
************************************************
*PREDICTING MORTALITY---FEMALE vs. MALE
************************************************
************************************************
************************************************

log using "/Users/katiereitz/OneDrive - UPMC/UPMC Research/NIS/PART 2/Logs/AAA NIS Logistic regression - inhosp mort - sex 5-15.log" , replace

svyset hosp_nis [pw=discwt], strata(year)

*Female vs. Male Race 
foreach var of varlist   cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i10_dx1_aaa_cat {
svy: logit died  female##i.`var' i.race_model  age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast female#`var', overall emptycells(reweight)
*white (female vs male)
lincom  1.female , or
*black (female vs male)
lincom  1.female + 1.female#1.`var', or
}


svy: logit died  i.female##i.race_model  i.race_model age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast female#race_model , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female+ 1.female#1.race_model  , or
	*VAR2 (female vs male)
	lincom  1.female+ 1.female#2.race_model  , or
	*VAR3 (female vs male)
	lincom  1.female+ 1.female#3.race_model  , or
	*VAR4 (female vs male)
	lincom  1.female+ 1.female#4.race_model  , or

*Female vs. Male Zip Income Quartile 
svy: logit died  i.female##i.zipinc_qrtl  i.race_model age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast female#zipinc_qrtl , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female    , or
	*VAR1 (female vs male)
	lincom  1.female+ 1.female#1.zipinc_qrtl  , or
	*VAR2 (female vs male)
	lincom  1.female+ 1.female#2.zipinc_qrtl  , or
	*VAR3 (female vs male)
	lincom  1.female+ 1.female#3.zipinc_qrtl  , or

*Female vs. Male Hospital Region 
	svy: logit died  i.female##i.hosp_region  i.race_model age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast female#hosp_region , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female   , or
	*VAR1 (female vs male)
	lincom  1.female+ 1.female#1.hosp_region  , or
	*VAR2 (female vs malee)
	lincom  1.female+ 1.female#2.hosp_region  , or
	*VAR3 (female vs male)
	lincom  1.female+ 1.female#3.hosp_region  , or

*Female vs. Male AAA Repair Type
	svy: logit died  i.female##i.aaa_repair  i.race_model age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast female#aaa_repair , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female   , or
	*VAR1 (female vs male)
	lincom  1.female+ 1.female#1.aaa_repair  , or
	*VAR2 (female vs malee)
	lincom  1.female+ 1.female#2.aaa_repair  , or
	*VAR3 (female vs male)
	lincom  1.female+ 1.female#3.aaa_repair  , or

*Female vs. Male Hospitalization Age Category 
		svy: logit died  i.female##i.age_cat_formodel  i.race_model age  i.zipinc_qrtl cm_dm_bin cm_perivasc cm_htn_c cm_chrnlung cm_smoke_notelixhuaser  cm_ctdz_notelixhauser i.tran_in i.i10_dx1_aaa_cat i.aaa_repair  i.year  i.hosp_region if  i10_dx1_aaa_rupture_intact ==1 & age>=18 , nolog or 
	contrast female#age_cat_formodel , overall emptycells(reweight)
	*VAR0 (female vs male)
	lincom  1.female   , or
	*VAR1 (female vs male)
	lincom  1.female+ 1.female#1.age_cat_formodel  , or
	*VAR2 (female vs malee)
	lincom  1.female+ 1.female#2.age_cat_formodel  , or


log close


