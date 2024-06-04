
***************************************************************************************************************
*
**Generating DALYs
*
***************************************************************************************************************
gen dweight_pph = 0.114 // GBD disability weight for maternal hemorrhage < 1L
gen dweight_spph = 0.324 // GBD disability weight for maternal hemorrhage > 1L
gen dweight = .
replace dweight = dweight_pph if pph == 1 & severe_pph == 0
replace dweight = dweight_spph if severe_pph == 1
replace dweight = 0 if pph == 0 & severe_pph == 0
replace dweight = 0 if mortality_bleed == 1
gen ddur = 6/52 // duration is postpartum period
gen yld = dweight*ddur

*discount factor*
gen r_discount = 0.03 // recommended discount factor (3%) for YLL

*KE life tables*
gen le_KE = 56.9443492 if po_age >= 15 & po_age <= 19 & country == 1 // GBD life tables used, checked against GHCEA DALY calculator 
replace le_KE = 52.22839081 if po_age >= 20 & po_age <= 24 & country == 1 // can use to less dp
replace le_KE = 47.58413446 if po_age >= 25 & po_age <= 29 & country == 1
replace le_KE = 43.07356411 if po_age >= 30 & po_age <= 34 & country == 1
replace le_KE = 38.72763447 if po_age >= 35 & po_age <= 39 & country == 1
replace le_KE = 34.55724409 if po_age >= 40 & po_age <= 44 & country == 1
replace le_KE = 30.561855400704 if po_age >= 45 & po_age <= 49 & country == 1

*NI life tables*
gen le_NI = 58.28254424 if po_age >= 15 & po_age <= 19 & country == 2 // GBD life tables used, checked against GHCEA DALY calculator 
replace le_NI = 53.51879703 if po_age >= 20 & po_age <= 24 & country == 2
replace le_NI = 48.81797126 if po_age >= 25 & po_age <= 29 & country == 2
replace le_NI = 44.22309312 if po_age >= 30 & po_age <= 34 & country == 2
replace le_NI = 39.74070632 if po_age >= 35 & po_age <= 39 & country == 2
replace le_NI = 35.36704975 if po_age >= 40 & po_age <= 44 & country == 2
replace le_NI = 31.07680254 if po_age >= 45 & po_age <= 49 & country == 2

*SA life tables*
gen le_SA = 55.94784406 if po_age >= 15 & po_age <= 19 & country == 4 // GBD life tables used, checked against GHCEA DALY calculator 
replace le_SA = 51.30818282 if po_age >= 20 & po_age <= 24 & country == 4
replace le_SA = 46.950359 if po_age >= 25 & po_age <= 29 & country == 4
replace le_SA = 42.94926568 if po_age >= 30 & po_age <= 34 & country == 4
replace le_SA = 39.23697239 if po_age >= 35 & po_age <= 39 & country == 4
replace le_SA = 35.58157193 if po_age >= 40 & po_age <= 44 & country == 4
replace le_SA = 31.9074854854673 if po_age >= 45 & po_age <= 49 & country == 4

*TZ life tables*
gen le_TZ = 58.44148149 if po_age >= 15 & po_age <= 19 & country == 5 // GBD life tables used, checked against GHCEA DALY calculator 
replace le_TZ = 53.70287464 if po_age >= 20 & po_age <= 24 & country == 5
replace le_TZ = 49.03682197 if po_age >= 25 & po_age <= 29 & country == 5
replace le_TZ = 44.44404952 if po_age >= 30 & po_age <= 34 & country == 5
replace le_TZ = 39.94365379 if po_age >= 35 & po_age <= 39 & country == 5
replace le_TZ = 35.53975823 if po_age >= 40 & po_age <= 44 & country == 5
replace le_TZ = 31.2452416696427 if po_age >= 44 & po_age <= 49 & country == 5

*CL life expectancy*
gen le_all = . // country-specific life expectancy incorporated 
replace le_all = le_KE if country == 1
replace le_all = le_NI if country == 2
replace le_all = le_SA if country == 4
replace le_all = le_TZ if country == 5

*YLL*
gen yll = (1/r_discount)*(1-exp(-r_discount*le_all)) // years of life lost due to premature death discounted
replace yll = 0 if mortality_bleed == 0
******************************************************************
*CL YLL*
*KE life tables*
gen le_KE_CL = 56.9443492 if po_age >= 15 & po_age <= 19 // as above, for all participants
replace le_KE_CL = 52.22839081 if po_age >= 20 & po_age <= 24 
replace le_KE_CL = 47.58413446 if po_age >= 25 & po_age <= 29 
replace le_KE_CL = 43.07356411 if po_age >= 30 & po_age <= 34 
replace le_KE_CL = 38.72763447 if po_age >= 35 & po_age <= 39 
replace le_KE_CL = 34.55724409 if po_age >= 40 & po_age <= 44 
replace le_KE_CL = 30.561855400704 if po_age >= 45 & po_age <= 49

*NI life tables*
gen le_NI_CL = 58.28254424 if po_age >= 15 & po_age <= 19 // as above, for all participants
replace le_NI_CL = 53.51879703 if po_age >= 20 & po_age <= 24 
replace le_NI_CL = 48.81797126 if po_age >= 25 & po_age <= 29 
replace le_NI_CL = 44.22309312 if po_age >= 30 & po_age <= 34 
replace le_NI_CL = 39.74070632 if po_age >= 35 & po_age <= 39
replace le_NI_CL = 35.36704975 if po_age >= 40 & po_age <= 44 
replace le_NI_CL = 31.07680254 if po_age >= 45 & po_age <= 49 

*SA life tables*
gen le_SA_CL = 55.94784406 if po_age >= 15 & po_age <= 19 // as above, for all participants
replace le_SA_CL = 51.30818282 if po_age >= 20 & po_age <= 24 
replace le_SA_CL = 46.950359 if po_age >= 25 & po_age <= 29 
replace le_SA_CL = 42.94926568 if po_age >= 30 & po_age <= 34 
replace le_SA_CL = 39.23697239 if po_age >= 35 & po_age <= 39 
replace le_SA_CL = 35.58157193 if po_age >= 40 & po_age <= 44 
replace le_SA_CL = 31.9074854854673 if po_age >= 45 & po_age <= 49 

*TZ life tables*
gen le_TZ_CL = 58.44148149 if po_age >= 15 & po_age <= 19 // as above, for all participants
replace le_TZ_CL = 53.70287464 if po_age >= 20 & po_age <= 24 
replace le_TZ_CL = 49.03682197 if po_age >= 25 & po_age <= 29 
replace le_TZ_CL = 44.44404952 if po_age >= 30 & po_age <= 34 
replace le_TZ_CL = 39.94365379 if po_age >= 35 & po_age <= 39 
replace le_TZ_CL = 35.53975823 if po_age >= 40 & po_age <= 44 
replace le_TZ_CL = 31.2452416696427 if po_age >= 44 & po_age <= 49 
******************************************************************
*apply discounts* 
gen yll_KE_CL = (1/r_discount)*(1-exp(-r_discount*le_KE_CL)) // as above, for all particpants
replace yll_KE_CL = 0 if mortality_bleed == 0
gen yll_NI_CL = (1/r_discount)*(1-exp(-r_discount*le_NI_CL))
replace yll_NI_CL = 0 if mortality_bleed == 0
gen yll_SA_CL = (1/r_discount)*(1-exp(-r_discount*le_SA_CL))
replace yll_SA_CL = 0 if mortality_bleed == 0
gen yll_TZ_CL = (1/r_discount)*(1-exp(-r_discount*le_TZ_CL))
replace yll_TZ_CL = 0 if mortality_bleed == 0
******************************************************************
* calc DALYs*
egen daly = rowtotal(yll yld) // DALY outcome for primary analysis
egen daly_KE_CL = rowtotal(yll_KE_CL yld) // DALY outcome variable for Kenya analysis
egen daly_NI_CL = rowtotal(yll_NI_CL yld) // DALY outcome variable for Nigeria analysis
egen daly_SA_CL = rowtotal(yll_SA_CL yld) // DALY outcome variable for SA analysis
egen daly_TZ_CL = rowtotal(yll_TZ_CL yld) // DALY outcome variable for Tanzania analysis
******************************************************************
***************************************************************************************************************
*
**Generating Costs
*
***************************************************************************************************************
*gen base case costs* // in 2022 USD, adjusted using average US inflation rates. 3 dp used here.
gen drp_ct = 1.518
gen oxy_ct = 1.253
gen txa_ct = 2.740
gen txa_a_ct = 0.801 if country == 1
replace txa_a_ct = 0.283 if country == 2
replace txa_a_ct = 0.000 if country == 4
replace txa_a_ct = 0.286 if country == 5
gen ivf_ct = 0.108
gen icu_ct = 57.430 if country == 1
replace icu_ct = 100.500 if country == 2
replace icu_ct = 717.860 if country == 4
replace icu_ct = 43.070 if country == 5
gen los_ct = 7.620 if country == 1
replace los_ct = 13.980 if country == 2
replace los_ct = 110.270 if country == 4
replace los_ct = 5.610 if country == 5
gen bt_ct = 95.641 if country == 1
replace bt_ct = 40.076 if country == 2
replace bt_ct = 288.547 if country == 4
replace bt_ct = 71.731 if country == 5
gen erg_ct = 0.730
gen lap_ct = 148.170 if country == 1
replace lap_ct = 207.090 if country == 2
replace lap_ct = 1071.590 if country == 4
replace lap_ct = 111.130 if country == 5
gen lap_h_ct = 185.210 if country == 1
replace lap_h_ct = 258.860 if country == 2
replace lap_h_ct = 1339.490 if country == 4
replace lap_h_ct = 138.910 if country == 5
gen miso_ct = 1.250
gen nasg_ct = 1.270 if country == 1
replace nasg_ct = 1.170 if country == 2
replace nasg_ct = 1.540 if country == 4
replace nasg_ct = 1.170 if country == 5
gen trans_ct = 19.354 if country == 1
replace trans_ct = 34.250 if country == 2
replace trans_ct = 53.740 if country == 4
replace trans_ct = 14.510 if country == 5
gen ubt_ct = 1.190 if country == 1
replace ubt_ct = 0.930 if country == 2
replace ubt_ct = 6.900 if country == 4
replace ubt_ct = 0.930 if country == 5
gen bic_ct = 2.400 if country == 1
replace bic_ct = 0.850 if country == 2
replace bic_ct = 6.350 if country == 4
replace bic_ct = 0.860 if country == 5
gen spph_ct = 1.541 if country == 1
replace spph_ct = 0.787 if country == 2
replace spph_ct = 4.270 if country == 4
replace spph_ct = 0.720 if country == 5
gen ivs_ct = 0.190
gen ns_ct = 0.050
gen exm_ct = 0.000
gen msg_ct = 0.000
******************************************************************
*applying costs to resource use*
gen drp_ct_u = 0
replace drp_ct_u = drp_ct if exposed == 1
gen oxy_d_ct_u = oxy_ct * oxytocin
gen ivf_am_KNT = 15
gen ivf_am_S = 12
gen oxy_ivf_ct_u = ivf_ct * ivf_am_KNT if oxytocin == 1 & country != 4 // 1500ml fluid for KE,NI,TZ (infusion + maintenance)
replace oxy_ivf_ct_u = ivf_ct * ivf_am_S if oxytocin == 1 & country == 4 // 1200ml fluid for KE,NI,TZ (infusion + maintenance)
replace oxy_ivf_ct_u = 0 if oxytocin == 0
gen txa_d_ct_u = txa_ct * txa
gen txa_a_ct_u = txa_a_ct * txa
gen icu_ct_u = 0 if icu == 0
replace icu_ct_u = icu_ct if icu_los == 0
replace icu_ct_u = icu_ct * icu_los if icu_los >=1 & icu_los != .
gen nicu_ct_u = los_ct if nicu_los == 0
replace nicu_ct_u = los_ct * nicu_los if nicu_los >= 1 & nicu_los != .
gen bt_ct_u = bt_ct * bt
gen erg_ct_d_u = erg_ct * ergometrine
gen lap_ct_u = lap_ct * lap_noh
gen lap_h_ct_u = lap_h_ct * lap_h
gen miso_ct_d_u = miso_ct * misoprostol
gen nasg_ct_u = nasg_ct * nasg
gen trans_ct_u = trans_ct * transfer
gen ubt_ct_u = ubt_ct * ubt
gen bic_ct_u = bic_ct * bimanual_compression
gen spph_ct_u = spph_ct * severe_pph
gen ivs_ct_u = ivs_ct if oxytocin == 1| iv_fluid == 1| txa == 1 & country == 4
replace ivs_ct_u = 0 if oxytocin == 0 & iv_fluid == 0 & country != 4| oxytocin == 0 & txa == 0 & iv_fluid == 0 & country == 4
gen exm_ct_u = exm_ct * examin
gen msg_ct_u = msg_ct * uterine_massage
gen ns_ct_u = 0
replace ns_ct_u = ns_ct if oxytocin == 1| txa == 1| ergometrine == 1| iv_fluid == 1
gen jiv_oxy_d_ct_u = oxy_ct * jiv
gen jiv_ivf_ct_u = ivf_am_KNT * ivf_ct if country != 4 & jiv == 1
replace jiv_ivf_ct_u = ivf_am_S * ivf_ct if country == 4 & jiv == 1
replace jiv_ivf_ct_u = 0 if jiv == 0
gen em_ivf_am = 5 * em_ivf
gen em_ivf_ct_u = 0
replace em_ivf_ct_u = ivf_ct * em_ivf_am
gen txa_ivf_ct_u = 0
replace txa_ivf_ct_u = ivf_ct * txa_ivf_SA if country == 4 & txa == 1 //TXA given using infusion in SA, injected in KE,NI,TZ
gen jiv_txa_oxy_d_ct_u = jiv_txa * oxy_ct
gen jiv_txa_ivf_ct_u = ivf_ct * ivf_am_KNT if country != 4 & jiv_txa == 1
replace jiv_txa_ivf_ct_u = ivf_ct * ivf_am_S if country == 4 & jiv_txa == 1
replace jiv_txa_ivf_ct_u = 0 if jiv_txa == 0
egen ivf_tc = rowtotal(oxy_ivf_ct_u txa_ivf_ct_u jiv_ivf_ct_u em_ivf_ct_u jiv_txa_ivf_ct_u)
egen oxy_d_tc = rowtotal(oxy_d_ct_u jiv_oxy_d_ct_u jiv_txa_oxy_d_ct_u)
egen ivfs_tc = rowtotal(ivf_tc ivs_ct_u) // cost of giving set included in IV fluid cost use
egen txa_tc = rowtotal(txa_d_ct_u txa_a_ct_u) // combined cost for use of TXA and administration
egen tc = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_d_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_ct_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc "Total Cost - Base Case" // Total cost outcome for primary analysis.
******************************************************************
*DSA costs*
*drape cost 1 USD* // to test various plausible drape costs
gen drp_ct_DSA_1 = 1.214
gen drp_ct_u_DSA_1 = drp_ct_DSA_1 * exposed
egen tc_1 = rowtotal(drp_ct_u_DSA_1 oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_d_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_ct_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_1 "TC - Drape Cost 1"
******************************************************************
*drape costT 0.75 USD* // to test various plausible drape costs
gen drp_ct_DSA_2 = 0.911
gen drp_ct_u_DSA_2 = drp_ct_DSA_2 * exposed
egen tc_2 = rowtotal(drp_ct_u_DSA_2 oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_d_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_ct_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_2 "TC - Drape Cost 0.75"
******************************************************************
*drape cost 0.50 USD* // to test various plausible drape costs
gen drp_ct_DSA_3 = 0.607
gen drp_ct_u_DSA_3 = drp_ct_DSA_3 * exposed
egen tc_3 = rowtotal(drp_ct_u_DSA_3 oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_d_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_ct_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_3 "TC - Drape Cost 0.50"
******************************************************************
*drape cost 0.25 USD* // to test various plausible drape costs
gen drp_ct_DSA_4 = 0.304
gen drp_ct_u_DSA_4 = drp_ct_DSA_4 * exposed
egen tc_4 = rowtotal(drp_ct_u_DSA_4 oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_d_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_ct_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_4 "TC - Drape Cost 0.25"
******************************************************************
*bimanual compression 15m* // to test importance of assumption
gen bic_ct_DSA_1 = 1.20 if country == 1
replace bic_ct_DSA_1 = 0.43 if country == 2
replace bic_ct_DSA_1 = 3.18 if country == 4
replace bic_ct_DSA_1 = 0.43 if country == 5
gen bic_ct_u_DSA_1 = bimanual_compression * bic_ct_DSA_1
egen tc_5 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u_DSA_1 spph_ct_u exm_ct_u msg_ct_u)
label var tc_5 "TC - BIC 15 "
******************************************************************
*bimnual compression 45m* // to test importance of assumption
gen bic_ct_DSA_2 = 3.60 if country == 1
replace bic_ct_DSA_2 = 1.28 if country == 2
replace bic_ct_DSA_2 = 9.52 if country == 4
replace bic_ct_DSA_2 = 1.29 if country == 5
gen bic_ct_u_DSA_2 = bimanual_compression * bic_ct_DSA_2
egen tc_6 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u_DSA_2 spph_ct_u exm_ct_u msg_ct_u)
label var tc_6 "TC - BIC 45"
******************************************************************
*bt 1 unit* // to test importance of assumption
gen bt_ct_DSA_1 = 48.20 if country == 1
replace bt_ct_DSA_1 = 21.19 if country == 2
replace bt_ct_DSA_1 = 152.57 if country == 4
replace bt_ct_DSA_1 = 36.15 if country == 5
gen bt_ct_u_DSA_1 = bt_ct_DSA_1 * bt 
egen tc_7 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u_DSA_1 lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_7 "TC - BT 1"
******************************************************************
*bt 3 units* // to test importance of assumption
gen bt_ct_DSA_2 = 143.08 if country == 1
replace bt_ct_DSA_2 = 58.97 if country == 2
replace bt_ct_DSA_2 = 424.53 if country == 4
replace bt_ct_DSA_2 = 107.31 if country == 5
gen bt_ct_u_DSA_2 = bt_ct_DSA_2 * bt 
egen tc_8 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u_DSA_2 lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_8 "TC - BT 3"
******************************************************************
*laparotomy cost 0.5xhysterectomy* // to test importance of assumption
gen lap_ct_DSA_1 = 92.61 if country == 1
replace lap_ct_DSA_1 = 129.43 if country == 2
replace lap_ct_DSA_1 = 669.75 if country == 4
replace lap_ct_DSA_1 = 69.46 if country == 5
gen lap_ct_u_DSA_1 = lap_noh * lap_ct_DSA_1
egen tc_9 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u_DSA_1 lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u msg_ct_u)
label var tc_9 "TC - Lap 50%"
******************************************************************
*5 minutes attending dr time spph* // to test importance of assumption. lower cost rather than higher used.
gen spph_ct_DSA_1 = 0.77 if country == 1
replace spph_ct_DSA_1 = 0.39 if country == 2
replace spph_ct_DSA_1 = 2.14 if country == 4
replace spph_ct_DSA_1 = 0.36 if country == 5
gen spph_ct_u_DSA_1 = spph_ct_DSA_1 * severe_pph 
egen tc_10 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u_DSA_1 exm_ct_u msg_ct_u)
label var tc_10 "TC - SPPH 5"
******************************************************************
*costs assigned to uterine massage and examiniation* // to test importance of assumption
gen msg_ct_DSA_1 = 0.16 if country == 1
replace msg_ct_DSA_1 = 0.06 if country == 2
replace msg_ct_DSA_1 = 0.42 if country == 4
replace msg_ct_DSA_1 = 0.06 if country == 5
gen msg_ct_u_DSA_1 = msg_ct_DSA_1 * uterine_massage if exposed == 1
gen exm_ct_DSA_1 = 0.40 if country == 1
replace exm_ct_DSA_1 = 0.14 if country == 2
replace exm_ct_DSA_1 = 1.06 if country == 4
replace exm_ct_DSA_1 = 0.14 if country == 5
gen exm_ct_u_DSA_1 = exm_ct_DSA_1 * examin if exposed == 1
egen tc_11 = rowtotal(drp_ct_u oxy_d_ct_u oxy_ivf_ct_u txa_d_ct_u txa_a_ct_u txa_ivf_ct_u jiv_oxy_d_ct_u jiv_ivf_ct_u ivs_ct_u erg_ct_d_u miso_ct_u em_ivf_ct_u jiv_txa_oxy_d_ct_u jiv_txa_ivf_ct_u ns_cost_u nicu_ct_u icu_ct_u bt_ct_u lap_ct_u lap_h_ct_u nasg_ct_u trans_ct_u ubt_ct_u bic_ct_u spph_ct_u exm_ct_u_DSA_1 msg_ct_u_DSA_1)
label var tc_11 "TC - MSG and EXM"
******************************************************************
**CL costs** // for one-country costing/LE analyses // to provide indicative info
*KE*
gen drp_ct_KE_CL = 1.518 // as above but KE specific for ease of generating subsequent variables.
gen oxy_ct_KE_CL = 1.253
gen txa_ct_KE_CL = 2.740
gen txa_a_ct_KE_CL = 0.801
gen ivf_ct_KE_CL = 0.108
gen icu_ct_KE_CL = 57.430
gen los_ct_KE_CL = 7.620
gen bt_ct_KE_CL = 95.641 
gen erg_ct_KE_CL = 0.730
gen lap_ct_KE_CL = 148.170 
gen lap_h_ct_KE_CL = 185.210 
gen miso_ct_KE_CL = 1.250
gen nasg_ct_KE_CL = 1.270
gen trans_ct_KE_CL = 19.354 
gen ubt_ct_KE_CL = 1.190 
gen bic_ct_KE_CL = 2.400 
gen spph_ct_KE_CL = 1.541 
gen ivs_ct_KE_CL = 0.190
gen ns_ct_KE_CL = 0.050
gen exm_ct_KE_CL = 0.000
gen msg_ct_KE_CL = 0.000
******************************************************************
gen drp_ct_u_KE_CL = 0 // as above but KE cost specific for use in country-level analysis.
replace drp_ct_u_KE_CL = drp_ct_KE_CL if exposed == 1
gen oxy_d_ct_u_KE_CL = oxy_ct_KE_CL * oxytocin
gen oxy_ivf_ct_u_KE_CL = ivf_ct_KE_CL * ivf_am_KNT if oxytocin == 1
replace oxy_ivf_ct_u = 0 if oxytocin == 0
gen txa_d_ct_u_KE_CL = txa_ct_KE_CL * txa
gen txa_a_ct_u_KE_CL = txa_a_ct_KE_CL * txa
gen icu_ct_u_KE_CL = 0 if icu == 0
replace icu_ct_u_KE_CL = icu_ct_KE_CL if icu_los == 0
replace icu_ct_u_KE_CL = icu_ct_KE_CL * icu_los if icu_los >=1 & icu_los != .
gen nicu_ct_u_KE_CL = los_ct_KE_CL if nicu_los == 0
replace nicu_ct_u_KE_CL = los_ct_KE_CL * nicu_los if nicu_los >= 1 & nicu_los != .
gen bt_ct_u_KE_CL = bt_ct_KE_CL * bt
gen erg_ct_d_u_KE_CL = erg_ct_KE_CL * ergometrine
gen lap_ct_u_KE_CL = lap_ct_KE_CL * lap_noh
gen lap_h_ct_u_KE_CL = lap_h_ct_KE_CL * lap_h
gen miso_ct_d_u_KE_CL = miso_ct_KE_CL * misoprostol
gen nasg_ct_u_KE_CL = nasg_ct_KE_CL * nasg
gen trans_ct_u_KE_CL = trans_ct_KE_CL * transfer
gen ubt_ct_u_KE_CL = ubt_ct_KE_CL * ubt
gen bic_ct_u_KE_CL = bic_ct_KE_CL * bimanual_compression
gen spph_ct_u_KE_CL = spph_ct_KE_CL * severe_pph
gen ivs_ct_u_KE_CL = ivs_ct_KE_CL if oxytocin == 1| iv_fluid == 1
replace ivs_ct_u = 0 if oxytocin == 0 & iv_fluid == 0
gen exm_ct_u_KE_CL = exm_ct_KE_CL * examin
gen msg_ct_u_KE_CL = msg_ct_KE_CL * uterine_massage
gen ns_ct_u_KE_CL = 0
replace ns_ct_u_KE_CL = ns_ct_KE_CL if oxytocin == 1| txa == 1| ergometrine == 1| iv_fluid == 1
gen jiv_oxy_d_ct_u_KE_CL = oxy_ct_KE_CL * jiv
gen jiv_ivf_ct_u_KE_CL = ivf_am_KNT * ivf_ct_KE_CL if jiv == 1
replace jiv_ivf_ct_u_KE_CL = 0 if jiv == 0
gen em_ivf_ct_u_KE_CL = 0
replace em_ivf_ct_u_KE_CL = ivf_ct_KE_CL * em_ivf_am
gen txa_ivf_ct_u_KE_CL = 0
gen jiv_txa_oxy_d_ct_u_KE_CL = jiv_txa * oxy_ct_KE_CL
gen jiv_txa_ivf_ct_u_KE_CL = ivf_ct_KE_CL * ivf_am_KNT if jiv_txa == 1
replace jiv_txa_ivf_ct_u = 0 if jiv_txa == 0

egen tc_KE_CL = rowtotal(drp_ct_u_KE_CL oxy_d_ct_u_KE_CL oxy_ivf_ct_u_KE_CL txa_d_ct_u_KE_CL txa_a_ct_u_KE_CL txa_ivf_ct_u_KE_CL jiv_oxy_d_ct_u_KE_CL jiv_ivf_ct_u_KE_CL ivs_ct_u_KE_CL erg_ct_d_u_KE_CL miso_ct_d_u_KE_CL em_ivf_ct_u_KE_CL jiv_txa_oxy_d_ct_u_KE_CL jiv_txa_ivf_ct_u_KE_CL ns_ct_u_KE_CL nicu_ct_u_KE_CL icu_ct_u_KE_CL bt_ct_u_KE_CL lap_ct_u_KE_CL lap_h_ct_u_KE_CL nasg_ct_u_KE_CL trans_ct_u_KE_CL ubt_ct_u_KE_CL bic_ct_u_KE_CL spph_ct_u_KE_CL exm_ct_u_KE_CL msg_ct_u_KE_CL)
label var tc_KE_CL "Total Cost - KE CL" // for use in KE CL analysis
******************************************************************
gen drp_ct_DSA_1_KE_CL = 1.214 // drape cost 1USD (2023). 
gen drp_ct_u_DSA_1_KE_CL = drp_ct_DSA_1_KE_CL * exposed
egen tc_KE_CL_1 = rowtotal(drp_ct_u_DSA_1_KE_CL oxy_d_ct_u_KE_CL oxy_ivf_ct_u_KE_CL txa_d_ct_u_KE_CL txa_a_ct_u_KE_CL txa_ivf_ct_u_KE_CL jiv_oxy_d_ct_u_KE_CL jiv_ivf_ct_u_KE_CL ivs_ct_u_KE_CL erg_ct_d_u_KE_CL miso_ct_d_u_KE_CL em_ivf_ct_u_KE_CL jiv_txa_oxy_d_ct_u_KE_CL jiv_txa_ivf_ct_u_KE_CL ns_ct_u_KE_CL nicu_ct_u_KE_CL icu_ct_u_KE_CL bt_ct_u_KE_CL lap_ct_u_KE_CL lap_h_ct_u_KE_CL nasg_ct_u_KE_CL trans_ct_u_KE_CL ubt_ct_u_KE_CL bic_ct_u_KE_CL spph_ct_u_KE_CL exm_ct_u_KE_CL msg_ct_u_KE_CL)
label var tc_KE_CL_1 "TC - KE CL: Drape Cost 1"
*drape cost 0.75 USD*
gen drp_ct_DSA_2_KE_CL = 0.911
gen drp_ct_u_DSA_2_KE_CL = drp_ct_DSA_2_KE_CL * exposed
egen tc_KE_CL_2 = rowtotal(drp_ct_u_DSA_2_KE_CL oxy_d_ct_u_KE_CL oxy_ivf_ct_u_KE_CL txa_d_ct_u_KE_CL txa_a_ct_u_KE_CL txa_ivf_ct_u_KE_CL jiv_oxy_d_ct_u_KE_CL jiv_ivf_ct_u_KE_CL ivs_ct_u_KE_CL erg_ct_d_u_KE_CL miso_ct_d_u_KE_CL em_ivf_ct_u_KE_CL jiv_txa_oxy_d_ct_u_KE_CL jiv_txa_ivf_ct_u_KE_CL ns_ct_u_KE_CL nicu_ct_u_KE_CL icu_ct_u_KE_CL bt_ct_u_KE_CL lap_ct_u_KE_CL lap_h_ct_u_KE_CL nasg_ct_u_KE_CL trans_ct_u_KE_CL ubt_ct_u_KE_CL bic_ct_u_KE_CL spph_ct_u_KE_CL exm_ct_u_KE_CL msg_ct_u_KE_CL)
label var tc_KE_CL_2 "TC - KE CL:Drape Cost 0.75"
*drape cost 0.50 USD*
gen drp_ct_DSA_3_KE_CL = 0.607
gen drp_ct_u_DSA_3_KE_CL = drp_ct_DSA_3_KE_CL * exposed
egen tc_KE_CL_3 = rowtotal(drp_ct_u_DSA_3 oxy_d_ct_u_KE_CL oxy_ivf_ct_u_KE_CL txa_d_ct_u_KE_CL txa_a_ct_u_KE_CL txa_ivf_ct_u_KE_CL jiv_oxy_d_ct_u_KE_CL jiv_ivf_ct_u_KE_CL ivs_ct_u_KE_CL erg_ct_d_u_KE_CL miso_ct_d_u_KE_CL em_ivf_ct_u_KE_CL jiv_txa_oxy_d_ct_u_KE_CL jiv_txa_ivf_ct_u_KE_CL ns_ct_u_KE_CL nicu_ct_u_KE_CL icu_ct_u_KE_CL bt_ct_u_KE_CL lap_ct_u_KE_CL lap_h_ct_u_KE_CL nasg_ct_u_KE_CL trans_ct_u_KE_CL ubt_ct_u_KE_CL bic_ct_u_KE_CL spph_ct_u_KE_CL exm_ct_u_KE_CL msg_ct_u_KE_CL)
label var tc_KE_CL_3 "TC - KE CL: Drape Cost 0.50"

*drape cost 0.25 USD*
gen drp_ct_DSA_4_KE_CL = 0.304
gen drp_ct_u_DSA_4_KE_CL = drp_ct_DSA_4_KE_CL * exposed
egen tc_KE_CL_4 = rowtotal(drp_ct_u_DSA_4 oxy_d_ct_u_KE_CL oxy_ivf_ct_u_KE_CL txa_d_ct_u_KE_CL txa_a_ct_u_KE_CL txa_ivf_ct_u_KE_CL jiv_oxy_d_ct_u_KE_CL jiv_ivf_ct_u_KE_CL ivs_ct_u_KE_CL erg_ct_d_u_KE_CL miso_ct_d_u_KE_CL em_ivf_ct_u_KE_CL jiv_txa_oxy_d_ct_u_KE_CL jiv_txa_ivf_ct_u_KE_CL ns_ct_u_KE_CL nicu_ct_u_KE_CL icu_ct_u_KE_CL bt_ct_u_KE_CL lap_ct_u_KE_CL lap_h_ct_u_KE_CL nasg_ct_u_KE_CL trans_ct_u_KE_CL ubt_ct_u_KE_CL bic_ct_u_KE_CL spph_ct_u_KE_CL exm_ct_u_KE_CL msg_ct_u_KE_CL)
label var tc_KE_CL_4 "TC - KE CL: Drape Cost 0.25"

*NI* 
gen drp_ct_NI_CL = 1.518 // as above but NI specific for ease of generating subsequent variables.
gen oxy_ct_NI_CL  = 1.253
gen txa_ct_NI_CL  = 2.740
gen txa_a_ct_NI_CL = 0.283
gen ivf_ct_NI_CL = 0.108
gen icu_ct_NI_CL = 100.500
gen los_ct_NI_CL = 13.980
gen bt_ct_NI_CL = 40.076
gen erg_ct_NI_CL = 0.730
gen lap_ct_NI_CL = 207.090
gen lap_h_ct_NI_CL = 258.860
gen miso_ct_NI_CL = 1.250
gen nasg_ct_NI_CL = 1.170
gen trans_ct_NI_CL = 34.250
gen ubt_ct_NI_CL = 0.930
gen bic_ct_NI_CL = 0.850
gen spph_ct_NI_CL = 0.787
gen ivs_ct_NI_CL = 0.190
gen ns_ct_NI_CL = 0.050
gen exm_ct_NI_CL = 0.000
gen msg_ct_NI_CL = 0.000
******************************************************************
gen drp_ct_u_NI_CL = 0 
replace drp_ct_u_NI_CL = drp_ct_NI_CL if exposed == 1
gen oxy_d_ct_u_NI_CL = oxy_ct_NI_CL * oxytocin
gen oxy_ivf_ct_u_NI_CL = ivf_ct_NI_CL * ivf_am_KNT if oxytocin == 1
replace oxy_ivf_ct_u = 0 if oxytocin == 0
gen txa_d_ct_u_NI_CL = txa_ct_NI_CL * txa
gen txa_a_ct_u_NI_CL = txa_a_ct_NI_CL * txa
gen icu_ct_u_NI_CL = 0 if icu == 0
replace icu_ct_u_NI_CL = icu_ct_NI_CL if icu_los == 0
replace icu_ct_u_NI_CL = icu_ct_NI_CL * icu_los if icu_los >=1 & icu_los != .
gen nicu_ct_u_NI_CL = los_ct_NI_CL if nicu_los == 0
replace nicu_ct_u_NI_CL = los_ct_NI_CL * nicu_los if nicu_los >= 1 & nicu_los != .
gen bt_ct_u_NI_CL = bt_ct_NI_CL * bt
gen erg_ct_d_u_NI_CL = erg_ct_NI_CL * ergometrine
gen lap_ct_u_NI_CL = lap_ct_NI_CL * lap_noh
gen lap_h_ct_u_NI_CL = lap_h_ct_NI_CL * lap_h
gen miso_ct_d_u_NI_CL = miso_ct_NI_CL * misoprostol
gen nasg_ct_u_NI_CL = nasg_ct_NI_CL * nasg
gen trans_ct_u_NI_CL = trans_ct_NI_CL * transfer
gen ubt_ct_u_NI_CL = ubt_ct_NI_CL * ubt
gen bic_ct_u_NI_CL = bic_ct_NI_CL * bimanual_compression
gen spph_ct_u_NI_CL = spph_ct_NI_CL * severe_pph
gen ivs_ct_u_NI_CL = ivs_ct_NI_CL if oxytocin == 1| iv_fluid == 1
replace ivs_ct_u = 0 if oxytocin == 0 & iv_fluid == 0
gen exm_ct_u_NI_CL = exm_ct_NI_CL * examin
gen msg_ct_u_NI_CL = msg_ct_NI_CL * uterine_massage
gen ns_ct_u_NI_CL = 0
replace ns_ct_u_NI_CL = ns_ct_NI_CL if oxytocin == 1| txa == 1| ergometrine == 1| iv_fluid == 1
gen jiv_oxy_d_ct_u_NI_CL = oxy_ct_NI_CL * jiv
gen jiv_ivf_ct_u_NI_CL = ivf_am_KNT * ivf_ct_NI_CL if jiv == 1
replace jiv_ivf_ct_u_NI_CL = 0 if jiv == 0
gen em_ivf_ct_u_NI_CL = 0
replace em_ivf_ct_u_NI_CL = ivf_ct_NI_CL * em_ivf_am
gen txa_ivf_ct_u_NI_CL = 0
gen jiv_txa_oxy_d_ct_u_NI_CL = jiv_txa * oxy_ct_NI_CL
gen jiv_txa_ivf_ct_u_NI_CL = ivf_ct_NI_CL * ivf_am_KNT if jiv_txa == 1
replace jiv_txa_ivf_ct_u = 0 if jiv_txa == 0

egen tc_NI_CL = rowtotal(drp_ct_u_NI_CL oxy_d_ct_u_NI_CL oxy_ivf_ct_u_NI_CL txa_d_ct_u_NI_CL txa_a_ct_u_NI_CL txa_ivf_ct_u_NI_CL jiv_oxy_d_ct_u_NI_CL jiv_ivf_ct_u_NI_CL ivs_ct_u_NI_CL erg_ct_d_u_NI_CL miso_ct_d_u_NI_CL em_ivf_ct_u_NI_CL jiv_txa_oxy_d_ct_u_NI_CL jiv_txa_ivf_ct_u_NI_CL ns_ct_u_NI_CL nicu_ct_u_NI_CL icu_ct_u_NI_CL bt_ct_u_NI_CL lap_ct_u_NI_CL lap_h_ct_u_NI_CL nasg_ct_u_NI_CL trans_ct_u_NI_CL ubt_ct_u_NI_CL bic_ct_u_NI_CL spph_ct_u_NI_CL exm_ct_u_NI_CL msg_ct_u_NI_CL)
label var tc_NI_CL "Total Cost - NI CL"

*drape cost 1 USD*
gen drp_ct_DSA_1_NI_CL = 1.214
gen drp_ct_u_DSA_1_NI_CL = drp_ct_DSA_1_NI_CL * exposed
egen tc_NI_CL_1 = rowtotal(drp_ct_u_DSA_1_NI_CL oxy_d_ct_u_NI_CL oxy_ivf_ct_u_NI_CL txa_d_ct_u_NI_CL txa_a_ct_u_NI_CL txa_ivf_ct_u_NI_CL jiv_oxy_d_ct_u_NI_CL jiv_ivf_ct_u_NI_CL ivs_ct_u_NI_CL erg_ct_d_u_NI_CL miso_ct_d_u_NI_CL em_ivf_ct_u_NI_CL jiv_txa_oxy_d_ct_u_NI_CL jiv_txa_ivf_ct_u_NI_CL ns_ct_u_NI_CL nicu_ct_u_NI_CL icu_ct_u_NI_CL bt_ct_u_NI_CL lap_ct_u_NI_CL lap_h_ct_u_NI_CL nasg_ct_u_NI_CL trans_ct_u_NI_CL ubt_ct_u_NI_CL bic_ct_u_NI_CL spph_ct_u_NI_CL exm_ct_u_NI_CL msg_ct_u_NI_CL)
label var tc_NI_CL_1 "TC - KE CL: Drape Cost 1"

*drape cost 0.75 USD*
gen drp_ct_DSA_2_NI_CL = 0.911
gen drp_ct_u_DSA_2_NI_CL = drp_ct_DSA_2_NI_CL * exposed
egen tc_NI_CL_2 = rowtotal(drp_ct_u_DSA_2_NI_CL oxy_d_ct_u_NI_CL oxy_ivf_ct_u_NI_CL txa_d_ct_u_NI_CL txa_a_ct_u_NI_CL txa_ivf_ct_u_NI_CL jiv_oxy_d_ct_u_NI_CL jiv_ivf_ct_u_NI_CL ivs_ct_u_NI_CL erg_ct_d_u_NI_CL miso_ct_d_u_NI_CL em_ivf_ct_u_NI_CL jiv_txa_oxy_d_ct_u_NI_CL jiv_txa_ivf_ct_u_NI_CL ns_ct_u_NI_CL nicu_ct_u_NI_CL icu_ct_u_NI_CL bt_ct_u_NI_CL lap_ct_u_NI_CL lap_h_ct_u_NI_CL nasg_ct_u_NI_CL trans_ct_u_NI_CL ubt_ct_u_NI_CL bic_ct_u_NI_CL spph_ct_u_NI_CL exm_ct_u_NI_CL msg_ct_u_NI_CL)
label var tc_NI_CL_2 "TC - KE CL:Drape Cost 0.75"

*drape cost 0.50 USD*
gen drp_ct_DSA_3_NI_CL = 0.607
gen drp_ct_u_DSA_3_NI_CL = drp_ct_DSA_3_NI_CL * exposed
egen tc_NI_CL_3 = rowtotal(drp_ct_u_DSA_3 oxy_d_ct_u_NI_CL oxy_ivf_ct_u_NI_CL txa_d_ct_u_NI_CL txa_a_ct_u_NI_CL txa_ivf_ct_u_NI_CL jiv_oxy_d_ct_u_NI_CL jiv_ivf_ct_u_NI_CL ivs_ct_u_NI_CL erg_ct_d_u_NI_CL miso_ct_d_u_NI_CL em_ivf_ct_u_NI_CL jiv_txa_oxy_d_ct_u_NI_CL jiv_txa_ivf_ct_u_NI_CL ns_ct_u_NI_CL nicu_ct_u_NI_CL icu_ct_u_NI_CL bt_ct_u_NI_CL lap_ct_u_NI_CL lap_h_ct_u_NI_CL nasg_ct_u_NI_CL trans_ct_u_NI_CL ubt_ct_u_NI_CL bic_ct_u_NI_CL spph_ct_u_NI_CL exm_ct_u_NI_CL msg_ct_u_NI_CL)
label var tc_NI_CL_3 "TC - KE CL: Drape Cost 0.50"

*drape cost 0.25 USD*
gen drp_ct_DSA_4_NI_CL = 0.304
gen drp_ct_u_DSA_4_NI_CL = drp_ct_DSA_4_NI_CL * exposed
egen tc_NI_CL_4 = rowtotal(drp_ct_u_DSA_4 oxy_d_ct_u_NI_CL oxy_ivf_ct_u_NI_CL txa_d_ct_u_NI_CL txa_a_ct_u_NI_CL txa_ivf_ct_u_NI_CL jiv_oxy_d_ct_u_NI_CL jiv_ivf_ct_u_NI_CL ivs_ct_u_NI_CL erg_ct_d_u_NI_CL miso_ct_d_u_NI_CL em_ivf_ct_u_NI_CL jiv_txa_oxy_d_ct_u_NI_CL jiv_txa_ivf_ct_u_NI_CL ns_ct_u_NI_CL nicu_ct_u_NI_CL icu_ct_u_NI_CL bt_ct_u_NI_CL lap_ct_u_NI_CL lap_h_ct_u_NI_CL nasg_ct_u_NI_CL trans_ct_u_NI_CL ubt_ct_u_NI_CL bic_ct_u_NI_CL spph_ct_u_NI_CL exm_ct_u_NI_CL msg_ct_u_NI_CL)
label var tc_NI_CL_4 "TC - NI CL: Drape Cost 0.25"
******************************************************************
*SA*
gen drp_ct_SA_CL = 1.518 // as above but SA specific for ease of generating subsequent variables.
gen oxy_ct_SA_CL = 1.253
gen txa_ct_SA_CL = 2.740
gen txa_a_ct_SA_CL = 0.000
gen ivf_ct_SA_CL = 0.108
gen icu_ct_SA_CL = 717.860
gen los_ct_SA_CL = 110.270 
gen bt_ct_SA_CL = 288.547
gen erg_ct_SA_CL = 0.730
gen lap_ct_SA_CL = 1071.590 
gen lap_h_ct_SA_CL = 1339.490
gen miso_ct_SA_CL = 1.250
gen nasg_ct_SA_CL = 1.540 
gen trans_ct_SA_CL = 53.740
gen ubt_ct_SA_CL = 6.900 
gen bic_ct_SA_CL = 6.350 
gen spph_ct_SA_CL = 4.270 
gen ivs_ct_SA_CL = 0.190
gen ns_ct_SA_CL = 0.050
gen exm_ct_SA_CL = 0.000
gen msg_ct_SA_CL = 0.000

gen drp_ct_u_SA_CL = 0
replace drp_ct_u_SA_CL = drp_ct_SA_CL if exposed == 1
gen oxy_d_ct_u_SA_CL = oxy_ct_SA_CL * oxytocin
gen oxy_ivf_ct_u_SA_CL = ivf_ct_SA_CL * ivf_am_S if oxytocin == 1
replace oxy_ivf_ct_u = 0 if oxytocin == 0
gen txa_d_ct_u_SA_CL = txa_ct_SA_CL * txa
gen txa_a_ct_u_SA_CL = txa_a_ct_SA_CL * txa
gen icu_ct_u_SA_CL = 0 if icu == 0
replace icu_ct_u_SA_CL = icu_ct_SA_CL if icu_los == 0
replace icu_ct_u_SA_CL = icu_ct_SA_CL * icu_los if icu_los >=1 & icu_los != .
gen nicu_ct_u_SA_CL = los_ct_SA_CL if nicu_los == 0
replace nicu_ct_u_SA_CL = los_ct_SA_CL * nicu_los if nicu_los >= 1 & nicu_los != .
gen bt_ct_u_SA_CL = bt_ct_SA_CL * bt
gen erg_ct_d_u_SA_CL = erg_ct_SA_CL * ergometrine
gen lap_ct_u_SA_CL = lap_ct_SA_CL * lap_noh
gen lap_h_ct_u_SA_CL = lap_h_ct_SA_CL * lap_h
gen miso_ct_d_u_SA_CL = miso_ct_SA_CL * misoprostol
gen nasg_ct_u_SA_CL = nasg_ct_SA_CL * nasg
gen trans_ct_u_SA_CL = trans_ct_SA_CL * transfer
gen ubt_ct_u_SA_CL = ubt_ct_SA_CL * ubt
gen bic_ct_u_SA_CL = bic_ct_SA_CL * bimanual_compression
gen spph_ct_u_SA_CL = spph_ct_SA_CL * severe_pph
gen ivs_ct_u_SA_CL = ivs_ct_SA_CL if oxytocin == 1| iv_fluid == 1| txa == 1 
replace ivs_ct_u_SA_CL = 0 if oxytocin == 0 & txa == 0 & iv_fluid == 0
gen exm_ct_u_SA_CL = exm_ct_SA_CL * examin
gen msg_ct_u_SA_CL = msg_ct_SA_CL * uterine_massage
gen ns_ct_u_SA_CL = 0
replace ns_ct_u_SA_CL = ns_ct if oxytocin == 1| txa == 1| ergometrine == 1| iv_fluid == 1
gen jiv_oxy_d_ct_u_SA_CL = oxy_ct_SA_CL * jiv
gen jiv_ivf_ct_u_SA_CL = ivf_am_S * ivf_ct_SA_CL if jiv == 1
replace jiv_ivf_ct_u_SA_CL = 0 if jiv == 0
gen em_ivf_am_SA_CL = 5 * em_ivf
gen em_ivf_ct_u_SA_CL = 0
replace em_ivf_ct_u_SA_CL = ivf_ct_SA_CL * em_ivf_am
gen txa_ivf_ct_u_SA_CL = 0
replace txa_ivf_ct_u_SA_CL = ivf_ct_SA_CL * txa_ivf_SA if txa == 1
gen jiv_txa_oxy_d_ct_u_SA_CL = jiv_txa * oxy_ct_SA_CL
gen jiv_txa_ivf_ct_u_SA_CL = ivf_ct_SA_CL * ivf_am_S if jiv_txa == 1
replace jiv_txa_ivf_ct_u_SA_CL = 0 if jiv_txa == 0

egen tc_SA_CL = rowtotal(drp_ct_u_SA_CL oxy_d_ct_u_SA_CL oxy_ivf_ct_u_SA_CL txa_d_ct_u_SA_CL txa_a_ct_u_SA_CL txa_ivf_ct_u_SA_CL jiv_oxy_d_ct_u_SA_CL jiv_ivf_ct_u_SA_CL ivs_ct_u_SA_CL erg_ct_d_u_SA_CL miso_ct_d_u_SA_CL em_ivf_ct_u_SA_CL jiv_txa_oxy_d_ct_u_SA_CL jiv_txa_ivf_ct_u_SA_CL ns_ct_u_SA_CL nicu_ct_u_SA_CL icu_ct_u_SA_CL bt_ct_u_SA_CL lap_ct_u_SA_CL lap_h_ct_u_SA_CL nasg_ct_u_SA_CL trans_ct_u_SA_CL ubt_ct_u_SA_CL bic_ct_u_SA_CL spph_ct_u_SA_CL exm_ct_u_SA_CL msg_ct_u_SA_CL)
label var tc_SA_CL "Total Cost - SA CL"

*drape cost 1 USD*
gen drp_ct_DSA_1_SA_CL = 1.214
gen drp_ct_u_DSA_1_SA_CL = drp_ct_DSA_1_SA_CL * exposed
egen tc_SA_CL_1 = rowtotal(drp_ct_u_DSA_1_SA_CL oxy_d_ct_u_SA_CL oxy_ivf_ct_u_SA_CL txa_d_ct_u_SA_CL txa_a_ct_u_SA_CL txa_ivf_ct_u_SA_CL jiv_oxy_d_ct_u_SA_CL jiv_ivf_ct_u_SA_CL ivs_ct_u_SA_CL erg_ct_d_u_SA_CL miso_ct_d_u_SA_CL em_ivf_ct_u_SA_CL jiv_txa_oxy_d_ct_u_SA_CL jiv_txa_ivf_ct_u_SA_CL ns_ct_u_SA_CL nicu_ct_u_SA_CL icu_ct_u_SA_CL bt_ct_u_SA_CL lap_ct_u_SA_CL lap_h_ct_u_SA_CL nasg_ct_u_SA_CL trans_ct_u_SA_CL ubt_ct_u_SA_CL bic_ct_u_SA_CL spph_ct_u_SA_CL exm_ct_u_SA_CL msg_ct_u_SA_CL)
label var tc_SA_CL_1 "TC - KE CL: Drape Cost 1"

*drape cost 0.75 USD*
gen drp_ct_DSA_2_SA_CL = 0.911
gen drp_ct_u_DSA_2_SA_CL = drp_ct_DSA_2_SA_CL * exposed

egen tc_SA_CL_2 = rowtotal(drp_ct_u_DSA_2_SA_CL oxy_d_ct_u_SA_CL oxy_ivf_ct_u_SA_CL txa_d_ct_u_SA_CL txa_a_ct_u_SA_CL txa_ivf_ct_u_SA_CL jiv_oxy_d_ct_u_SA_CL jiv_ivf_ct_u_SA_CL ivs_ct_u_SA_CL erg_ct_d_u_SA_CL miso_ct_d_u_SA_CL em_ivf_ct_u_SA_CL jiv_txa_oxy_d_ct_u_SA_CL jiv_txa_ivf_ct_u_SA_CL ns_ct_u_SA_CL nicu_ct_u_SA_CL icu_ct_u_SA_CL bt_ct_u_SA_CL lap_ct_u_SA_CL lap_h_ct_u_SA_CL nasg_ct_u_SA_CL trans_ct_u_SA_CL ubt_ct_u_SA_CL bic_ct_u_SA_CL spph_ct_u_SA_CL exm_ct_u_SA_CL msg_ct_u_SA_CL)
label var tc_SA_CL_2 "TC - KE CL:Drape Cost 0.75"

*drape cost 0.50 USD*
gen drp_ct_DSA_3_SA_CL = 0.607
gen drp_ct_u_DSA_3_SA_CL = drp_ct_DSA_3_SA_CL * exposed
egen tc_SA_CL_3 = rowtotal(drp_ct_u_DSA_3 oxy_d_ct_u_SA_CL oxy_ivf_ct_u_SA_CL txa_d_ct_u_SA_CL txa_a_ct_u_SA_CL txa_ivf_ct_u_SA_CL jiv_oxy_d_ct_u_SA_CL jiv_ivf_ct_u_SA_CL ivs_ct_u_SA_CL erg_ct_d_u_SA_CL miso_ct_d_u_SA_CL em_ivf_ct_u_SA_CL jiv_txa_oxy_d_ct_u_SA_CL jiv_txa_ivf_ct_u_SA_CL ns_ct_u_SA_CL nicu_ct_u_SA_CL icu_ct_u_SA_CL bt_ct_u_SA_CL lap_ct_u_SA_CL lap_h_ct_u_SA_CL nasg_ct_u_SA_CL trans_ct_u_SA_CL ubt_ct_u_SA_CL bic_ct_u_SA_CL spph_ct_u_SA_CL exm_ct_u_SA_CL msg_ct_u_SA_CL)
label var tc_SA_CL_3 "TC - KE CL: Drape Cost 0.50"

*drape cost 0.25 USD*
gen drp_ct_DSA_4_SA_CL = 0.304
gen drp_ct_u_DSA_4_SA_CL = drp_ct_DSA_4_SA_CL * exposed
egen tc_SA_CL_4 = rowtotal(drp_ct_u_DSA_4 oxy_d_ct_u_SA_CL oxy_ivf_ct_u_SA_CL txa_d_ct_u_SA_CL txa_a_ct_u_SA_CL txa_ivf_ct_u_SA_CL jiv_oxy_d_ct_u_SA_CL jiv_ivf_ct_u_SA_CL ivs_ct_u_SA_CL erg_ct_d_u_SA_CL miso_ct_d_u_SA_CL em_ivf_ct_u_SA_CL jiv_txa_oxy_d_ct_u_SA_CL jiv_txa_ivf_ct_u_SA_CL ns_ct_u_SA_CL nicu_ct_u_SA_CL icu_ct_u_SA_CL bt_ct_u_SA_CL lap_ct_u_SA_CL lap_h_ct_u_SA_CL nasg_ct_u_SA_CL trans_ct_u_SA_CL ubt_ct_u_SA_CL bic_ct_u_SA_CL spph_ct_u_SA_CL exm_ct_u_SA_CL msg_ct_u_SA_CL)
label var tc_SA_CL_4 "TC - SA CL: Drape Cost 0.25"

*TZ*
gen drp_ct_TZ_CL = 1.518 // as above but TZ specific for ease of generating subsequent variables.
gen oxy_ct_TZ_CL = 1.253
gen txa_ct_TZ_CL = 2.740
gen txa_a_ct_TZ_CL = 0.286 
gen ivf_ct_TZ_CL = 0.108
gen icu_ct_TZ_CL = 43.070 
gen los_ct_TZ_CL = 5.610 
gen bt_ct_TZ_CL = 71.731 
gen erg_ct_TZ_CL = 0.730
gen lap_ct_TZ_CL = 111.130 
gen lap_h_ct_TZ_CL = 138.910 
gen miso_ct_TZ_CL = 1.250
gen nasg_ct_TZ_CL = 1.170 
gen trans_ct_TZ_CL = 14.510 
gen ubt_ct_TZ_CL = 0.930 
gen bic_ct_TZ_CL = 0.860 
gen spph_ct_TZ_CL = 0.720 
gen ivs_ct_TZ_CL = 0.190
gen ns_ct_TZ_CL = 0.050
gen exm_ct_TZ_CL = 0.000
gen msg_ct_TZ_CL = 0.000

gen drp_ct_u_TZ_CL = 0
replace drp_ct_u_TZ_CL = drp_ct_TZ_CL if exposed == 1
gen oxy_d_ct_u_TZ_CL = oxy_ct_TZ_CL * oxytocin
gen oxy_ivf_ct_u_TZ_CL = ivf_ct_TZ_CL * ivf_am_KNT if oxytocin == 1
replace oxy_ivf_ct_u = 0 if oxytocin == 0
gen txa_d_ct_u_TZ_CL = txa_ct_TZ_CL * txa
gen txa_a_ct_u_TZ_CL = txa_a_ct_TZ_CL * txa
gen icu_ct_u_TZ_CL = 0 if icu == 0
replace icu_ct_u_TZ_CL = icu_ct_TZ_CL if icu_los == 0
replace icu_ct_u_TZ_CL = icu_ct_TZ_CL * icu_los if icu_los >=1 & icu_los != .
gen nicu_ct_u_TZ_CL = los_ct_TZ_CL if nicu_los == 0
replace nicu_ct_u_TZ_CL = los_ct_TZ_CL * nicu_los if nicu_los >= 1 & nicu_los != .
gen bt_ct_u_TZ_CL = bt_ct_TZ_CL * bt
gen erg_ct_d_u_TZ_CL = erg_ct_TZ_CL * ergometrine
gen lap_ct_u_TZ_CL = lap_ct_TZ_CL * lap_noh
gen lap_h_ct_u_TZ_CL = lap_h_ct_TZ_CL * lap_h
gen miso_ct_d_u_TZ_CL = miso_ct_TZ_CL * misoprostol
gen nasg_ct_u_TZ_CL = nasg_ct_TZ_CL * nasg
gen trans_ct_u_TZ_CL = trans_ct_TZ_CL * transfer
gen ubt_ct_u_TZ_CL = ubt_ct_TZ_CL * ubt
gen bic_ct_u_TZ_CL = bic_ct_TZ_CL * bimanual_compression
gen spph_ct_u_TZ_CL = spph_ct_TZ_CL * severe_pph
gen ivs_ct_u_TZ_CL = ivs_ct_TZ_CL if oxytocin == 1| iv_fluid == 1
replace ivs_ct_u = 0 if oxytocin == 0 & iv_fluid == 0
gen exm_ct_u_TZ_CL = exm_ct_TZ_CL * examin
gen msg_ct_u_TZ_CL = msg_ct_TZ_CL * uterine_massage
gen ns_ct_u_TZ_CL = 0
replace ns_ct_u_TZ_CL = ns_ct_TZ_CL if oxytocin == 1| txa == 1| ergometrine == 1| iv_fluid == 1
gen jiv_oxy_d_ct_u_TZ_CL = oxy_ct_TZ_CL * jiv
gen jiv_ivf_ct_u_TZ_CL = ivf_am_KNT * ivf_ct_TZ_CL if jiv == 1
replace jiv_ivf_ct_u_TZ_CL = 0 if jiv == 0
gen em_ivf_ct_u_TZ_CL = 0
replace em_ivf_ct_u_TZ_CL = ivf_ct_TZ_CL * em_ivf_am
gen txa_ivf_ct_u_TZ_CL = 0
gen jiv_txa_oxy_d_ct_u_TZ_CL = jiv_txa * oxy_ct_TZ_CL
gen jiv_txa_ivf_ct_u_TZ_CL = ivf_ct_TZ_CL * ivf_am_KNT if jiv_txa == 1
replace jiv_txa_ivf_ct_u = 0 if jiv_txa == 0

egen tc_TZ_CL = rowtotal(drp_ct_u_TZ_CL oxy_d_ct_u_TZ_CL oxy_ivf_ct_u_TZ_CL txa_d_ct_u_TZ_CL txa_a_ct_u_TZ_CL txa_ivf_ct_u_TZ_CL jiv_oxy_d_ct_u_TZ_CL jiv_ivf_ct_u_TZ_CL ivs_ct_u_TZ_CL erg_ct_d_u_TZ_CL miso_ct_d_u_TZ_CL em_ivf_ct_u_TZ_CL jiv_txa_oxy_d_ct_u_TZ_CL jiv_txa_ivf_ct_u_TZ_CL ns_ct_u_TZ_CL nicu_ct_u_TZ_CL icu_ct_u_TZ_CL bt_ct_u_TZ_CL lap_ct_u_TZ_CL lap_h_ct_u_TZ_CL nasg_ct_u_TZ_CL trans_ct_u_TZ_CL ubt_ct_u_TZ_CL bic_ct_u_TZ_CL spph_ct_u_TZ_CL exm_ct_u_TZ_CL msg_ct_u_TZ_CL)
label var tc_TZ_CL "Total Cost - TZ CL"

*drape cost 1 USD*
gen drp_ct_DSA_1_TZ_CL = 1.214
gen drp_ct_u_DSA_1_TZ_CL = drp_ct_DSA_1_TZ_CL * exposed
egen tc_TZ_CL_1 = rowtotal(drp_ct_u_DSA_1_TZ_CL oxy_d_ct_u_TZ_CL oxy_ivf_ct_u_TZ_CL txa_d_ct_u_TZ_CL txa_a_ct_u_TZ_CL txa_ivf_ct_u_TZ_CL jiv_oxy_d_ct_u_TZ_CL jiv_ivf_ct_u_TZ_CL ivs_ct_u_TZ_CL erg_ct_d_u_TZ_CL miso_ct_d_u_TZ_CL em_ivf_ct_u_TZ_CL jiv_txa_oxy_d_ct_u_TZ_CL jiv_txa_ivf_ct_u_TZ_CL ns_ct_u_TZ_CL nicu_ct_u_TZ_CL icu_ct_u_TZ_CL bt_ct_u_TZ_CL lap_ct_u_TZ_CL lap_h_ct_u_TZ_CL nasg_ct_u_TZ_CL trans_ct_u_TZ_CL ubt_ct_u_TZ_CL bic_ct_u_TZ_CL spph_ct_u_TZ_CL exm_ct_u_TZ_CL msg_ct_u_TZ_CL)
label var tc_TZ_CL_1 "TC - KE CL: Drape Cost 1"

*drape cost 0.75 USD*
gen drp_ct_DSA_2_TZ_CL = 0.911
gen drp_ct_u_DSA_2_TZ_CL = drp_ct_DSA_2_TZ_CL * exposed
egen tc_TZ_CL_2 = rowtotal(drp_ct_u_DSA_2_TZ_CL oxy_d_ct_u_TZ_CL oxy_ivf_ct_u_TZ_CL txa_d_ct_u_TZ_CL txa_a_ct_u_TZ_CL txa_ivf_ct_u_TZ_CL jiv_oxy_d_ct_u_TZ_CL jiv_ivf_ct_u_TZ_CL ivs_ct_u_TZ_CL erg_ct_d_u_TZ_CL miso_ct_d_u_TZ_CL em_ivf_ct_u_TZ_CL jiv_txa_oxy_d_ct_u_TZ_CL jiv_txa_ivf_ct_u_TZ_CL ns_ct_u_TZ_CL nicu_ct_u_TZ_CL icu_ct_u_TZ_CL bt_ct_u_TZ_CL lap_ct_u_TZ_CL lap_h_ct_u_TZ_CL nasg_ct_u_TZ_CL trans_ct_u_TZ_CL ubt_ct_u_TZ_CL bic_ct_u_TZ_CL spph_ct_u_TZ_CL exm_ct_u_TZ_CL msg_ct_u_TZ_CL)
label var tc_TZ_CL_2 "TC - KE CL:Drape Cost 0.75"

*drape cost 0.50 USD*
gen drp_ct_DSA_3_TZ_CL = 0.607
gen drp_ct_u_DSA_3_TZ_CL = drp_ct_DSA_3_TZ_CL * exposed
egen tc_TZ_CL_3 = rowtotal(drp_ct_u_DSA_3 oxy_d_ct_u_TZ_CL oxy_ivf_ct_u_TZ_CL txa_d_ct_u_TZ_CL txa_a_ct_u_TZ_CL txa_ivf_ct_u_TZ_CL jiv_oxy_d_ct_u_TZ_CL jiv_ivf_ct_u_TZ_CL ivs_ct_u_TZ_CL erg_ct_d_u_TZ_CL miso_ct_d_u_TZ_CL em_ivf_ct_u_TZ_CL jiv_txa_oxy_d_ct_u_TZ_CL jiv_txa_ivf_ct_u_TZ_CL ns_ct_u_TZ_CL nicu_ct_u_TZ_CL icu_ct_u_TZ_CL bt_ct_u_TZ_CL lap_ct_u_TZ_CL lap_h_ct_u_TZ_CL nasg_ct_u_TZ_CL trans_ct_u_TZ_CL ubt_ct_u_TZ_CL bic_ct_u_TZ_CL spph_ct_u_TZ_CL exm_ct_u_TZ_CL msg_ct_u_TZ_CL)
label var tc_TZ_CL_3 "TC - KE CL: Drape Cost 0.50"

*drape cost 0.25 USD*
gen drp_ct_DSA_4_TZ_CL = 0.304
gen drp_ct_u_DSA_4_TZ_CL = drp_ct_DSA_4_TZ_CL * exposed
egen tc_TZ_CL_4 = rowtotal(drp_ct_u_DSA_4 oxy_d_ct_u_TZ_CL oxy_ivf_ct_u_TZ_CL txa_d_ct_u_TZ_CL txa_a_ct_u_TZ_CL txa_ivf_ct_u_TZ_CL jiv_oxy_d_ct_u_TZ_CL jiv_ivf_ct_u_TZ_CL ivs_ct_u_TZ_CL erg_ct_d_u_TZ_CL miso_ct_d_u_TZ_CL em_ivf_ct_u_TZ_CL jiv_txa_oxy_d_ct_u_TZ_CL jiv_txa_ivf_ct_u_TZ_CL ns_ct_u_TZ_CL nicu_ct_u_TZ_CL icu_ct_u_TZ_CL bt_ct_u_TZ_CL lap_ct_u_TZ_CL lap_h_ct_u_TZ_CL nasg_ct_u_TZ_CL trans_ct_u_TZ_CL ubt_ct_u_TZ_CL bic_ct_u_TZ_CL spph_ct_u_TZ_CL exm_ct_u_TZ_CL msg_ct_u_TZ_CL)
label var tc_TZ_CL_4 "TC - TZ CL: Drape Cost 0.25"

save Full_Sample.dta,
*only use individuals with verified blood loss data (98% sample)
drop if severe_pph ==. 
save Verified_Sample.dta,
******************************************************************

***************************************************************************************************************
*
**Analyses
*
***************************************************************************************************************
**Tab stats**
*outcomes, table 2*
bysort arm time_period: tab pph
bysort arm time_period: tab severe_pph
bysort arm time_period: sum dalys
******************************************************************
*resources, table a3*
bysort arm time_period: tab uterine_massage
bysort arm time_period: tab oxytocin
bysort arm time_period: tab txa
bysort arm time_period: tab examin
bysort arm time_period: tab ergometrine
bysort arm time_period: tab misoprostol
bysort arm time_period: tab lap_noh
bysort arm time_period: tab lap_h
bysort arm time_period: tab ubt
bysort arm time_period: tab bt
bysort arm time_period: tab transfer
bysort arm time_period: tab icu
bysort arm time_period: sum los
bysort arm time_period: sum icu_los
******************************************************************
*costs table 2, table a4*
bysort arm time_period: sum drp_ct_u
bysort arm time_period: sum oxy_d_tc
bysort arm time_period: sum txa_tc 
bysort arm time_period: sum ivfs_tc
bysort arm time_period: sum miso_ct_d_u
bysort arm time_period: sum erg_ct_d_u
bysort arm time_period: sum ns_ct_u
bysort arm time_period: sum lap_ct_u
bysort arm time_period: sum lap_h_ct_u
bysort arm time_period: sum nasg_ct_u
bysort arm time_period: sum bic_ct_u
bysort arm time_period: sum ubt_ct_u
bysort arm time_period: sum bt_ct_u
bysort arm time_period: sum nicu_ct_u
bysort arm time_period: sum icu_ct_u
bysort arm time_period: sum trans_ct_u
bysort arm time_period: sum spph_ct_u
bysort arm time_period: sum tc
******************************************************************
*CL costs, table 4*
bysort arm time_period: sum tc_KE_CL
bysort arm time_period: sum tc_KE_CL
bysort arm time_period: sum tc_KE_CL
bysort arm time_period: sum tc_KE_CL
******************************************************************
********************************************************************************************************************
**outcomes analysis**
*severe pph*
*risk ratio*
melogit severe_pph i.exposed i.time_period i.country i.minim_cluster_size i.minim_oxytocin  || cluster:  || clustime: ,or  vce(robust)
margins exposed, post vce(unconditional)
nlcom (ln(_b[1.exposed])-ln(_b[0.exposed])) , post
local b  = exp(r(b)[1,1])
local lb = exp(r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = exp(r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.6f  `b' " (" `lb' ", " `ub' ")"
******************************************************************
*risk difference*
melogit severe_pph i.exposed i.time_period i.country i.minim_cluster_size i.minim_oxytocin  || cluster: || clustime: ,or  vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = 100*(r(b)[1,1])
local lb = 100*(r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = 100*(r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.7f  `b' " (" `lb' ", " `ub' ")"
****************************************************************** 
*DALYs*
mixed daly i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.7f  `b' " (" `lb' ", " `ub' ")" // lb,ub to use as starting point in swpermute
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly) null(-0.00814) reps(1000): mixed daly i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly) null(0.00287) reps(1000): mixed daly i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: ||
******************************************************************
*KE*
mixed daly_KE_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.7f  `b' " (" `lb' ", " `ub' ")" // lb,ub to use as starting point in swpermute
******************************************************************
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly_KE_CL) null(-0.00817) reps(1000): mixed daly_KE_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly_KE_CL) null(0.00281) reps(1000): mixed daly_KE_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

*NI*
mixed daly_NI_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.7f  `b' " (" `lb' ", " `ub' ")" 

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly_NI_CL) null(-0.00814) reps(1000): mixed daly_NI_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly_NI_CL) null(0.00283) reps(1000): mixed daly_NI_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

*SA*
mixed daly_SA_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.7f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly_SA_CL) null(-0.00814) reps(1000): mixed daly_SA_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(daly_SA_CL) null(0.00283) reps(1000): mixed daly_SA_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

*TZ*
mixed daly_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %8.7f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_KE_CL) null(-0.68) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_KE_CL) null(2.75) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

********************************************************************************************************************
*cost analysis*
*base-case*
*table 2*
mixed tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.312) reps(1000): mixed tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.783) reps(1000): mixed tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*table A4*
mixed oxy_d_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(oxy_d_tc) null(0.007) reps(1000): mixed oxy_d_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(oxy_d_tc) null(0.068) reps(1000): mixed oxy_d_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed txa_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(txa_tc) null(0.199) reps(1000): mixed txa_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(txa_tc) null(0.305) reps(1000): mixed txa_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed ivfs_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(ivfs_tc) null(0.199) reps(1000): mixed ivfs_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(ivfs_tc) null(0.305) reps(1000): mixed ivfs_tc i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed miso_ct_d_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(miso_ct_d_u) null(-0.019) reps(1000): mixed miso_ct_d_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(miso_ct_d_u) null(0.026) reps(1000): mixed miso_ct_d_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed erg_ct_d_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(erg_ct_d_u) null(0.000) reps(1000): mixed erg_ct_d_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(erg_ct_d_u) null(0.003) reps(1000): mixed miso_ct_d_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed ns_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(ns_ct_u) null(0.000) reps(1000): mixed ns_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(ns_ct_u) null(0.002) reps(1000): mixed ns_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed lap_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(lap_ct_u) null(-0.019) reps(1000): mixed lap_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(lap_ct_u) null(0.005) reps(1000): mixed lap_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed lap_h_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(lap_h_ct_u) null(-0.030) reps(1000): mixed lap_h_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(lap_h_ct_u) null(0.228) reps(1000): mixed lap_h_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed nasg_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(nasg_ct_u) null(-0.001) reps(1000): mixed nasg_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(nasg_ct_u) null(0.003) reps(1000): mixed nasg_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed bic_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(bic_ct_u) null(-0.012) reps(1000): mixed bic_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(bic_ct_u) null(0.004) reps(1000): mixed bic_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed ubt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(ubt_ct_u) null(-0.001) reps(1000): mixed ubt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(ubt_ct_u) null(0.002) reps(1000): mixed ubt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed bt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(bt_ct_u) null(-0.585) reps(1000): mixed bt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(bt_ct_u) null(0.439) reps(1000): mixed bt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed nicu_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(nicu_ct_u) null(-3.823) reps(1000): mixed nicu_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(nicu_ct_u) null(0.396) reps(1000): mixed nicu_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed icu_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(icu_ct_u) null(-0.106) reps(1000): mixed bt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(icu_ct_u) null(0.689) reps(1000): mixed bt_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

mixed trans_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(trans_ct_u) null(-0.001) reps(1000): mixed trans_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(trans_ct_u) null(0.047) reps(1000): mixed trans_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:

mixed spph_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(spph_ct_u) null(-0.035) reps(1000): mixed spph_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(spph_ct_u) null(0.018) reps(1000): mixed spph_ct_u i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:

*KE*
mixed tc_KE_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_KE_CL) null(-0.68) reps(1000): mixed tc_KE_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_KE_CL) null(2.75) reps(1000): mixed tc_KE_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

mixed tc_KE_CL_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"
*margins for BIA inputs*
mixed tc_KE_CL_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_KE_CL_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_KE_CL_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

*NI*
mixed tc_NI_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_NI_CL) null(-1.99) reps(1000): mixed tc_NI_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_NI_CL) null(3.24) reps(1000): mixed tc_NI_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

mixed tc_NI_CL_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_NI_CL_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_NI_CL_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_NI_CL_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

*SA*
mixed tc_SA_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_SA_CL) null(-23.41) reps(1000): mixed tc_SA_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: ||
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_SA_CL) null(12.88) reps(1000): mixed tc_SA_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: ||

mixed tc_SA_CL_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_SA_CL_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_SA_CL_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_SA_CL_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

*TZ*
mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-0.01) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(2.58) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || 

mixed tc_TZ_CL_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_TZ_CL_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_TZ_CL_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

mixed tc_TZ_CL_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"
*DSAs*
mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc_TZ_CL) null(-1.99) reps(1000): mixed tc_TZ_CL i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)

*DSAs*
*table A5*
*drape cost 1 USD*  // to test various plausible drape costs
mixed tc_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.61) reps(1000): mixed tc_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.48) reps(1000): mixed tc_1 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:
 
*drape cost 0.75 USD*  // to test various plausible drape costs
mixed tc_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.91) reps(1000): mixed tc_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.18) reps(1000): mixed tc_2 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*drape cost 0.50 USD*  // to test various plausible drape costs
mixed tc_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-3.22) reps(1000): mixed tc_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(1.87) reps(1000): mixed tc_3 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*drape cost 0.25 USD*  // to test various plausible drape costs
mixed tc_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-3.52) reps(1000): mixed tc_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(1.56) reps(1000): mixed tc_4 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*costs assigned to uterine massage and examination* // to test importance of assumption
mixed tc_11 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.24) reps(1000): mixed tc_11 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.84) reps(1000): mixed tc_11 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*bt 3 units* // to test importance of assumption
mixed tc_8 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.52) reps(1000): mixed tc_8 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.84) reps(1000): mixed tc_8 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*table A6*
*bt 1 unit* // to test importance of assumption
mixed tc_7 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.50) reps(1000): mixed tc_7 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.74) reps(1000): mixed tc_7 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*bimanual compression 45m* // to test importance of assumption
mixed tc_6 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.31) reps(1000): mixed tc_6 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.78) reps(1000): mixed tc_6 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*bimanual compression 15m* // to test importance of assumption
mixed tc_5 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.31) reps(1000): mixed tc_5 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.78) reps(1000): mixed tc_5 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: 

*5 minutes attending dr time spph* // to test importance of assumption. 
mixed tc_10 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.32) reps(1000): mixed tc_10 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.80) reps(1000): mixed tc_10 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:  

*laparotomy cost 0.5xhysterectomy* // to test importance of assumption
mixed tc_9 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: || , vce(robust)
margins exposed, post vce(unconditional)
nlcom _b[1.exposed]-_b[0.exposed], post
local b  = (r(b)[1,1])
local lb = (r(b)[1,1] - ((invnorm(0.975))*sqrt(r(V)[1,1])))
local ub = (r(b)[1,1] + ((invnorm(0.975))*sqrt(r(V)[1,1])))
display %4.3f  `b' " (" `lb' ", " `ub' ")"

swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(-2.31) reps(1000): mixed tc_9 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime: //swpermute is iterative. null(X) are CIs constructed by finding the upper and lower boundaries of the intervention effect that would lead to a two-sided P value less than the 5% level (1000 replications). 
swpermute _b[1.exposed], cluster(cluster) period(time_period) intervention(exposed) outcome(tc) null(2.79) reps(1000): mixed tc_9 i.exposed i.minim_cluster_size i.minim_oxytocin i.minim_primary_outcome i.time_period i.country || cluster: || clustime:

********************************************************************************************************************
*sensitivity analysis with multiple imputation*
use Full_Sample.dta, clear
drop if cluster==.
replace severe_pph = -9999 if severe_pph ==.
replace pph = -9999 if pph ==.
replace yll = -9999 if yll_gbd ==.
replace po_age = -9999 if po_age ==.
replace parity = -9999 if parity ==.
replace multiple_preg = -9999 if multiple_preg ==.
replace mode = -9999 if mode ==.
replace po_baby1_weight = -9999 if po_baby1_weight ==.
replace po_csection = -9999 if po_csection ==.
replace po_ga = -9999 if po_ga ==.
replace po_aph = -9999 if po_aph ==.
replace po_placenta  = -9999 if po_placenta  ==.
replace po_drape_weight  = -9999 if po_drape_weight  ==.
replace tc_nospph = -9999 if total_cost_nospph  ==.

export delimited cluster severe_pph pph yll exposed time_period country minim_cluster_size minim_oxytocin minim_primary_outcome po_age parity multiple_preg mode po_baby1_weight po_csection po_ga po_aph po_placenta po_drape_weight tc_nospph using Dataset for MI.csv, nolabel replace

*use fully conditional specification in BLIMP 3 to allow cluster random effect to be included*
// https://www.appliedmissingdata.com/blimp
// https://stefvanbuuren.name/fimd/sec-FCS.html

clear all
import delimited MI Imps.csv, encoding(ISO-8859-2) numericcols(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22)
ren imp dataset
ren severe_pp severe_pph
ren time_peri time_period 
ren minim_clu minim_cluster_size 
ren minim_oxy minim_oxytocin 
ren minim_pri minim_primary_outcome 
ren multiple_ multiple_preg 
ren po_baby1_ po_baby1_weight 
ren po_csecti po_csection 
ren po_placen po_placenta

merge m:m cluster using Treatment_Arm.dta

by dataset, sort: gen patient_id = _n
egen clustime = group(cluster time_period)	

foreach x of varlist dataset cluster severe_pph pph yll total_cost_nospph exposed time_period country minim_cluster_size minim_oxytocin minim_primary_outcome po_age parity multiple_preg mode po_baby1_weight po_csection po_ga po_aph po_placenta po_drape_ arm _merge patient_id clustime  {
replace `x' = . if `x'==-9999
}
gen missing = . 
replace missing = 1 if severe_pph ==. 
by patient_id, sort : egen float temp = max(missing)

*definining disability weights*
gen dweight_pph = 0.114 
gen dweight_spph = 0.324 
gen dweight = 0
replace dweight = dweight_pph if pph == 1 & severe_pph == 0 & yll_gbd == 0
replace dweight = dweight_spph if severe_pph == 1 & yll_gbd == 0
gen ddur = 6/52
gen yld = dweight*ddur 
gen yld_pph_new = dweight * ddur if pph == 1 & severe_pph == 0
gen yld_spph_new = dweight * ddur if severe_pph == 1
egen yld_new = rowtotal(yld_pph_new yld_spph_new)
sum yld_new yld 
egen daly = rowtotal(yll yld)

*inc. severe pph cost*
gen spph_ct = 1.541 if country == 1
replace spph_ct = 0.787 if country == 2
replace spph_ct = 4.270 if country == 4
replace spph_ct = 0.720 if country == 5
gen spph_ct_u = spph_ct * severe_pph
egen tc= rowtotal(tc_nospph spph_ct_u)

by dataset, sort : tabulate severe_pph exposed if temp ==1 , col miss
tempname effect_measures
tempfile te_results
postfile `effect_measures' prop trt_rr se_rr trt_rd se_rd trt_dd se_dd trt_cd se_cd using te_results, replace

forvalues i = 1/7{

tabulate severe_pph exposed if temp ==1 & dataset ==`i' , matcell(A)

local temp1 = A[1,2]
local temp2 = A[2,2]
local temp3 = `temp1'+`temp2'

scalar prop = `temp2'/`temp3'

melogit severe_pph i.exposed i.time_period i.country i.minim_cluster_size i.minim_primary_outcome i.minim_oxytocin if dataset==`i' || cluster: || clustime: ,or  vce(robust) // SE robust to types of model misspecifcation 
margins exposed, post vce(unconditional)
 nlcom (rr: ln(_b[1.exposed])-ln(_b[0.exposed]))(rd: _b[1.exposed]-_b[0.exposed]) , post 
 
return list
matrix list r(b)
matrix list r(V)
mat a = r(b)
mat var = r(V)

scalar trt_rr = (a[1,1])
scalar se_rr = sqrt(var[1,1])

scalar trt_rd = (a[1,2])
scalar se_rd = sqrt(var[2,2])

mixed daly i.exposed i.time_period i.country i.minim_cluster_size i.minim_primary_outcome i.minim_oxytocin if dataset==`i' || cluster: || clustime: , vce(robust)
margins exposed, post 
 nlcom (dd: _b[1.exposed]-_b[0.exposed]) , post 
 
return list
matrix list r(b)
matrix list r(V)
mat a = r(b)
mat var = r(V)

scalar trt_dd = (a[1,1])
scalar se_dd = sqrt(var[1,1])

 mixed tc i.exposed i.time_period i.country i.minim_cluster_size i.minim_primary_outcome i.minim_oxytocin if dataset==`i'    || cluster:  || clustime: ,  vce(robust)
margins exposed, post 
 nlcom (cd: _b[1.exposed]-_b[0.exposed]) , post 
 
return list
matrix list r(b)
matrix list r(V)
mat a = r(b)
mat var = r(V)

scalar trt_cd = (a[1,1])
scalar se_cd = sqrt(var[1,1])

post `effect_measures' (prop) (trt_rr) (se_rr) (trt_rd) (se_rd) (trt_dd) (se_dd) (trt_cd) (se_cd)
}
postclose `effect_measures'
use te_results, clear
describe

*Using Rubin's Rules to combine the MI datasets to find the 95% CI
*Set number of imputations (m)
scalar m=7 

*Within imputation variance = U
gen within_imp_var =(se_rd^2)/m /*m=2: U=SE^2/m per imputation*/
sum within_imp_var
scalar U_bar=r(sum) 
di U_bar

*Between imputation variance = B
sum trt_rd 
scalar rd_m=r(mean)
gen between_imp_var=((trt_rd-rd_m)^2)/(m-1) /*m=2: B=((RD-mean of RD)^2)/m-1*/
sum between_imp_var
scalar B_bar=r(sum) 
di B_bar

*Total imputation variance = T
scalar total_imp_var = U_bar + B_bar +(B_bar/m)
di total_imp_var /*Total variance*/

*Creating confidence intervals
scalar L_CI=rd_m-(1.96*(sqrt(total_imp_var)))
scalar U_CI=rd_m+(1.96*(sqrt(total_imp_var)))

*Within imputation variance = U
gen within_imp_var2 =(se_rr^2)/m /*m=2: U=SE^2/m per imputation*/
sum within_imp_var2
scalar U_bar=r(sum) 
di U_bar

*Between imputation variance = B
sum trt_rr 
scalar ln_rr_m=r(mean)
scalar rr_m = exp(ln_rr_m)
gen between_imp_var2=((trt_rr-ln_rr_m)^2)/(m-1) /*m=2: B=((RR-mean of RR)^2)/m-1*/
sum between_imp_var2
scalar B_bar=r(sum)
di B_bar

*total imputation variance = T
scalar total_imp_var = U_bar + B_bar +(B_bar/m)
di total_imp_var /*total variance*/

*creating confidence intervals
scalar SL_CI=exp(ln_rr_m-(1.96*(sqrt(total_imp_var))))
scalar SU_CI=exp(ln_rr_m+(1.96*(sqrt(total_imp_var))))

*within imputation variance = U
gen within_imp_var3 =(se_dd^2)/m /*m=2: U=SE^2/m per imputation*/
sum within_imp_var3
scalar U_bar=r(sum) 
di U_bar

*between imputation variance = B
sum trt_dd 
scalar dd_m=r(mean)
gen between_imp_var3=((trt_dd-dd_m)^2)/(m-1) /*m=2: B=((DD-mean of DD)^2)/m-1*/
sum between_imp_var3
scalar B_bar=r(sum) 
di B_bar

*total imputation variance = T
scalar total_imp_var = U_bar + B_bar +(B_bar/m)
di total_imp_var /*Total variance*/

*Cis*
scalar L_CId=dd_m-(1.96*(sqrt(total_imp_var)))
scalar U_CId=dd_m+(1.96*(sqrt(total_imp_var)))

*within imputation variance = U*
gen within_imp_var4 =(se_cd^2)/m /*m=2: U=SE^2/m per imputation*/
sum within_imp_var4
scalar U_bar=r(sum) 
di U_bar

*between imputation variance = B
sum trt_cd 
scalar cd_m=r(mean)
gen between_imp_var4=((trt_cd-cd_m)^2)/(m-1) /*m=2: B=((CD-mean of CD)^2)/m-1*/
sum between_imp_var4
scalar B_bar=r(sum)
di B_bar

*total imputation variance = T
scalar total_imp_var = U_bar + B_bar +(B_bar/m)
di total_imp_var /*total variance*/

*CIs*
scalar L_CIc=cd_m-(1.96*(sqrt(total_imp_var)))
scalar U_CIc=cd_m+(1.96*(sqrt(total_imp_var)))

*table A7*
noi di as txt "Pooled DALY Difference = " as res dd_m
noi di as txt "Lower 95% Confidence interval = " as res L_CId
noi di as txt "Upper 95% Confidence interval = " as res U_CId
noi di as txt "Pooled DALY Difference (95% CI) = " %-8.7fc as res dd_m " (" %-8.7fc L_CId " to " %-8.7fc U_CId ")"
noi di as txt "Pooled DALY Difference (95% CI) = " %-4.3fc as res dd_m " (" %-4.3fc L_CId " to " %-4.3fc U_CId ")"
noi di as txt "Pooled Cost Difference = " as res cd_m
noi di as txt "Lower 95% Confidence interval = " as res L_CIc
noi di as txt "Upper 95% Confidence interval = " as res U_CIc
noi di as txt "Pooled Cost Difference (95% CI) = " %-8.7fc as res cd_m " (" %-8.7fc L_CIc " to " %-8.7fc U_CIc ")"
noi di as txt "Pooled Cost Difference (95% CI) = " %-4.3fc as res cd_m " (" %-4.3fc L_CIc " to " %-4.3fc U_CIc ")"

********************************************************************************************************************

