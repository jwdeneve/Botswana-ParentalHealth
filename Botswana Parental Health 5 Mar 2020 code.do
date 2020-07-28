************************************************************************
* Children's education and parental health: evidence from Botswana.
* Date: 28 Jul 2020
************************************************************************

************************************************************************
* Preparing IPUMS datasets
************************************************************************

use "D:\PAR HLTH\botswana\raw data\IPUMS Botswana census.dta", clear
keep if year == 2001 | year == 2011
drop perwt hhwt

************************************************************************
* CLEANING AND STUDY CRITERIA
************************************************************************

* Overall population

drop if sex == .
drop if age == . | age == 999 | age > 100
drop if citizen == .
drop if yrschool == . | (yrschool >= 90 & yrschool <=99)

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

keep if malive <. & falive < .

* Study criteria

drop if citizen == 4 /*no Botswana citizens*/
drop if bplbw == 98 | bplbw == 99 /*not born in Botswana or unknown*/

************************************************************************
* ADDITIONAL VARIABLES
************************************************************************

* Year of birth

gen yob = year - age if age <= 100
gen yob2 = yob^2

* Age group

egen fiveyragegrp = cut(age), at(10(5)101)
gen agegrp20 = fiveyragegrp == 20 & fiveyragegrp <.
gen agegrp25 = fiveyragegrp == 25 & fiveyragegrp <.
gen agegrp30 = fiveyragegrp == 30 & fiveyragegrp <.
gen agegrp35 = fiveyragegrp == 35 & fiveyragegrp <.

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

gen bothalive = 1 if malive == 1 & falive == 1
replace bothalive = 0 if malive == 0 | falive == 0 

gen deadany = 1 if malive == 0 | falive == 0
replace deadany = 0 if malive == 1 & falive == 1

* Co-residence with biological parents

gen withany = 0 if momloc == 0 & poploc == 0 // no mother/father present in household
replace withany = 1 if (momloc > 0 & momloc < 50 & malive == 1) | (poploc > 0 & poploc < 50 & falive == 1)

gen withmom = 0 if momloc == 0
replace withmom = 1 if (momloc > 0 & momloc < 50 & malive == 1)

gen withfat = 0 if poploc == 0
replace withfat = 1 if (poploc > 0 & poploc < 50 & falive == 1)

gen withboth = 0 if momloc == 0 | poploc == 0 // no mother/father present in household
replace withboth = 1 if (momloc > 0 & momloc < 50 & malive == 1) & (poploc > 0 & poploc < 50 & falive == 1)

* Labor force participation

gen lfp = 1 if labforce == 2
replace lfp = 0 if labforce == 1

gen health = 0 if isco88a < 998
replace health = 1 if isco88a == 222 | isco88a == 223 | isco88a == 322 | isco88a == 323 | isco88a == 324

* Age2, Age3, Age4, Agegrp

drop age2
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

gen radiohh = 1 if radio == 2
replace radiohh = 0 if radio == 1
drop radio
rename radiohh radio

gen owns = 1 if ownership == 1
replace owns = 0 if ownership == 2

gen number = famsize if famsize < 99

gen nchildren = chborn if chborn <= 12

gen hhmort = 1 if anymort == 1
replace hhmort = 0 if anymort == 2

gen dirty = 1 if fuelcook >= 40 & fuelcook <= 56
replace dirty = 0 if fuelcook >= 20 & fuelcook <= 35
replace dirty = 0 if fuelcook == 72

gen migrated = 1 if migrate1 == 20 | migrate1 == 30
replace migrated = 0 if migrate1 == 10

gen momchildren = chborn_mom if chborn_mom <= 30
gen ageyoungest = yngch_mom if yngch_mom < 90
gen lfpmom = 1 if labforce_mom == 2
replace lfpmom = 0 if labforce_mom == 1

gen year_2001 = year == 2001
gen year_2011 = year == 2011

gen momedu7 = momedu >= 7 & momedu < .
gen momedu10 = momedu >= 10 & momedu < .

gen momagegrp30 = momagegrp == 30 & momagegrp <.
gen momagegrp40 = momagegrp == 40 & momagegrp <.
gen momagegrp50 = momagegrp == 50 & momagegrp <.
gen momagegrp60 = momagegrp == 60 & momagegrp <.

gen birthdistrictGabs = birthdistr == 1 & birthdistr < .

gen setswana = 1 if langbw == 1
replace setswana = 0 if langbw > 1 & langbw <= 23

save bots_fullsample.dta, replace

drop if age < 18
keep if yob >= 1975

save bots.dta, replace

************************************************************************
* FIGURES
************************************************************************

* Educational attainment by birth cohort

use bots.dta, clear
keep if age >= 18 & year == 2011
collapse atleast7 atleast8 atleast9 atleast10 atleast11 atleast12, by (yob)
keep if yob >= 1972 & yob <= 1990
twoway (sc atleast7 yob, connect (1)) (sc atleast8 yob, connect (1)) (sc atleast9 yob, connect (1)) /// 
(sc atleast10 yob, connect (1)) (sc atleast11 yob, connect (1)) /// 
(sc atleast12 yob, connect (1)), legend(order(1 "Pr(Educ {&ge} 7)" 2 "Pr(Educ {&ge} 8)" /// 
3 "Pr(Educ {&ge} 9)" 4 "Pr(Educ {&ge} 10)" 5 "Pr(Educ {&ge} 11)" 6 "Pr(Educ {&ge} 12)")) 

* Parental survival by children's education

use bots_fullsample.dta, clear
keep if age >= 22
keep if year == 2011
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
legend(order(1 "Mother" 3 "Father")) xtitle("{bf}Schooling (years)") ytitle("{bf}Probability parent alive)")

save graphsurvoveredu.dta, replace

* Parental disability by children's education

use bots_fullsample.dta, clear
keep if age >= 22
keep if disany != . 
keep if year == 2011
egen educyrscat = cut(educyrs), at(0, 1, 8, 10, 11, 13, 25)

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
ylabel(0(0.2)1, axis(2)) ytitle("{bf}Probability parent disabled", axis(2))) ///
(rcap hidisany lodisany educyrs, yaxis(2) color(black)), /// 
xlabel( 0 "0" 1 "1-7" 2 "8-9" 3 "10" 4 "11-12" 5 "13+", noticks) ylabel(0(0.2)1) /// 
legend(order(1 "Mother" 3 "Father" 5 "Pooled")) xtitle("{bf}Schooling (years)") ytitle("{bf}Probability parent alive")

* Parental survival and disability by children's birth cohort

use bots_fullsample.dta, clear
keep if yob >= 1971 & yob <= 1991
keep if year == 2011

collapse (mean) meanmotheralive=malive meanfatheralive=falive meanwithany=withany, by(yob)
save survbybirth.dta, replace

use bots_fullsample.dta, clear
keep if age >= 16
keep if yob >= 1971 & yob <= 1991
keep if year == 2011

collapse (mean) meandisany = disany, by(yob)
append using survbybirth.dta

twoway (connected meanmotheralive yob, msize(medsmall) lpattern(dash)) /// 
(connected meanfatheralive yob, msize(medsmall) lpattern(dash)) /// 
(connected meandisany yob, msize(medsmall) lpattern(dash)), ///
yscale(range(0 1)) legend(order(1 "Mother alive" 2 "Father alive" 3 "Parental disability")) /// 
ylabel(0(.2)1) xtitle("Year of birth") ytitle("{bf}Proportion (%)") xline(1981, lc(cranberry))

* Age heaping and birth cohort size

use bots_fullsample.dta, clear
keep if age >= 15 & age <= 40
keep if year == 2001

gen heap = age == 20 | age == 25 | age == 30 | age == 35 | age == 40 | age == 45 | age == 50 | age == 55 /// 
| age == 60 | age == 65 | age == 70 | age == 75 | age == 80 | age == 85 | age == 90 | age == 95| age == 100

twoway hist age if heap == 0, discrete frequency width(1) start(15) color(blue) lcolor(black) xtitle("{bf}Age") ///
|| hist age if heap == 1, discrete frequency width(1) start(15) color(red) lcolor(black) xtitle("{bf}Age") ///
legend(order(2 `"Heap Years"')) 

****************************************************************************
* REGRESSION ANALYSES: FS, OLS, ITT, AND 2SLS RESULTS
****************************************************************************

* First stage

use bots.dta, clear

replace atleast10 = atleast10*100

reg educyrs instr2 i.age yob i.year i.birthdistr if fem == 1, r
est sto m1

reg educyrs instr2 i.age yob i.year i.birthdistr if fem == 0, r
est sto m2

reg educyrs instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

reg atleast10 instr2 i.age yob i.year i.birthdistr if fem == 1, r
est sto m4

reg atleast10 instr2 i.age yob i.year i.birthdistr if fem == 0, r
est sto m5

reg atleast10 instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(instr2) stats(coef ci) dec(1) replace

* OLS, ITT, 2SLS

use bots.dta, clear

replace malive = malive*100
replace falive = falive*100

reg malive educyrs i.age yob i.birthdistr i.year if fem == 1, r
est sto m1
margins if yob < 1981

reg malive educyrs i.age yob i.birthdistr i.year if fem == 0, r
est sto m2
margins if yob < 1981

reg malive educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg falive educyrs i.age yob i.birthdistr i.year if fem == 1, r
est sto m4
margins if yob < 1981

reg falive educyrs i.age yob i.birthdistr i.year if fem == 0, r
est sto m5
margins if yob < 1981

reg falive educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(educyrs) stats(coef, ci) dec(1) replace

reg malive atleast10 i.age yob i.birthdistr i.year if fem == 1, r
est sto m1
margins if yob < 1981

reg malive atleast10 i.age yob i.birthdistr i.year if fem == 0, r
est sto m2
margins if yob < 1981

reg malive atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg falive atleast10 i.age yob i.birthdistr i.year if fem == 1, r
est sto m4
margins if yob < 1981

reg falive atleast10 i.age yob i.birthdistr i.year if fem == 0, r
est sto m5
margins if yob < 1981

reg falive atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(atleast10) stats(coef, ci) dec(1) replace

reg malive instr2 i.age yob i.birthdistr i.year if fem == 1, r
est sto m1
margins if yob < 1981

reg malive instr2 i.age yob i.birthdistr i.year if fem == 0, r
est sto m2
margins if yob < 1981

reg malive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg falive instr2 i.age yob i.birthdistr i.year if fem == 1, r
est sto m4
margins if yob < 1981

reg falive instr2 i.age yob i.birthdistr i.year if fem == 0, r
est sto m5
margins if yob < 1981

reg falive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(instr2) stats(coef, ci) dec(1) replace

* 2SLS

ivregress 2sls malive i.age yob i.birthdistr i.year (educyrs = instr2) if fem == 1, r
est sto m1
estat firststage
estat endogenous

ivregress 2sls malive i.age yob i.birthdistr i.year (educyrs = instr2) if fem == 0, r
est sto m2
estat firststage
estat endogenous

ivregress 2sls malive i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m3
estat firststage
estat endogenous

ivregress 2sls falive i.age yob i.birthdistr i.year (educyrs = instr2) if fem == 1, r
est sto m4
estat firststage
estat endogenous

ivregress 2sls falive i.age yob i.birthdistr i.year (educyrs = instr2) if fem == 0, r
est sto m5
estat firststage
estat endogenous

ivregress 2sls falive i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m6
estat firststage
estat endogenous

outreg2 [m1 m2 m3 m4 m5 m6] using bots.xls, keep(educyrs instr2) stats(coef, ci) dec(1) replace

* Robustness checks for ITT results: mother alive

* Using alternative f(age)

use bots.dta, clear

replace malive = malive*100

reg malive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

reg malive instr2 i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2

reg malive instr2 i.agegrp##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

reg malive instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m4

outreg2 [m1 m2 m3 m4] using bots.xls, keep(instr2) dec(1) replace

* Smaller smaple around cutoff

use bots.dta, clear
keep if yob >= 1976 & yob <= 1986
replace malive = malive*100

reg malive instr2 c.age##i.sex c.age2##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

keep if yob >= 1978 & yob <= 1984
reg malive instr2 c.age##i.sex c.age2##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Using larger sample around cutoff

use bots_fullsample.dta, clear
keep if age >= 18
keep if yob >= 1971

replace malive = malive*100

reg malive instr2 c.age##i.sex c.age2##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Heap year in age

use bots.dta, clear

replace malive = malive*100

gen heap = age == 20 | age == 25 | age == 30 | age == 35 | age == 40 | age == 45 | age == 50 | age == 55 /// 
| age == 60 | age == 65 | age == 70 | age == 75 | age == 80 | age == 85 | age == 90 | age == 95| age == 100

reg malive instr2 i.age##i.sex c.yob##i.sex i.heap##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Using sample with 9+ years of schooling

use bots.dta, clear
keep if educyrs >= 9

replace malive = malive*100

reg malive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Intergenerational education gap

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
gen gap5 = 1 if gap >= 5.5 // 50% Percentile
replace gap5 = 0 if gap <= 5.5

replace malive = malive*100

reg malive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if gap5 == 1, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Parental age (maternal survival if father alive and age >= 50)

use bots.dta, clear

replace malive = malive*100

reg malive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if popage >= 50 & popage < ., r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Slope change in YOB

use bots.dta, clear

replace malive = malive*100

gen YOBcentered = yob - 1981
reg malive instr2 c.YOBcentered##i.sex c.YOBcentered#1.instr2 c.YOBcentered#1.instr2#i.sex i.age##i.sex i.year##i.sex i.birthdistr##i.sex
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Using Logit

use bots.dta, clear

drop yob2
gen yob2 = (yob-1983)^2

logit malive educyrs i.age yob yob2 i.birthdistr i.year if fem == 1, r or
est sto m1
margins if yob < 1981

logit malive educyrs i.age yob yob2 i.birthdistr i.year if fem == 0, r or
est sto m2
margins if yob < 1981

logit malive educyrs i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m3
margins if yob < 1981

logit malive atleast10 i.age yob yob2 i.birthdistr i.year if fem == 1, r or
est sto m4
margins if yob < 1981

logit malive atleast10 i.age yob yob2 i.birthdistr i.year if fem == 0, r or
est sto m5
margins if yob < 1981

logit malive atleast10 i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m6
margins if yob < 1981

logit malive instr2 i.age yob yob2 i.birthdistr i.year if fem == 1, r or
est sto m7
margins if yob < 1981

logit malive instr2 i.age yob yob2 i.birthdistr i.year if fem == 0, r or
est sto m8
margins if yob < 1981

logit malive instr2 i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(3) append ctitle(Odds ratio) eform replace

* Robustness checks for ITT results: father alive

* Using alternative f(age)

use bots.dta, clear

replace falive = falive*100

drop yob2
gen yob2 = (yob-1983)^2

reg falive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

reg falive instr2 i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2

reg falive instr2 i.agegrp##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3

reg falive instr2 c.age##i.sex c.age2##i.sex c.age3##i.sex c.age4##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m4

outreg2 [m1 m2 m3 m4] using bots.xls, keep(instr2) dec(1) replace

* Smaller smaple around cutoff

use bots.dta, clear
keep if yob >= 1976 & yob <= 1986
replace falive = falive*100

reg falive instr2 c.age##i.sex c.age2##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

keep if yob >= 1978 & yob <= 1984
reg falive instr2 c.age##i.sex c.age2##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Using larger sample around cutoff

use bots_fullsample.dta, clear
keep if age >= 18
keep if yob >= 1971

replace falive = falive*100

reg falive instr2 c.age##i.sex c.age2##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Heap year in age

use bots.dta, clear

replace falive = malive*100

gen heap = age == 20 | age == 25 | age == 30 | age == 35 | age == 40 | age == 45 | age == 50 | age == 55 /// 
| age == 60 | age == 65 | age == 70 | age == 75 | age == 80 | age == 85 | age == 90 | age == 95| age == 100

reg falive instr2 i.age##i.sex c.yob##i.sex i.heap##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Using sample with 9+ years of schooling

use bots.dta, clear
keep if educyrs >= 9

replace falive = falive*100

reg falive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Intergenerational education gap

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
gen gap5 = 1 if gap >= 5.5 // 50% Percentile
replace gap5 = 0 if gap <= 5.5

replace falive = malive*100

reg falive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if gap5 == 1, r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Parental age

use bots.dta, clear

replace falive = falive*100

reg falive instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momage >= 50 & momage < ., r
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Slope change in YOB

use bots.dta, clear

replace falive = falive*100

gen YOBcentered = yob - 1981
reg falive instr2 c.YOBcentered##i.sex c.YOBcentered#1.instr2 c.YOBcentered#1.instr2#i.sex i.age##i.sex i.year##i.sex i.birthdistr##i.sex
est sto m1

outreg2 [m1] using bots.xls, keep(instr2) dec(1) replace

* Using Logit

use bots.dta, clear

drop yob2
gen yob2 = (yob-1983)^2

logit falive educyrs i.age yob yob2 i.birthdistr i.year if fem == 1, r or
est sto m1
margins if yob < 1981

logit falive educyrs i.age yob yob2 i.birthdistr i.year if fem == 0, r or
est sto m2
margins if yob < 1981

logit falive educyrs i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m3
margins if yob < 1981

logit falive atleast10 i.age yob yob2 i.birthdistr i.year if fem == 1, r or
est sto m4
margins if yob < 1981

logit falive atleast10 i.age yob yob2 i.birthdistr i.year if fem == 0, r or
est sto m5
margins if yob < 1981

logit falive atleast10 i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m6
margins if yob < 1981

logit falive instr2 i.age yob yob2 i.birthdistr i.year if fem == 1, r or
est sto m7
margins if yob < 1981

logit falive instr2 i.age yob yob2 i.birthdistr i.year if fem == 0, r or
est sto m8
margins if yob < 1981

logit falive instr2 i.age##i.sex c.yob##i.sex c.yob2##i.sex i.year##i.sex i.birthdistr##i.sex, r or
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(3) append ctitle(Odds ratio) eform replace

****************************************************************************
* CO-RESIDENCE FULL SAMPLE
****************************************************************************

* OLS, ITT, and 2SLS

use bots.dta, clear

replace withany = withany*100
replace withboth = withboth*100
replace migrated = migrated*100
keep if withany < . & withboth < . & migrated < .

reg migrated educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1
margins if yob < 1981

reg migrated atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2
margins if yob < 1981

reg migrated instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

ivregress 2sls migrated i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m4
estat firststage
estat endogenous

reg withany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5
margins if yob < 1981

reg withany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

reg withany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m7
margins if yob < 1981

ivregress 2sls withany i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m8
estat firststage
estat endogenous

reg withboth educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m9
margins if yob < 1981

reg withboth atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m10
margins if yob < 1981

reg withboth instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m11
margins if yob < 1981

ivregress 2sls withboth i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m12
estat firststage
estat endogenous

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(1) replace

****************************************************************************
* DISABILITY OUTCOMES AND CHILDBEARING
****************************************************************************

* OLS, ITT, and 2SLS

use bots.dta, clear
keep if withany == 1
keep if disempany < . & disblnany < . & disloany < .
replace disempany = disempany*100
replace disblnany = disblnany*100
replace disloany = disloany*100

reg disempany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1
margins if yob < 1981

reg disempany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2
margins if yob < 1981

reg disempany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

ivregress 2sls disempany i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m4
estat firststage
estat endogenous

reg disblnany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5
margins if yob < 1981

reg disblnany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

reg disblnany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m7
margins if yob < 1981

ivregress 2sls disblnany i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m8
estat firststage
estat endogenous

reg disloany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m9
margins if yob < 1981

reg disloany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m10
margins if yob < 1981

reg disloany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m11
margins if yob < 1981

ivregress 2sls disloany i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m12
estat firststage
estat endogenous

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(1) replace

use bots.dta, clear
keep if withmom == 1
keep if momchildren < . & ageyoungest < . & lfpmom < .
replace lfpmom = lfpmom*100

reg momchildren educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m1
margins if yob < 1981

reg momchildren atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m2
margins if yob < 1981

reg momchildren instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

ivregress 2sls momchildren i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m4
estat firststage
estat endogenous

reg ageyoungest educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m5
margins if yob < 1981

reg ageyoungest atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6
margins if yob < 1981

reg ageyoungest instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m7
margins if yob < 1981

ivregress 2sls ageyoungest i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m8
estat firststage
estat endogenous

reg lfpmom educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m9
margins if yob < 1981

reg lfpmom atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m10
margins if yob < 1981

reg lfpmom instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m11
margins if yob < 1981

ivregress 2sls lfpmom i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex (educyrs = instr2), r
est sto m12
estat firststage
estat endogenous

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12] using bots.xls, keep(educyrs atleast10 instr2) stats(coef, ci) dec(1) replace

****************************************************************************
* SUMMARY STATISTICS
****************************************************************************

use bots.dta, clear

keep if withany==1

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

su setswana if year == 2001 & yob < 1981 
su setswana if year == 2011 & yob < 1981
su setswana if year == 2001 & yob >= 1981
su setswana if year == 2011 & yob >= 1981

su married if year == 2001 & yob < 1981 
su married if year == 2011 & yob < 1981
su married if year == 2001 & yob >= 1981
su married if year == 2011 & yob >= 1981

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

su owns if year == 2001 & yob < 1981 
su owns if year == 2011 & yob < 1981
su owns if year == 2001 & yob >= 1981
su owns if year == 2011 & yob >= 1981

su hhmort if year == 2001 & yob < 1981 
su hhmort if year == 2011 & yob < 1981
su hhmort if year == 2001 & yob >= 1981
su hhmort if year == 2011 & yob >= 1981

****************************************************************************
* OLS AND ITT RESULTS CONTROLLING FOR MATERNAL AGE AND EDUCATION
****************************************************************************

use bots.dta, clear

replace disany = disany*100

reg disany educyrs i.age momage momedu yob i.birthdistr i.year if fem == 1, r
est sto m1
margins if yob < 1981

reg disany educyrs i.age momage momedu i.birthdistr i.year if fem == 0, r
est sto m2
margins if yob < 1981

reg disany educyrs i.age##i.sex c.momage##i.sex c.momedu##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m3
margins if yob < 1981

reg disany atleast10 i.age momage momedu yob i.birthdistr i.year if fem == 1, r
est sto m4

reg disany atleast10 i.age momage momedu yob i.birthdistr i.year if fem == 0, r
est sto m5

reg disany atleast10 i.age##i.sex c.momage##i.sex c.momedu##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m6

reg disany instr2 i.age momage momedu yob i.birthdistr i.year if fem == 1, r
est sto m7

reg disany instr2 i.age momage momedu yob i.birthdistr i.year if fem == 0, r
est sto m8

reg disany instr2 i.age##i.sex c.momage##i.sex c.momedu##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(educyrs atleast10 instr2) stats(coef ci) dec(1) replace

****************************************************************************
* COVARIATE BALANCE PLOTS
****************************************************************************

use bots.dta, clear
keep if withany == 1

* female

reg fem educyrs i.age yob i.birthdistr i.year, r
est sto reg_fem
ivreg2 fem (educyrs=instr2) i.age yob i.birthdistr i.year, endog(educyrs) r 
est sto iv_fem

* birth district = Gaborone

reg birthdistrictGabs educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_birthdistrictGabs
ivreg2 birthdistrictGabs (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r 
est sto iv_birthdistrictGabs

* Setswana

reg setswana educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_setswana
ivreg2 setswana (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_setswana

* religion

reg norelig educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_relig
ivreg2 norelig (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_relig

* christian

reg christian educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_christ
ivreg2 christian (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_christ

* telephone

reg telephone educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_phone
ivreg2 telephone (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_phone

* water

reg water educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_water
ivreg2 water (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_water

* remittances

reg rem educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_rem
ivreg2 rem (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_rem

* maternal secondary educ

reg momedu10 educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_momedu10
ivreg2 momedu10 (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_momedu10

* maternal age 30-39

reg momagegrp30 educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_momagegrp30
ivreg2 momagegrp30 (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_momagegrp30

* maternal age 40-49

reg momagegrp40 educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_momagegrp40
ivreg2 momagegrp40 (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_momagegrp40

* maternal age 50-59

reg momagegrp50 educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_momagegrp50
ivreg2 momagegrp50 (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_momagegrp50

* maternal age 60-69

reg momagegrp60 educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, r
est sto reg_momagegrp60
ivreg2 momagegrp60 (educyrs=instr2) i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex, endog(educyrs) r
est sto iv_momagegrp60

coefplot (reg_fem,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Female")) (iv_fem,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05) rename(educyrs= "Female")) ///
		 (reg_birthdistrictGabs,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Birth District Gaborone")) (iv_birthdistrictGabs,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05) rename(educyrs= "Birth District Gaborone")) ///
		 (reg_setswana,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Speaks Setswana")) (iv_setswana,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Speaks Setswana")) ///
		 (reg_relig,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="No Religion")) (iv_relig,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "No Religion")) /// 
 		 (reg_christ,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Christian")) (iv_christ,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Christian")) /// 
		 (reg_phone,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Telephone")) (iv_phone,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Telephone")) ///
		 (reg_water,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Water")) (iv_water,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Water")) /// 
		 (reg_rem,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Remittances")) (iv_rem,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Remittances")) /// 
		 (reg_momedu10,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Maternal Secondary Education")) (iv_momedu10,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Maternal Secondary Education")) /// 
 		 (reg_momagegrp30,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Maternal Age 30-39")) (iv_momagegrp40,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Maternal Age 30-39")) /// 
		 (reg_momagegrp40,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Maternal Age 40-49")) (iv_momagegrp40,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Maternal Age 40-49")) /// 
		 (reg_momagegrp50,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Maternal Age 50-59")) (iv_momagegrp50,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Maternal Age 50-59")) ///
		 (reg_momagegrp60,keep(educyrs) ms(S) mc(gs5) ciopts(lc(gs5)) offset(0.05) rename(educyrs="Maternal Age 60-69")) (iv_momagegrp60,keep(educyrs) ms(T) mc(gs10) ciopts(lc(gs10)) offset(-0.05)  rename(educyrs = "Maternal Age 60-69")) /// 
		  , legend(off) xline(0) byopts(yrescale)  xtitle("Scaled bias components") graphregion(color(white))
		  
****************************************************************************
* RESULTS BY PARENTAL AGE
****************************************************************************

use bots.dta, clear

replace disany = disany*100

reg disany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 50 | popagegrp == 50, r
est sto m1
margins if yob < 1981

reg disany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 60 | popagegrp == 60, r
est sto m2
margins if yob < 1981

reg disany educyrs i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 70 | popagegrp == 70, r
est sto m3
margins if yob < 1981

reg disany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 50 | popagegrp == 50, r
est sto m4

reg disany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 60 | popagegrp == 60, r
est sto m5

reg disany atleast10 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 70 | popagegrp == 70, r
est sto m6

reg disany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 50 | popagegrp == 50, r
est sto m7

reg disany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 60 | popagegrp == 60, r
est sto m8

reg disany instr2 i.age##i.sex c.yob##i.sex i.year##i.sex i.birthdistr##i.sex if momagegrp == 70 | popagegrp == 70, r
est sto m9

outreg2 [m1 m2 m3 m4 m5 m6 m7 m8 m9] using bots.xls, keep(instr2 educyrs atleast10) stats(coef ci) dec(1) replace
		  
