
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
        topleft = c(0.17, 0.85),
        otherleft = c(0.08, 0.9),
        topright = c(0.8, 0.85),
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
      cex = 1.0,
      xpd = T,
      ...
    )
  }


if (export_plots_to_plots_folder) {
  plotname=file.path(plot_dir,"FIG5_T_EPNP.pdf") #Comment to SIP 
  pdf(file=plotname, height =6, width = 5, paper = "special") #Comment to SIP
}

par(mfcol= c(3, 1))
par(mar = c(0, 0, 0, 0))
par(oma = c(3, 5, 1, 5))

plot(c(1973:2022),			tele$dec.airTemp, type="l",axes=F, ylim = c(0, 28)); box()
	points(c(1973:2022),	tele$dec.airTemp, pch = 16, cex = 0.85)
	axis(1,c(1973:2022),tck=-0.03,labels=F); axis(2)
	axis(1,tck = -0.06, seq(1975,2020,5),labels=F)
	mtext("Temperature (\u00B0F)", 2, line = 3, cex = 0.85)
	put.fig.letter("December Air Temp")

plot(c(1973:2022),			tele$aug.waterTmp, type="l",axes=F, ylim = c(7,20)); box()
	points(c(1973:2022),	tele$aug.waterTmp, pch = 16, cex = 0.85)
	axis(1,c(1973:2022),tck=-0.03,labels=F); axis(4)
	axis(1,tck = -0.06, seq(1975,2020,5),labels=F)
	mtext("Temperature (\u00B0C)", 4, line = 3, cex = 0.85)
	put.fig.letter("August Water Temp")



plot(c(1973:2022),tele$sep.epo, type="h", lwd=3, axes=F, lend = 1, ylim = c(-2.8, 2.8),
	col = ifelse(tele$sep.epo>0, "red", "blue")); box()
	axis(1,c(1973:2022),tck=-0.03,labels=F)
	axis(1,tck = -0.06, seq(1975,2020,5))
	axis(2)
	mtext("Normalized Index Value", 2, line = 3, cex = 0.85)
	put.fig.letter("September EP-NP", "topright")


if (export_plots_to_plots_folder) {
  dev.off()
}


