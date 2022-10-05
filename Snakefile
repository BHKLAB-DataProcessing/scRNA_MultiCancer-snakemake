from snakemake.remote.S3 import RemoteProvider as S3RemoteProvider
S3 = S3RemoteProvider(
    access_key_id=config["key"], 
    secret_access_key=config["secret"],
    host=config["host"],
    stay_on_remote=False
)
prefix = config["prefix"]
filename = config["filename"]

rule get_SummarizedExp:
    input:
        S3.remote(prefix + 'download/GSE157220_CPM_data.txt.gz'),
        S3.remote(prefix + 'download/GSE157220_Pool_composition.xlsx')
    output:
        S3.remote(prefix + filename)
    resources:
        mem_mb=8000,
        disk_mb=8000
    shell:
        """
        Rscript scripts/get_GSE157220.R \
        {prefix} \
        {filename}
        """

rule download_data:
    output:
        S3.remote(prefix + 'download/GSE157220_CPM_data.txt.gz'),
        S3.remote(prefix + 'download/GSE157220_Pool_composition.xlsx')
    shell:
        """
        Rscript scripts/download_GSE157220.R \
        {prefix}
        """