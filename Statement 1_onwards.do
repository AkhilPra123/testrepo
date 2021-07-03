use "D:\Study\Project_NEW_2020\DTA FILES of DATA (STATA Format)\DTA_NSS_R67_2_34\Block-2-particulars of operation and background information of enterprises-records.dta"
tab Sector [iw= wgt_combined ]
gen NIC = substr( B2_q202 ,1,2)
destring NIC, replace
recode NIC (01/33=1  "Manufacturing") (45/47=2 "Trade") (48/96=3 "OthServices"), gen (NIC_cat)
replace NIC_cat=3 if NIC==37 | NIC==38 | NIC==39
tab NIC_cat [iw= wgt_combined]
tab NIC [iw= wgt_combined]
destring B2_q210, replace
destring Sector, replace
label define Sector 1"Rural" 2"Urban"
label values Sector Sector
label define B2_q210 1"OAE" 2"Estt"
label values B2_q210 B2_q210
table NIC_cat B2_q210 Sector [iw= wgt_combined ], row
table NIC_cat B2_q210 Sector [iw= wgt_combined ], col
table NIC_cat B2_q210 Sector [iw= wgt_combined ], row col
table NIC_cat B2_q210 [iw= wgt_combined ], row col
*Statement 1 completed
bysort Sector: tab NIC_cat B2_q210 [iw= wgt_combined ], col nof
tab NIC_cat B2_q210 [iw= wgt_combined ], col nof
*Statement 2 completed
destring State, replace
label define State 28"Andhra Pradesh" 12"Arunachal Pradesh" 18"Assam" 10"Bihar" 22"Chhattisgarh" 07"Delhi" 30"Goa" 24"Gujarat" 06"Haryana" 02"Himachal Pradesh" 01"Jammu & Kashmir" 20"Jharkhand" 29"Karnataka" 32"Kerala" 23"Madhya Pradesh" 27"Maharashtra" 14"Manipur" 17"Meghalaya" 15"Mizoram" 13"Nagaland" 21"Odisha" 03"Punjab" 08"Rajasthan" 11"Sikkim" 33"Tamilnadu" 16"Tripura" 09"Uttar Pradesh" 05"Uttarakhand" 19"West Bengal" 35"Andaman & Nikobar Island" 04"Chandigarh" 26"Dadra & Nagar Haveli" 25"Daman & Diu" 31"Lakshadweep" 34"Puducherry"
label values State State
table State B2_q210 Sector [iw= wgt_combined ], row col
table State B2_q210 [iw= wgt_combined ], row col
*Statement 3 completed
bysort Sector: tab State B2_q210 [iw= wgt_combined ], col nof
tab State B2_q210 [iw= wgt_combined ], col nof
*Statement 4 completed
save "D:\Study\Project_NEW_2020\DTA FILES of DATA (STATA Format)\Append\67th round\Statement 1_onwards.dta"
clear
use "D:\Study\Project_NEW_2020\DTA FILES of DATA (STATA Format)\DTA_NSS_R67_2_34\Block-6 and7 -other receipts-gross value added-records.dta"
destring State Sector B6_7_c3 B6_7_c2 B6_7_sign, replace
label value Sector Sector
keep if B6_7_c2 == 709
merge 1:1 Key_entpr using "D:\Study\Project_NEW_2020\DTA FILES of DATA (STATA Format)\Append\67th round\Statement 1_onwards.dta"
gen GVA = B6_7_c3*12 if B2_q212 == "1"
destring B2_q212 B2_q213, replace
replace GVA = B6_7_c3*B2_q213 if B2_q212== 2
replace GVA = B6_7_c3*B2_q213 if B2_q212== 3
gen GVA_s = GVA/10000000
replace GVA_s = GVA_s*-1 if B6_7_sign == 1
total GVA_s [iw= wgt_combined ], over ( NIC_cat Sector B2_q210 )
