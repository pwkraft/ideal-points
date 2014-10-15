#################################################################
# Title:		   2 functions to generate plots for voting simulation
# Description: These function summarizes and plots the results
#				       and efficiency of simulated election results
# Arguments:	 a = matrix of utilities (nrow voters, ncol sims)
#				b = matrix of utilities (nrow voters, ncol sims)
#       dif = matrix of individual utility differentials
#				bw = bandwidth for densities
#				ylim = limit y-axis
#				xlim = limit x-axis
# Filename:		vote_plot.R
# Last edit:	10/14/2014
# Author:		Patrick Kraft
#################################################################

# function to calculate efficiency of election results
vote_eff <- function(dif){
  if(length(unique(dim(a)!=dim(b)))>1)
    {stop("Utility matrices do not have same dimensions!")
     } else if(unique(dim(a)!=dim(b)))
       {stop("Utility matrices do not have same dimensions!")}

  # predict vote choice for a
  vote.i <- 1*(dif>0)
  vote <- apply(vote.i,2,mean)

  # aggregate individual utilities
  util.a <- apply(a,2,sum)
  util.b <- apply(b,2,sum)
  util <- util.a - util.b

  # percentage of efficient majorities
  eff <- mean(as.numeric((vote>.5)==(util>0)))
  eff
}

# function to plot and summarize simulation result
vote_plot <- function(a,b,bw="nrd0",ylim=NULL,xlim=NULL){
  if(length(unique(dim(a)!=dim(b)))>1)
    {stop("Utility matrices do not have same dimensions!")
     } else if(unique(dim(a)!=dim(b)))
       {stop("Utility matrices do not have same dimensions!")}

  par(mfrow=c(3,1))

  # calculate individual utility differential
  dif <- a-b

  # plot efficiency of election results
  eff <- vote_eff(dif)
  eff.plot <- barplot(c(1-eff,eff)
    , main="Percentage of Efficient Majorities"
    , col="lightgrey", names.arg=c("Not Efficient","Efficient"), ylim=c(0,1))
  text(eff.plot, c(1-eff+.1,eff-.1), labels=round(c(1-eff,eff),digits=4)
    , col="black",cex=1.5)

  # plot distribution of utility differentials
  plot(density(dif[,1])
    ,main="Distribution of Individual Utility Differentials for 3 Simulations"
    ,col=1,ylim=ylim,xlim=xlim,lwd=2)
  for(i in 2:3){
    lines(density(dif[,i],bw=bw),lwd=2,lty=i)
  }

  # estimate correlation between utilities
  corrs <- NULL
  for(i in 1:ncol(a)){
    corrs <- c(corrs,cor(a[,i],b[,i]))
  }
  hist(corrs
    , main="Histogram of Correlations between Utilities for each Simulation"
  	,xlim=c(-1,1),col="lightgrey",xlab="Correlation Coefficients")
}