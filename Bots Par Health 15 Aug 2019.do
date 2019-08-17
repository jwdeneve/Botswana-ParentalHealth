************************************************************************
* Children's education and parental health: evidence from Botswana.
* Date: 15 Aug 2019
************************************************************************

************************************************************************
* Preparing IPUMS
************************************************************************

use "D:\PAR HLTH\botswana\raw data\IPUMS census 2001 and 2011.dta", clear
drop perwt hhwt

* Year of birth

gen yob = year - age if age <= 100

************************************************************************
* CLEANING AND STUDY CRITERIA
************************************************************************

* Overall population

drop if sex == .
drop if age == . | age == 999 | age > 100
drop if citizen == .
drop if yrschool == . | (yrschool >= 90 & yrschool <=99)

* Study criteria

drop if citizen == 4 /*no Botswana citizens*/
drop if bplbw == 98 | bplbw == 99 /*not born in Botswana or unknown*/

************************************************************************
* ADDITIONAL VARIABLES
************************************************************************

* Female

gen fem = 1 if sex == 2
replace fem = 0 if sex == 1

* Educational attainment

rename yrschool educyrs

gen noedu = 1 if educyrs == 0
replace noedu = 0 if educyrs > 0 & educyrs != .

gen atleast7 = 1 if educyrs >= 7 & educyrs < .
replace atleast7 = 0 if educyrs < 7
label var atleast7 "having completed at least 7 years of schooling"
label define atleast7 1 "yes", add
label define atleast7 0 "no", add

gen atleast8 = 1 if educyrs >= 8 & educyrs < .
replace atleast8 = 0 if educyrs < 8
label var atleast8 "having completed at least 8 years of schooling"
label define atleast8 1 "yes", add
label define atleast8 0 "no", add

gen atleast9 = 1 if educyrs >= 9 & educyrs < .
replace atleast9 = 0 if educyrs < 9
label var atleast9 "having completed at least 9 years of schooling"
label define atleast9 1 "yes", add
label define atleast9 0 "no", add

gen atleast10 = 1 if educyrs >= 10 & educyrs < .
replace atleast10 = 0 if educyrs < 10
label var atleast10 "having completed at least 10 years of schooling"
label define atleast10 1 "yes", add
label define atleast10 0 "no", add

gen atleast11 = 1 if educyrs >= 11 & educyrs < .
replace atleast11 = 0 if educyrs < 11
label var atleast11 "having completed at least 11 years of schooling"
label define atleast11 1 "yes", add
label define atleast11 0 "no", add

gen atleast12 = 1 if educyrs >= 12 & educyrs < .
replace atleast12 = 0 if educyrs < 12
label var atleast12 "having completed at least 12 years of schooling"
label define atleast12 1 "yes", add
label define atleast12 0 "no", add

gen atleast13 = 1 if educyrs >= 13 & educyrs < .
replace atleast13 = 0 if educyrs < 13
label var atleast13 "having completed at least 13 years of schooling"
label define atleast13 1 "yes", add
label define atleast13 0 "no", add

gen educyrsg3 = 1 if educyrs <=7 & educyrs != 0						
replace educyrsg3 = 2 if educyrs >7 & educyrs <= 9
replace educyrsg3 = 3 if educyrs == 10
replace educyrsg3 = 4 if educyrs >= 11 & educyrs < 13
replace educyrsg3 = 5 if educyrs >= 13 & educyrs != .
replace educyrsg3 = 0 if educyrs == 0
label var educyrsg3 "DV depending on specific levels of Educational Attainment"
label define educyrsg3nl 0 "0", add
label define educyrsg3nl 1 "1-7", add
label define educyrsg3nl 2 "8-9", add
label define educyrsg3nl 3 "10", add
label define educyrsg3nl 4 "11-13", add
label define educyrsg3nl 5 "13+", add
label values educyrsg3 educyrs3gnl

* Parental survival

gen malive = 0 if mortmot == 2
replace malive = 1 if mortmot == 1		
label var malive "Mother Alive"
label define malive 1 "yes", add
label define malive 0 "no", add

gen falive = 0 if mortfat == 2
replace falive = 1 if mortfat == 1		
label var falive "Father Alive"
label define falive 1 "yes", add
label define falive 0 "no", add

* Co-residence with biological parents

gen withany = 0 if momloc == 0 | poploc == 0
replace withany = 1 if (momloc > 0 & momloc < 50 & malive == 1) | (poploc > 0 & poploc < 50 & falive == 1)

* Labor force participation

gen lfp = 1 if labforce == 2
replace lfp = 0 if labforce == 1

* Age2, Age3, Age4, Agegrp

gen age2 = age^2
gen age3 = age^3
gen age4 = age^4
egen agegrp = cut(age), at(1(3)60)

* District of birth

rename bplbw birthdistr

* Instrument

gen instr2 = yob > 1980

* Disability

gen dismom = 1 if disabled_mom == 1
replace dismom = 0 if disabled_mom == 2

gen dispop = 1 if disabled_pop == 1
replace dispop = 0 if disabled_pop == 2

gen disany = 0 if dismom < . | dispop < .
replace disany = 1 if dismom == 1 | dispop == 1

* Employment

gen disempmom = 1 if disemp_mom == 1
replace disempmom = 0 if disemp_mom == 2

gen disemppop = 1 if disemp_pop == 1
replace disemppop = 0 if disemp_pop == 2

gen disempany = 0 if disempmom < . | disemppop < .
replace disempany = 1 if disempmom == 1 | disemppop == 1

* Blind

gen disblnmom = 1 if disblnd_mom == 1
replace disblnmom = 0 if disblnd_mom == 2

gen disblnpop = 1 if disblnd_pop == 1
replace disblnpop = 0 if disblnd_pop == 2

gen disblnany = 0 if disblnmom < . | disblnpop < .
replace disblnany = 1 if disblnmom == 1 | disblnpop == 1

* Lower extremity

gen dislomom = 1 if dislowr_mom == 1
replace dislomom = 0 if dislowr_mom == 2

gen dislopop = 1 if dislowr_pop == 1
replace dislopop = 0 if dislowr_pop == 2

gen disloany = 0 if dislomom < . | dislopop < .
replace disloany = 1 if dislomom == 1 | dislopop == 1

* Upper extremity

gen disupmom = 1 if disuppr_mom == 1
replace disupmom = 0 if disuppr_mom == 2

gen disuppop = 1 if disuppr_pop == 1
replace disuppop = 0 if disuppr_pop == 2

gen disupany = 0 if disupmom < . | disuppop < .
replace disupany = 1 if disupmom == 1 | disuppop == 1

* Deaf

gen disdeafmom = 1 if disdeaf_mom == 1
replace disdeafmom = 0 if disdeaf_mom == 2

gen disdeafpop = 1 if disdeaf_pop == 1
replace disdeafpop = 0 if disdeaf_pop == 2

gen disdeafany = 0 if disdeafmom < . | disdeafpop < .
replace disdeafany = 1 if disdeafmom == 1 | disdeafpop == 1

* Parental age and schooling

gen momage = age_mom if age_mom <= 94
gen popage = age_pop if age_pop <= 94
gen parage = (momage + popage)/2
egen momagegrp = cut(momage), at(10(10)101)
egen popagegrp = cut(popage), at(10(10)101)
egen paragegrp = cut(parage), at(10(10)101)

gen momedu = yrschool_mom if yrschool_mom <= 18
gen popedu = yrschool_pop if yrschool_pop <= 18

* Other

gen rem = 1 if remitt == 1
replace rem = 0 if remitt == 0

gen christian = 0 if religion >= 1 & religion <= 9
replace christian = 1 if religion == 6

gen norelig = 0 if religion >= 1 & religion <= 9
replace norelig = 1 if religion == 1

gen married = 0 if marst >= 1 & marst <= 4
replace married = 1 if marst == 2

gen elec = 1 if electric == 1
replace elec = 0 if electric == 2

gen water = 1 if watsup == 11 // piped water inside dwelling
replace water = 0 if watsup >= 13 & watsup <= 20

gen cellphone = 1 if cell == 1
replace cellphone = 0 if cell == 2

gen telephone = 1 if phone == 2
replace telephone = 0 if phone == 1

gen number = famsize if famsize < 99

gen nchildren = chborn if chborn <= 12

save bots_fullsample.dta, replace

drop if age < 16
drop if yob < 1971
keep if withany == 1

save bots.dta, replace

************************************************************************
* FIGURES
************************************************************************

* Educational attainment by birth cohort

use bots_fullsample.dta, clear
keep if age >= 18 & year == 2011
collapse atleast7 atleast8 atleast9 atleast10 atleast11 atleast12, by (yob)
keep if yob >= 1972 & yob <= 1990
twoway (area atleast7 yob) (area atleast8 yob) (area atleast9 yob) (area atleast10 yob) (area atleast11 yob) ///
(area atleast12 yob), legend(order(1 "Pr(Educ {&ge} 7)" 2 "Pr(Educ {&ge} 8)" /// 
3 "Pr(Educ {&ge} 9)" 4 "Pr(Educ {&ge} 10)" 5 "Pr(Educ {&ge} 11)" 6 "Pr(Educ {&ge} 12)")) 

* Parental survival by children's education

use bots_fullsample.dta, clear
keep if year == 2011
keep if age >= 22
egen educyrscat = cut(educyrs), at(0, 1, 8, 10, 11, 13, 25)

replace educyrscat = 0 if educyrscat == 0
replace educyrscat = 1 if educyrscat == 1
replace educyrscat = 2 if educyrscat == 8
replace educyrscat = 3 if educyrscat == 10
replace educyrscat = 4 if educyrscat == 11
replace educyrscat = 5 if educyrscat == 13

collapse (mean) meanmotheralive=malive meanfatheralive=falive (sd) sdfatheralive=falive sdmotheralive=malive /// 
(count) nfat=falive nmot=malive /*[w=perwt]*/ , by(educyrscat)
generate himotheralive = meanmotheralive + invttail(nmot-1,0.025)*(sdmotheralive / sqrt(nmot))
generate lomotheralive = meanmotheralive - invttail(nmot-1,0.025)*(sdmotheralive / sqrt(nmot))
generate hifatheralive = meanfatheralive + invttail(nfat-1,0.025)*(sdfatheralive / sqrt(nfat))
generate lofatheralive = meanfatheralive - invttail(nfat-1,0.025)*(sdfatheralive / sqrt(nfat))

twoway (bar meanmotheralive educyrscat, barwidth(0.5)) (rcap himotheralive lomotheralive educyrscat) /// 
(bar meanfatheralive educyrscat, barwidth(0.5)) (rcap hifatheralive lofatheralive educyrscat), /// 
xlabel( 0 "0" 1 "1-7" 2 "8-9" 3 "10" 4 "11-12" 5 "13+", noticks) ylabel (0(0.2)1) /// 
legend(order(1 "Mother" 3 "Father")) xtitle("{bf}Schooling (years)") ytitle("{bf}Parent alive %)")

save graphsurvoveredu.dta, replace

* Parental disability by children's education

use bots.dta, clear
keep if year == 2011
keep if age >= 22
egen educyrscat = cut(educyrs), at(0, 1, 8, 10, 11, 13, 25)
keep if disany != .

replace educyrscat = 0 if educyrscat == 0
replace educyrscat = 1 if educyrscat == 1
replace educyrscat = 2 if educyrscat == 8
replace educyrscat = 3 if educyrscat == 10
replace educyrscat = 4 if educyrscat == 11
replace educyrscat = 5 if educyrscat == 13

collapse (mean) meandisany=disany (sd) sddisany=disany /// 
(count) ndisany=disany, by(educyrscat)
generate hidisany = meandisany + invttail(ndisany-1,0.025)*(sddisany / sqrt(ndisany))
generate lodisany = meandisany - invttail(ndisany-1,0.025)*(sddisany / sqrt(ndisany))

save graphdisoveredu.dta, replace
//append with survival

append using graphsurvoveredu.dta
twoway (bar meanmotheralive educyrscat, barwidth(0.5)) (rcap himotheralive lomotheralive educyrscat) /// 
(bar meanfatheralive educyrscat, barwidth(0.5)) (rcap hifatheralive lofatheralive educyrscat) ///
(connected meandisany educyrscat, msize(tiny) color(black) yaxis(2) yticks(0(0.2)1, axis(2)) color(black) /// 
ylabel(0(0.2)1, axis(2)) ytitle("{bf}Any parent disabled (%)", axis(2))) ///
(rcap hidisany lodisany educyrs, yaxis(2) color(black)), /// 
xlabel( 0 "0" 1 "1-7" 2 "8-9" 3 "10" 4 "11-12" 5 "13+", noticks) ylabel(0(0.2)1) /// 
legend(order(1 "Mother" 3 "Father" 5 "Pooled")) xtitle("{bf}Schooling (years)") ytitle("{bf}Parent alive (%)")

* Parental survival, disability and coresidence by children's birth cohort

use bots_fullsample.dta, clear
keep if age >= 16
keep if yob >= 1971 & yob <= 1991
keep if year == 2011

collapse (mean) meanmotheralive=malive meanfatheralive=falive meanwithany=withany, by(yob)
save survbybirth.dta, replace

use bots_fullsample.dta, clear
keep if age >= 16
keep if yob >= 1971 & yob <= 1991
keep if year == 2011
keep if disany != .

collapse (mean) meandisany = disany, by(yob)
append using survbybirth.dta

twoway (connected meanmotheralive yob, msize(medsmall) lpattern(dash)) /// 
(connected meanfatheralive yob, msize(medsmall) lpattern(dash)) /// 
(connected meandisany yob, msize(medsmall) lpattern(dash)) /// 
(connected meanwithany yob, msize(medsmall) lpattern(dash)), ///
yscale(range(0 1)) legend(order(1 "Mother alive" 2 "Father alive" 3 "Parental disability" 4 "Coresidence")) /// 
ylabel(0(.2)1) xtitle("Year of birth") ytitle("{bf}Proportion (%)") xline(1981, lc(cranberry))

* age heaping and birth cohort size

use bots_fullsample.dta, replace
keep if disany != .
keep if age >= 15 & age <= 40
keep if year == 2011

gen heap = 1 if age == 15 | age == 20 | age == 25 | age == 30 | age == 35 | age == 40 | age == 45 | age == 50 | age == 55 | age == 60 /// 
| age == 65 | age == 70 | age == 75 | age == 80 | age == 85 | age == 90 | age == 95| age == 100
replace heap = 0 if age != 15 & age != 20 & age != 25 & age != 30 & age != 35 & age != 40 & age != 45 & age != 50 & age != 55 & age /// 
!= 60 & age != 65 & age != 70 & age != 75 & age != 80 & age != 85 & age != 90 & age != 95 & age != 100

twoway hist age if heap == 0, discrete frequency width(1) start(15) color(blue) lcolor(black) xtitle("{bf}Age") ///
|| hist age if heap == 1, discrete frequency width(1) start(15) color(red) lcolor(black) xtitle("{bf}Age") ///
legend(order(2 `"Heap Years"')) 

* Diff-in-diff

use bots.dta, clear
keep if yob == 1975 /*pre-reform*/
gen edu9 = 0
keep if year == 2011
replace edu9 = 1 if educyrs == 9
collapse edu9, by (birthdistr)
su edu9, detail
gen district_h = 0
replace district_h = 1 if edu9 >= .3076923 /*includes 13 districts each*/
tab district_h
merge 1:m birthdistr using bots.dta
keep if year == 2011
gen atleast10d_h = atleast10 if district_h == 1
gen atleast10d_l = atleast10 if district_h == 0
collapse atleast10d_h atleast10d_l, by(yob)
keep if yob >= 1976 & yob <= 1986
twoway (sc atleast10d_h atleast10d_l yob, connect (1 2) xtitle("{bf}Year of birth") /// 
ytitle("{bf}At least ten years of schooling (%)") xline(1981, lc(cranberry)))

****************************************************************************
* ANALYSES 
****************************************************************************

* First stage

use bots.dta, clear

reg educyrs instr2 c.age##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

reg educyrs instr2 c.age##i.sex c.age2##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

reg educyrs instr2 i.agegrp##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m4

reg educyrs instr2 i.agegrp##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5

reg educyrs instr2 age i.year i.birthdistr if fem == 1, r
est sto m6

reg educyrs instr2 age age2 i.year i.birthdistr if fem == 1, r
est sto m7

reg educyrs instr2 age age2 age3 age4 i.year i.birthdistr if fem == 1, r
est sto m8

reg educyrs instr2 i.agegrp i.year i.birthdistr if fem == 1, r
est sto m9

reg educyrs instr2 i.agegrp yob i.year i.birthdistr if fem == 1, r
est sto m10

reg educyrs instr2 age i.year i.birthdistr if fem == 0, r
est sto m11

reg educyrs instr2 age age2 i.year i.birthdistr if fem == 0, r
est sto m12

reg educyrs instr2 age age2 age3 age4 i.year i.birthdistr if fem == 0, r
est sto m13

reg educyrs instr2 i.agegrp i.year i.birthdistr if fem == 0, r
est sto m14

reg educyrs instr2 i.agegrp yob i.year i.birthdistr if fem == 0, r
est sto m15

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15] using bots.xls, keep(instr2) dec(3) replace

* OLS and ITT

use bots.dta, clear

reg disany educyrs age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m1
margins if yob < 1981

reg disany educyrs age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m2
margins if yob < 1981

reg disany educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg disany atleast10 age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m4

reg disany atleast10 age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m5

reg disany atleast10 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6

reg disany instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m7

reg disany instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m8

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(3) replace

****************************************************************************
* OTHER ROBUSTNESS CHECKS FOR FIRST STAGE
****************************************************************************

* smaller smaple around cutoff

use bots.dta, clear
keep if yob >= 1976 & yob <= 1986
keep if age >= 16

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m1

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

outreg2 [m1 m2 m3] using bots.xls, keep(instr2) dec(3) replace

* using sample with 9+ educyrs

use bots.dta, clear
keep if educyrs >= 9

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m1

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

outreg2 [m1 m2 m3] using bots.xls, keep(instr2) dec(3) replace

* using larger sample

use bots_fullsample.dta, clear
keep if disany != .

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m1

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

outreg2 [m1 m2 m3] using bots.xls, keep(instr2) dec(3) replace

* educ gap

use bots.dta, clear

gen educyrs_mom = yrschool_mom if yrschool_mom < 18
replace educyrs_mom = 4 if yrschool_mom == 91 //"some primary"
replace educyrs_mom = 8 if yrschool_mom == 93 //"some secondary"
replace educyrs_mom = 13 if yrschool_mom == 94 //"some tertiary"
replace educyrs_mom = . if yrschool_mom > 94

gen educyrs_pop = yrschool_pop if yrschool_pop < 18
replace educyrs_pop = 4 if yrschool_pop == 91 //"some primary"
replace educyrs_pop = 8 if yrschool_pop == 93 //"some secondary"
replace educyrs_pop = 13 if yrschool_pop == 94 //"some tertiary"
replace educyrs_pop = . if yrschool_pop > 94

gen gap = educyrs - ((educyrs_pop + educyrs_mom) / 2) if educyrs_pop != . & educyrs_mom != .
replace gap = educyrs - educyrs_mom if educyrs_pop == . & educyrs_mom != .
replace gap = educyrs - educyrs_pop if educyrs_mom == . & educyrs_pop != .
replace gap = . if educyrs_pop == . & educyrs_mom == .

drop if missing(gap)
gen gap9 = 1 if gap >= 8.5 // 75% Percentile
replace gap9 = 0 if gap <= 8.5

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1 & gap9 == 1, r
est sto m1

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0 & gap9 == 1, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if gap9 == 1, r
est sto m3

outreg2 [m1 m2 m3] using bots.xls, keep(instr2) dec(3) replace

* heap year

use bots.dta, clear

gen heap = 1 if age == 20 | age == 25 | age == 30 | age == 35 | age == 40 | age == 45 | age == 50 | age == 55 | age == 60 | age == 65 | age == 70 | age == 75 | age == 80 | age == 85 | age == 90 | age == 95| age == 100
replace heap = 0 if age != 20 & age != 25 & age != 30 & age != 35 & age != 40 & age != 45 & age != 50 & age != 55 & age != 60 & age != 65 & age != 70 & age != 75 & age != 80 & age != 85 & age != 90 & age != 95 & age != 100

twoway hist age if heap == 0, discrete frequency width(1) start(16) xticks(20(5)50) color(blue) lcolor(black) xtitle("Age") ///
|| hist age if heap == 1, discrete frequency width(1) start(16) xticks(20(5)50) color(red) lcolor(black) xtitle("Age") ///
legend(order(2 `"Heap Years"')) by(year) 

drop if heap == 1

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1, r
est sto m1

reg educyrs instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

outreg2 [m1 m2 m3] using bots.xls, keep(instr2) dec(3) replace

****************************************************************************
* ROBUSTNESS FOR ITT
****************************************************************************

* using age

use bots.dta, clear

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

reg disany instr2 c.age##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2

reg disany instr2 c.age##i.sex c.age2##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

reg disany instr2 i.agegrp##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m4

reg disany instr2 i.agegrp##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5

outreg2 [m1 m2 m3 m4 m5] using bots.xls, keep(instr2) dec(3) replace

* smaller smaple around cutoff

use bots.dta, clear
keep if yob >= 1976 & yob <= 1986
keep if age >= 16

reg disany instr2 c.age##i.sex c.age4##i.sex c.age2##i.sex c.age3##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace

* using larger sample

use bots_fullsample.dta, clear
drop if disany == .

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##c.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace

* using sample with 9+ educyrs

use bots.dta, clear
keep if educyrs >= 9

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace

* gap between parental and children's education

use bots.dta, clear

gen educyrs_mom = yrschool_mom if yrschool_mom < 18
replace educyrs_mom = 4 if yrschool_mom == 91 //"some primary"
replace educyrs_mom = 8 if yrschool_mom == 93 //"some secondary"
replace educyrs_mom = 13 if yrschool_mom == 94 //"some tertiary"
replace educyrs_mom = . if yrschool_mom > 94

gen educyrs_pop = yrschool_pop if yrschool_pop < 18
replace educyrs_pop = 4 if yrschool_pop == 91 //"some primary"
replace educyrs_pop = 8 if yrschool_pop == 93 //"some secondary"
replace educyrs_pop = 13 if yrschool_pop == 94 //"some tertiary"
replace educyrs_pop = . if yrschool_pop > 94

gen gap = educyrs - ((educyrs_pop + educyrs_mom) / 2) if educyrs_pop != . & educyrs_mom != .
replace gap = educyrs - educyrs_mom if educyrs_pop == . & educyrs_mom != .
replace gap = educyrs - educyrs_pop if educyrs_mom == . & educyrs_pop != .
replace gap = . if educyrs_pop == . & educyrs_mom == .

drop if missing(gap)
gen gap9 = 1 if gap >= 8 // 75% Percentile
replace gap9 = 0 if gap <= 8

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if gap9 == 1, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace

* parental age group

use bots.dta, clear

reg disany educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 50 | popagegrp == 50, r
est sto m1
margins if yob < 1981

reg disany educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 60 | popagegrp == 60, r
est sto m2
margins if yob < 1981

reg disany educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 70 | popagegrp == 70, r
est sto m3
margins if yob < 1981

reg disany atleast10 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 50 | popagegrp == 50, r
est sto m4

reg disany atleast10 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 60 | popagegrp == 60, r
est sto m5

reg disany atleast10 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 70 | popagegrp == 70, r
est sto m6

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 50 | popagegrp == 50, r
est sto m7

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 60 | popagegrp == 60, r
est sto m8

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 70 | popagegrp == 70, r
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(instr2 educyrs atleast10) dec(3) replace

* heap year

use bots.dta, clear

gen heap = 1 if age == 20 | age == 25 | age == 30 | age == 35 | age == 40 | age == 45 | age == 50 | age == 55 | age == 60 | age == 65 | age == 70 | age == 75 | age == 80 | age == 85 | age == 90 | age == 95| age == 100
replace heap = 0 if age != 20 & age != 25 & age != 30 & age != 35 & age != 40 & age != 45 & age != 50 & age != 55 & age != 60 & age != 65 & age != 70 & age != 75 & age != 80 & age != 85 & age != 90 & age != 95 & age != 100
drop if heap == 1

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace
 
* excluding 1980 cohort

use bots.dta, clear

drop if yob == 1980

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace

* including social parents (eg, stepparents, adoption parents)

use bots_fullsample.dta, clear
drop if age < 16
drop if yob < 1971
drop if disany == .

reg disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(3) replace

* using difference-in-differences, exploiting differential impact of the reform by birth district 

use bots.dta, clear
keep if yob == 1975 /*pre-reform*/
gen edu9 = educyrs == 9
collapse edu9, by (birthdistr)
su edu9, detail
gen birthdistr_highedu9 = 0
replace birthdistr_highedu9 = 1 if edu9 >= .3076923 /*includes 13 districts each*/
merge 1:m birthdistr using bots.dta
keep if disany != .

reg disany i.instr2#i.birthdistr_highedu9 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.instr2##i.sex i.year##i.sex i.birthdistr_highedu9##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(i.instr2#i.birthdistr_highedu9) dec(3) replace

* logit

use bots.dta, clear

logit disany educyrs age age2 age3 age4 i.birthdistr i.year if fem == 1, r or
est sto m1
margins if yob < 1981

logit disany educyrs age age2 age3 age4 i.birthdistr i.year if fem == 0, r or
est sto m2
margins if yob < 1981

logit disany educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m3
margins if yob < 1981

logit disany atleast10 age age2 age3 age4 i.birthdistr i.year if fem == 1, r or
est sto m4

logit disany atleast10 age age2 age3 age4 i.birthdistr i.year if fem == 0, r or
est sto m5

logit disany atleast10 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m6

logit disany instr2 age age2 age3 age4 i.birthdistr i.year if fem == 1, r or
est sto m7

logit disany instr2 age age2 age3 age4 i.birthdistr i.year if fem == 0, r or
est sto m8

logit disany instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(3) append ctitle(Odds ratio) eform replace

****************************************************************************
* SUMMARY STATS
****************************************************************************

use bots.dta, clear

su malive if year == 2001 & yob < 1981 
su malive if year == 2011 & yob < 1981
su malive if year == 2001 & yob >= 1981
su malive if year == 2011 & yob >= 1981

su falive if year == 2001 & yob < 1981 
su falive if year == 2011 & yob < 1981
su falive if year == 2001 & yob >= 1981
su falive if year == 2011 & yob >= 1981

su disany if year == 2001 & yob < 1981 
su disany if year == 2011 & yob < 1981
su disany if year == 2001 & yob >= 1981
su disany if year == 2011 & yob >= 1981

su age if year == 2001 & yob < 1981 
su age if year == 2011 & yob < 1981
su age if year == 2001 & yob >= 1981
su age if year == 2011 & yob >= 1981

su educyrs if year == 2001 & yob < 1981 
su educyrs if year == 2011 & yob < 1981
su educyrs if year == 2001 & yob >= 1981
su educyrs if year == 2011 & yob >= 1981

su atleast10 if year == 2001 & yob < 1981 
su atleast10 if year == 2011 & yob < 1981
su atleast10 if year == 2001 & yob >= 1981
su atleast10 if year == 2011 & yob >= 1981

su lfp if year == 2001 & yob < 1981 
su lfp if year == 2011 & yob < 1981
su lfp if year == 2001 & yob >= 1981
su lfp if year == 2011 & yob >= 1981

su christian if year == 2001 & yob < 1981 
su christian if year == 2011 & yob < 1981
su christian if year == 2001 & yob >= 1981
su christian if year == 2011 & yob >= 1981

su norelig if year == 2001 & yob < 1981 
su norelig if year == 2011 & yob < 1981
su norelig if year == 2001 & yob >= 1981
su norelig if year == 2011 & yob >= 1981

su married if year == 2001 & yob < 1981 
su married if year == 2011 & yob < 1981
su married if year == 2001 & yob >= 1981
su married if year == 2011 & yob >= 1981

su momage if year == 2001 & yob < 1981 
su momage if year == 2011 & yob < 1981
su momage if year == 2001 & yob >= 1981
su momage if year == 2011 & yob >= 1981

su popage if year == 2001 & yob < 1981 
su popage if year == 2011 & yob < 1981
su popage if year == 2001 & yob >= 1981
su popage if year == 2011 & yob >= 1981

su momedu if year == 2001 & yob < 1981 
su momedu if year == 2011 & yob < 1981
su momedu if year == 2001 & yob >= 1981
su momedu if year == 2011 & yob >= 1981

su popedu if year == 2001 & yob < 1981 
su popedu if year == 2011 & yob < 1981
su popedu if year == 2001 & yob >= 1981
su popedu if year == 2011 & yob >= 1981

su number if year == 2001 & yob < 1981 
su number if year == 2011 & yob < 1981
su number if year == 2001 & yob >= 1981
su number if year == 2011 & yob >= 1981

su elec if year == 2001 & yob < 1981 
su elec if year == 2011 & yob < 1981
su elec if year == 2001 & yob >= 1981
su elec if year == 2011 & yob >= 1981

su water if year == 2001 & yob < 1981 
su water if year == 2011 & yob < 1981
su water if year == 2001 & yob >= 1981
su water if year == 2011 & yob >= 1981

su telephone if year == 2001 & yob < 1981 
su telephone if year == 2011 & yob < 1981
su telephone if year == 2001 & yob >= 1981
su telephone if year == 2011 & yob >= 1981

su cellphone if year == 2001 & yob < 1981 
su cellphone if year == 2011 & yob < 1981
su cellphone if year == 2001 & yob >= 1981
su cellphone if year == 2011 & yob >= 1981

su rem if year == 2001 & yob < 1981 
su rem if year == 2011 & yob < 1981
su rem if year == 2001 & yob >= 1981
su rem if year == 2011 & yob >= 1981

gen edudiff_m = educyrs - momedu if momedu < .
gen edudiff_p = educyrs - popedu if popedu < .

****************************************************************************
* SECONDARY HEALTH OUTCOMES
****************************************************************************

use bots.dta, clear

reg disempmom instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1
margins if yob < 1981

reg disblnmom instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2
margins if yob < 1981

reg dislomom instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg disemppop instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m4
margins if yob < 1981

reg disblnpop instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5
margins if yob < 1981

reg dislopop instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(educyrs instr2) dec(3) replace

****************************************************************************
* LABOR MARKET OUTCOMES
****************************************************************************

use bots.dta, clear

reg lfp educyrs age age2 age3 age4 i.year i.birthdistr if fem == 1, r
est sto m1
margins if yob < 1981

reg lfp educyrs age age2 age3 age4 i.year i.birthdistr if fem == 0, r
est sto m2
margins if yob < 1981

reg lfp educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg lfp instr2 age age2 age3 age4 i.year i.birthdistr if fem == 1, r
est sto m4
margins if yob < 1981

reg lfp instr2 age age2 age3 age4 i.year i.birthdistr if fem == 0, r
est sto m5
margins if yob < 1981

reg lfp instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

ivregress 2sls lfp age age2 age3 age4 i.year i.birthdistr (educyrs = instr2) if fem == 1, r
est sto m7
estat firststage

ivregress 2sls lfp age age2 age3 age4 i.year i.birthdistr (educyrs = instr2) if fem == 0, r
est sto m8
estat firststage

ivregress 2sls lfp c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m9
estat firststage

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(educyrs lfp instr2) stats(coef, ci) dec(3) replace

****************************************************************************
* FIRST STAGE IN FULL SAMPLE
****************************************************************************

use bots_fullsample.dta, clear

drop if age < 16
drop if yob < 1971

reg educyrs instr2 c.age##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

reg educyrs instr2 c.age##i.sex c.age2##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2

reg educyrs instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

reg educyrs instr2 i.agegrp##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m4

reg educyrs instr2 i.agegrp##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5

reg educyrs instr2 age i.year i.birthdistr if fem == 1, r
est sto m6

reg educyrs instr2 age age2 i.year i.birthdistr if fem == 1, r
est sto m7

reg educyrs instr2 age age2 age3 age4 i.year i.birthdistr if fem == 1, r
est sto m8

reg educyrs instr2 i.agegrp i.year i.birthdistr if fem == 1, r
est sto m9

reg educyrs instr2 i.agegrp yob i.year i.birthdistr if fem == 1, r
est sto m10

reg educyrs instr2 age i.year i.birthdistr if fem == 0, r
est sto m11

reg educyrs instr2 age age2 i.year i.birthdistr if fem == 0, r
est sto m12

reg educyrs instr2 age age2 age3 age4 i.year i.birthdistr if fem == 0, r
est sto m13

reg educyrs instr2 i.agegrp i.year i.birthdistr if fem == 0, r
est sto m14

reg educyrs instr2 i.agegrp yob i.year i.birthdistr if fem == 0, r
est sto m15

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 m13 m14 m15] using bots.xls, keep(instr2) dec(3) replace

****************************************************************************
* OLS RESULTS CONTROLLING FOR MATERNAL AGE AND EDUC
****************************************************************************

use bots.dta, clear

reg disany educyrs age age2 age3 age4 momage momedu i.birthdistr i.year if fem == 1, r
est sto m1
margins if yob < 1981

reg disany educyrs age age2 age3 age4 momage momedu i.birthdistr i.year if fem == 0, r
est sto m2
margins if yob < 1981

reg disany educyrs c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex c.momage##i.sex c.momedu##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg disany atleast10 age age2 age3 age4 momage momedu i.birthdistr i.year if fem == 1, r
est sto m4

reg disany atleast10 age age2 age3 age4 momage momedu i.birthdistr i.year if fem == 0, r
est sto m5

reg disany atleast10 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex c.momage##i.sex c.momedu##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(educyrs atleast10) dec(3) replace

****************************************************************************
* POWER CALCULATION
****************************************************************************

use bots.dta, clear

su disany
power twomeans 0.06 0.07, sd(0.21)







