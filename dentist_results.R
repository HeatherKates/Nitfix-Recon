library(corHMM)
library(dplyr)
library(stringr)
#Load ten .RData files that each include a corhmm object
files=list.files(path="../",pattern=".*dentist.RData")
for (i in 1:9){load(paste("../",files[i],sep=""))
  name=paste("confidence_results",i,sep="")
  assign(name,confidence_results)
  }
#Make a list of the confidence_results objects
dentists=mget(ls(pattern="confidence_results.*"))

#function
select_top_ips <- function(x) {
  #data frame of the results
  newdata = x[x$neglnL,]
  name=deparse(substitute(x))
  #set up and filter unique parameter sets
  param_vars=as.vector(as.character(letters[1:11]))
  colnames(newdata)=c("neglnL",param_vars)
  new=distinct(newdata, a,b,c,d,e,f,g,h,i,j,k, .keep_all = TRUE)
  #subset the top ten rows to come up with the set of ip values for plotting
  new.sorted=head(arrange(new,neglnL,.by_group = FALSE),10)
  assign(name,new.sorted,envir = .GlobalEnv)
}
#loop through the number of dentist objects and run the function
for (i in 1:9){
  ip=select_top_ips(dentists[1]$confidence_results$results)
  iname=paste("ip",i,sep="")
  assign(iname,ip)
}
#combine and write ip values to csv sheet formatted to be looped through by corHMM
Pattern1<-grep("ip\\d",names(.GlobalEnv),value=TRUE)
Pattern1_list<-do.call("list",mget(Pattern1))
All_ips=as.data.frame(bind_rows(Pattern1_list, .id = "neglnL"))
      