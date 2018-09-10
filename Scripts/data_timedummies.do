/*
Project:				Hedge Fund Flow
Author:					Ruby Zhang and Lucas Cusimano
Output:					Regressions and Data Analysis
Original Date:			Sept 5, 2018
*/

cd "/Users/rubyzhang/Desktop/UChicago/Year 3/Spring/Applied Econometrics/Project/Data, Code, Results/"

clear

use cleaned_data.dta

sort name date crisis

xtset productreference date

*** Fixed Effects Regressions with Time Dummies
xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility vwretd tmytm vix m2-m12 y2-y24, fe cluster(name) 

xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility vwretd tmytm vix i.date, fe cluster(name)

*** OLS Regression with Time Dummies
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.agg6returns agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* m2-m12 y2-y24, cluster(name) 

reg flow_ass incentivefee managementfee size_ass c.ln_age##c.agg6returns agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* i.date, cluster(name) 

*** Sorting by Crisis (only with monthly/year dummies sincne approximately the same) 
reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* m2-m12 y2-y24 if crisis==0
est sto ols_before 

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* m2-m12 y2-y24 if crisis==2
est sto ols_during

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* m2-m12 y2-y24 if crisis==1
est sto ols_after
