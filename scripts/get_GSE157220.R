library(GEOquery)
library(SummarizedExperiment)
library(readxl)
library(data.table)

args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]
filename <- args[2]

download_dir <- paste0(work_dir, 'download')
data_dir <- paste0(work_dir, 'data')

pool_data <- read_excel(file.path(download_dir, "GSE157220_Pool_composition.xlsx"))
pools <- unique(pool_data$Pool_ID)[1:8]

new_matrix <- readRDS(file.path(data_dir, 'pool.custom.rds'))
new_colData <- data.frame(pool_id=rep("c",ncol(new_matrix)),row.names = colnames(new_matrix))
new_rowData <- data.frame(type=rep("Gene",nrow(new_matrix)),row.names = rownames(new_matrix))
new_metaData <- list(data.frame(pool_data[pool_data$Pool_ID == "custom",]))
experiment <- SummarizedExperiment(assays = new_matrix,colData = new_colData,rowData = new_rowData,metadata = new_metaData)

experiment_list <- list(experiment)

for (i in pools) {
  new_matrix <- readRDS(file.path(data_dir, paste0('pool.', i, '.rds')))
  new_colData <- data.frame(pool_id=rep(i,ncol(new_matrix)),row.names = colnames(new_matrix))
  new_rowData <- data.frame(type=rep("Gene",nrow(new_matrix)),row.names = rownames(new_matrix))
  new_metaData <- list(data.frame(pool_data[pool_data$Pool_ID == i,]))
  experiment <- SummarizedExperiment(assays = new_matrix,colData = new_colData,rowData = new_rowData,metadata = new_metaData)
  experiment_list <- append(experiment_list,experiment)
}
names(experiment_list) <- c("custom Pools",paste("Pool",pools))

saveRDS(experiment_list, file.path(work_dir, filename))
