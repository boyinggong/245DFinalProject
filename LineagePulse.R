
# ========== Read data ==========

normalizedCounts <- as.matrix(read.table("data/normalisedCountsVariableGenes.txt", header=TRUE, sep = ""))
rawCounts <- read.table("data/rawCounts.txt", header=TRUE, sep = "")
rownames(rawCounts) <- rawCounts$ID
rawCounts$ID <- NULL
rawCounts <- as.matrix(rawCounts)
# subset the raw counts
rawCounts <- rawCounts[rownames(normalizedCounts), colnames(normalizedCounts)]
# load the pseudo time data
load("output/pseudotimes.RData")
rownames(psdt) <- colnames(normalizedCounts)

# ========== Lineage ==========

for (lineageIdx in 1:ncol(psdt)){
  pseudotime <- psdt[, paste0("curve", lineageIdx)]
  annot <- data.frame(cell = colnames(normalizedCounts),
                      continuous = pseudotime,
                      row.names = colnames(normalizedCounts))
  rawCountsSubset <- rawCounts[, !is.na(pseudotime)]
  annot <- annot[!is.na(pseudotime), ]
  
  objLP <- runLineagePulse(
    counts = rawCountsSubset,
    dfAnnotation = annot)
  save(objLP, file = paste0("output/lineage", lineageIdx, ".RData"))
}
