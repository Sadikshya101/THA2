**clear all
set more off
use "/Users/sadikshyanepal/Desktop/THA/Final Paper /CMS Data- FULL Variable.dta"
keep MIG* A1_* A2_* A2A1_* A3_* A4_* A9_* B11_* B11A_* B11B_* B11C_* B12_* B12A_* B12B_* B12C_* B13_* B13A_* B13B_* B13C_* B14_* B14A_* B14B_* B14C_* B17_1_* B17_1A_* B17_1B_* REM* HHID ETHNICITY
reshape long MIG A1_ A2_ A2A1_ A3_ A4_ A9_ B11_ B11A_ B11B_ B11C_ B12_ B12A_ B12B_ B12C_ B13_ B13A_ B13B_ B13C_ B14_ B14A_ B14B_ B14C_ B17_1_ B17_1A_ B17_1B_ REM, i(HHID) j(year)
foreach x of varlist A* B* MIG REM {
recode `x' (999=.) 
recode `x' (998=.)
}
* We recoded 
recode B11_ (2=1)
recode B11_ (3=1)
recode B12_ (2=1)
recode B12_ (3=1)
recode B14_ (2=1)
recode B14_ (3=1)
replace A2_ = A2_/11.97295
replace A2A1_= A2A1_/11.97295
replace A3_ = A3_/11.97295
replace A4_ = A4_/11.97295
replace B11A_ = B11A_/11.97295
replace B12A = B12A/11.97295
replace B13A_= B13A_/11.97295
replace B14A_= B14A_/11.97295
replace B17_1A=B17_1A/11.97295
regress A1_ MIG if A1_==1| A1_==0
generate self_cult= A2_- A3_
generate wheat_prod= B13B_/B13A_
generate rice_prod= B11B_/B11A_
generate buck_prod= B17_1B/B17_1A
generate must_prod= B14B_/B14A_
gen logincome= log(REM)
collapse (sum) A2_ A2A1_ A3_ B11_ B11A_ B11B_ B11C_ B12_ B12A_ B12B_ B12C_ B13_ B13A_ B13B_ B13C_ B14_ B14A_ B14B_ B14C_ B17_1_ B17_1A_ B17_1B_ MIG REM, by(year)
generate total_production= B11B_+ B12B_+ B13B_+ B14B_+ B17_1B
generate propotion_prod=B11B_/total_production 
regress wheat_prod MIG 
estimates store m1, title(Model 1)
regress rice_prod MIG 
estimates store m2, title(Model 2)
regress B11B MIG
estimates store m3, title(Model 3)
estout m1 m2 m3
regress rice_prod MIG REM i.ETHNICITY
*regress on all variables rice, wheat, buckwheat
*then regress on individual variables to see if things change when produced individually
*do it as as Model 1, Model 2, and Model 3. 
*add animal production in the variable too
