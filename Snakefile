from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
S3 = S3RemoteProvider(
    access_key_id=config["key"], 
    secret_access_key=config["secret"],
    host=config["host"],
    stay_on_remote=False
)
prefix = config["prefix"]
filename = config["filename"]

pools = ["custom", "6", "9", "10", "15", "16", "18", "19", "22"]

rule get_SummarizedExp:
    input:
        S3.remote(expand(prefix + "data/pool.{pool}.rds", pool=pools)),
        S3.remote(prefix + 'download/GSE157220_Pool_composition.xlsx')
    output:
        S3.remote(prefix + filename)
    resources:
        mem_mb=15000
    shell:
        """
        Rscript scripts/get_GSE157220.R \
        {prefix} \
        {filename}
        """

rule extract_data:
    input:
        S3.remote(prefix + 'download/GSE157220_CPM_data.txt'),
        S3.remote(prefix + 'download/GSE157220_Pool_composition.xlsx')
    output:
        S3.remote(expand(prefix + "data/pool.{pool}.rds", pool=pools))
    shell:
        """
        Rscript scripts/extract_GSE157220.R \
        {prefix}
        """

rule download_data:
    output:
        S3.remote(prefix + 'download/GSE157220_CPM_data.txt'),
        S3.remote(prefix + 'download/GSE157220_Pool_composition.xlsx')
    shell:
        """
        Rscript scripts/download_GSE157220.R \
        {prefix}
        """