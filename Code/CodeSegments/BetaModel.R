
#----------------------------------------------------------------------------------------------
# REGRESSSION MODEL: BETA DEVELOPMENT
#----------------------------------------------------------------------------------------------

###################################################
## Yin/Ayumi Model
#cols = c("aug.nao","sep.nao","aug.nino3.4","aug.pna","sep.pna","oct.pna","nov.pna","dec.pna"
#         ,"aug.epo","sep.epo","oct.epo","nov.epo","dec.tnh")
## Just Mishra Model
#cols = c("aug.airTemp","sep.airTemp","oct.airTemp","nov.airTemp","dec.airTemp","aug.AMO","aug.nino3.4","aug.pdo")
## Just FU Model ?

###################################################

# Use stepwise regression; more efficient than manual using "betareg" (use "betareg" at end)
# (see snippet at end of this file for unused method using stepGAIC)

###################################################

#----------------------------------------------------------------------------------------------
# SET UP BETA CALIBRATION
#----------------------------------------------------------------------------------------------

### Set up 'gamlss' model object using all possible explanatory variables (teleall)

beta.gam	<-gamlss(	avg10day.max~., data=teleall,	
                   family = BE, trace = FALSE, 			
                   method = mixed(10,1000))	

## First, automated stepwise regression...results in 15 variables, impractical

beta.step = step(beta.gam, direction = "both")  
summary(beta.step)		

## Second, manual stepwise using betareg

beta.man.1 = betareg(avg10day.max~.,data=teleall)
summary(beta.man.1)

beta.data_a = teleall[,summary(beta.man.1)$coefficients$mean[-1,4]<=0.05]
beta.man.2 = betareg(avg10day.max~.,data=beta.data_a)
summary(beta.man.2)

beta.data_b = beta.data_a[,summary(beta.man.2)$coefficients$mean[-1,4]<=0.05]
beta.man.3 = betareg(avg10day.max~.,data=beta.data_b)
summary(beta.man.3)

beta.data_c = beta.data_b[,summary(beta.man.3)$coefficients$mean[-1,4]<=0.05]
beta.man.4 = betareg(avg10day.max~.,data=beta.data_c)
summary(beta.man.4)

beta.data_d = beta.data_c[,summary(beta.man.4)$coefficients$mean[-1,4]<=0.05]
beta.man.5 = betareg(avg10day.max~.,data=beta.data_d)
summary(beta.man.5)

## Third, combination of model selection and expert opinion

temp_cols.manual = c("aug.waterTmp","sep.epo")  			# Results of manual regression

temp_cols.exp = c("dec.airTemp","nov.ao","aug.AMO","dec.OLR","sep.epo") ## Expert opinion variables

beta.expert = betareg(avg10day.max~.,data=tele[temp_cols.exp])
summary(beta.expert)

#beta.expert = betareg(avg10day.max~.,data=tele[temp_cols.manual])
#summary(beta.expert)

#----------------------------------------------------------------------------------------------
# FULL PERIOD CALCULATIONS
#----------------------------------------------------------------------------------------------

#mod.beta.max = beta.man.5  # Enter which model to plot and evaluate here....
mod.beta.max = beta.expert
# ## betareg function, unfortunately does not (!) have uncertainty bounds, 
# ## so we calculate them manually through mu, phi (alpha, beta)


mu 		<- predict(mod.beta.max)
phi 	= mod.beta.max$coefficients$precision
alpha 	= mu*phi
beta	= (1-mu)*phi
#up_bound	= qbeta(c(0.975),alpha,beta)	# This is the quantile based method
#lw_bound	= qbeta(c(0.025),alpha,beta)
up.bounds = lw.bounds = lw.iqr = up.iqr = NULL							# Use HPD intervals instead	
for(i in 1:length(alpha)){
  lw.bounds[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i])[1]
  up.bounds[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i])[2]
  lw.iqr[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i], credMass = 0.5)[1]
  up.iqr[i] = hdi(qbeta,shape1 = alpha[i], shape2 = beta[i], credMass = 0.5)[2]
}

#cbind(lw_bound, up_bound, lw.bounds, up.bounds)

## To find probability of ice cover exceeding 90%, we use pbeta
pr_pr_beta  = pbeta(0.9,alpha,beta)						# predicted probability of NO safe ice cover in each season



#----------------------------------------------------------------------------------------------
# SPLIT PERIOD CALCULATIONS
#----------------------------------------------------------------------------------------------

pr_pr_beta_cpt=array(NA)

mod.beta.max.cpt_b = betareg(avg10day.max[1:24]~.,			data=beta.data_d[1:24,])
mod.beta.max.cpt_a = betareg(avg10day.max[25:number_of_years]~.,	data=beta.data_d[25:number_of_years,])     # Have to go back one year from year 24 for positive definite matrix
summary(mod.beta.max.cpt_b); summary(mod.beta.max.cpt_a)

## Didn't yield any better results....
# step.beta.max.cpt_b = gamlss(avg10day.max[1:24]~.,data=teleall[1:24,],
# family = BE, trace = FALSE, 			## Use LOTS of iterations
# method = mixed(10,1000))
# step.beta.max.cpt_a = gamlss(avg10day.max[23:number_of_years]~.,data=teleall[23:number_of_years,],
# family = BE, trace = FALSE, 			## Use LOTS of iterations
# method = mixed(10,1000))
# summary(step(step.beta.max.cpt_b)); summary(step(step.beta.max.cpt_a))



## before 1998
pred_value_cpt_b <- predict(mod.beta.max.cpt_b)
mu_cpt_b	= pred_value_cpt_b
phi_cpt_b	= mod.beta.max.cpt_b$coefficients$precision
alpha_cpt_b	= mu_cpt_b*phi_cpt_b
beta_cpt_b	= (1-mu_cpt_b)*phi_cpt_b
pr_pr_beta_cpt[1:24] = unlist(pbeta(0.9,alpha_cpt_b,beta_cpt_b))
## after 1998
pred_value_cpt_a <- predict(mod.beta.max.cpt_a)
mu_cpt_a	= pred_value_cpt_a
phi_cpt_a	= mod.beta.max.cpt_a$coefficients$precision
alpha_cpt_a	= mu_cpt_a*phi_cpt_a
beta_cpt_a	= (1-mu_cpt_a)*phi_cpt_a
pr_pr_beta_cpt[25:number_of_years] = unlist(pbeta(0.9,alpha_cpt_a,beta_cpt_a))

#----------------------------------------------------------------------------------------------
# CROSS VALIDATION
#----------------------------------------------------------------------------------------------
# cross validation for mode of whole time period

pr_pr_beta_cv = array(NA)
ndb_cv = as.data.frame(cbind(teleall[,c(5,7, 8,12, 13, 14,15,18, 21)]))


for(i in 1:number_of_years)	{
  mod.beta.max.cv = betareg(avg10day.max[-i]~., data = ndb_cv[-i,])
  mu_cv <- predict(mod.beta.max.cv, newdata=ndb_cv[i,])
  phi_cv 		= mod.beta.max.cv$coefficients$precision
  alpha_cv 	= mu_cv*phi_cv
  beta_cv 	= (1-mu_cv)*phi_cv
  pr_pr_beta_cv[i] = unlist(pbeta(0.9,alpha_cv,beta_cv))
}

# cross validation for change point model
pr_pr_beta_cpt_cv = array(NA,dim=number_of_years)

### post-1998 model

for(i in 22:number_of_years)	{
  mod.beta.max.cpt_cv = betareg(avg10day.max[22:number_of_years][-(i-21)]~., data = ndb_cv[22:number_of_years,][-(i-21),])
  mu_cpt_cv <- predict(mod.beta.max.cpt_cv, newdata = ndb_cv[22:number_of_years,][i-21,])
  phi_cpt_cv = mod.beta.max.cpt_cv$coefficients$precision
  alpha_cpt_cv=mu_cpt_cv*phi_cpt_cv
  beta_cpt_cv=(1-mu_cpt_cv)*phi_cpt_cv
  pr_pr_beta_cpt_cv[i]=unlist(pbeta(0.9,alpha_cpt_cv,beta_cpt_cv))
}

# cross validation for beta before 1998

for(i in 1:24)	{
  mod.beta.max.cpt_cv = betareg(avg10day.max[1:24][-i]~.,data = ndb_cv[1:24,][-i,])
  mu_cpt_cv <- predict(mod.beta.max.cpt_cv,newdata = ndb_cv[1:24,][i,])
  phi_cpt_cv = mod.beta.max.cpt_cv$coefficients$precision
  alpha_cpt_cv = mu_cpt_cv*phi_cpt_cv
  beta_cpt_cv = (1-mu_cpt_cv)*phi_cpt_cv
  pr_pr_beta_cpt_cv[i] = unlist(pbeta(0.9,alpha_cpt_cv,beta_cpt_cv))
}
