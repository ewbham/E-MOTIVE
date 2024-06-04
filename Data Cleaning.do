
***************************************************************************************************************
*
**								Merging of files
*
***************************************************************************************************************

use Combined_Dataset.dta , clear

*	Add a column which indicates whether the patient has source-verified blood loss data (used for primary outcome)
merge n:n po_pt_id using Validated_IDs.dta
gen validated_id = 1 if _merge ==3 & po_drape_weight!=.		// Creating a variable which indicates whether a patient has a validated ID
drop _merge													// dropping merge variable

*	Merge in the data source verified data collection started. Note: this is the data that sites had >=80% source data verification. Observations made before this data aren't included in the analysis
merge m:m redcap_data_access_group using Start_Date.dta
ren  _merge source_data 									// Creating a variable at the cluster level which indicates when the cluster met the inclusion criteria of >=80% SDV.

*	Generating delivery date. Need to do this because the original variable "po_baby1_dob" contains date and time, and so is not in the correct format. We need a variable which is day only
gen delivery_date = dofc(po_baby1_dob)
format delivery_date %td

*	Generate variable which indicates if data is after source verification started - all observations before it are dropped
gen exclude = . 
replace exclude = 1 if delivery_date < DatestartedSDVdatacollection		// Excluding deliveries for women whose baby was born prior to the sites meeting the source-verified criteria
replace exclude = 1 if po_date < DatestartedSDVdatacollection		// Excluding deliveries for women whose baby was born prior to the sites meeting the source-verified criteria
drop if exclude == 1

****	Checks on drape weight (Drape weight should be a multiple of 10 because of scales rounding)
gen drape_tempvar = .
forvalues i=100(10)7000{
replace drape_tempvar= 1 if  po_drape_weight ==`i'	
}
replace po_drape_weight = . if po_drape_weight <110 		// Drape weight should not be less than 110g/120g (since dry drape should be more than this)

**	Merge in the Minimisation variables
merge m:m redcap_data_access_group using Minimisation_values.dta
drop _merge

*	Merge in the dates of transition and intervention phase starts
merge m:m redcap_data_access_group using dates.dta
drop _merge

***************************************************************************************************************
*
**								Creating cluster, time-period, arm allocation and exposure status
*
***************************************************************************************************************
*	Creating a variable for country
gen country2 = substr( redcap_data_access_group,1,2)
label variable country2 "Country"
encode country2, generate(country)
******************************************************************
* add exposure and arm status
do  arm.do
label define arm 0 "Standard Care" 1 "E-motive"
label values arm arm
******************************************************************
*	Creating variable for time period
gen time_period = . 											// 	Creating time_period which indicates whether observation in baseline or post-randomisation
replace time_period = 0 if delivery_date < transition_start   		// 	Setting time_period to 0 for observations made in baseline period
replace time_period = 1 if delivery_date >= intervention_start		//	Setting time_period to 1 for observations made in post-randomisation period
******************************************************************
*	labelling time_period
label variable time_period "Time Period"
label define time_period 0 "Baseline" 1"Post-Randomisation"
label values time_period time_period
******************************************************************
*	Creating variable for exposure status
gen exposed = .													// 	Creating variable which indicates exposure to E-MOTIVE
replace exposed = 0 if arm ==0 | time_period ==0				//	Setting all women who were in the standard care arm or who were in the baseline phase to be classified as unexposed
replace exposed = 1 if arm ==1 & time_period==1					//	Setting all women who were in the E-MOTIVE arm in the post-randomisation phase to be classified as exposed
label variable exposed "Exposed to E-MOTIVE"
label define exposed 0 "Not Exposed" 1"Exposed to E-MOTIVE"
label values exposed exposed
******************************************************************
*dropping data from transition period
drop if time_period == .
******************************************************************
**	Creating cluster variable for in the analysis	(Need a numeric variable rather than string)
encode redcap_data_access_group_orig, generate(cluster)					//	Generating "cluster" which is needed for analysis models for random effect
label variable cluster "Cluster"
egen clustime = group(cluster time_period)								//	Generating the cluster by period interaction which is needed for random effect
label variable clustime "Cluster by period interaction"
******************************************************************
*	Dropping from Sites who are no longer in the study
drop if redcap_data_access_group_orig == "ke09"
drop if redcap_data_access_group_orig == "ke10"
drop if redcap_data_access_group_orig == "ta07"
drop if redcap_data_access_group_orig == "ta08"

***************************************************************************************************************
*
**								Variable creations
*
***************************************************************************************************************
***************************************************************************************************************
*
**		Generate primary outcome components
*
***************************************************************************************************************

******************************************************************
**		Severe PPH - 	measured using weight of blood drape (po_drape_weight)
******************************************************************
*	Weight of the blood drape is 120g (Email from Leanne on 28/01/2021)
*	Generate variable which is weight of just the blood (by subtracting dry blood drape weight from the measured weight)
gen blood_weight = po_drape_weight - 120
label variable blood_weight "Weight of blood loss"

*	Sum drapes may have a weight lower than dry weight, these are replaced with a weight of zero (as it has been verified)
replace blood_weight = 0 if blood_weight <0
replace blood_weight = . if blood_weight ==.

*	Generate variable which is total amount of blood lost (using blood weight and estimated blood loss for missing data mechanism)
egen total_blood_loss = rowtotal(blood_weight po_ebl)
replace total_blood_loss = . if blood_weight ==. & po_ebl ==.

gen total_blood_loss2 = total_blood_loss				// 	Creating a copy of it that appears in all patients
replace total_blood_loss = . if validated_id!=1			//	Setting it so total blood loss value only appears in those with source verified blood loss data
label variable total_blood_loss "Bloos loss based on drape (Verified)"
label variable total_blood_loss2 "Bloos loss based on drape (Includes non-verified)"

*	Generating variable which indicates severe PPH (bloos loss>=1000ml)
gen severe_pph = 1 if total_blood_loss >=1000			//	Setting it as 1 if total blood loss >=1000ml (using source verified blood loss only)
replace severe_pph = 0 if total_blood_loss <1000		//	Setting it as 0 if total blood loss <1000ml (using source verified blood loss only)
replace severe_pph = . if total_blood_loss ==. 			//	Setting it as missing if total blood loss is not known or is not source verified
replace severe_pph = . if validated_id != 1				//	Making sure anyone who doesnt have source verified blood loss has missing outcome
label variable severe_pph "Severe PPH"

******************************************************************
*	Generate variable for postpartum laparotomy for bleeding
*	do_lap = Did the woman have a postpartum laparotomy?
*	rff_laparotomy_bleeding = Was the postpartum laparotomy for bleeding?
******************************************************************
generate lap_bleed = 1 if do_lap == 1 & rff_laparotomy_bleeding==1		//	Generating variable (lap_bleed) which indicates woman had a laparotomy and it was for bleeding (as defined by BERC)
replace lap_bleed = 0 if lap_bleed != 1									// 	Setting all women who didnt have a laparotomy for bleeding to have a 0
label variable lap_bleed "Laparotomy for Bleeding"

******************************************************************
*	Generate variale for maternal mortality for bleeding
* rff_cause_death = Was the primary cause of maternal death due to postpartum haemorrhage (PPH)?
******************************************************************
generate mortality_bleed = 1 if rff_cause_death == 1					//	Generating variable (mortality_bleed) which indicates woman died and it was due to bleeding (as defined by BERC)
replace mortality_bleed = 0 if mortality_bleed != 1						// 	Setting all women who didnt have a mortality due to bleeding to have a 0
label variable mortality_bleed "Mortality for Bleeding"

***************************************************************************************************************
*
**		Generate primary outcome 
*
***************************************************************************************************************
egen primary_outcome = rowtotal(severe_pph lap_bleed mortality_bleed)		//	Creating primary outcome which adds up the three components (severe PPH, lap from bleeding, mortality from bleeding)
replace primary_outcome = 1 if primary_outcome>1							// 	Replacing so primary outcome is a 0 or 1
replace primary_outcome = . if total_blood_loss ==.							//	Replacing primary outcome to be missing if blood loss data is not known
*replace primary_outcome = . if validated_id != 1							//	Setting primary outcome to be missing if blood loss data is not source verified
label variable primary_outcome "Primary Outcome"

******************************************************************
*	Gestational age < 37 weeks
gen ga_less_37 = 1 if po_ga < 37										//	Creating binary variable which indicates if the gestational age was less than 37 weeks
replace ga_less_37 = 0 if po_ga>=37			
replace ga_less_37 = . if po_ga ==.
label define ga_less_37 0 ">=37 weeks" 1 "<37 Weeks" 
label values ga_less_37 ga_less_37
label variable ga_less_37 "Gestational Age < 37 weeks"

******************************************************************
*	Number of previous births - replace any values that are incorrect as missing
replace po_births24wks = . if po_births24wks >45

******************************************************************
*	Gestational age - replace any values that are incorrect as missing
replace po_ga = . if po_ga>70

******************************************************************
* 	recoding missing category for previous C-section
replace po_csection = . if po_csection == 3

******************************************************************
*	Creating (all cause) maternal mortality
gen mat_mortality = 1 if do_disc_status ==2							//	Using maternal status at discharge from health facility
replace mat_mortality = 1 if fdo_disc_status == 2					//	Using maternal status at discharge from further health facility
replace mat_mortality = 0 if do_disc_status == 1					//	Using maternal status at discharge from health facility
replace mat_mortality = 0 if fdo_disc_status==1						//	Using maternal status at discharge from further health facility
label variable mat_mortality "Maternal Mortality (All cause)"

******************************************************************
*	Creating icu admission
gen icu = 0
replace icu = 1 if do_icu ==1										//	Using ICU admission status from discharge outcome form
replace icu = 1 if fdo_icu == 1										//	Using ICU admission status from further discharge outcome form
replace icu = 0 if do_icu == 0 & fdo_icu ==0
replace icu = . if do_icu == . & fdo_icu ==.						//	Setting values as missing if both discharge and further discharge outcome forms are missing
label variable icu "ICU Admission"
******************************************************************
**	Laparotomy 
gen lap = 0
replace lap = 1 if do_lap==1										//	Using whether any laparotomy occured from discharge outcome form
replace lap = . if do_lap==.										//	Setting values as missing if its not recorded on discharge outcome form
replace lap = 1 if fdo_lap==1										//	Using whether any laparotomy occured from further discharge outcome form
label variable lap "Laparotomy"
******************************************************************
**	Laparotomy with compression sutures
gen lap_cs = 0
replace lap_cs = 1 if do_lap_surg___1 ==1							//	Using whether a laparotomy with compression sutures occured from discharge outcome form (do_lap_surg___1)
replace lap_cs = . if do_lap_surg___1 ==.							//	Setting values as missing if its not recorded on discharge outcome form whether a laparotomy with compression sutures occured
replace lap_cs = . if do_lap ==.									//	Setting values as missing if its not recorded on discharge outcome form whether a laparotomy occured
replace lap_cs = 1 if fdo_lap_surg___1 ==1							//	Using whether a laparotomy with compression sutures occured from further discharge outcome form (fdo_lap_surg___1)
label variable lap_cs "Laparotomy with Compression sutures"
******************************************************************
**	Laparotomy with  arterial ligation
gen lap_al = 0
replace lap_al = 1 if do_lap_surg___2 ==1							//	Using whether a laparotomy with arterial ligation occured from discharge outcome form (do_lap_surg___2)
replace lap_al = . if do_lap_surg___2 ==.							//	Setting values as missing if its not recorded on discharge outcome form whether a laparotomy with arterial ligation occured
replace lap_al = . if do_lap ==.									//	Setting values as missing if its not recorded on discharge outcome form whether a laparotomy occured
replace lap_al = 1 if fdo_lap_surg___2 ==1							//	Using whether a laparotomy with arterial ligation occured from further discharge outcome form (fdo_lap_surg___2)
label variable lap_al "Laparotomy with Arterial Ligation"
******************************************************************
**	Hysterectomy
gen lap_h = 0
replace lap_h = 1 if do_lap_surg___3 ==1							//	Using whether a hysterectomy occured from discharge outcome form (do_lap_surg___3)
replace lap_h = . if do_lap_surg___3 ==.							//	Setting values as missing if its not recorded on discharge outcome form whether a hysterectomy occured
replace lap_h = . if do_lap ==.										//	Setting values as missing if its not recorded on discharge outcome form whether a laparotomy occured
replace lap_h = 1 if fdo_lap_surg___3 ==1							//	Using whether a hysterectomy occured from further discharge outcome form (fdo_lap_surg___3)
label variable lap_h "Hysterectomy"

******************************************************************
**	Hysterectomy for bleeding
generate hyst_bleed = 1 if lap_h == 1 & rff_laparotomy_bleeding==1		//	Setting a hysterectomy for bleeding as occured if a hysterectomy occured and the laparotomy was due to bleeding based on BERC
replace hyst_bleed=0 if hyst_bleed!=1
replace hyst_bleed = . if lap_h==.										//	Setting values as missing if its not recorded on discharge outcome form whether a hysterectomy occured
label variable hyst_bleed "Hysterectomy for Bleeding"

******************************************************************
**	Primary PPH
gen pph = 1 if total_blood_loss >=500								//	Generating primary PPH (blood loss >=500ml) 
replace pph = 0 if total_blood_loss <500							//	Setting it as 0 if blood loss was <500ml
replace pph = . if total_blood_loss ==. 							//	Setting as missing if blood loss data is missing
replace pph = . if validated_id != 1								//	Setting it to be missing if blood loss is not source verified
label variable pph "PPH"

******************************************************************
**	Transferred to higher facility
gen transfer = 0													//	Generating variable that indicates patient was tranferred to another facility
replace transfer = 1 if do_disc_status ==3							//	Transferred to another facility means that discharge status was set as "transferred"
replace transfer = . if do_disc_status ==.							//	Set to be missing if discharge status was not known
label variable transfer "Transferred to higher facility"

******************************************************************
**	Non-pneumatic anti-shock garment (NASG)
gen nasg = 0
replace nasg =1 if po_pph_int___16 == 1								//	NASG used if po_pph_int___16 ==1 	- no missing data for these as it is a checkbox that is either checked or unchecked
label define nasg 0 "Not Used" 1 "NASG Used" 
label values nasg nasg
label variable nasg "Non-pneumatic anti-shock garment (NASG) used"

******************************************************************
**	Uterine balloon tamponade
gen ubt = 0
replace ubt =1 if po_pph_int___12 == 1								//	Uterine balloon tamponade used if po_pph_int___12 ==1 	- no missing data for these as it is a checkbox that is either checked or unchecked
label define ubt 0 "Not Used" 1 "Uterine balloon tamponade Used" 
label values ubt ubt
label variable ubt "Uterine balloon tamponade used"

******************************************************************
**	Blood Transfusion
gen bt = 0
replace bt = 1 if do_blood_trans ==1										//	Setting it to be one if discharge outcome form says blood transfusion occured 
replace bt = . if do_blood_trans ==.										//	Setting it to be missing if transfusion status was not known
replace bt = 1 if fdo_blood_trans ==1										//	Setting it to be one if further discharge outcome form says blood transfusion occured 
label define bt 0 "No Transfusion" 1 "Blood Transfusion Occured" 
label values bt bt
label variable bt "Blood Transfusion"

******************************************************************
**	Blood Transfusion for bleeding
gen bt_bleed = 0
replace bt_bleed = 1 if do_blood_trans ==1 & po_pph ==1							//	Setting it to be one if blood transfusion occured and it was because PPH was diagnosed by health care practitioner
replace bt_bleed = . if do_blood_trans ==.										// 	Setting it as missing if transfusion status is not known
replace bt_bleed = 1 if fdo_blood_trans ==1 & po_pph ==1						//	Setting it to be one if blood transfusion occured in further facility and PPH was diagnosed by health care practitioner
replace bt_bleed = . if do_blood_trans ==. & fdo_blood_trans==.					// 	Setting it as missing if transfusion status is not known in original and further facility
label define bt_bleed 0 "No Transfusion" 1 "Blood Transfusion Occured" 
label values bt_bleed bt_bleed
label variable bt_bleed "Blood Transfusion for bleeding"

******************************************************************
**	Blood Loss (24 hours)
*	Generate variable which is total amount of blood lost
egen blood_loss_24 = rowtotal(blood_weight do_additional_bl_est fdo_additional_bl_est )		//	Generating blood loss based on blood weight (from drape), additional blood loss and further discharge form additional blood loss
replace blood_loss_24 = . if validated_id!=1												//	Set as missing if patient does not have source verified blood loss (only original blood loss, additional blood loss is not verified)
label variable blood_loss_24 "Blood Loss in 24 hours"

******************************************************************
**	Hospitalisation length
egen discharge = rowmax(do_date_disc fdo_date_disc)						//	Take data patient was discharged (maximum of either discharge outcome form or further discharge outcome form)	
format discharge %td													//	Formating variable as a date
generate baby1_dob = dofc(po_baby1_dob)									//	Generate variable for baby date of birth
format baby1_dob %td													//	Formating variable as a date
gen los = discharge-baby1_dob											//	Generate length of stay as the difference between babys date of birth and date of discharge
*replace los = . if los< 0												//	Replace length of stay
*replace los = . if los>360
label variable los "Length of Stay"

******************************************************************
**	ICU length
gen icu_los_1 = do_icu_date_of_disc - do_icu_date_of_adm				//	generate ICU length of stay which is difference between the ICU date of discharge and ICU date of admission
gen icu_los_2 = fdo_icu_date_of_disc - fdo_icu_date_of_adm				//	generate ICU length of stay which is difference between the ICU date of discharge and ICU date of admission from further discharge outcome form
egen icu_los = rowtotal(icu_los_1  icu_los_2)							//	adding total icu length of stay
replace icu_los = . if icu_los_1 ==. & icu_los_2==.						//	setting it to be missing if both ICU length of stay is missing
label variable icu_los "ICU Length of Stay"

******************************************************************
**		ICU Admission
gen icu_admit = 1 if do_icu ==1											//	Generating icu admission
replace icu_admit = 1 if fdo_icu ==1									//	Equal to 1 if further discharge outcome form is 1
label variable icu_admit "ICU admission"

******************************************************************

**	Any Treatment Uterotonic
gen uter = 0
replace uter = 1 if po_pph_int___1 ==1 | po_pph_int___2==1 | po_pph_int___3 ==1 | po_pph_int___4 ==1 | po_pph_int___5 ==1
label variable uter "Any treatment Uterotonic"

******************************************************************

**	Any additional treatment interventions
gen ati = 0
replace ati = 1 if  ubt==1 | lap_bleed==1
label variable ati "Any additional treatment intervention"

******************************************************************

**		Parity
*	Generate a variable for parity which has only 3 levels (rather than the actual number of previous births)	
gen parity = po_births24wks
replace parity = 2 if parity>2
replace parity = . if po_births24wks ==.
label define parity 0 "Nulliparous" 1 "Primaparous" 2 "Multiparous"
label values parity parity
label variable parity "Parity"

******************************************************************

*	Spontaneuous delivery
gen mode = 1 if po_baby1_mode==1
replace mode = 0 if po_baby1_mode==2
replace mode = 0 if po_baby1_mode==3
replace mode = . if po_baby1_mode==9
label define mode 1 "Spontaneous" 0 "Instrumental" 
label values mode mode
label variable mode "Mode of Birth"
**************************************************
gen multiple_preg = 0 if po_pregnancytype ==1
replace multiple_preg = 1 if po_pregnancytype ==2
replace multiple_preg = 1 if po_pregnancytype ==3
label define multiple_preg 1 "Multiple" 0 "Single" 
label values multiple_preg multiple_preg
label variable multiple_preg "Multiple pregnancy"
******************************************************************
replace po_aph = . if po_aph == 3
replace po_preecl = . if po_preecl == 3
replace po_prev_pph = . if po_prev_pph == 3

******************************************************************
*	Diagnosis of PPH by midwife - setting 3 (Unknown) to be missing
replace po_pph = . if po_pph == 3

   ******************************************************************
*The PPH intervention  are tick boxes and are currently just "1" or missing. Creating new binary variables for them which is "0" if they didnt receive the intervention and a "1" if they recevied it
 gen oxytocin = 0
 replace oxytocin = 1 if po_pph_int___1 ==1
 label variable oxytocin "Oxytocin Used"
 ******************************************************************
 gen misoprostol = 0
 replace misoprostol = 1 if po_pph_int___2 ==1
 label variable misoprostol "Misoprostol Used"
  ******************************************************************
 gen ergometrine = 0
 replace ergometrine = 1 if po_pph_int___3 ==1
 label variable ergometrine "Ergometrine Used"
  ******************************************************************
 gen carboprost = 0
 replace carboprost = 1 if po_pph_int___4 ==1
 label variable carboprost "Carboprost Used"
******************************************************************
 gen carbetocin = 0
 replace carbetocin = 1 if po_pph_int___5 ==1
 label variable carbetocin "Carbetocin Used"
  ******************************************************************
 gen txa = 0
 replace txa = 1 if po_pph_int___6 ==1
 label variable txa "Tranexamic Acid Used"
  ******************************************************************
 gen iv_fluid = 0
 replace iv_fluid = 1 if po_pph_int___7 ==1
 label variable iv_fluid "IV Fluid Used" 
  ******************************************************************
 gen uterine_massage = 0
 replace uterine_massage = 1 if po_pph_int___8 ==1
 label variable uterine_massage "Uterine massage Used"

******************************************************************
 gen prev_births = po_births24wks
 replace prev_births = 5 if prev_births > 5
 label variable prev_births "Previous Births"
  
  ******************************************************************
 gen examin = 0
 replace examin = 1 if po_pph_int___10 ==1
 label variable examin "Examination of Genital Tract"
  
  

save Cleaned_Dataset.dta , replace

