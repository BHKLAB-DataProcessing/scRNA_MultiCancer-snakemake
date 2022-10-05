options(timeout=1000)
library(GEOquery)
args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]

download_dir <- paste0(work_dir, 'download')
dir.create(download_dir)
getGEOSuppFiles("GSE157220", makeDirectory=FALSE, baseDir=download_dir)
gunzip(
  filename=file.path(download_dir, "GSE157220_CPM_data.txt.gz")
)
file.remove(file.path(download_dir, "GSE157220_CPM_data.txt.gz"))
