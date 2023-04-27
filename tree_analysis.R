

library(treeio)
library(ggtree)
library(readxl)
library(tidyr)
library(colorspace)
library(tidyr)
library(ggplot2)
#nwk <- system.file("extdata", "sample.nwk", package="treeio")
#tree <- read.tree(nwk)

tree_boot = read.tree('RAxML_bootstrap.treefile_raxml.txt')
tree_best = read.tree('RAxML_bestTree.treefile_raxml.txt')

btree = ggtree(tree_boot) + facet_wrap(~.id, ncol=10) 
show(btree)
ggsave("test.png", btree,width = 50, height = 50, units = "cm", limitsize = FALSE)


ggplot(tree_best, aes(x, y)) + geom_tree() + theme_tree() + geom_text(aes(label=node), hjust=-.3)



ggtree(tree_best) + theme_tree2()

df = data.frame(tree_best[["tip.label"]])
colnames(df) = 'ID'
label = read_excel("data/resistant_strains.xlsx")
colnames(label)[which(colnames(label) == 'x')] <- 'ID'
df2 = merge(df, label, by = 'ID',all.x=T)

anti = list(TET = c(df2[which(df2$Antibiotic=='TET'),'ID']),
           AMP = c(df2[which(df2$Antibiotic=='AMP'),'ID']),
           CIP = c(df2[which(df2$Antibiotic=='CIP'),'ID']),
           CRO = c(df2[which(df2$Antibiotic=='CRO'),'ID'])
)

tree_best = groupOTU(tree_best,anti,group_name = "anti")

p1 = ggtree(tree_best,aes(color=anti)) +
  geom_treescale()+
  geom_tiplab() + 
  scale_color_manual(values=c("black", rainbow_hcl(4))) + 
  theme(legend.position="right") + 
  theme_tree2() + xlim(0,4e-05)
show(p1)

par = list(Ancestor = c(df2[which(df2$Parent=='Ancestor'),'ID']),
           Ara_m6 = c(df2[which(df2$Parent=='Ara–6'),'ID']),
           Ara_m5 = c(df2[which(df2$Parent=='Ara–5'),'ID']),
           Ara_p5 = c(df2[which(df2$Parent=='Ara+5'),'ID']),
           Ara_p4 = c(df2[which(df2$Parent=='Ara+4'),'ID'])
           )
tree_par = groupOTU(tree_best,par,group_name = "par")
p2 = ggtree(tree_par,aes(color=par,linetype=par)) +
  geom_treescale()+
  geom_tiplab() + 
  scale_color_manual(values=c("black", rainbow_hcl(5))) + 
  theme(legend.position="right") + 
  theme_tree2() + xlim(0,4e-05)

show(p2)

ggtree(tree_par,aes(color=parent,linetype=parent)) +
  geom_treescale()+
  geom_tiplab() + 
  scale_color_manual(values=c("black", rainbow_hcl(5))) 


