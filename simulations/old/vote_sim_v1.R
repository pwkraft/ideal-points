
## ----echo=FALSE----------------------------------------------------------
### load required packages
suppressPackageStartupMessages(library(MASS))
suppressPackageStartupMessages(library(smacof))

### set simulation parameters
n.vote <- 2000
n.sim <- 500
set.seed(123)

### define fuction to present results
res <- function(a,b,bw="nrd0",ylim=NULL,xlim=NULL){
  if(length(unique(dim(a)!=dim(b)))>1)
    {stop("Utility matrices do not have same dimensions!")
     } else if(unique(dim(a)!=dim(b)))
       {stop("Utility matrices do not have same dimensions!")}
          
  # estimate correlation between utilities
  corrs <- NULL
  for(i in 1:ncol(a)){
    corrs <- c(corrs,cor(a[,i],b[,i]))
  }
  par(mfrow=c(3,1))
  hist(corrs, main="Histogram of Correlations between Utilities for each Simulation",xlim=c(-1,1),col="lightgrey",xlab="Correlation Coefficients")

  # calculate individual utility differential
  dif <- a-b
  plot(density(dif[,1]),main="Distribution of Individual Utility Differentials for 10 Simulations",col=1,ylim=ylim,xlim=xlim,lwd=2)
  for(i in 2:10){
    lines(density(dif[,i],bw=bw),col=i,lwd=2,lty=i)
  }

  # predict vote choice for a
  vote.i <- 1*(dif>0)
  vote <- apply(vote.i,2,mean)

  # aggregate individual utilities
  util.a <- apply(a,2,sum)
  util.b <- apply(b,2,sum)
  util <- util.a - util.b
  
  # percentage of efficient majorities
  eff <- mean(as.numeric((vote>.5)==(util>0)))
  eff.plot <- barplot(c(1-eff,eff), main="Percentage of Efficient Majorities", col="lightgrey",
                      names.arg=c("Not Efficient","Efficient"), ylim=c(0,1))
  text(eff.plot, c(1-eff+.1,eff-.1), labels=round(c(1-eff,eff),digits=4), col="black",cex=1.5)
}

smacofRes <- function(utils,n=n.vote){
  sres <- smacofRect(utils[1:n,],ndim=1)
  par(mfrow=c(3,1))
  hist(sres$conf.row,main="Histogram of Estimated Ideal Points Based on Simulated Utilities",col="lightgrey",xlab="Latent Dimension")
  abline(v=sres$conf.col, col="red")
  legend("topright","Candidate Ideal Points",col="red",lty=1)
  utils.abs <- -1*abs(sres$conf.row %*% c(1,1) - rep(1,n.vote) %*% t(sres$conf.col))
  utils.sq <- -1*(sres$conf.row %*% c(1,1) - rep(1,n.vote) %*% t(sres$conf.col))^2
  plot(utils[1:n,],utils.abs,main="Actual Utilities and Utilities based on Estimated Ideal Points (absolute distance)"
       ,col=rgb(0,100,0,50,maxColorValue=255), pch=16,xlab="Actual Simulated Utilities",ylab="Estimated Utilites")
  plot(utils[1:n,],utils.sq,main="Actual Utilities and Utilities based on Estimated Ideal Points (squared distance)"
       ,col=rgb(0,100,0,50,maxColorValue=255), pch=16,xlab="Actual Simulated Utilities",ylab="Estimated Utilites")
}


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
a <- matrix(runif(n.vote*n.sim),nrow=n.vote)
b <- matrix(runif(n.vote*n.sim),nrow=n.vote)

res(a,b,ylim=c(0,1))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
a <- matrix(rnorm(n.vote*n.sim),nrow=n.vote)
b <- matrix(rnorm(n.vote*n.sim),nrow=n.vote)

res(a,b,ylim=c(0,.3))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
ideal <- matrix(runif(n.vote*n.sim),nrow=n.vote)
pos.a <- matrix(rep(runif(n.sim),n.vote),nrow=n.vote,byrow=T)
pos.b <- matrix(rep(runif(n.sim),n.vote),nrow=n.vote,byrow=T)
a <- -1*abs(ideal - pos.a)
b <- -1*abs(ideal - pos.b)

res(a,b,xlim=c(-.8,.8),ylim=c(0,20))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
a <- -1*(ideal - pos.a)^2
b <- -1*(ideal - pos.b)^2

res(a,b,ylim=c(0,4),xlim=c(-.7,.7))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
ideal <- matrix(rnorm(n.vote*n.sim),nrow=n.vote)
pos.a <- matrix(rep(rnorm(n.sim),n.vote),nrow=n.vote,byrow=T)
pos.b <- matrix(rep(rnorm(n.sim),n.vote),nrow=n.vote,byrow=T)
a <- -1*abs(ideal - pos.a)
b <- -1*abs(ideal - pos.b)

res(a,b,bw=0.1,xlim=c(-2.5,2.5),ylim=c(0,4))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
a <- -1*(ideal - pos.a)^2
b <- -1*(ideal - pos.b)^2

res(a,b,ylim=c(0,.6),xlim=c(-10,10))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
utils <- mvrnorm(n.vote*n.sim,mu=c(0,0),Sigma=matrix(c(1,.5,.5,1),nrow=2))
a <- matrix(utils[,1],nrow=n.vote)
b <- matrix(utils[,2],nrow=n.vote)

res(a,b,ylim=c(0,.45))
smacofRes(utils)


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
utils <- mvrnorm(n.vote*n.sim,mu=c(0,0),Sigma=matrix(c(1,-.9,-.9,1),nrow=2))
a <- matrix(utils[,1],nrow=n.vote)
b <- matrix(utils[,2],nrow=n.vote)

res(a,b,ylim=c(0,.25))
smacofRes(utils)


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
p <- .5
utils <- rbind(mvrnorm(n.vote*n.sim*p,mu=c(0,0),Sigma=matrix(c(1,-.99,-.99,1),nrow=2))
               , mvrnorm(n.vote*n.sim*(1-p),mu=c(0,0),Sigma=matrix(c(1,.5,.5,1),nrow=2)))
utils <- utils[sample(1:(n.vote*n.sim),size=n.vote*n.sim),]
a <- matrix(utils[,1],nrow=n.vote)
b <- matrix(utils[,2],nrow=n.vote)

res(a,b)
smacofRes(utils)


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
ideal <- matrix(rnorm(n.vote*n.sim),nrow=n.vote)
pos.a <- matrix(rep(rnorm(n.sim,mean=.025,sd=.1),n.vote),nrow=n.vote,byrow=T)
pos.b <- matrix(rep(rnorm(n.sim,mean=-.025,sd=.1),n.vote),nrow=n.vote,byrow=T)
a <- -1*(ideal - pos.a)^2
b <- -1*(ideal - pos.b)^2

res(a,b,xlim=c(-3,3))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
ideal <- matrix(rnorm(n.vote*n.sim),nrow=n.vote)
pos.a <- matrix(rep(rnorm(n.sim,mean=0,sd=.1),n.vote),nrow=n.vote,byrow=T)
pos.b <- matrix(rep(rnorm(n.sim,mean=0,sd=.1),n.vote),nrow=n.vote,byrow=T)
a <- -1*abs(ideal - pos.a)
b <- -1*abs(ideal - pos.b)

res(a,b,ylim=c(0,6),xlim=c(-.5,.5))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
ideal <- matrix(exp(rnorm(n.vote*n.sim,0,10)),nrow=n.vote)
pos.a <- matrix(rep(rnorm(n.sim,mean=0,sd=.1),n.vote),nrow=n.vote,byrow=T)
pos.b <- matrix(rep(rnorm(n.sim,mean=0,sd=.1),n.vote),nrow=n.vote,byrow=T)
a <- -1*(ideal - pos.a)^2
b <- -1*(ideal - pos.b)^2

res(a,b)


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
ideal <- matrix(exp(rnorm(n.vote*n.sim,0,10)),nrow=n.vote)
pos.a <- matrix(rep(runif(n.sim,0,.1),n.vote),nrow=n.vote,byrow=T)
pos.b <- matrix(rep(runif(n.sim,0,.1),n.vote),nrow=n.vote,byrow=T)
a <- -1*(ideal - pos.a)^2
b <- -1*(ideal - pos.b)^2

res(a,b)


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives

n.vote <- 200
n.sim <- 500

a <- matrix(rnorm(n.vote*n.sim,0,1),nrow=n.vote)
b <- matrix(rnorm(n.vote*n.sim,0,1),nrow=n.vote)
res(a,b)
#smacofRes(cbind(a[,1],b[,1]))

a <- matrix(rnorm(n.vote*n.sim,.05,1),nrow=n.vote)
b <- matrix(rnorm(n.vote*n.sim,-.05,1),nrow=n.vote)

res(a,b)

a <- matrix(rnorm(n.vote*n.sim,.005,1),nrow=n.vote)
b <- matrix(rnorm(n.vote*n.sim,-.005,1),nrow=n.vote)

res(a,b)


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
a <- matrix(rnorm(n.vote*n.sim,0,.1),nrow=n.vote)
b <- matrix(rnorm(n.vote*n.sim,0,.1),nrow=n.vote)

res(a,b)
smacofRes(cbind(a[,1],b[,1]))


## ----echo=FALSE,fig.height=6,fig.width=6---------------------------------
# simulate utilities for both alternatives
p=.5
tmp <- sample(1:(n.vote*n.sim),size=n.vote*n.sim)
a <- matrix(sample(c(rnorm(n.vote*n.sim*p,0,.1), rnorm(n.vote*n.sim*(1-p),1,.1))[tmp]),nrow=n.vote)
b <- matrix(sample(c(rnorm(n.vote*n.sim*p,0,.1), rnorm(n.vote*n.sim*(1-p),1,.1))[tmp]),nrow=n.vote)

res(a,b)
smacofRes(cbind(a[,1],b[,1]))


# correlated utilities at varying distance

utils <- mvrnorm(n.vote*n.sim,mu=c(0.05,-0.05),Sigma=matrix(c(1,.9,.9,1),nrow=2))
a <- matrix(utils[,1],nrow=n.vote)
b <- matrix(utils[,2],nrow=n.vote)

res(a,b,ylim=c(0,1))
smacofRes(utils)



