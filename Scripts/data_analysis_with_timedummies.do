/*
Project:				Hedge Fund Flow
Author:					Ruby Zhang and Lucas Cusimano
Output:					Regressions and Data Analysis
Original Date:	September 5, 2018
*/

cd "\\itsnas\udesk\users\lucascusimano\Documents\ECON 21150\data"

clear

use cleaned_data.dta

sort name date crisis

xtset productreference date

***** Table 4 \\ Updated to include time dummies

** OLS
reg flow_ass incentivefee managementfee size_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* y2-y24 m2-m12, cluster(name) 
est store ols_exp

reg flow_ass incentivefee managementfee size_ass c.ln_age##c.agg6returns agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* y2-y24 m2-m12, cluster(name) 
est store ols_agg

** Fixed Effects
xtreg flow_ass c.ln_age##c.agg6returns agg3flow_ass size_ass pastvolatility vwretd tmytm vix y2-y24 m2-m12, fe cluster(name) 
est store fe_agg

xtreg flow_ass c.ln_age##c.pastreturns past2returns past3returns past4returns past5returns past6returns pastflow_ass past2flow_ass past3flow_ass size_ass pastvolatility vwretd tmytm vix y2-y24 m2-m12, fe cluster(name) 
est store fe_exp

// Create latex table 
esttab ols_exp ols_agg fe_exp fe_agg using OLSFE.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) ///
	star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2_a r2_w r2_b r2_o F) ///
	sfmt(%9.0fc %9.3fc  %9.3fc %9.3fc %9.3fc %9.3fc) replace drop(c.ln_age#c.agg6returns c.ln_age#c.pastreturns)

*****

***** Table 6 \\ Updated to include time dummies

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* y2-y24 m2-m12 if crisis==0
est sto ols_before 

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* y2-y24 m2-m12 if crisis==2
est sto ols_during

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 legalstruct1-legalstruct34 ae_* af_* ac_* acur_* ap_* sf_* ia_* gf_* if_* y2-y24 m2-m12 if crisis==1
est sto ols_after

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 y2-y24 m2-m12 if crisis==0
est sto ols_before 

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 y2-y24 m2-m12 if crisis==2
est sto ols_during

reg flow_ass incentivefee managementfee size_ass ln_age agg6returns age_times_agg6 agg3flow_ass pastvolatility ln_min_inv highwatermark lockupperiod redemptionnoticeperiod personalcapital opentopublic leveraged onshore vwretd tmytm vix futures derivatives margin fxcredit category1-category12 y2-y24 m2-m12 if crisis==1
est sto ols_after

esttab ols_before fe_before ols_during fe_during ols_after fe_after using comparison.tex, cells(b(fmt(%9.3fc) star) se(fmt(%9.3fc) par)) ///
	star(* 0.10 ** 0.05 *** 0.01) scalars(N_clust r2_a r2_w r2_b r2_o F) ///
	sfmt(%9.0fc %9.3fc  %9.3fc %9.3fc %9.3fc %9.3fc) replace ///
	drop(c.ln_age#c.agg6returns)
	
*****	
