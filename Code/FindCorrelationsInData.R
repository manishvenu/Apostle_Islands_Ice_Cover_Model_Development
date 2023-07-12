###############Assess correlation of teleconnection indices:#####################################################

## NOTE: code below calculates serial and auto correlation among teleconnections (tele_data_c)
# AND correlation between teleconnections and ice cover (cor_ice_tele);
# we only use tele_data_c and telpair in our paper.
cor_ice_tele = array(NA,dim=c(11,5))
tele_data_c <- tele_data[,-1:-2] 
monthnames=c("aug","sep","oct","nov","dec")
telenames=colnames(tele_data)[3:length(tele_data)]
for(i in 1:10){
  telepair<-tele_data_c[,i]
  telepair<-data.frame(matrix(unlist(t(telepair)),byrow=T,number_of_years,5))
  colnames(telepair)<-paste(monthnames,".",telenames[i], sep = "")
  tryCatch({
    for(j in 1:5)	{
      
      cor_ice_tele[i,j]<-cor(date_num,telepair[,j],use='pairwise')
    }
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
  
  print(cor_ice_tele)
  print(i)
}
colnames(cor_ice_tele)<-c("aug","sep","oct","nov","dec")
cor_ice_tele<-t(cor_ice_tele)


################# Plots! ###############
#source(file.path(plot_code_dir,"TeleconnectionCorrelationPlotCode.R")) #Commented out because it takes a long time

################# Manually place relevant teleconnections ###################
nino3.4 = which(colnames(tele)=="aug.nino3.4")
aug.AMO = which(colnames(tele)=="aug.AMO")
aug.OLR = which(colnames(tele)=="aug.OLR")
nov.OLR = which(colnames(tele)=="nov.OLR")
dec.OLR = which(colnames(tele)=="dec.OLR")
pdo = which(colnames(tele)=="aug.pdo")
waterTmp= which(colnames(tele)=="aug.waterTmp")
WSI = which(colnames(tele)=="aug.wsi")
aug.NAO=which(colnames(tele)=="aug.nao")
sep.NAO=which(colnames(tele)=="sep.nao")
dec.TNH = which(colnames(tele)=="dec.tnh")
seqEPO<-which(endsWith(colnames(tele),".epo")==TRUE & colnames(tele)!="dec.epo")
seqAO<-which(endsWith(colnames(tele),".ao")==TRUE)
seqPNA<-which(endsWith(colnames(tele),".pna")==TRUE)
seqAirTmp<-which(endsWith(colnames(tele),".airTemp")==TRUE)
time = which(colnames(tele)=="aug.time")

tele = cbind(tele[seqAO],tele[seqPNA], tele[seqAirTmp],tele[nino3.4],tele[pdo], tele[waterTmp], tele[aug.NAO], tele[sep.NAO], tele[WSI],tele[dec.TNH],tele[seqEPO],tele[aug.AMO],tele[aug.OLR],tele[nov.OLR],tele[dec.OLR])
telecolnames <-names(tele)
teleall = cbind(tele)	# [use this only for indices; not used],c(rep(1,24),rep(0,19)))
names(teleall) = c(telecolnames)

if (nrow(teleall)>length(date_num)) #if teleconnection data has more years than ice data, this bit erases the extra years of teleconnection data
{
  x=0
  for(i in nrow(teleall):length(date_num)+1)
  {
    teleall = teleall[-i,] 
    x=x+1
  }
  print(paste0(x,  " years were taken off the teleconnection index"))
}
