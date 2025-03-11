#!/bin/bash



# Directorio de salida para los resultados de FastQC

outdir="fastqc_results"

mkdir -p "$outdir"



# Directorio donde se encuentran las lecturas descargadas

download_dir="fasterq_downloads"



# Itera por cada línea del archivo samples.txt

while IFS= read -r sample; do

    echo "Procesando la muestra: $sample"

    fastqc "${download_dir}/${sample}_1.fastq" "${download_dir}/${sample}_2.fastq" --outdir "$outdir"

done < samples.txt


