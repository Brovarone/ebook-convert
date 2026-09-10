#!/bin/bash

# --- CONFIGURAZIONE ---
TARGET_DIR="/mnt/biblioteca/bookdrop"
# ----------------------

cd "$TARGET_DIR" || exit 1

# 1. CERCA EPUB SENZA AZW3
for epub_file in *.epub; do
    [ -e "$epub_file" ] || continue

    filename="${epub_file%.*}"
    azw3_file="${filename}.azw3"

    if [ ! -f "$azw3_file" ]; then
        echo "[$(date)] Generazione di $azw3_file da $epub_file..."

        # Esegue la conversione usando la tua immagine aggiornata e leggera
        docker run --rm \
          -v "$TARGET_DIR":/target \
          mio-convertitore:latest \
          "$epub_file" "$azw3_file"

        # Imposta i permessi corretti per evitare che Grimmory si blocchi
        chmod 666 "$azw3_file"
    fi
done

# 2. CERCA AZW3 SENZA EPUB
for azw3_file in *.azw3; do
    [ -e "$azw3_file" ] || continue

    filename="${azw3_file%.*}"
    epub_file="${filename}.epub"

    if [ ! -f "$epub_file" ]; then
        echo "[$(date)] Generazione di $epub_file da $azw3_file..."

        docker run --rm \
          -v "$TARGET_DIR":/target \
          mio-convertitore:latest \
          "$azw3_file" "$epub_file"

        chmod 666 "$epub_file"
    fi
done
