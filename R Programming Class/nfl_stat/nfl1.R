stat1 <- function(){
    library(sqldf)
    library(ggplot2)
    library(dplyr)
    
    data12 <- read.csv("./nfl_stat/years_2012_passing_passing.csv",header=TRUE,nrow=29)
    data13 <- read.csv("./nfl_stat/years_2013_passing_passing.csv",header=TRUE,nrow=29)
    data14 <- read.csv("./nfl_stat/years_2014_passing_passing.csv",header=TRUE,nrow=29)
    data15 <- read.csv("./nfl_stat/years_2015_passing_passing.csv",header=TRUE,nrow=29)
    
    data12 = mutate(data12,year=2012)
    data13 = mutate(data13,year=2013)
    data14 = mutate(data14,year=2014)
    data15 = mutate(data15,year=2015)
    
    sub12.td = sqldf('select X,TD,Yds,year from data12 order by TD desc')
    sub13.td = sqldf('select X,TD,Yds,year from data13 order by TD desc')
    sub14.td = sqldf('select X,TD,Yds,year from data14 order by TD desc')
    sub15.td = sqldf('select X,TD,Yds,year from data15 order by TD desc')
    
    sub12.td$X = gsub("\\*||\\+","",sub12.td$X)
    sub13.td$X = gsub("\\*||\\+","",sub13.td$X)
    sub14.td$X = gsub("\\*||\\+","",sub14.td$X)
    sub15.td$X = gsub("\\*||\\+","",sub15.td$X)
    
    temp1 = sub12.td[sub12.td$X %in% sub13.td$X,]
    temp2 = temp1[temp1$X %in% sub14.td$X,]
    qb_names = temp2[temp2$X %in% sub15.td$X,]
    num_qbs = sqldf('select count(distinct X) as Num_QBs from qb_names')
    comb_year = rbind(sub12.td,sub13.td,sub14.td,sub15.td)
    comb_year = comb.year[comb.year$X%in%qb_names$X,]
    comb_year$year = factor(comb.year$year)
    
    joe = sqldf('select X,TD,Yds,year from comb_year where X = "Joe Flacco"')
    
    comb_year$X = factor(comb.year$X)
    
    g = ggplot(comb.year,aes(X,TD))
    g + facet_wrap(~year) + geom_bar(stat='identity',fill='#350A50')+ geom_bar(stat='identity',data=joe,aes(X,TD),fill='gold') +
        theme(axis.text.x=element_text(angle=90,hjust=1)) + geom_hline(aes(yintercept=TD),joe,color='gold')
    
    
    
    
    
    
    
}    
    