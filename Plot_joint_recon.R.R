library(corHMM)
library(phytools)
library(ggtree)
library(ggplot2)
library(dplyr)

load("Species.3HRC.Precursor.custom_p_NUM.RData")
Alttaxtree <- read.tree("../../ultrametric.Rosids.alternativeBB.pxrlt.tree")
#Node states
node.states <- as.data.frame(Species.3HRC.Precursor.custom_p_80$states)
colnames(node.states) <- "states"
#Make the row name a column called node and make it numeric
node.states<- cbind(node=rownames(node.states),node.states,row.names=NULL)
node.states$node <- as.numeric(node.states$node)
#Tip states
tip.states
tip.states <- as.data.frame(Species.3HRC.Precursor.custom_p_80$tip.states)
colnames(tip.states) <- "states"
#Make the row name a column called node and make it numeric
tip.states<- cbind(node=rownames(tip.states),tip.states,row.names=NULL)
tip.states$node <- as.numeric(tip.states$node)
#Add number of tips to the node.state data because of how ggplot codes the tips
node.states$node <- node.states[, 1] + length(Species.3HRC.Precursor.custom_p_80$phy$tip.label)
#Combine the node and tip state dataframes
all.states <- rbind(node.states,tip.states)
all.states$states <- as.character(all.states$states)

#Plotting subtrees
#Plot the non-circle tree with skinny branches
p <- ggtree(Alttaxtree,ladderize=FALSE,continuous="none",size=0.05) %<+% all.states + aes(color=states)+theme(legend.key.height=unit(.5, "cm"),legend.key.wid=unit(.5, "cm"))
#color branches
tiff(filename = "Plot.NUM.png", res = 300,
     width = 6, height = 8,units='in')
p+scale_colour_manual(values = c("orange","cyan","orangered","dodgerblue","red4","darkblue"))
dev.off()
