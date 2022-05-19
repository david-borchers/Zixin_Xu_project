library('LT2D')

# set perp trunc, forward trunc
# total transect length and survey
# area:
w = 0.15 ; ystart = 0.55
L = 10 ; A = 2*w*L

# set value of 'true' parameters
# for simulated data:
b=c(-7.3287948, 0.9945317)
logphi <- c(0.02,-4.42)

# produce simulated data:
set.seed(3)
simobj = simXY(50, 'pi.norm',
               logphi, 'h1', 
               b, w, 
               ystart)
simDat = simobj$locs # locations of simulated animals
N = nrow(simDat) # number of simulated animals

# create the data.frame:
all.1s <- rep(1,length(simDat$x))
obj <- 1:length(simDat$x)
sim.df <- data.frame(x = simDat$x,
                     y = simDat$y,
                     stratum = all.1s,
                     transect = all.1s,
                     L = L,
                     area = A,
                     object = obj,
                     size = all.1s)
head(sim.df)

# fit an LT2D model
fit <- LT2D.fit(DataFrameInput = sim.df,
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

# plote the bootstrap sampling distribution, with point estimate and CI
par(mfrow=c(1,1))
hist(boot$Ns,main='',xlab='Estimate of Abundance')
points(fit$ests$N[length(fit$ests$N)],0,pch=19,col="blue")
points(boot$ci,rep(0,2),pch="|",col="blue",lwd=2)
lines(boot$ci,rep(0,2),col="blue",lwd=2)
