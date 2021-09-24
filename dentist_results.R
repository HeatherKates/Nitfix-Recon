library(corHMM)
library(dplyr)
#Load ten .RData files that each include a corhmm object
files=list.files(pattern=".*dentist.RData")
for (i in 1:9){load(files[i])
  name=paste("confidence_results",i,sep="")
  assign(name,confidence_results)
  }
#Make a list of the confidence_results objects
dentists=mget(ls(pattern="confidence_results.*"))

lapply(dentists, `[[`, 1)



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
for (i in 1:1){
  ip=select_top_ips(dentists[1]$confidence_results$results)
  iname=paste("ip",i,sep="")
  assign(iname,ip)
}
test=as.data.frame(dentists[1]$confidence_results$results)
