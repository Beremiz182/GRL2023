dev.off(dev.list()["RStudioGD"])

rm(list=ls())

Rain=read.csv("neerslaggeg_ALMELO_664.csv")
plot(Rain$RD, type = "h", col = "royalblue")


r=Rain$RD
rs=sqrt(r)
rp=r^0.075

X=rp
X=X[X>0]


hist(X,prob=T,col="lightblue")

xfordens=seq(min(X),max(X),length=300)
lines(xfordens,dnorm(xfordens,mean=mean(X), sd=sd(X)), col="red", lwd=3)


# ok
library(lubridate)

Rain$YYYYMMDD = as.Date(as.character(Rain$YYYYMMDD), "%Y%m%d")
y50 = max(year(Rain$YYYYMMDD))-50
R50 = Rain[which(year(Rain$YYYYMMDD) > y50),]
plot(R50$YYYYMMDD,R50$RD, type="h",col="royalblue",yaxt="n",ylab="",xlab="")
axis(side=2, las=2)
title(ylab="Rainfall (0.1*mm)", xlab="Years",main ="Rainfall ALMELO")


y18 = Rain[which(year(Rain$YYYYMMDD) < 1900),]
y19a = Rain[which(year(Rain$YYYYMMDD) > 1900 & year(Rain$YYYYMMDD) <1950),]
y19b = Rain[which(year(Rain$YYYYMMDD) >= 1950 & year(Rain$YYYYMMDD) <2000),]
y20 = Rain[which(year(Rain$YYYYMMDD) >= 2000),]
yrs = list(y18,y19a,y19b,y20)


par(mfrow = c(4, 2))#, mar = c(3, 3, 3, 3))
for (i in 1:4) {
  x2=yrs[[i]]
  plot(x2$YYYYMMDD,x2$RD,type="l",col="blue")
  hist(log10(x2$RD[x2$RD>0]))
}
  
