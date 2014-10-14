#################################################################
# Title:		Relaxing Assumptions about Voter Utilities
#				and Majority Rule Efficiency
# Description:	Simulation Studies to investigate how basic
#				assumptions about voter utilities affect the
#				efficiency / social welfare of majority voting
# Filename:		ideal_sim.R
# Last edit:	10/14/2014
# Author:		Patrick Kraft
#################################################################


rm(list=ls())
setwd("/data/Uni/projects/2014/ideal-point/draft/calc/ideal_sim.R")


### load required packages
library(MASS)
library(smacof)

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

#purl("vote_sim.Rnw","vote_sim.R")
@

### Scenario 1: Basic comparison of Ideal points and normal utilities

## a) normal ideal points
# 5000 voters in 200 elections
#



## b) independent normal utilities for two alternatives
# 5000 voters in 200 elections
#