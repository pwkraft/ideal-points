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
setwd("/data/Uni/projects/2014/ideal-point/simulations/")


### load required packages
library(MASS)
library(ggplot2)
library(reshape2)
library(sn)
library(moments)

### load required functions
source("func/vote_func.R")

### set simulation parameters: 2000 voters in 1000 elections
n_vote <- 2000
n_sim <- 1000
set.seed(10142014)


### Scenario 1: Basic comparison of normal ideal points and normal utilities

## a) normal ideal points
# X_i, X_a, X_b ~ N(mu=0, sigma^2 = 1)
# U_ai = -(X_a - X_i)^2
# U_bi = -(X_b - X_i)^2
ideal <- matrix(rnorm(n_vote*n_sim),nrow=n_vote)
pos_a <- matrix(rep(rnorm(n_sim),n_vote),nrow=n_vote,byrow=T)
pos_b <- matrix(rep(rnorm(n_sim),n_vote),nrow=n_vote,byrow=T)
a <- -1*(ideal - pos_a)^2
b <- -1*(ideal - pos_b)^2
png("fig/s1a.png",width=9,height=3,units="in",res=300)
vote_plot(a,b,ylim=c(0,0.8),xlim=c(-5,5))
dev.off()
# calculate standard deviation of means and medians in utility differentials
sd(apply(a-b,2,mean))
sd(apply(a-b,2,median))


## b) independent normal utilities for two alternatives
# U_ai, U_bi ~ N(mu=0, sigma^2 = 1)
a <- matrix(rnorm(n_vote*n_sim),nrow=n_vote)
b <- matrix(rnorm(n_vote*n_sim),nrow=n_vote)
png("fig/s1b.png",width=9,height=3,units="in",res=300)
vote_plot(a,b,ylim=c(0,.3))
dev.off()
# calculate standard deviation of means and medians in utility differentials
sd(apply(a-b,2,mean))
sd(apply(a-b,2,median))


### Scenario 2: Investigating the effect correlated utilities

## a) independent normal utilities for two alternatives
# U_ai, U_bi ~ N(mu=0, sigma^2 = 1), sigma=.9
utils <- mvrnorm(n_vote*n_sim,mu=c(0,0),Sigma=matrix(c(1,.9,.9,1),nrow=2))
a <- matrix(utils[,1],nrow=n_vote)
b <- matrix(utils[,2],nrow=n_vote)
png("fig/s2a.png",width=9,height=3,units="in",res=300)
vote_plot(a,b,ylim=c(0,1))
dev.off()
# calculate standard deviation of means and medians in utility differentials
sd(apply(a-b,2,mean))
sd(apply(a-b,2,median))

## b) independent normal utilities for two alternatives
# U_ai, U_bi ~ N(mu=0, sigma^2 = 1), sigma=-.9
utils <- mvrnorm(n_vote*n_sim,mu=c(0,0),Sigma=matrix(c(1,-.9,-.9,1),nrow=2))
a <- matrix(utils[,1],nrow=n_vote)
b <- matrix(utils[,2],nrow=n_vote)
png("fig/s2b.png",width=9,height=3,units="in",res=300)
vote_plot(a,b)
dev.off()
# calculate standard deviation of means and medians in utility differentials
sd(apply(a-b,2,mean))
sd(apply(a-b,2,median))


### set new simulation parameters
n_vote <- c(10,20,50,100,200,500,1000,2000,5000,10000)
sd_diff <- c(0,0.005,0.01,0.025,0.05,0.1,0.25,0.5,0.75,1)


### Scenario 3: Investigating inefficiencies for varying utility differences

a1 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],0,1)
	,Policy="A",Scenario="Mean Difference = 0")
b1 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],0,1)
	,Policy="B",Scenario="Mean Difference = 0")
diff1 <- data.frame(Utility=a1[,1] - b1[,1]
	,Policy="Difference",Scenario="Mean Difference = 0")
a2 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],0,1)
	,Policy="A",Scenario="Mean Difference = 1")
b2 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],1,1)
	,Policy="B",Scenario="Mean Difference = 1")
diff2 <- data.frame(Utility=a2[,1] - b2[,1]
	,Policy="Difference",Scenario="Mean Difference = 1")
dat <- data.frame(rbind(a1,b1,diff1,a2,b2,diff2))
dat_mean <- aggregate(dat$Utility[dat$Policy=="Difference"]
	, by=list(Scenario=dat$Scenario[dat$Policy=="Difference"]),FUN=mean)
dat_median <- aggregate(dat$Utility[dat$Policy=="Difference"]
	, by=list(Scenario=dat$Scenario[dat$Policy=="Difference"]),FUN=median)
ggplot(dat, aes(x=Utility, linetype=Policy)) +
  ggtitle("Example of Utility Distributions with Varying Mean Difference") +
  geom_density(alpha=.3) +
  scale_linetype_manual(values = c("A"=2,"B"=3,"Difference"=1)) +
  scale_y_continuous(name="Density") +
  geom_vline(aes(xintercept=x), dat_mean, linetype=1) +
  geom_vline(aes(xintercept=x), dat_median, linetype=2) +
  facet_grid(Scenario ~ .) + theme_bw()
ggsave(filename = "fig/s3a.png",
  path = NULL, scale = 1, width = 8, height = 4, units = c("in"))

res <- matrix(NA,ncol=length(n_vote),nrow=length(sd_diff))
colnames(res) <- n_vote
rownames(res) <- sd_diff
for(n in 1:length(n_vote)){
  for(s in 1:length(sd_diff)){
    a <- matrix(rnorm(n_vote[n]*n_sim,0,1),nrow=n_vote[n])
    b <- matrix(rnorm(n_vote[n]*n_sim,sd_diff[s],1),nrow=n_vote[n])
    res[s,n] <- vote_eff(a-b)
  }
}
res_m <- melt(res)
res_m[,1] <- as.factor(res_m[,1])
res_m[,2] <- as.factor(res_m[,2])
qplot(x=Var1, y=Var2, data=res_m, fill=value, geom="tile"
	, xlab="Mean Difference in Utility Distributions"
	, ylab="Number of Voters"
	, main="Efficiency of Majority Election Results") +
	scale_fill_gradient2(limits=c(0,1), low="white", high="grey40"
		,name="Proportion of\nEfficient Elections") +
	geom_text(aes(fill = res_m$value
		, label = round(res_m$value, 2)), size=3) + theme_bw() +
	theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))
ggsave(filename = "fig/s3b.png",
  path = NULL, scale = 1, width = 8, height = 4, units = c("in"))


### Scenario 4: Investigating the effect of skewed utility distributions
# skewness parameter alpha = 5
sd_diff <- c(-1,-0.75,-0.5,-0.25,-0.05,-0.025,-0.01,-0.005,0
				,0.005,0.01,0.025,0.05,0.1,0.25,0.5,0.75,1)
alpha <- 5
omega <- sqrt(pi/(pi-2*(alpha/sqrt(1+alpha^2))^2))
xi <- (-1)*omega*alpha/sqrt(1+alpha^2)*sqrt(2/pi)

a1 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],-1,1)
	,Policy="A",Scenario="Epsilon = -1")
b1 <- data.frame(Utility=rsn(n_vote[length(n_vote)]
	,xi=1+xi,omega=omega,alpha=alpha),Policy="B",Scenario="Epsilon = -1")
diff1 <- data.frame(Utility=a1[,1] - b1[,1]
	,Policy="Difference",Scenario="Epsilon = -1")
a2 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],0,1)
	,Policy="A",Scenario="Epsilon = 0")
b2 <- data.frame(Utility=rsn(n_vote[length(n_vote)]
	,xi=0+xi,omega=omega,alpha=alpha)
	,Policy="B",Scenario="Epsilon = 0")
diff2 <- data.frame(Utility=a2[,1] - b2[,1]
	,Policy="Difference",Scenario="Epsilon = 0")
a3 <- data.frame(Utility=rnorm(n_vote[length(n_vote)],1,1)
	,Policy="A",Scenario="Epsilon = 1")
b3 <- data.frame(Utility=rsn(n_vote[length(n_vote)]
	,xi=-1+xi,omega=omega,alpha=alpha),Policy="B",Scenario="Epsilon = 1")
diff3 <- data.frame(Utility=a3[,1] - b3[,1]
	,Policy="Difference",Scenario="Epsilon = 1")
dat <- data.frame(rbind(a1,b1,diff1,a2,b2,diff2,a3,b3,diff3))
dat_mean <- aggregate(dat$Utility[dat$Policy=="Difference"]
	,by=list(Scenario=dat$Scenario[dat$Policy=="Difference"]),FUN=mean)
dat_median <- aggregate(dat$Utility[dat$Policy=="Difference"]
	,by=list(Scenario=dat$Scenario[dat$Policy=="Difference"]),FUN=median)
ggplot(dat, aes(x=Utility, linetype=Policy)) +
  ggtitle("Example of Skewed Utility Distributions with Varying Mean Difference") +
  geom_density(alpha=.3) +
  scale_linetype_manual(values = c("A"=2,"B"=3,"Difference"=1)) +
  scale_y_continuous(name="Density") +
  geom_vline(aes(xintercept=x), dat_mean, linetype=1) +
  geom_vline(aes(xintercept=x), dat_median, linetype=2) +
  facet_grid(Scenario ~ .) + theme_bw()
ggsave(filename = "fig/s4a.png",
  path = NULL, scale = 1, width = 8, height = 4, units = c("in"))

# skewness for scenarios (empirically)
skewness(a1[,1])
skewness(b1[,1])
skewness(a2[,1])
skewness(b2[,1])
skewness(a3[,1])
skewness(b3[,1])

# skewness for scenarios (analytically)
delta <- alpha/sqrt(1+alpha^2)
(4-pi)/2*(delta*sqrt(2/pi))^3/(1-2*delta^2/pi)^(3/2)

# run simulations
res <- matrix(NA,ncol=length(n_vote),nrow=length(sd_diff))
colnames(res) <- n_vote
rownames(res) <- sd_diff
for(n in 1:length(n_vote)){
  for(s in 1:length(sd_diff)){
    a <- matrix(rnorm(n_vote[n]*n_sim,+sd_diff[s],1),nrow=n_vote[n])
    b <- matrix(rsn(n_vote[n]*n_sim,xi=-sd_diff[s]+xi,omega=omega,alpha=alpha)
    	,nrow=n_vote[n])
    res[s,n] <- vote_eff(a-b)
  }
}
res_m <- melt(res)
res_m[,1] <- as.factor(res_m[,1])
res_m[,2] <- as.factor(res_m[,2])
qplot(x=Var1, y=Var2, data=res_m, fill=value, geom="tile"
	,xlab="Mean Difference in Skewed Utility Distributions (+/-)"
	, ylab="Number of Voters"
	, main="Efficiency of Majority Election Results") +
	scale_fill_gradient2(limits=c(0,1), low="white", high="grey40"
		,name="Proportion of\nEfficient Elections") +
	geom_text(aes(fill = res_m$value
		, label = round(res_m$value, 2)), size=3) + theme_bw() +
	theme(axis.text.x = element_text(angle=90, vjust=.5, hjust=1))
ggsave(filename = "fig/s4b.png",
  path = NULL, scale = 1, width = 8, height = 4, units = c("in"))


### set simulation parameters: 2000 voters in 1000 elections
n_vote <- 2000
set.seed(10142014)

### Add X1: Investigating the effect of skewed distributions of ideal point

ideal <- matrix(rsn(n_vote[length(n_vote)]*n_sim,0+xi
	,omega=omega,alpha=alpha),nrow=n_vote[length(n_vote)])
pos.a <- matrix(rep(rnorm(n_sim),n_vote[length(n_vote)])
	,nrow=n_vote[length(n_vote)],byrow=T)
pos.b <- matrix(rep(rnorm(n_sim),n_vote[length(n_vote)])
	,nrow=n_vote[length(n_vote)],byrow=T)
a <- -1*(ideal - pos.a)^2
b <- -1*(ideal - pos.b)^2
png("fig/sX1.png",width=9,height=3,units="in",res=300)
vote_plot(a,b,ylim=c(0,2),xlim=c(-3,3))
dev.off()

### Add X2: Solution why ideal-point based preferences perform better...

ideal <- matrix(rnorm(n_vote*n_sim),nrow=n_vote)
pos_a <- matrix(rep(rnorm(n_sim),n_vote),nrow=n_vote,byrow=T)
pos_b <- -1*pos_a
a <- -1*(ideal - pos_a)^2
b <- -1*(ideal - pos_b)^2
png("fig/sX2.png",width=9,height=3,units="in",res=300)
vote_plot(a,b,ylim=c(0,.2),xlim=c(-5,5))
dev.off()
# calculate standard deviation of means and medians in utility differentials
sd(apply(a-b,2,mean))
sd(apply(a-b,2,median))



# if the electorate is on average indifferent between both ideal points,
# then we get the same results for voting efficiencies
#
