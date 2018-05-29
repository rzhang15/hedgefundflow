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
xtreg flow_NAV pastreturns, fe cluster(name)

// --> found pastflow_NAV is not helpful

xtreg flow_NAV pastreturns past2returns, fe cluster(name)

xtreg flow_NAV pastreturns past2returns past3returns, fe cluster(name)

// Controlling for lagged volatility
xtreg flow_NAV pastreturns pastvolatility, fe cluster(name)

xtreg flow_NAV pastreturns past2returns pastvolatility, fe cluster(name)

// Adding CURRENT TIME time-fixed controls (S&P, risk-free rate, CBOE VIX)
xtreg flow_NAV pastreturns vwretd tmytm vix, fe cluster(name)

// xtreg flow_NAV pastreturns pastvolatility vwretd tmytm vix, fe cluster(name) --> adding past volatility useless

// Adding age, size of fund

xtreg flow_NAV pastreturns size_NAV pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_NAV pastreturns size_NAV ln_age pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_NAV pastreturns size_NAV ln_age ln_age_sq pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_NAV size_NAV c.ln_age##c.pastreturns pastvolatility vwretd tmytm vix, fe cluster(name) 

xtreg flow_NAV bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility vwretd tmytm vix, fe cluster(name) 

// Sorting by crisis time
sort crisis name date

by crisis: xtreg flow_NAV pastreturns, fe cluster(name)

by crisis: xtreg flow_NAV pastreturns pastvolatility, fe cluster(name)

// Adding CURRENT TIME time-fixed controls (S&P, risk-free rate, CBOE VIX)
by crisis: xtreg flow_NAV pastreturns vwretd tmytm vix, fe cluster(name)

by crisis: xtreg flow_NAV pastreturns pastvolatility vwretd tmytm vix, fe cluster(name)

// Adding age, size of fund

by crisis: xtreg flow_NAV pastreturns size_NAV ln_age ln_age_sq pastvolatility vwretd tmytm vix, fe cluster(name) 

by crisis: xtreg flow_NAV size_NAV c.ln_age##c.pastreturns pastvolatility vwretd tmytm vix, fe cluster(name)

by crisis: xtreg flow_NAV size_NAV c.ln_age##c.pastreturns pastvolatility vwretd tmytm vix, fe cluster(name)  

by crisis: xtreg flow_NAV bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility vwretd tmytm vix, fe cluster(name) 

// Check residuals not autocorrelated

*** OLS Regressions

// Just ln_age
reg flow_NAV pastreturns incentivefee managementfee size_NAV ln_age pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name)
// With ln_age squared
reg flow_NAV pastreturns incentivefee managementfee size_NAV ln_age ln_age_sq pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 
// With age as interaction
reg flow_NAV incentivefee managementfee size_NAV c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 
reg flow_NAV incentivefee managementfee bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 

// Adding more categories
reg flow_NAV pastreturns incentivefee managementfee size_NAV ln_age ln_age_sq pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct36 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 
reg flow_NAV incentivefee managementfee size_NAV c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct36 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 
reg flow_NAV incentivefee managementfee bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct36 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

// Sorting by crisis time
sort crisis name date
by crisis: reg flow_NAV pastreturns incentivefee managementfee size_NAV ln_age pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name)
by crisis: reg flow_NAV pastreturns incentivefee managementfee size_NAV ln_age ln_age_sq pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 
by crisis: reg flow_NAV incentivefee managementfee size_NAV c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore category1-category12 vwretd tmytm vix, cluster(name) 
by crisis: reg flow_NAV pastreturns incentivefee managementfee size_NAV ln_age ln_age_sq pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct36 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 
by crisis: reg flow_NAV incentivefee managementfee size_NAV c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct36 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 
by crisis: reg flow_NAV incentivefee managementfee bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct36 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_*, cluster(name) 

*** Robustness Checks

// Two-Way Fixed Effects / Cross-Sectional Data 
// 2005 to 2007 
use cleaned_05to07.dta
xtreg flow_NAV bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility i.date, fe cluster(name) 
reg flow_NAV bot30 mid30 top30 c.ln_age##c.pastreturns pastvolatility i.productreference i.date, cluster(name) 

// Out-of-sample predictions with HFR

/*********************************************************************************
Regressions with flow from estimated assets
**********************************************************************************
xtreg flow_ass pastreturns, fe

xtreg flow_ass pastreturns pastflow_ass, fe

xtreg flow_ass pastreturns past2returns, fe

xtreg flow_ass pastreturns past2returns past3returns, fe

xtreg flow_ass pastreturns past2returns pastflow_ass, fe

xtreg flow_ass pastreturns past2returns pastflow_ass past2flow_ass, fe

// Adding CURRENT TIME time-fixed controls (S&P, risk-free rate, CBOE VIX)
xtreg flow_ass pastreturns vwretd tmytm vix, fe

// Sorting by crisis time
sort crisis name date

by crisis: xtreg flow_ass pastreturns, fe

by crisis: xtreg flow_ass pastreturns pastflow_ass, fe

by crisis: xtreg flow_ass pastreturns past2returns pastflow_ass, fe

by crisis: xtreg flow_ass pastreturns past2returns pastflow_ass past2flow_ass, fe

// Adding CURRENT TIME time-fixed controls (S&P, risk-free rate, CBOE VIX)
by crisis: xtreg flow_ass pastreturns vwretd tmytm vix, fe
