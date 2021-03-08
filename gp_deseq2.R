##
## Copyright (c) 2019 Broad Institute, Inc. and Massachusetts Institute of Technology.  All rights reserved.
##

GP.deseq2.normalize <- function(gct, output.file.base, random.seed) {

    if (!is.null(random.seed) && !is.na(random.seed)) {
       set.seed(random.seed)
    }

coldata <- as.data.frame(colnames(gct$data), stringsAsFactors = FALSE, header = FALSE)
colnames(coldata) <- c("EXPERIMENT")
rownames(coldata) <- colnames(gct$data)

    # Filter out any low expression rows (with only 0 or 1 read) for better memory usage & speed of transformation.
    data_filtered <- round(gct$data[rowSums(gct$data) > 1,])


    dds <- DESeqDataSetFromMatrix(countData = data_filtered, colData = coldata, design = ~ 1)
    dds <- estimateSizeFactors(dds)

        write.reports(dds, output.file.base)
}

write.reports <- function(dds, output.file.base) {

    # Write the normalized counts table.  This can be fed into GSEA downstream.
    normCounts <- counts(dds, normalized=TRUE)
    row.descriptions <- c(rep("n/a", times = length(row.names(normCounts))))
    normCountsGct <- list(row.descriptions=row.descriptions, data=as.matrix(normCounts))
    write.gct(normCountsGct, file = paste0(output.file.base, ".normalized_counts.gct"), check.file.extension=FALSE)
    write.table(as.data.frame(normCounts), sep='\t', quote=FALSE,
               file=paste0(output.file.base, ".normalized_counts.txt"))

    # Write an alternative (vst) normalized counts table.  This can be fed into GSEA downstream.
    # vstnormCounts <- vst(dds, blind = TRUE)
    # row.descriptions <- c(rep("n/a", times = length(row.names(vstnormCounts))))
    # vstnormCountsGct <- list(row.descriptions=row.descriptions, data=as.matrix(assay(vstnormCounts)))
    # write.gct(vstnormCountsGct, file = paste0(output.file.base, ".vst.normalized_counts.gct"), check.file.extension=FALSE)
    # write.table(as.data.frame(assay(vstnormCounts)), sep='\t', quote=FALSE,
    #            file=paste0(output.file.base, ".vst.normalized_counts.txt"))

    # Write an alternative (rlog) normalized counts table.  This can be fed into GSEA downstream.
    # rlognormCounts <- rlog(dds, blind = TRUE)
    # row.descriptions <- c(rep("n/a", times = length(row.names(rlognormCounts))))
    # rlognormCountsGct <- list(row.descriptions=row.descriptions, data=as.matrix(assay(rlognormCounts)))
    # write.gct(rlognormCountsGct, file = paste0(output.file.base, ".rlog.normalized_counts.gct"), check.file.extension=FALSE)
    # write.table(as.data.frame(assay(rlognormCounts)), sep='\t', quote=FALSE,
    #            file=paste0(output.file.base, ".rlog.normalized_counts.txt"))
}
