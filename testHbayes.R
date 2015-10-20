d <- read.csv(url("http://hosho.ees.hokudai.ac.jp/~kubo/stat/iwanamibook/fig/hbm/data7a.csv"))
head(d)

dat<-list(N=nrow(d), y=d$y)
