#!/usr/bin/env bash



THREADS=4

OUTDIR="trimmomatic_results"

DOWNLOAD_DIR="fasterq_downloads"



mkdir -p "$OUTDIR"



while read -r SAMPLE; do

  echo "Procesando: ${SAMPLE}"

  trimmomatic PE -threads "$THREADS" "${DOWNLOAD_DIR}/${SAMPLE}_1.fastq" "${DOWNLOAD_DIR}/${SAMPLE}_2.fastq" "$OUTDIR/${SAMPLE}_1_paired.fastq" "$OUTDIR/${SAMPLE}_1_unpaired.fastq" "$OUTDIR/${SAMPLE}_2_paired.fastq" "$OUTDIR/${SAMPLE}_2_unpaired.fastq" ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

  echo "Finalizado: ${SAMPLE}"

  echo "----------------------------------------"

done < samples.txt


