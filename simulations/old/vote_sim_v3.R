
## ----echo=FALSE----------------------------------------------------------
setwd("/data/Dropbox/Uni/TA_Peter/voting")

### load required packages
suppressPackageStartupMessages(library(MASS))
suppressPackageStartupMessages(library(sn))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(reshape2))

### set simulation parameters
n.vote <- c(10,20,50,100,200,500,1000,2000,5000,10000)
sd.diff <- c(-1,-0.75,-0.5,-0.25,-0.05,-0.025,-0.01,-0.005,0,0.005,0.01,0.025,0.05,0.1,0.25,0.5,0.75,1)
n.sim <- 1000
set.seed(123)

### define fuction to present results
eff <- function(a,b){
  if(length(unique(dim(a)!=dim(b)))>1)
    {stop("Utility matrices do not have same dimensions!")
     } else if(unique(dim(a)!=dim(b)))
       {stop("Utility matrices do not have same dimensions!")}
          
  # predict vote choice for a
  dif <- a-b
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


## ----echo=FALSE,fig.height=3,fig.width=7,message=FALSE-------------------
a1 <- data.frame(Utility=rnorm(n.vote[length(n.vote)],1,1),Candidate="A",Scenario="No Correlation")
b1 <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=-1,omega=1,alpha=10),Candidate="B",Scenario="No Correlation")
diff1 <- data.frame(Utility=a1[,1] - b1[,1],Candidate="Difference",Scenario="No Correlation")
utils <- rmsn(n=n.vote[length(n.vote)], xi=c(1,-1), Omega=matrix(c(1,.9,.9,1),nrow=2), alpha=c(0,10))
a2 <- data.frame(Utility=utils[,1],Candidate="A",Scenario="Positive Correlation")
b2 <- data.frame(Utility=utils[,2],Candidate="B",Scenario="Positive Correlation")
diff2 <- data.frame(Utility=a2[,1] - b2[,1],Candidate="Difference",Scenario="Positive Correlation")
utils <- rmsn(n=n.vote[length(n.vote)], xi=c(1,-1), Omega=matrix(c(1,-.9,-.9,1),nrow=2), alpha=c(0,10))
a3 <- data.frame(Utility=utils[,1],Candidate="A",Scenario="Negative Correlation")
b3 <- data.frame(Utility=utils[,2],Candidate="B",Scenario="Negative Correlation")
diff3 <- data.frame(Utility=a3[,1] - b3[,1],Candidate="Difference",Scenario="Negative Correlation")
data <- data.frame(rbind(a1,b1,diff1,a2,b2,diff2,a3,b3,diff3))
ggplot(data, aes(x=Utility, fill=Candidate)) + 
  ggtitle("Example of Utility Distributions with Means +/- 1") +
  geom_density(alpha=.3) +
  scale_y_continuous(name="Density") +
  facet_grid(. ~ Scenario)


## ----echo=FALSE,fig.height=4,fig.width=8---------------------------------
res <- matrix(NA,ncol=length(n.vote),nrow=length(sd.diff))
colnames(res) <- n.vote
rownames(res) <- sd.diff
for(n in 1:length(n.vote)){
  for(s in 1:length(sd.diff)){
    a <- matrix(rnorm(n.vote[n]*n.sim,0+sd.diff[s],1),nrow=n.vote[n])
    b <- matrix(rsn(n.vote[n]*n.sim,xi=0-sd.diff[s],omega=1,alpha=10),nrow=n.vote[n])
    res[s,n] <- eff(a,b)
  }
}
res.m <- melt(res); res.m[,1] <- as.factor(res.m[,1]); res.m[,2] <- as.factor(res.m[,2])
qplot(x=Var1, y=Var2, data=res.m, fill=value, geom="tile",xlab="Mean Difference in Utility Distributions (+/-)", ylab="Number of Voters", main="Efficiency of Majority Election Results") + scale_fill_gradient2(limits=c(0,1),name="Proportion of\nEfficient Elections") + geom_text(aes(fill = res.m$value, label = round(res.m$value, 2)), size=3)


## ----echo=FALSE,fig.height=4,fig.width=8---------------------------------
res <- matrix(NA,ncol=length(n.vote),nrow=length(sd.diff))
colnames(res) <- n.vote
rownames(res) <- sd.diff
for(n in 1:length(n.vote)){
  for(s in 1:length(sd.diff)){
    utils <- rmsn(n=n.vote[n]*n.sim, xi=c(0+sd.diff[s],0-sd.diff[s]), Omega=matrix(c(1,.9,.9,1),nrow=2), alpha=c(0,10))
    a <- matrix(utils[,1],nrow=n.vote[n])
    b <- matrix(utils[,2],nrow=n.vote[n])
    res[s,n] <- eff(a,b)
  }
}
res.m <- melt(res); res.m[,1] <- as.factor(res.m[,1]); res.m[,2] <- as.factor(res.m[,2])
qplot(x=Var1, y=Var2, data=res.m, fill=value, geom="tile",xlab="Mean Difference in Utility Distributions (+/-)", ylab="Number of Voters", main="Efficiency of Majority Election Results") + scale_fill_gradient2(limits=c(0,1),name="Proportion of\nEfficient Elections") + geom_text(aes(fill = res.m$value, label = round(res.m$value, 2)), size=3)


## ----echo=FALSE,fig.height=4,fig.width=8---------------------------------
res <- matrix(NA,ncol=length(n.vote),nrow=length(sd.diff))
colnames(res) <- n.vote
rownames(res) <- sd.diff
for(n in 1:length(n.vote)){
  for(s in 1:length(sd.diff)){
    utils <- rmsn(n=n.vote[n]*n.sim, xi=c(0+sd.diff[s],0-sd.diff[s]), Omega=matrix(c(1,-.9,-.9,1),nrow=2), alpha=c(0,10))
    a <- matrix(utils[,1],nrow=n.vote[n])
    b <- matrix(utils[,2],nrow=n.vote[n])
    res[s,n] <- eff(a,b)
  }
}
res.m <- melt(res); res.m[,1] <- as.factor(res.m[,1]); res.m[,2] <- as.factor(res.m[,2])
qplot(x=Var1, y=Var2, data=res.m, fill=value, geom="tile",xlab="Mean Difference in Utility Distributions (+/-)", ylab="Number of Voters", main="Efficiency of Majority Election Results") + scale_fill_gradient2(limits=c(0,1),name="Proportion of\nEfficient Elections") + geom_text(aes(fill = res.m$value, label = round(res.m$value, 2)), size=3)


## ----echo=FALSE,fig.height=3,fig.width=7,message=FALSE-------------------
a1 <- data.frame(Utility=rnorm(n.vote[length(n.vote)],1,1),Candidate="A",Scenario="No Correlation")
b1 <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=-1,omega=1,alpha=-10),Candidate="B",Scenario="No Correlation")
diff1 <- data.frame(Utility=a1[,1] - b1[,1],Candidate="Difference",Scenario="No Correlation")
utils <- rmsn(n=n.vote[length(n.vote)], xi=c(1,-1), Omega=matrix(c(1,.9,.9,1),nrow=2), alpha=c(0,-10))
a2 <- data.frame(Utility=utils[,1],Candidate="A",Scenario="Positive Correlation")
b2 <- data.frame(Utility=utils[,2],Candidate="B",Scenario="Positive Correlation")
diff2 <- data.frame(Utility=a2[,1] - b2[,1],Candidate="Difference",Scenario="Positive Correlation")
utils <- rmsn(n=n.vote[length(n.vote)], xi=c(1,-1), Omega=matrix(c(1,-.9,-.9,1),nrow=2), alpha=c(0,-10))
a3 <- data.frame(Utility=utils[,1],Candidate="A",Scenario="Negative Correlation")
b3 <- data.frame(Utility=utils[,2],Candidate="B",Scenario="Negative Correlation")
diff3 <- data.frame(Utility=a3[,1] - b3[,1],Candidate="Difference",Scenario="Negative Correlation")
data <- data.frame(rbind(a1,b1,diff1,a2,b2,diff2,a3,b3,diff3))
ggplot(data, aes(x=Utility, fill=Candidate)) + 
  ggtitle("Example of Utility Distributions with Means +/- 1") +
  geom_density(alpha=.3) +
  scale_y_continuous(name="Density") +
  facet_grid(. ~ Scenario)
  #+ geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=mean(Utility)), color="green",linetype=1) +
  #geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=median(Utility)), color="red",linetype=2)


## ----echo=FALSE,fig.height=5,fig.width=9---------------------------------
res <- matrix(NA,ncol=length(n.vote),nrow=length(sd.diff))
colnames(res) <- n.vote
rownames(res) <- sd.diff
for(n in 1:length(n.vote)){
  for(s in 1:length(sd.diff)){
    a <- matrix(rnorm(n.vote[n]*n.sim,0+sd.diff[s],1),nrow=n.vote[n])
    b <- matrix(rsn(n.vote[n]*n.sim,xi=0-sd.diff[s],omega=1,alpha=-10),nrow=n.vote[n])
    res[s,n] <- eff(a,b)
  }
}
res.m <- melt(res); res.m[,1] <- as.factor(res.m[,1]); res.m[,2] <- as.factor(res.m[,2])
qplot(x=Var1, y=Var2, data=res.m, fill=value, geom="tile",xlab="Mean Difference in Utility Distributions (+/-)", ylab="Number of Voters", main="Efficiency of Majority Election Results") + scale_fill_gradient2(limits=c(0,1),name="Proportion of\nEfficient Elections") + geom_text(aes(fill = res.m$value, label = round(res.m$value, 2)), size=3)


## ----echo=FALSE,fig.height=5,fig.width=9---------------------------------
res <- matrix(NA,ncol=length(n.vote),nrow=length(sd.diff))
colnames(res) <- n.vote
rownames(res) <- sd.diff
for(n in 1:length(n.vote)){
  for(s in 1:length(sd.diff)){
    utils <- rmsn(n=n.vote[n]*n.sim, xi=c(0+sd.diff[s],0-sd.diff[s]), Omega=matrix(c(1,.9,.9,1),nrow=2), alpha=c(0,-10))
    a <- matrix(utils[,1],nrow=n.vote[n])
    b <- matrix(utils[,2],nrow=n.vote[n])
    res[s,n] <- eff(a,b)
  }
}
res.m <- melt(res); res.m[,1] <- as.factor(res.m[,1]); res.m[,2] <- as.factor(res.m[,2])
qplot(x=Var1, y=Var2, data=res.m, fill=value, geom="tile",xlab="Mean Difference in Utility Distributions (+/-)", ylab="Number of Voters", main="Efficiency of Majority Election Results") + scale_fill_gradient2(limits=c(0,1),name="Proportion of\nEfficient Elections") + geom_text(aes(fill = res.m$value, label = round(res.m$value, 2)), size=3)


## ----echo=FALSE,fig.height=5,fig.width=9---------------------------------
res <- matrix(NA,ncol=length(n.vote),nrow=length(sd.diff))
colnames(res) <- n.vote
rownames(res) <- sd.diff
for(n in 1:length(n.vote)){
  for(s in 1:length(sd.diff)){
    utils <- rmsn(n=n.vote[n]*n.sim, xi=c(0+sd.diff[s],0-sd.diff[s]), Omega=matrix(c(1,-.9,-.9,1),nrow=2), alpha=c(0,-10))
    a <- matrix(utils[,1],nrow=n.vote[n])
    b <- matrix(utils[,2],nrow=n.vote[n])
    res[s,n] <- eff(a,b)
  }
}
res.m <- melt(res); res.m[,1] <- as.factor(res.m[,1]); res.m[,2] <- as.factor(res.m[,2])
qplot(x=Var1, y=Var2, data=res.m, fill=value, geom="tile",xlab="Mean Difference in Utility Distributions (+/-)", ylab="Number of Voters", main="Efficiency of Majority Election Results") + scale_fill_gradient2(limits=c(0,1),name="Proportion of\nEfficient Elections") + geom_text(aes(fill = res.m$value, label = round(res.m$value, 2)), size=3)


## ----echo=FALSE,fig.height=6,fig.width=7,message=FALSE-------------------
a <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=.75,omega=1,alpha=-10),Candidate="A")
b <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=-.75,omega=1,alpha=10),Candidate="B")
diff <- data.frame(Utility=a[,1] - b[,1],Candidate="Difference")
data <- data.frame(rbind(a,b,diff))
ggplot(data, aes(x=Utility, fill=Candidate)) + 
  ggtitle("Example of Utility Distributions with Means +/- .75") +
  geom_density(alpha=.3) +
  scale_y_continuous(name="Density") +
  geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=mean(Utility)), color="blue",linetype=1) +
  geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=median(Utility)), color="darkblue",linetype=2)


## ----echo=FALSE,fig.height=6,fig.width=7,message=FALSE-------------------
a <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=0,omega=1,alpha=-10),Candidate="A")
b <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=0,omega=1,alpha=10),Candidate="B")
diff <- data.frame(Utility=a[,1] - b[,1],Candidate="Difference")
data <- data.frame(rbind(a,b,diff))
ggplot(data, aes(x=Utility, fill=Candidate)) + 
  ggtitle("Example of Utility Distributions with Means +/- 0") +
  geom_density(alpha=.3) +
  scale_y_continuous(name="Density") +
  geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=mean(Utility)), color="blue",linetype=1) +
  geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=median(Utility)), color="darkblue",linetype=2)


## ----echo=FALSE,fig.height=6,fig.width=7,message=FALSE-------------------
a <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=0,omega=1,alpha=-10),Candidate="A")
b <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=-1,omega=1,alpha=10),Candidate="B")
diff <- data.frame(Utility=a[,1] - b[,1],Candidate="Difference")
data <- data.frame(rbind(a,b,diff))
ggplot(data, aes(x=Utility, fill=Candidate)) + 
  ggtitle("Example of Utility Distributions with Means +/- 1") +
  geom_density(alpha=.3) +
  scale_y_continuous(name="Density") +
  geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=mean(Utility)), color="blue",linetype=1) +
  geom_vline(data=data[data$Candidate=="Difference",], aes(xintercept=median(Utility)), color="darkblue",linetype=2)


