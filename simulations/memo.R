# check normal and skewed distributions
# check real means and medians for scenarios
# look closer at distributions where efficiency doesn't work


## ----echo=FALSE----------------------------------------------------------
setwd("/data/Dropbox/Uni/TA_Peter/voting")

### load required packages
suppressPackageStartupMessages(library(MASS))
suppressPackageStartupMessages(library(sn))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(reshape2))

### set simulation parameters
n.vote <- c(10,20,50,100,200,500,1000,2000,5000,10000)
sd.diff <- c(0,0.005,0.01,0.025,0.05,0.1,0.25,0.5,0.75,1)
n.sim <- 1000
set.seed(123)


a <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=0,omega=1,alpha=-10),Candidate="A")
b <- data.frame(Utility=rsn(n.vote[length(n.vote)],xi=0,omega=1,alpha=10),Candidate="B")
diff <- data.frame(Utility=a[,1] - b[,1],Candidate="Difference")


utils <- rmsn(n=n.vote[length(n.vote)], xi=c(0,0), Omega=matrix(c(1,0,0,1),nrow=2), alpha=c(-100,100))
a <- data.frame(Utility=utils[,1],Candidate="A")
b <- data.frame(Utility=utils[,2],Candidate="B")
diff <- data.frame(Utility=a[,1] - b[,1],Candidate="Difference")

data <- data.frame(rbind(a,b,diff))
ggplot(data, aes(x=Utility, fill=Candidate)) + 
  ggtitle("Example of Utility Distributions with Means +/- 1") +
  geom_density(alpha=.3) +
  scale_y_continuous(name="Density")
