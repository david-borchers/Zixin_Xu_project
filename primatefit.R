library('LT2D')

# Primate data:
# =============
data(primate.dat)
x=primate.dat$x
y=primate.dat$y

quartz(h=3,w=12)
par(mfrow=c(1,3))
pdlab="Perpendicular distance"
fdlab="Distance along transect"
sp=unique(primate.dat$species)
plot(jitter(y,1,0),jitter(x),pch="+",ylab=pdlab,xlab=fdlab,main="")
hist(y,breaks=seq(0,max(na.omit(y)),length=16),xlab=fdlab,main="")
hist(x,breaks=seq(0,max(na.omit(x)),length=12),xlab=pdlab,main="")

# create the data.frame:
all.1s <- rep(1,length(x))
obj <- 1:length(x)
L = 100 # just made this up
primate.df <- data.frame(x = x,
                     y = y,
                     stratum = all.1s,
                     transect = all.1s,
                     L = L,
                     area = A,
                     object = obj,
                     size = all.1s)
head(primate.df)

# Try fitting a few models:
w=0.03;ystart=0.05

# Normal bump with hazard h1:
b=c(-7.3287948, 0.9945317)
logphi=c(.01646734, -4.67131261)

ystart = 0.04
# fit an LT2D model
fit <- LT2D.fit(DataFrameInput = primate.df,
                hr = 'h1',
                # start values for b:
                b = b,
                ystart = ystart,
                pi.x = 'pi.norm',
                # start values for logphi:
                logphi = logphi,
                w = w,
                hessian = TRUE)

# calculate goodness of fit statistics and plot:
par(mfrow=c(1,2))
gof.LT2D(fit, plot=TRUE)
# plot the perpendicular and forward distance fits:
par(mfrow=c(1,2))
plot(fit,smooth.fy=T)
# look at the AIC
fit$fit$AIC
# look at the density and abundance estimates:
fit$ests

# bootstrap for confidence intervals for abundance
boot <- LT2D.bootstrap(fit,r=999,alpha = 0.05)
boot$ci

# plot the bootstrap sampling distribution, with point estimate and CI
par(mfrow=c(1,1))
hist(boot$Ns,main='',xlab='Estimate of Abundance')
points(fit$ests$N[length(fit$ests$N)],0,pch=19,col="blue")
points(boot$ci,rep(0,2),pch="|",col="blue",lwd=2)
lines(boot$ci,rep(0,2),col="blue",lwd=2)
