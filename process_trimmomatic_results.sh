#!/usr/bin/env bash



# Directorios

FASTQC_DIR="fastqc_results"

TRIM_DIR="trimmomatic_results"

SAMPLES_FILE="samples.txt"



# Itera sobre cada muestra en samples.txt

while read -r SAMPLE; do

    echo "Verificando FastQC para la muestra: ${SAMPLE}"

    PASS=true

    # Verifica los reportes de FastQC para lectura 1 y 2 (paired)

    for read in 1 2; do

        fastqc_report="${FASTQC_DIR}/${SAMPLE}_${read}_paired_fastqc.html"

        if [[ ! -f "$fastqc_report" ]]; then

            echo "  No se encontró el reporte: $fastqc_report"

            PASS=false

        else

            echo "  Reporte encontrado: $fastqc_report"

        fi

    done



    # Si ambos reportes existen, continúa con el ensamblaje

    if [ "$PASS" = true ]; then

        echo "FastQC OK para ${SAMPLE}. Ejecutando ensamblaje con SPAdes..."

        SPADES_OUT="spades_out_${SAMPLE}"

        QUAST_OUT="quast_results_${SAMPLE}"

        FILE1="${TRIM_DIR}/${SAMPLE}_1_paired.fastq"

        FILE2="${TRIM_DIR}/${SAMPLE}_2_paired.fastq"

        

        if [[ -f "$FILE1" && -f "$FILE2" ]]; then

            spades.py --careful -1 "$FILE1" -2 "$FILE2" -o "$SPADES_OUT"

            echo "Ensamblaje finalizado para ${SAMPLE}."

            if [[ -f "$SPADES_OUT/scaffolds.fasta" ]]; then

                echo "Ejecutando QUAST para ${SAMPLE}..."

                quast.py "$SPADES_OUT/scaffolds.fasta" -o "$QUAST_OUT"

                echo "QUAST finalizado para ${SAMPLE}."

            else

                echo "No se encontró scaffolds.fasta en ${SPADES_OUT} para ${SAMPLE}."

            fi

        else

            echo "No se encontraron archivos paired para ${SAMPLE} en ${TRIM_DIR}."

        fi

    else

        echo "FastQC no pasó para ${SAMPLE}, se omite ensamblaje."

    fi

    echo "----------------------------------------"

done < "$SAMPLES_FILE"


