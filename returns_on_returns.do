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

cd "\\itsnas\udesk\users\lucascusimano\Documents\ECON 21150"

*import delimited 
use cleaned_data

sort name date

by name: gen past4returns = rateofreturn[_n-4]
by name: gen past5returns = rateofreturn[_n-5]
by name: gen past6returns = rateofreturn[_n-6]
by name: gen past9returns = rateofreturn[_n-9]
by name: gen past12returns = rateofreturn[_n-12]

sort name date

by name: gen N = _n

sort name date

tsset productreference N

newey rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns if name == "Fund-1", lag(1)

reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns, cluster(name) 


sort crisis name date
by crisis: reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns past9returns past12returns, cluster(name)


reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns if crisis == 0
estimates store before
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns if crisis == 1
estimates store after
reg rateofreturn pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns if crisis == 2
estimates store during

suest before after

test [before_mean = after_mean]
* not the same

test [before_mean]pastreturns = [after_mean]pastreturns
local sign_ag = sign([after_mean]pastreturns-[before_mean]pastreturns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag is less before



test [before_mean]past3returns = [after_mean]past3returns
local sign_ag = sign([after_mean]past3returns-[before_mean]past3returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the three period lag is less before


clear
use cleaned_data

sort name date

by name: gen past4returns = rateofreturn[_n-4]
by name: gen past5returns = rateofreturn[_n-5]
by name: gen past6returns = rateofreturn[_n-6]
by name: gen past9returns = rateofreturn[_n-9]
by name: gen past12returns = rateofreturn[_n-12]

by name: gen pastsp = sprtrn[_n-1]
by name: gen pastvx = vix[_n-1]
by name: gen pasttb = tb3ms[_n-1]

preserve

*training data
keep if date < tm(2006m1)

reg rateofreturn pastsp pastvx pasttb pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns, cluster(name) 

restore

preserve

keep if (date > tm(2006m1) & date < tm(2007m12))

predict preds

scatter rateofreturn preds
cor rateofreturn preds

restore

preserve

keep if (date > tm(2009m6) & date < tm(2015m12))

reg rateofreturn pastsp pastvx pasttb pastreturns past2returns past3returns past4returns past5returns past6returns  past9returns past12returns, cluster(name) 

restore
preserve

keep if date > tm(2015m12)

predict preds

scatter rateofreturn preds
cor rateofreturn preds