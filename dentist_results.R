library(corHMM)
library(dplyr)
library(stringr)

#This is setup to run on nine dentist outputs that were generated for the nine top likelihoods out of 100 nstarts of corHMM (identical models!)
#A normal run of corHMM with nstarts=100 for example would generate one output, but because I did it manually I can access more. fyi.

#Load ten .RData files that each include a corhmm object
files=list.files(path="../",pattern=".*dentist.RData")
for (i in 1:9){load(paste("../",files[i],sep=""))
  name=paste("confidence_results",i,sep="")
  assign(name,confidence_results)
  }
#Make a list of the confidence_results objects
dentists=mget(ls(pattern="confidence_results.*"))

#function to select the top ten parameter sets output by dentist for each dentist run (in this case 9 for 9 top ML corHMM runs)
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
write.table(All_ips,"../Top.10.ips.from.9.best.starts.csv",row.names = FALSE,quote = FALSE,col.names = FALSE,sep = ",")      

#Code run after to set up parallel runs of corHMM using p to compare reconstructions
#make each line in R vector format
#sed 's/ip[0-9],/c(/g' Top.10.ips.from.9.best.starts.csv |sed 's/$/)/g'>List_of_p_values.txt
#Loop through and replace the p value with a line from the List_of_p_values and write a new .R script
#for i in {1..90}; do p=$(head -n $i List_of_p_values.txt |tail -1); sed "s/,p=NULL/,p=$p/g" Species.3HRC.Precursor.customp.R > Species.3HRC.Precursor.customp.${i}.R; done    
#change to joint recon
#for i in {1..90}; do sed -i 's/none/joint/g' Species.3HRC.Precursor.customp.${i}.R; done
#change name of R object
#for i in {1..90}; do sed -i "s/02starts/custom_p_$i/g" Species.3HRC.Precursor.customp.${i}.R; done
#change name of RData file
#for i in {1..90}; do sed -i "s/02restarts/custom_p_$i/g" Species.3HRC.Precursor.customp.${i}.R; done