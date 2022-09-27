options(timeout=1000)
library(GEOquery)
args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

getGEOSuppFiles("GSE157220", makeDirectory=FALSE, baseDir=work_dir)
gunzip(file.path(work_dir, "GSE157220_CPM_data.txt.gz"))