/*
Project:				Hedge Fund Flow
Author:					Ruby Zhang and Lucas Cusimano
Output:					Cleans original data
Original Date:			June 1, 2018
Description: 			This code finds the relationship with present hedge fund 
						returns and previous returns (various lags, from 4 to 12 
						months). We also do an in-sample training and out-of-sample 
						prediction before and after the crisis, and find little 
						evidence for predictability of returns based on previous returns.
*/

*cd "\\itsnas\udesk\users\lucascusimano\Documents\ECON 21150"
cd "/Users/rubyzhang/Desktop/UChicago/Year 3/Applied Econometrics/Project/data/"

*import delimited 
use cleaned_data.dta

sort name date

by name: gen past4returns = rateofreturn[_n-4]
by name: gen past5returns = rateofreturn[_n-5]
by name: gen past6returns = rateofreturn[_n-6]
by name: gen past7returns = rateofreturn[_n-7]
by name: gen past8returns = rateofreturn[_n-8]
by name: gen past9returns = rateofreturn[_n-9]
by name: gen past10returns = rateofreturn[_n-10]
by name: gen past11returns = rateofreturn[_n-11]
by name: gen past12returns = rateofreturn[_n-12]
sort name date

by name: gen N = _n

sort name date

*tsset productreference N

xtset productreference date

newey rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns if name == "Fund-1", lag(1)

reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns, cluster(name) 


sort crisis name date
by crisis: reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns, cluster(name)


reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past7returns past8returns past9returns past10returns past11returns past12returns if crisis == 0, cluster(name)
estimates store before
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past7returns past8returns past9returns past10returns past11returns past12returns if crisis == 1, cluster(name)
estimates store after
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past7returns past8returns past9returns past10returns past11returns past12returns if crisis == 2, cluster(name)
estimates store during

* Create latex table 
esttab before during after using lagsBDA.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2 F df_b) sfmt(%9.0fc %9.3fc %9.3fc %9.0fc) replace

*WITHOUT CLUSTERS IN ORIGINAL TO ALLOW SUEST
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past7returns past8returns past9returns past10returns past11returns past12returns if crisis == 0
estimates store before
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past7returns past8returns past9returns past10returns past11returns past12returns if crisis == 1
estimates store after
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past7returns past8returns past9returns past10returns past11returns past12returns if crisis == 2
estimates store during
suest before after, cluster(name)

test [before_mean = after_mean]
* not the same

test [before_mean]pastreturns = [after_mean]pastreturns
local sign_ag = sign([after_mean]pastreturns-[before_mean]pastreturns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag is less before



test [before_mean]past3returns = [after_mean]past3returns
local sign_ag = sign([after_mean]past3returns-[before_mean]past3returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We fail to reject the null that the three period lag is less before

local sign_ag = sign([after_mean]past4returns-[before_mean]past4returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past5returns-[before_mean]past5returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past6returns-[before_mean]past6returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past7returns-[before_mean]past7returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past8returns-[before_mean]past8returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past9returns-[before_mean]past9returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past10returns-[before_mean]past10returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past11returns-[before_mean]past11returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
local sign_ag = sign([after_mean]past12returns-[before_mean]past12returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))





clear
use cleaned_data

sort name date

by name: gen past4returns = rateofreturn[_n-4]
by name: gen past5returns = rateofreturn[_n-5]
by name: gen past6returns = rateofreturn[_n-6]
by name: gen past7returns = rateofreturn[_n-7]
by name: gen past8returns = rateofreturn[_n-8]
by name: gen past9returns = rateofreturn[_n-9]
by name: gen past10returns = rateofreturn[_n-10]
by name: gen past11returns = rateofreturn[_n-11]
by name: gen past12returns = rateofreturn[_n-12]

by name: gen oneyearreturns = (1+ pastreturns) * (1+ past2returns) * (1+ past3returns) * (1+ past4returns) * (1+ past5returns) * (1+ past6returns) * (1+ past7returns) * (1+ past8returns) * (1+ past9returns) * (1+ past10returns)  * (1+ past11returns) * (1+ past12returns) if reporting == 1 | reporting == .
by name: gen threeyearreturns = oneyearreturns * oneyearreturns[_n-12] * oneyearreturns[_n-24]  if reporting == 1 | reporting == .


by name: gen pastsp = sprtrn[_n-1]
by name: gen pastvx = vix[_n-1]
by name: gen pasttb = tb3ms[_n-1]




preserve

*********** BEFORE ****************

*training data
keep if date < tm(2006m1)

*reg rateofreturn pastsp pastvx pasttb pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns, cluster(name) 
*reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns, cluster(name) 
*reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns oneyearreturns, cluster(name) 
*xtreg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns m1-m12 y1-y24, fe cluster(name)
xtreg rateofreturn i.direction#c.past*returns, fe cluster(name)

restore

preserve

keep if (date > tm(2006m1) & date < tm(2007m12))

predict preds

scatter rateofreturn preds
cor rateofreturn preds
keep rateofreturn preds
*export delimited "before-predictions-ex-oneyear-w-controls",replace
*export delimited "before-predictions-ex-oneyear",replace
export delimited "before-predictions-w-oneyear", replace


restore


*********** AFTER ****************
preserve

keep if (date > tm(2009m6) & date < tm(2015m12))

*reg rateofreturn pastsp pastvx pasttb pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns, cluster(name) 
*reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns, cluster(name) 
*reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns oneyearreturns, cluster(name) 
*xtreg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns m1-m12 y1-y24, fe cluster(name)
xtreg rateofreturn i.direction#c.past*returns, fe cluster(name)

restore
preserve

keep if date > tm(2015m12)

predict preds

scatter rateofreturn preds
cor rateofreturn preds
keep rateofreturn preds
*export delimited "after-predictions-ex-oneyear-w-controls"
export delimited "after-predictions-ex-oneyear", replace
*export delimited "after-predictions-w-oneyear"

restore
