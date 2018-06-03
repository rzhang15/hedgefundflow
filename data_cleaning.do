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
rename caldt date
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

// Daily volatility, we take the median of the month as an estimate
use VIX.dta
rename date date_orig
gen date = mofd(date_orig)
format date %tm
collapse (median) vixo=vixo vixh=vixh vixl=vixl vix=vix, by(date)
save VIX_avg.dta, replace

use cleaned_data.dta
merge m:1 date using sp500.dta
drop _merge
merge m:1 date using 3monthrf.dta
drop _merge
merge m:1 date using TB3MS.dta
drop _merge
merge m:1 date using VIX_avg.dta
drop if _merge==2
drop _merge

// Construct age of fund 
gen age=(date_orig-inceptiondate)/365
label variable age "Age of fund from inception date"
gen age_sq=age^2
label variable age_sq "Squared Age of fund from inception date"
gen ln_age = log(age)
label variable ln_age "Logarithm of fund age"
gen ln_age_sq = log(age)^2
label variable ln_age_sq "Logarithm of fund age square"

// Construct volatility (24-month rolling window) 
use cleaned_data.dta
merge 1:1 date name using rollingvol.dta
label variable volatility "Rolling 24-month window of standard deviation of returns"

// Drop information from when fund is younger than 2 years old or not between 1994-2017
drop if age<2
drop if date_orig<td(01jan1994)
drop if date_orig>td(31dec2017) 

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
replace onshore = 1 if onshore29==1
label variable onshore "0=domicile country not US, 1=domicile country US"
drop onshore1-onshore30
tab live_graveyard, gen(survived)
gen survived=0
replace survived=1 if survived2==1
label variable survived "0=graveyard fund as of April 2018, 1=live fund as of April 2018"
drop survived1-survived2

// Test if funds report monthly
sort name date
by name: gen pastdate = date[_n-1]
gen reporting = date-pastdate
sort reporting name date
** seems like funds do report monthly for the most part */

// Construct flow of fund
sort name date
replace rateofreturn = rateofreturn/100
by name: gen pastNAV = nav[_n-1]
by name: gen pastEstAss = estimatedassets[_n-1]
gen flow_NAV = (nav-pastNAV*(1+rateofreturn))/pastNAV
label variable flow_NAV "Flow of funds calculated using NAV"
gen flow_ass = (estimatedassets-pastEstAss*(1+rateofreturn))/pastEstAss
label variable flow_ass "Flow of funds calculated using estimated assets"

replace flow_NAV = . if reporting>1
replace flow_ass = . if reporting>1

// Replace outliers
replace flow_NAV=. if flow_NAV>10 & flow_NAV!=. // replaced 1 entry
replace flow_ass=. if flow_ass>10 & flow_ass!=. // replaced 31
replace rateofreturn=. if rateofreturn>0.5 & rateofreturn!=. // replaced 74 entry

sort name date

// Control lag-1 returns and flows: 
by name: gen pastflow_NAV = flow_NAV[_n-1]
label variable pastflow_NAV "t-1 flow of funds calculated using NAV"
by name: gen pastflow_ass = flow_ass[_n-1]
label variable pastflow_ass "t-1 flow of funds calculated using estimated assets"
by name: gen pastreturns = rateofreturn[_n-1]
label variable pastreturns "t-1 rate of returns"

// Control lag-2 returns and flows: 
by name: gen past2flow_NAV = flow_NAV[_n-2]
label variable past2flow_NAV "t-2 flow of funds calculated using NAV"
by name: gen past2flow_ass = flow_ass[_n-2]
label variable past2flow_ass "t-2 flow of funds calculated using estimated assets"
by name: gen past2returns = rateofreturn[_n-2]
label variable past2returns "t-2 rate of returns"

// Control lag-3 returns and flows: 
by name: gen past3flow_NAV = flow_NAV[_n-3]
label variable past3flow_NAV "t-3 flow of funds calculated using NAV"
by name: gen past3flow_ass = flow_ass[_n-3]
label variable past3flow_ass "t-3 flow of funds calculated using estimated assets"
by name: gen past3returns = rateofreturn[_n-3]
label variable past3returns "t-3 rate of returns"

// Control lag-4 returns and flows: 
by name: gen past4flow_NAV = flow_NAV[_n-4]
label variable past4flow_NAV "t-4 flow of funds calculated using NAV"
by name: gen past4flow_ass = flow_ass[_n-4]
label variable past4flow_ass "t-4 flow of funds calculated using estimated assets"
by name: gen past4returns = rateofreturn[_n-4]
label variable past4returns "t-4 rate of returns"

// Control lag-5 returns and flows: 
by name: gen past5flow_NAV = flow_NAV[_n-5]
label variable past5flow_NAV "t-5 flow of funds calculated using NAV"
by name: gen past5flow_ass = flow_ass[_n-5]
label variable past5flow_ass "t-5 flow of funds calculated using estimated assets"
by name: gen past5returns = rateofreturn[_n-5]
label variable past5returns "t-5 rate of returns"

// Control lag-6 returns and flows: 
by name: gen past6flow_NAV = flow_NAV[_n-6]
label variable past6flow_NAV "t-6 flow of funds calculated using NAV"
by name: gen past6flow_ass = flow_ass[_n-6]
label variable past6flow_ass "t-6 flow of funds calculated using estimated assets"
by name: gen past6returns = rateofreturn[_n-6]
label variable past6returns "t-6 rate of returns"

// More lag returns
by name: gen past7returns = rateofreturn[_n-7]
by name: gen past8returns = rateofreturn[_n-8]
by name: gen past9returns = rateofreturn[_n-9]
by name: gen past10returns = rateofreturn[_n-10]
by name: gen past11returns = rateofreturn[_n-11]
by name: gen past12returns = rateofreturn[_n-12]

// aggregate returns
sort name date
by name: gen oneyearreturns = (1+ pastreturns) * (1+ past2returns) * (1+ past3returns) * (1+ past4returns) * (1+ past5returns) * (1+ past6returns) * (1+ past7returns) * (1+ past8returns) * (1+ past9returns) * (1+ past10returns)  * (1+ past11returns) * (1+ past12returns)
by name: gen threeyearreturns = oneyearreturns * oneyearreturns[_n-12] * oneyearreturns[_n-24]
by name: gen agg6returns = (1+pastreturns)*(1+past2returns)*(1+past3returns)*(1+past4returns)*(1+past5returns)*(1+past6returns)
label variable agg6returns "past 6 months aggregate returns"

// More lag flow_ass
sort name date
by name: gen past7flow_ass = flow_ass[_n-7]
by name: gen past8flow_ass = flow_ass[_n-8]
by name: gen past9flow_ass = flow_ass[_n-9]
by name: gen past10flow_ass = flow_ass[_n-10]
by name: gen past11flow_ass = flow_ass[_n-11]
by name: gen past12flow_ass = flow_ass[_n-12]

// aggregate flow_ass
by name: gen oneyearflow_ass = (1+ pastflow_ass) * (1+ past2flow_ass) * (1+ past3flow_ass) * (1+ past4flow_ass) * (1+ past5flow_ass) * (1+ past6flow_ass) * (1+ past7flow_ass) * (1+ past8flow_ass) * (1+ past9flow_ass) * (1+ past10flow_ass)  * (1+ past11flow_ass) * (1+ past12flow_ass)
by name: gen threeyearflow_ass = oneyearflow_ass * oneyearflow_ass[_n-12] * oneyearflow_ass[_n-24]
by name: gen agg6flow_ass = (1+pastflow_ass)*(1+past2flow_ass)*(1+past3flow_ass)*(1+past4flow_ass)*(1+past5flow_ass)*(1+past6flow_ass)
label variable agg6flow_ass "past 6 months aggregate flow"
by name: gen agg3flow_ass = (1+pastflow_ass)*(1+past2flow_ass)*(1+past3flow_ass)
label variable agg3flow_ass "past 6 months aggregate flow"

// Control lag-1 market conditions
by name: gen pastvwretd = vwretd[_n-1]
label variable pastvwretd "t-1 value weighted S&P return"
by name: gen pasttmytm = tmytm[_n-1]
label variable pasttmytm "t-1 value weighted 3-month risk free rate"
by name: gen pastvix = vix[_n-1]
label variable pastvix "t-1 value weighted CBOE VIX"

// Control lag-1 volatility
by name: gen pastvolatility = volatility[_n-1]
label variable pastvolatility "t-1 volatility using 24-month rolling window"

// Drop the fund if missing ROR, NAV, incentive fee, management fee, high watermark, minimum investment
drop if incentivefee==0 & managementfee==0
drop if incentivefee==.
drop if minimuminvestment==.
replace incentivefee = incentivefee/100
replace managementfee = managementfee/100
gen ln_min_inv = log(minimuminvestment)
label variable ln_min_inv "log of minimum investment"

// Categorical variable for before, during, after financial crisis 
gen crisis=2
replace crisis=0 if date<tm(2008m1)
replace crisis=1 if date>tm(2009m6)
label variable crisis "0=before crisis, 1=after crisis, 2=during crisis"

/* Categorical variable for bottom, middle, top 30% of funds by estimated assets over the course of a calendar year
gen year = year(date_orig)

collapse (max) assets=estimatedassets, by(productreference year)
gen tercile = .
forvalues y=1994/2017 {
	xtile terciles`y'=assets if year==`y', n(3)
	replace tercile = terciles`y' if year==`y'
}
drop terciles1994-terciles2017
gen bot30 = 0 
replace bot30 = 1 if tercile==1
gen mid30 = 0
replace mid30 = 1 if tercile==2
gen top30 = 0 
replace top30 = 1 if tercile==3

replace bot30=. if tercile==.
replace mid30=. if tercile==.
replace top30=. if tercile==.

save size_tercile.dta, replace
clear

use cleaned_data.dta
merge m:1 productreference year using size_tercile.dta, keepus(bot30 mid30 top30)
drop _merge

save cleaned_data.dta, replace
*/

// Drop the fund if they don't report any estimated assets
preserve
	collapse (count) missing_ass = estimatedassets missing_flow = flow_ass (firstnm) first_nm = estimatedassets first_flow = flow_ass, by(productreference)
	sort missing_ass missing_flow first_nm first_flow
	gen no_ass = 0
	replace no_ass = 1 if missing_ass==0 
	save missing_estass.dta, replace
restore

merge m:1 productreference using missing_estass.dta, keepus(no_ass)
drop if no_ass==1
drop _merge

save cleaned_data.dta, replace

// Construct data for 2005-2007 cross-sectional data
collapse (first) first_date=date (last) last_date=date, by(productreference)
drop if first_date>tm(2005m1) | last_date<tm(2007m12)
gen present05to07 = 1
save 05to07.dta, replace
clear

use cleaned_data2.dta
merge m:1 productreference using 05to07.dta
drop first_date last_date
keep if present05to07==1
drop if date_orig<td(01jan2005)
drop if date_orig>td(31dec2007)
save cleaned_05to07.dta, replace

// Construct data for 2008-2009 cross-sectional data
clear 
use cleaned_data2.dta
collapse (first) first_date=date (last) last_date=date, by(productreference)
drop if first_date>tm(2008m1) | last_date<tm(2009m12)
gen present08to09 = 1
save 08to09.dta, replace
clear

use cleaned_data2.dta
merge m:1 productreference using 08to09.dta
drop first_date last_date
keep if present08to09==1
drop if date_orig<td(01jan2008)
drop if date_orig>td(31dec2009)
save cleaned_08to09.dta, replace
 
// Construct data for 2010-2012 cross-sectional data
clear 
use cleaned_data2.dta
collapse (first) first_date=date (last) last_date=date, by(productreference)
drop if first_date>tm(2010m1) | last_date<tm(2012m12)
gen present10to12 = 1
save 10to12.dta, replace
clear

use cleaned_data2.dta
merge m:1 productreference using 10to12.dta
drop first_date last_date
keep if present10to12==1
drop if date_orig<td(01jan2010)
drop if date_orig>td(31dec2012)
save cleaned_10to12.dta, replace







