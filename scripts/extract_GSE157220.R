library(readxl)
library(data.table)

args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]
filename <- args[2]

download_dir <- paste0(work_dir, 'download')
data_dir <- paste0(work_dir, 'data')
dir.create(data_dir)

CPM_data <- read.table(file.path(download_dir, "GSE157220_CPM_data.txt"),row.names = 1,header = TRUE)
pool_data <- read_excel(file.path(download_dir, "GSE157220_Pool_composition.xlsx"))

CPM_cols <- data.frame(colnames(CPM_data))
pools <- unique(pool_data$Pool_ID)[1:8]

value <- CPM_cols[CPM_cols$colnames.CPM_data. %like% "c",]
new_matrix <- CPM_data[,value]
saveRDS(new_matrix, file=file.path(data_dir, paste0('pool.custom.rds')))

for (i in pools) {
  value <- CPM_cols[CPM_cols$colnames.CPM_data. %like% paste(".",i,sep = ''),]
  new_matrix <- CPM_data[,value]
  saveRDS(new_matrix, file=file.path(data_dir, paste0('pool.', i, '.rds')))
}

