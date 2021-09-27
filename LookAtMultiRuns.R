#Load ten .RData files that each include a corhmm object
files=list.files(pattern=".*0.*RData")
for (i in 1:10){load(files[i])}
#Make a list of the corhmm objects
corhmms=mget(ls(pattern=".*0.*"))
#loop over the corhmm objects to 
lapply(corhmms, `[[`, 1)
