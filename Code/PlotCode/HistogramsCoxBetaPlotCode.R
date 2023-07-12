## df is a flag for no ice

par(mfrow=c(1,2))
hist(betacpt[-(1:25)][!df[-(1:25)]], freq = F)

#lines(density(betacpt[-(1:25)][!df[-(1:25)]]), col = "blue")
#lines(density(betacpt[-(1:25)][!!df[-(1:25)]]), col = "red")
x.bar = mean(betacpt[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betacpt[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue")

x.bar = mean(betacpt[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betacpt[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red")

#lines(density(betacptcv[-(1:25)][!df[-(1:25)]]), col = "blue", lty = 2)
#lines(density(betacptcv[-(1:25)][!!df[-(1:25)]]), col = "red", lty = 2)
x.bar = mean(betacptcv[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betacptcv[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue", lty = 2)

x.bar = mean(betacptcv[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betacptcv[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red", lty = 2)



hist(betacpt[-(1:25)][!df[-(1:25)]], freq = F)
#lines(density(betanorm[-(1:25)][!df[-(1:25)]]), col = "blue")
#lines(density(betanorm[-(1:25)][!!df[-(1:25)]]), col = "red")

x.bar = mean(betanorm[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betanorm[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue")

x.bar = mean(betanorm[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betanorm[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red")

#lines(density(betanormcv[-(1:25)][!df[-(1:25)]]), col = "blue", lty = 2)
#lines(density(betanormcv[-(1:25)][!!df[-(1:25)]]), col = "red", lty = 2)

x.bar = mean(betanormcv[-(1:25)][!df[-(1:25)]]); x.bar
x.var = var(betanormcv[-(1:25)][!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "blue", lty = 2)

x.bar = mean(betanormcv[-(1:25)][!!df[-(1:25)]]); x.bar
x.var = var(betanormcv[-(1:25)][!!df[-(1:25)]]); x.var
a.hat = x.bar*(x.bar*(1-x.bar)/x.var-1); a.hat
b.hat = (1-x.bar)*(x.bar*(1-x.bar)/x.var-1); b.hat
lines(seq(0,1,0.01),dbeta(seq(0,1,0.01),a.hat,b.hat), col = "red", lty = 2)

betacpt[i] = 1-pr_pr_beta_cpt[i]
betacptcv[i] = 1-pr_pr_beta_cpt_cv[i]
betanorm[i] = 1-pr_pr_beta[i]
betanormcv[i] = 1-pr_pr_beta_cv[i]
