####ROC Curves - Skill Test #### Note: Not part of manuscript
if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"5_Var_ROC_2022.pdf") 
  pdf(file=plotname, height = 6.5, width = 6.5, paper = "special") 
  
}

library(pROC)
library(pracma)

obsnoice = array(NA)

for (i in 1:length(date_num)) {
  if (is.na(date_num[i])) {
    obsnoice[i] = TRUE
  }
  else {
    obsnoice[i] = FALSE
  }
  
}
TPR=array(NA)
FPR=array(NA)
tTP=array(NA)
tTN=array(NA)
tFP=array(NA)
tFN=array(NA)
cutoff = array(NA)
for (i in 0:100) {
  cutoff[i+1]=0.01*i
  beta_curr = array(NA)
  for (r in 1:length(pr_pr_beta_cpt))
  {
    if(pr_pr_beta_cpt[r] < cutoff[i+1])
    {
      beta_curr[r]=FALSE;
    }
    else
    {
      beta_curr[r]=TRUE;
    }
  }
  TP = 0
  FP = 0
  TN = 0
  FN = 0
  
  # Determine whether each prediction is TP, FP, TN, or FN
  for (q in 1:length(pr_pr_beta_cpt)){
    if (obsnoice[q] && beta_curr[q]){
      TP = 1+TP
    }
    
    if (obsnoice[q] && !beta_curr[q]){
      FN = 1+FN
      
    }
    if (!obsnoice[q]&& !beta_curr[q]){
      TN = 1+TN
      
    }
    if (!obsnoice[q] && beta_curr[q]){
      FP = 1+FP
      
    }
  }
  tTP[i+1] = TP
  tTN[i+1] = TN
  tFP[i+1] = FP
  tFN[i+1] = FN
  TPR[i+1] = TP / (TP + FN)
  FPR[i+1] = FP / (FP + TN)
  
  
}

df = data.frame(cutoff = cutoff)
df$TPR = TPR
df$FPR = FPR
df$tTP = tTP
df$tTN = tTN
df$tFP = tFP
df$tFN = tFN
s = (trapz(FPR,TPR))
plot(df$FPR,df$TPR,type='o',xlim=c(0,1),ylim=c(0,1),main="ROC Curve", xlab="False Positive Rate", ylab="True Positive Rate",
     col="lightgreen",pch = 16,lwd=3)
lines(c(0,1),c(0,1),lty=3, lwd=3,col="blue")
legend("bottomright",legend=c(paste("Beta Model (AUC: ",-1*round(s,2),")",sep=""),"Random"),
       col=c("lightgreen","Blue"), lty=c(1,3), lwd = 3,cex=0.8)

if (export_plots_to_plots_folder) {
  dev.off()
}
