
########### FUNCTION FROM SOMEONE ELSE: https://waterprogramming.wordpress.com/2015/12/02/easy-labels-for-multi-panel-plots-in-r/#############################
put.fig.letter <-
  function(label,
           location = "topleft",
           x = NULL,
           y = NULL,
           offset = c(0, 0),
           ...) {
    if (length(label) > 1) {
      warning("length(label) > 1, using label[1]")
    }
    if (is.null(x) | is.null(y)) {
      coords <- switch(
        location,
        topleft = c(0.08, 0.9),
        topcenter = c(0.5525, 0.98),
        topright = c(0.985, 0.98),
        bottomleft = c(0.08, 0.1),
        bottomcenter = c(0.5525, 0.02),
        bottomright = c(0.985, 0.02),
        c(0.015, 0.98)
      )
    } else {
      coords <- c(x, y)
    }
    this.x <- grconvertX(coords[1] + offset[1], from = "nfc", to = "user")
    this.y <- grconvertY(coords[2] + offset[2], from = "nfc", to = "user")
    text(
      labels = label[1],
      x = this.x,
      y = this.y,
      cex = 1.5,
      xpd = T,
      ...
    )
  }
cols = c("dec.airTemp","nov.ao","aug.AMO","dec.OLR","sep.epo")
real_names = c("Dec Air Temp","Nov AO","Aug AMO","Dec OLR","Sep EP-NP")
pos = c("topleft","topleft","topleft","topleft","bottomleft")
if (export_plots_to_plots_folder) {
  plotname=   file.path(plot_dir,"SignificantVariables.pdf")
  pdf(file=plotname, height = 10, width = 8, paper = "special")
}

par(mfrow = c(5, 1))
par(oma = c(6,5,4,4))
par(mar = c(0,0,0,0))

for (c in seq_along(cols)) {
  if (c!=1) {
    plot(seq(1,length(tele[,cols[c]]),1),tele[,cols[c]],ylim = range(pretty(c(0, tele[,cols[c]]))),type="h",axes=F,lwd=3);
    #lines(seq(1,length(tele[,cols[c]]),1),rep(0,50))
    
  }else {
    plot(seq(1,length(tele[,cols[c]]),1),tele[,cols[c]],ylim = range(pretty(c(0, tele[,cols[c]]))),type="l",axes=F);
    
  }
  put.fig.letter(real_names[c],pos[c])
  if (c%%2==1) {
    axis(2)
  } else {
    axis(4)
  }
  box()
  if (c==1) {
    mtext("Temperature (\u00B0F)", side = 2,line=3)
  }
  if (c==5) {
    axis(1,at = seq(3,48,5),label=seq(1975,2020,5))
    axis(1,at = seq(1,50,1),label=F,tck=-0.012)
    
  } else {
    axis(1,at = seq(3,48,5),label=F)
    axis(1,at = seq(1,50,1),label=F,tck=-0.012)
  }
}
mtext(paste("Model Selected Climate Variables"), side = 3,line=2,
      outer = TRUE)
if (export_plots_to_plots_folder) {
  dev.off() 
  
}
