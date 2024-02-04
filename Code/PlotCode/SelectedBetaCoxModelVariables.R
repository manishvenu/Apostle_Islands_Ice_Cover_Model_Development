
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
        topleft = c(0.10, 0.9),
        otherleft = c(0.08, 0.9),
        topright = c(0.985, 0.98),
        bottomleft = c(0.10, 0.1),
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
      cex = 1.2,
      xpd = T,
      ...
    )
  }


if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"S5_SelectedCoxBetaModelVariables.pdf") #Comment to SIP 
  pdf(file=plotname, height =8, width = 16, paper = "special") #Comment to SIP
}

par(mfcol= c(4, 2))
par(mar = c(0, 0, 0, 0))
par(oma = c(5, 5, 5, 5))
plot(c(1973:2022),tele$dec.airTemp, type="l",axes=F)
axis(3,c(1973:2022),tck=-0.03,labels=F)
axis(3,seq(1975,2020,5))
mtext("Temperature (\u00B0F)",2,line = 3)
put.fig.letter("December Air Temp")
axis(2)
box()
mtext("Selected Cox Model Variables",side=3,line=3)

plot(c(1973:2022),tele$nov.ao,type="h", lwd=2,axes=F)
put.fig.letter("November AO", "otherleft")
axis(2)
box()
plot(c(1973:2022),tele$dec.OLR,type="h", lwd=2,axes=F)
put.fig.letter("December OLR", "otherleft")
axis(2)
box()
plot(c(1973:2022),tele$sep.epo,type="h", lwd=2,axes=F)
put.fig.letter("September EP-NP", "bottomleft")
axis(2)
box()
axis(1,c(1973:2022),tck=-0.03,labels=F)
axis(1,seq(1975,2020,5))

plot(c(1973:2022),tele$aug.waterTmp, type="l",axes=F)
axis(3,c(1973:2022),tck=-0.03,labels=F)
axis(3,seq(1975,2020,5))
mtext("Temperature (\u00B0C)",4,line = 3)
put.fig.letter("December Water Temp")
axis(4)
box()
mtext("Selected Beta Model Variables",side=3,line=3)

plot(c(1973:2022),tele$sep.epo,type="h", lwd=2,axes=F)
put.fig.letter("September EP-NP", "bottomleft")
axis(4)
box()
axis(1,c(1973:2022),tck=-0.03,labels=F)
axis(1,seq(1975,2020,5))
if (export_plots_to_plots_folder) {
  dev.off()
}