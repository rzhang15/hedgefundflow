/*
Project:				Hedge Fund Flow
Author:					Ruby Zhang and Lucas Cusimano
Output:					Cleans original data
Original Date:			May 17, 2018
*/

cd "/Users/rubyzhang/Desktop/UChicago/Year 3/Applied Econometrics/Project/data/"

clear

use original_data.dta

// Keep if date between 1994-2017 (include 1992-2017 to construct volatility)
drop if date<td(01jan1992)
drop if date>td(31dec2017)
gen date_orig=date
label variable date_orig "Date in D-M-Y format" 
format date_orig %td
replace date=mofd(date) // convert to monthly data
format date %tm

// Keep only $US firms
tab currencycode, gen(cur)
drop if cur27==0
drop cur1-cur28

// Keep only open-ended funds 
drop if openended==0

// Drop fund-of funds, managed futures
tab primarycategory, gen(strat)
drop if strat7==1
drop if strat10==1
drop strat1-strat14

// Merge in S&P, 3-month treasury bill, 3-month risk free rate, and CBOE volatility index (median over a month)
clear
use sp500.dta 
replace date = mofd(date)
format date %tm
save sp500.dta, replace

use 3monthrf.dta 
gen date = mofd(mcaldt)
format date %tm
save 3monthrf.dta,replace

use TB3MS.dta
replace date = mofd(date)
format date %tm
save TB3MS.dta, replace

use VIX.dta
rename date date_orig
gen date = mofd(date_orig)
format date %tm
collapse (median) vixo=vixo vixh=vixh vixl=vixl vix=vix, by(date)
save VIX_avg.dta, replace

use cleaned_data.dta
merge m:1 date using sp500.dta
drop _merge
merge m:1 date using 3monthfr.dta
drop _merge
merge m:1 date using TB3MS.dta
drop _merge
merge m:1 date using VIX_avg.dta
drop if _merge==2
drop _merge

// Construct age of fund 
gen age=date_orig-inceptiondate
label variable age "Age of fund from inception date"
gen ln_age = log(age)
label variable ln_age "Logarithm of fund age"
gen ln_age_sq = log(age)^2
label variable ln_age_sq "Logarithm of fund age square"

// Construct size of fund
gen size_NAV = log(nav)
label variable size_NAV "Logarithm of fund NAV"
gen size_ass = log(estimatedassets)
label variable size_ass "Logarithm of fund asset size"

// Construct indicator/categorical variables
tab primarycategory, gen(category)
tab legalstructure, gen(legalstruct)
tab domicilecountry, gen(onshore)
gen onshore=0
replace onshore = 1 if onshore32==1
label variable onshore "0=domicile country not US, 1=domicile country US"
drop onshore1-onshore33
tab live_graveyard, gen(survived)
gen survived=0
replace survived=1 if survived2==1
label variable survived "0=graveyard fund as of April 2018, 1=live fund as of April 2018"
drop survived1-survived2

// Construct flow of fund
sort name date
by name: gen pastNAV = nav[_n-1]
by name: gen pastEstAss = estimatedassets[_n-1]
gen flow_NAV = (nav-pastNAV*(1+rateofreturn))/nav
label variable flow_NAV "Flow of funds calculated using NAV"
gen flow_ass = (estimatedassets-pastEstAss*(1+rateofreturn))/estimatedassets
label variable flow_ass "Flow of funds calculated using estimated assets"

****** Construct volatility (24-month rolling window) - ONLY DID IT UP TO PRODUCT REFERENCE 384 
tsset productreference date
rolling volatility = r(sd), window(24) saving(volatility, replace) keep(date): sum rateofreturn 
*******

// Drop the fund if missing ROR, NAV, incentive fee, management fee, high watermark, minimum investment
drop if incentivefee==0 & managementfee==0
drop if incentivefee==.
drop if minimuminvestment==.

// Drop information from when fund is younger than 2 years old
**** BECAUSE NOT DONE VOLATILITY, FOR NOW SPECIFY IF AGE >= 2

// Categorical variable for before, during, after financial crisis 
gen crisis=2
replace crisis=0 if date<tm(2008m1)
replace crisis=1 if date>tm(2009m6)
label variable crisis "0=before crisis, 1=after crisis, 2=during crisis"

save cleaned_data.dta, replace







