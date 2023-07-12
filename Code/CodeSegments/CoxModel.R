#----------------------------------------------------------------------------------------------
# COX MODEL DEVELOPMENT
#----------------------------------------------------------------------------------------------

## build object for survival model ##
k=which(is.na(date_num))

## censoring status 0=censored, 1=solid ##

status=array(NA)
status[1:number_of_years]=1
status[k]=0
date_num_s=date_num
date_num_s[k]=280
survobj<-Surv(date_num_s, status)

#----------------------------------------------------------------------------------------------
# CALIBRATION: FULL PERIOD
#----------------------------------------------------------------------------------------------
# First, use stepwise automated...9 explanatory variables

coxfit1 <- coxph(survobj~.,teleall); summary(coxfit1)
cox.stepfit = step(coxfit1)
summary(cox.stepfit)

# Second, use manual selection automated...CI 0.79, 2 explanatory variables

cox.data_a = teleall[summary(coxfit1)$coefficients[,5]<=0.05]

coxfit2 <- coxph(survobj~.,cox.data_a); 	summary(coxfit2)
cox.data_man = cox.data_a[summary(coxfit2)$coefficients[,5]<=0.05]
cox.manual <- coxph(survobj~.,cox.data_man); 	
summary(cox.manual)

# Third, use values from the literature... CI 0.83, 4-5 explanatory variables

temp_cols = c("dec.airTemp","sep.epo","aug.AMO","dec.OLR", "nov.ao")
#cox.data_b = tele[temp_cols]  # Aug.AMO not significant

#temp_cols = c("dec.airTemp","sep.epo","dec.OLR", "nov.ao")
cox.data_b = tele[temp_cols] 

coxfit3 <- coxph(survobj~., cox.data_b, x=TRUE); 	
summary(coxfit3)

#----------------------------------------------------------------------------------------------
# PROCEED WITH THE MODEL USING VALUES FROM THE LIST
#----------------------------------------------------------------------------------------------

pr_pr_cox = predictSurvProb(coxfit3,cox.data_b,times=c(280))

date_cox=array(NA)	# days until solid ice happen
for(i in 1:number_of_years){
  date_cox[i]<-quantile(survfit(coxfit3, newdata = cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

#----------------------------------------------------------------------------------------------
# VALIDATION (SPLIT PERIODS) AND LEAVE-ONE-OUT
#----------------------------------------------------------------------------------------------

survobj1 = survobj[1:24]
survobj2 = survobj[25:number_of_years]

coxfit_cpt_b <- coxph(survobj1~.,cox.data_b[1:24,],x=TRUE)
summary(coxfit_cpt_b)

coxfit_cpt_a <- coxph(survobj2~.,data.frame(cox.data_b[25:number_of_years,]),x=TRUE)#, iter.max = 30)#,x=TRUE)
summary(coxfit_cpt_a)

pr_pr_cox_cpt = array(NA)
pr_pr_cox_cpt[1:24]=predictSurvProb(coxfit_cpt_b,cox.data_b[1:24,],times=c(280))
pr_pr_cox_cpt[25:number_of_years]=predictSurvProb(coxfit_cpt_a,cox.data_b[25:number_of_years,],times=c(280))
date_cox_cpt=array(NA)
for(i in 1:24){
  date_cox_cpt[i]<-quantile(survfit(coxfit_cpt_b, newdata=cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}
for(i in 25:number_of_years){
  date_cox_cpt[i]<-quantile(survfit(coxfit_cpt_a, newdata=cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

#----------------------------------------------------------------------------------------------
# LEAVE-ONE-OUT CROSS VALIDATION FOR FULL PERIOD
#----------------------------------------------------------------------------------------------

pr_pr_cox_cv=array(NA)
date_cox_cv=array(NA)

for(i in 1:number_of_years){
  survobj_cv <- survobj[-i]
  cox.data_b.cv <- cox.data_b[-i,]
  coxfit_cv <- coxph(survobj_cv~.,cox.data_b.cv, x=TRUE)
  pr_pr_cox_cv[i] = predictSurvProb(coxfit_cv, cox.data_b[i,],times=c(280))
  date_cox_cv[i] <- quantile(survfit(coxfit_cv, cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

#----------------------------------------------------------------------------------------------
# LEAVE-ONE-OUT CROSS VALIDATION FOR SPLIT PERIOD
#----------------------------------------------------------------------------------------------

pr_pr_cox_cpt_cv=array(NA,dim=number_of_years)
date_cox_cpt_cv=array(NA,dim=number_of_years)

for(i in 25:number_of_years){
  survobj_cpt_cv 		<- survobj[25:number_of_years][-(i-24)]
  cox.data_b.cpt.cv 	<- cox.data_b[25:number_of_years,][-(i-24),]
  coxfit_cpt_a_cv 	<- coxph(survobj_cpt_cv~.,cox.data_b.cpt.cv, x=TRUE)
  
  pr_pr_cox_cpt_cv[i] = predictSurvProb(coxfit_cpt_a_cv, cox.data_b[i,],times=c(280))
  date_cox_cpt_cv[i]	<- quantile(survfit(coxfit_cpt_a_cv, cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}

for(i in 1:24){
  survobj_cpt_cv 		<- survobj[1:24][-i]
  cox.data_b.cpt.cv 	<- cox.data_b[1:24,][-i,]
  coxfit_cpt_b_cv		<- coxph(survobj_cpt_cv~., cox.data_b.cpt.cv, x=TRUE)
  
  pr_pr_cox_cpt_cv[i]	= predictSurvProb(coxfit_cpt_b_cv, cox.data_b[i,],times=c(280))
  date_cox_cpt_cv[i]	<- quantile(survfit(coxfit_cpt_b_cv, cox.data_b[i,]),probs = 0.1, conf.int = FALSE)
}


#----------------------------------------------------------------------------------------------
#  Cox model - USING LAST PREDICTED SURIVIVAL PROBABILITY TO PREDICT THE YEARLY CHANCE OF ICE ONSET
#----------------------------------------------------------------------------------------------

cox_probs_cpt = array(NA)
for (year_number in 1:number_of_years) {
  
  cox_model_to_use = NULL
  
  if (year_number <(1998-1973)) {
    cox_model_to_use = coxfit_cpt_b
  } else {
    cox_model_to_use = coxfit_cpt_a
  }
  cox_probs_cpt[year_number] = tail(survfit(cox_model_to_use, newdata=teleall[year_number,])$surv,1)
  
}

