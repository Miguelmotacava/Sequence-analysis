#!/bin/bash



# Directorio donde se encuentran los resultados de Trimmomatic

TRIM_DIR="trimmomatic_results"



# Directorio de salida para los resultados de FastQC

OUTDIR="fastqc_results"

mkdir -p "$OUTDIR"



# Itera por cada muestra (ID) listada en samples.txt

for sample in $(cat samples.txt); do

    # Itera sobre los posibles números de lectura (1 y 2)

    for read in 1 2; do

        # Construye los nombres de archivo para "paired" y "unpaired" en el directorio de trimmomatic

        file_paired="${TRIM_DIR}/${sample}_${read}_paired.fastq"

        file_unpaired="${TRIM_DIR}/${sample}_${read}_unpaired.fastq"

        

        # Comprueba y ejecuta FastQC si el archivo "paired" existe

        if [[ -f "$file_paired" ]]; then

            echo "Procesando $file_paired"

            fastqc "$file_paired" --outdir "$OUTDIR"

        fi



        # Comprueba y ejecuta FastQC si el archivo "unpaired" existe

        if [[ -f "$file_unpaired" ]]; then

            echo "Procesando $file_unpaired"

            fastqc "$file_unpaired" --outdir "$OUTDIR"

        fi

    done

done


