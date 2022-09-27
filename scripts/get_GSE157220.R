library(SummarizedExperiment)
library(readxl)
library(data.table)

args <- commandArgs(trailingOnly = TRUE)
work_dir <- args[1]
filename <- args[2]

CPM_data <- read.table(file.path(work_dir, "download", "GSE157220_CPM_data.txt"), row.names = 1, header = TRUE)
pool_data <- read_excel(file.path(work_dir, "download", "GSE157220_Pool_composition.xlsx"))
new_value <- c()
CPM_cols <- data.frame(colnames(CPM_data))
pools <- unique(pool_data$Pool_ID)[1:8]
value <- CPM_cols[CPM_cols$Cell_ID %like% "c",]
new_matrix <- CPM_data[,value]
new_colData <- data.frame(pool_id=rep("c",ncol(new_matrix)),row.names = colnames(new_matrix))
new_rowData <- data.frame(type=rep("Gene",nrow(new_matrix)),row.names = rownames(new_matrix))
new_metaData <- list(data.frame(pool_data[pool_data$Pool_ID == "custom",]))
experiment <- SummarizedExperiment(assays = new_matrix,colData = new_colData,rowData = new_rowData,metadata = new_metaData)

experiment_list <- list(experiment)

for (i in pools) {
  value <- CPM_cols[CPM_cols$Cell_ID %like% paste(".", i, sep = ''), ]
  new_matrix <- CPM_data[, value]
  new_colData <- data.frame(pool_id=rep(i,ncol(new_matrix)),row.names = colnames(new_matrix))
  new_rowData <- data.frame(type=rep("Gene",nrow(new_matrix)),row.names = rownames(new_matrix))
  new_metaData <- list(data.frame(pool_data[pool_data$Pool_ID == i,]))
  experiment <- SummarizedExperiment(assays = new_matrix,colData = new_colData,rowData = new_rowData,metadata = new_metaData)
  experiment_list <- append(experiment_list,experiment)
}
names(experiment_list) <- c("custom Pools", paste("Pool", pools))

saveRDS(experiment_list, file.path(work_dir, filename))