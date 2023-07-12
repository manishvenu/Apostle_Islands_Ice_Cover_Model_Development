
#############################################################################
## Plot summarizing evolution of cofficients during different periods
#############################################################################

if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"param_summ.pdf") #Comment for SIP
  pdf(file=plotname, height = 2.75, width = 6.75, paper = "special") #Comment for SIP
  
}


par(mfcol=c(1,2))
par(mar = c(2.5, 0.5, 0.2, 0))
par(oma = c(0,6.2,0,6.2))
plot(x = c(-1.8,1.8), y = c(0.5,4.5), type = "n", ylim = c(4.5,0.5),
     axes = F, xlab = "", ylab = ""); box(); axis(1)
axis(2, at = seq(1,4), 
     labels = c(expression("T"[a]*" (Dec)"), "EP-NP (Sep)", "OLR (Dec)", "AO (Nov)"),
     las = 1)

abline(v = 0, lty = 3)
for(i in 1:4){
  points(x = summary(coxfit3)$coefficients[-3,][i,1], y = i-0.2, pch = 20)
  segments(	x0 = log(summary(coxfit3)$conf.int[-3,][i,3]),
            x1 = log(summary(coxfit3)$conf.int[-3,][i,4]),
            y0 = i-0.2, col = 8)
}
for(i in 1:4){
  points(x = summary(coxfit_cpt_b)$coefficients[-3,][i,1], y = i, pch = 20)
  segments(	x0 = log(summary(coxfit_cpt_b)$conf.int[-3,][i,3]),
            x1 = log(summary(coxfit_cpt_b)$conf.int[-3,][i,4]),
            y0 = i, col = 8)
}			

for(i in 1:4){
  points(x = summary(coxfit_cpt_a)$coefficients[-3,][i,1], y = i+0.2, pch = 20)
  segments(	x0 = log(summary(coxfit_cpt_a)$conf.int[-3,][i,3]),
            x1 = log(summary(coxfit_cpt_a)$conf.int[-3,][i,4]),
            y0 = i+0.2, col = 8)
}	

plot(x = c(-0.8,0.8), y = c(0.5,4.5), type = "n", ylim = c(4.5,0.5),
     axes = F, xlab = "", ylab = ""); box(); axis(1)
axis(4, at = seq(1,3), 
     labels = c(expression("T"[a]*" (Sep)"), expression("T"[w]*" (Aug)"), "EP-NP (Nov)"),
     las = 1)
abline(v = 0, lty = 3)

for(i in 1:3){
  points(x = mod.beta.max$coeff$mean[i+1], y = i-0.2, pch = 20)	
  segments(	x0 = confint(mod.beta.max)[i+1,1],
            x1 = confint(mod.beta.max)[i+1,2],
            y0 = i-0.2, col = 8)
}

for(i in 1:3){
  points(x = mod.beta.max.cpt_b$coeff$mean[i+1], y = i, pch = 20)
  segments(	x0 = confint(mod.beta.max.cpt_b)[i+1,1],
            x1 = confint(mod.beta.max.cpt_b)[i+1,2],
            y0 = i, col = 8)
}			

for(i in 1:3){
  points(x = mod.beta.max.cpt_a$coeff$mean[i+1], y = i+0.2, pch = 20)
  segments(	x0 = confint(mod.beta.max.cpt_a)[i+1,1],
            x1 = confint(mod.beta.max.cpt_a)[i+1,2],
            y0 = i+0.2, col = 8)
}	
if (export_plots_to_plots_folder) {
  dev.off() #Comment for SIP
}

