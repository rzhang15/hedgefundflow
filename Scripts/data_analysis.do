/*
Project:				Hedge Fund Flow
Author:					Ruby Zhang and Lucas Cusimano
Output:					Regressions and Data Analysis
Original Date:			May 20, 2018
*/

cd "/Users/rubyzhang/Desktop/UChicago/Year 3/Spring/Applied Econometrics/Project/Data, Code, Results/"

clear

use cleaned_data.dta

sort name date crisis

xtset productreference date

*** Fixed Effects Regressions  
xtreg flow_ass pastreturns, fe cluster(name)
est store fe0

xtreg flow_ass pastreturns agg3flow_ass, fe cluster(name)
est store fe1

xtreg flow_ass pastreturns past2returns agg3flow_ass, fe cluster(name)
est store fe2

xtreg flow_ass pastreturns past2returns past3returns agg3flow_ass, fe cluster(name)
est store fe3

xtreg flow_ass pastreturns past2returns past3returns past4returns agg3flow_ass, fe cluster(name)
est store fe4

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns agg3flow_ass, fe cluster(name)
est store fe5

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns past6returns agg3flow_ass, fe cluster(name)
est store fe6

// Create latex table 
esttab fe0 fe1 fe2 fe3 fe4 fe5 fe6 using lagsFE2.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) ///
	star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2_w r2_b r2_o F df_b) ///
	sfmt(%9.0fc %9.3fc %9.3fc %9.3fc %9.3fc %9.0fc) replace
//	coeflabel(pastreturns "$R_{t-1}$" past2returns "$R_{t-2}$" past3returns "$R_{t-3}$" past4returns "$R_{t-4}$" past5returns "$R_{t-5}$" past6returns "$R_{t-6}$" agg3flow_ass "$Flow^*_{t-3}$") replace

// Other results 
xtreg flow_ass pastreturns pastflow_ass, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass past4flow_ass, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass past4flow_ass past5flow_ass, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass past4flow_ass past5flow_ass past6flow_ass, fe cluster(name)

// Include the past three flows - highest R^2

xtreg flow_ass pastreturns past2returns, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns past4returns, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns past6returns, fe cluster(name)

// Past returns and flows 
xtreg flow_ass pastreturns past2returns pastflow_ass past2flow_ass past3flow_ass, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns pastflow_ass past2flow_ass past3flow_ass, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns past4returns pastflow_ass past2flow_ass past3flow_ass, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns pastflow_ass past2flow_ass past3flow_ass, fe cluster(name)

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass, fe cluster(name)

// Controlling for lagged volatility
xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass past6flow_ass pastvolatility, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility, fe cluster(name)

// Adding CURRENT TIME time-fixed controls (S&P, risk-free rate, CBOE VIX)
xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name)

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass vwretd tmytm vix, fe cluster(name)

// Adding age, size of fund

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass size_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass size_ass ln_age pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns size_ass agg3flow pastvolatility vwretd tmytm vix, fe cluster(name) 


// Aggregated returns and flows (too few observations for three years)
xtreg flow_ass c.ln_age##c.agg6returns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.oneyearreturns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass pastreturns past2returns past3returns past4returns past5returns past6returns c.ln_age##c.agg6returns agg3flow_ass size_ass  pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.oneyearreturns size_ass agg3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility vwretd tmytm vix, fe cluster(name) 
est store fe_agg

xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass size_ass pastvolatility vwretd tmytm vix, fe cluster(name) 
est store fe_exp

// Check residuals not autocorrelated

*** OLS Regressions

// With age as interaction
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 

// Adding more categories
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

// All 6 lags 
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 
est store ols_exp

// Aggregate lags
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.agg6returns agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 
est store ols_agg

// Create latex table 
esttab ols_exp ols_agg fe_exp fe_agg using OLSFE.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) ///
	star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2_a r2_w r2_b r2_o F) ///
	sfmt(%9.0fc %9.3fc  %9.3fc %9.3fc %9.3fc %9.3fc) replace drop(c.ln_age#c.agg6returns c.ln_age#c.pastreturns)

*** Sorting by Crisis
sort crisis name date

// Fixed Effects
by crisis: xtreg flow_ass pastreturns, fe cluster(name)

by crisis: xtreg flow_ass pastreturns pastvolatility pastflow_ass past2flow_ass past3flow_ass , fe cluster(name)

by crisis: xtreg flow_ass pastreturns pastflow_ass past2flow_ass past3flow_ass , fe cluster(name)


// Adding CURRENT TIME time-fixed controls (S&P, risk-free rate, CBOE VIX)
by crisis: xtreg flow_ass pastreturns vwretd tmytm vix, fe cluster(name)

by crisis: xtreg flow_ass pastreturns pastvolatility vwretd tmytm vix, fe cluster(name)

// Adding age, size of fund

by crisis: xtreg flow_ass pastreturns size_ass ln_age ln_age_sq pastvolatility vwretd tmytm vix, fe cluster(name) 

by crisis: xtreg flow_ass size_ass c.ln_age##c.pastreturns pastvolatility vwretd tmytm vix, fe cluster(name)

by crisis: xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

// OLS
by crisis: reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 

by crisis: reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

// Saved Comparisons 
//(NO CLUSTER IN ORDER TO DO HYPOTHESIS TESTING. THE ACTUAL TABLE IS THE VERSION WITH CLUSTERING)
sort name crisis date

gen age_times_agg6 = ln_age*agg6returns
local dep_var flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix
foreach v in `dep_var' {
	gen cen_`v' = . 
}

xtreg flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix if crisis==0, fe
display e(df_r)
sort name
by name: center flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix if e(sample)
local dep_var flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix
foreach v in `dep_var' {
	replace cen_`v' = c_`v' if c_`v'!=.
} 
reg cen_flow_ass cen_ln_age cen_agg6returns cen_age_times_agg6 cen_agg3flow_ass cen_size_ass cen_pastvolatility cen_vwretd cen_tmytm cen_vix if crisis==0, dof(73398) nocons
display e(df_r)
est sto fe_before
drop c_*

xtreg flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix if crisis==2, fe
display e(df_r)
sort name 
by name: center flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix if e(sample)
local dep_var flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix
foreach v in `dep_var' {
	replace cen_`v' = c_`v' if c_`v'!=.
} 
reg cen_flow_ass cen_ln_age cen_agg6returns cen_age_times_agg6 cen_agg3flow_ass cen_size_ass cen_pastvolatility cen_vwretd cen_tmytm cen_vix if crisis==2, dof(12605) nocons
display e(df_r)
est sto fe_during
drop c_*

xtreg flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix if crisis==1, fe
display e(df_r)
sort name 
by name: center flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix if e(sample)
local dep_var flow_ass ln_age agg6returns age_times_agg6 agg3flow_ass size_ass pastvolatility vwretd tmytm vix
foreach v in `dep_var' {
	replace cen_`v' = c_`v' if c_`v'!=.
} 
reg cen_flow_ass cen_ln_age cen_agg6returns cen_age_times_agg6 cen_agg3flow_ass cen_size_ass cen_pastvolatility cen_vwretd cen_tmytm cen_vix if crisis==1, dof(47352) nocons
display e(df_r)
est sto fe_after
drop c_*

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* if crisis==0
est sto ols_before 

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* if crisis==2
est sto ols_during

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* if crisis==1
est sto ols_after

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 if crisis==0
est sto ols_before 

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 if crisis==2
est sto ols_during

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 if crisis==1
est sto ols_after

esttab ols_before fe_before ols_during fe_during ols_after fe_after using comparison.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) ///
	star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2_a r2_w r2_b r2_o F) ///
	sfmt(%9.0fc %9.3fc  %9.3fc %9.3fc %9.3fc %9.3fc) replace ///
	drop(c.ln_age#c.agg6returns)

// Hypothesis testing on before and after to see if coefficients are significantly different
* OLS 
suest ols_before ols_after, cluster(name)

*** Agg 6 past returns 
local sign_ag = sign([ols_after_mean]agg6returns-[ols_before_mean]agg6returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Agg 3 Past Flow
local sign_ag = sign([ols_after_mean]agg3flow_ass-[ols_before_mean]agg3flow_ass)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Size
local sign_ag = sign([ols_after_mean]size_ass-[ols_before_mean]size_ass)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Age
local sign_ag = sign([ols_after_mean]cen_ln_age-[ols_before_mean]cen_ln_age)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Age interact with Agg 6 past returns
local sign_ag = sign([ols_after_mean]cen_age_times_agg6-[ols_before_mean]cen_age_times_agg6)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

* FE
suest fe_before fe_after, cluster(name)

*** Agg 6 past returns 
test [fe_after_mean]cen_agg6returns = [fe_before_mean]cen_agg6returns
local sign_ag = sign([fe_after_mean]cen_agg6returns-[fe_before_mean]cen_agg6returns)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Agg 3 Past Flow
test [fe_after_mean]cen_agg3flow_ass = [fe_before_mean]cen_agg3flow_ass
local sign_ag = sign([fe_after_mean]cen_agg3flow_ass-[fe_before_mean]cen_agg3flow_ass)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Size
test [fe_after_mean]cen_size_ass = [fe_before_mean]cen_size_ass
local sign_ag = sign([fe_after_mean]cen_size_ass-[fe_before_mean]cen_size_ass)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before
local sign_ag = sign([fe_before_mean]cen_size_ass-[fe_after_mean]cen_size_ass)
display "H_0: after coef <= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag before is less after

*** Age
test [fe_after_mean]cen_ln_age = [fe_before_mean]cen_ln_age
local sign_ag = sign([fe_after_mean]cen_ln_age-[fe_before_mean]cen_ln_age)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

*** Age interact with Agg 6 past returns
test [fe_after_mean]cen_age_times_agg6= [fe_before_mean]cen_age_times_agg6
local sign_ag = sign([fe_after_mean]cen_age_times_agg6-[fe_before_mean]cen_age_times_agg6)
display "H_0: after coef >= before coef. p-value = " normal(`sign_ag'*sqrt(r(chi2)))
* We REJECT the null that the one period lag after is less before

// Two-Way Fixed Effects / Cross-Sectional Data 
clear
use cleaned_05to07.dta
xtset productreference date
//xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass past4flow_ass past5flow_ass past6flow_ass size_ass pastvolatility i.date, fe cluster(name) 
xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility i.date, fe cluster(name) 
est store check05to07

clear
use cleaned_08to09.dta
xtset productreference date
//xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass past4flow_ass past5flow_ass past6flow_ass size_ass pastvolatility i.date, fe cluster(name) 
xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility i.date, fe cluster(name) 
est store check08to09

clear
use cleaned_10to12.dta
xtset productreference date
//xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass past4flow_ass past5flow_ass past6flow_ass size_ass pastvolatility i.date, fe cluster(name) 
xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility i.date, fe cluster(name) 
est store check10to12

esttab check05to07 check08to09 check10to12 using robustcheck.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) ///
	star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2_w r2_b r2_o F) ///
	sfmt(%9.0fc %9.3fc  %9.3fc %9.3fc %9.3fc) replace ///
	keep(ln_age agg6returns agg3flow_ass size_ass pastvolatility)
