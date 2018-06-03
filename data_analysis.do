/*
Project:				Hedge Fund Flow
Author:					Ruby Zhang and Lucas Cusimano
Output:					Regressions and Data Analysis
Original Date:			May 20, 2018
*/

cd "/Users/rubyzhang/Desktop/UChicago/Year 3/Applied Econometrics/Project/data/"

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

// Aggregated returns and flows (too few observations for three years)
xtreg flow_ass c.ln_age##c.agg6returns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.oneyearreturns size_ass pastflow_ass past2flow_ass past3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.agg6returns pastreturns past2returns past3returns past4returns past5returns past6returns size_ass agg3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_ass c.ln_age##c.oneyearreturns size_ass agg3flow_ass pastvolatility vwretd tmytm vix, fe cluster(name) 

// Sorting by crisis time
sort crisis name date

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

// Check residuals not autocorrelated

*** OLS Regressions

// With age as interaction
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 

// Adding more categories
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

// All 6 lags 
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass past4flow_ass past5flow_ass past6flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

// Sorting by crisis time
sort crisis name date

by crisis: reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 

by crisis: reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

*** Robustness Checks

/* Two-Way Fixed Effects / Cross-Sectional Data 

use cleaned_05to07.dta
xtset productreference date
xtreg flow_ass size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility i.date, fe cluster(name) 

clear
use cleaned_08to09.dta
xtset productreference date
xtreg flow_ass size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility i.date, fe cluster(name) 

clear
use cleaned_10to12.dta
xtset productreference date
xtreg flow_ass size_ass c.ln_age##c.pastreturns pastflow_ass past2flow_ass past3flow_ass pastvolatility i.date, fe cluster(name) 


