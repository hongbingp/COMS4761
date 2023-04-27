
library(grid)

label = read_excel("data/resistant_strains.xlsx")
colnames(label)[which(colnames(label) == 'x')] <- 'ID'

dir_path <- "C:/Users/PHB/Comp_Genomics/data/var_ano/"

name = label[which(label$Antibiotic=='TET'),c('ID','Parent')]
name = name[order(name$Parent), ]

merged = data.frame(Gene = character(), stringsAsFactors = FALSE)

for (strain in name$ID) {
  #show(strain)
  p = paste(dir_path,strain,sep='','.csv')
  if (!file.exists(p)) {
    # Skip the file and move on to the next one
    next
  }
  df = read.csv(p)
  if (nrow(df) == 0) {
    next
  }
  genecount = as.data.frame(table(df$Gene,exclude = ""))
  colnames(genecount) = c('Gene',strain)
  merged <- merge(merged, genecount, by = "Gene", all = TRUE)
}

merged$row_sums <- rowSums(merged[, -1], na.rm = TRUE)
target = merged[order(merged$row_sums,decreasing = TRUE), 'Gene'][1:10]
show(target)
#t = as.data.frame(table(merged$Gene,exclude = ""))


# Convert the dataframe to a matrix and replace NA values with a placeholder value
mat <- as.matrix(merged[, -1])
mat[is.na(mat)] <- -999

# Create a heatmap of the gene expression matrix

# TET:#4baba9, CRO:#EC8F3F, CIP:#478058, AMP:#8B7F8B

heatmap(mat, Rowv = NA, Colv = NA, 
        col = colorRampPalette(c("#E1E1DF", "#8B7F8B"))(256), 
        scale = "none",
        labRow = merged$Gene,       
        cexCol = 0.8,
        sepcolor='black')




