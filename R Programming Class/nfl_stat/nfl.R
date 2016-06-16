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
    
    sub12_td = sqldf('select X,TD,Rate,year from data12 order by TD desc')
    sub13_td = sqldf('select X,TD,Rate,year from data13 order by TD desc')
    sub14_td = sqldf('select X,TD,Rate,year from data14 order by TD desc')
    sub15_td = sqldf('select X,TD,Rate,year from data15 order by TD desc')
    
    sub12_td$X = gsub("\\*||\\+","",sub12_td$X)
    sub13_td$X = gsub("\\*||\\+","",sub13_td$X)
    sub14_td$X = gsub("\\*||\\+","",sub14_td$X)
    sub15_td$X = gsub("\\*||\\+","",sub15_td$X)
    
    temp1 = sub12_td[sub12_td$X %in% sub13_td$X,]
    temp2 = temp1[temp1$X %in% sub14_td$X,]
    qb_names = temp2[temp2$X %in% sub15_td$X,]
    num_qbs = sqldf('select count(distinct X) as Num_QBs from qb_names')
    comb_year = rbind(sub12_td,sub13_td,sub14_td,sub15_td)
    combrate_year = comb_year
    comb_year = comb_year[comb_year$X%in%qb_names$X,]
    comb_year$year = factor(comb_year$year)
    
    joe = sqldf('select X,TD,Rate,year from comb_year where X = "Joe Flacco"')
    
    
    hi_joe12 = sqldf('select count(X) from comb_year where TD > (select TD from comb_year where
                    X = "Joe Flacco" and year = 2012) and year=2012')
    hi_joe13 = sqldf('select count(X) from comb_year where TD > (select TD from comb_year where
                    X = "Joe Flacco" and year = 2013) and year=2013')
    hi_joe14 = sqldf('select count(X) from comb_year where TD > (select TD from comb_year where
                    X = "Joe Flacco" and year = 2014) and year=2014')
    hi_joe15 = sqldf('select count(X) from comb_year where TD > (select TD from comb_year where
                    X = "Joe Flacco" and year = 2015) and year=2015')
    
    rate_qb = sqldf('select X from comb_year where TD > (select TD from comb_year
                   where X = "Joe Flacco" and year = 2014) and year = 2014')
    combrate_year = combrate_year[combrate_year$X %in% rate_qb$X,]
    combrate_year= rbind(combrate_year,joe)
    
    comb_year$X = factor(comb_year$X)
    
    ggplot(combrate_year,aes(year,Rate,group=X))+geom_line(aes(color=X)) +
        scale_color_brewer(palette='Set3')
    
    g = ggplot(comb_year,aes(X,TD))
    g + facet_wrap(~year) + geom_bar(stat='identity',fill='#350A50')+ geom_bar(stat='identity',data=joe,aes(X,TD),fill='gold') +
       theme(axis.text.x=element_text(angle=90,hjust=1)) + geom_hline(aes(yintercept=TD),joe,color='gold')
    
   
    
    
    
    
    
}    
    