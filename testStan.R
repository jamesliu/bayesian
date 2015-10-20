library(rstan)
dat <- read.csv("data/conflict_sample.txt", sep=" ")
dat$cv <- as.numeric(dat$cv)-1

conflict.dat<-list(x1=dat$a1,x2=dat$a2,x3=dat$a3,x4=dat$a4,x5=dat$a5,x6=dat$a6,x7=dat$a7,y=dat$cv,N=3000)
conflict.fit<-stan(file="conflict2.stan",data=conflict.dat,iter=1000,chains=4)

library(coda)
conflict.fit.coda<-mcmc.list(lapply(1:ncol(conflict.fit),function(x) mcmc(as.array(conflict.fit)[,x,])))
par(mar = rep(2, 4))
plot(conflict.fit.coda)

d.ext<-extract(conflict.fit,permuted=T)

#N.mcmc<-length(d.ext$beta0)
#b1<-d.ext$beta[1:2000]
#b2<-d.ext$beta[2001:4000]
#b3<-d.ext$beta[4001:6000]
#b4<-d.ext$beta[6001:8000]
#b5<-d.ext$beta[8001:10000]
#b6<-d.ext$beta[10001:12000]
#b7<-d.ext$beta[12001:14000]

N.mcmc<-length(d.ext$b0)
b1<-d.ext$b1[1:2000]
b2<-d.ext$b2[1:2000]
b3<-d.ext$b3[1:2000]
b4<-d.ext$b4[1:2000]
b5<-d.ext$b5[1:2000]
b6<-d.ext$b6[1:2000]
b7<-d.ext$b7[1:2000]

bs2<-data.frame(b1=b1,b2=b2,b3=b3,b4=b4,b5=b5,b6=b6,b7=b7)

library(reshape)
bs2.melt<-melt(bs2,id=c(),variable="param")

library(plyr)
bs2.qua.melt<-ddply(bs2.melt,.(param),summarize,
                      median=median(value),
                      ymax=quantile(value,prob=0.975),
                      ymin=quantile(value,prob=0.025))
colnames(bs2.qua.melt)[2]<-"value"

bs2.melt<-data.frame(bs2.melt,ymax=rep(0,N.mcmc),ymin=rep(0,N.mcmc))
p<-ggplot(bs2.melt,aes(x=param,y=value,group=param,ymax=ymax,ymin=ymin,color=param))
p<-p+geom_violin(trim=F,fill="#5B423D",linetype="blank",alpha=I(1/3))
p<-p+geom_pointrange(data=bs2.qua.melt,size=0.4)
p<-p+labs(x="",y="")+theme(axis.text.x=element_text(size=11),axis.text.y=element_text(size=11))
ggsave(file="d7.png",plot=p,dpi=300,width=4,height=3)

