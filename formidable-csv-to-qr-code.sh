#!/bin/bash

# Input CSV file
INPUT_CSV="/home/rzimmerman/Downloads/qr/mfr.csv"

# Base URL
BASE_URL="https://claytoncountyforms.claytoncountyga.gov/mfr/entry/"

# Output directory for QR codes
OUTPUT_DIR="qrcodes"

# Delete directory and recreate it
rm -r "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Use duckdb to extract the 'id' column
/home/rzimmerman/.duckdb/cli/latest/duckdb -c "COPY (SELECT id FROM read_csv('$INPUT_CSV')) TO STDOUT (HEADER FALSE)" | while read ID; do
  # Construct the full URL
  FULL_URL="$BASE_URL$ID"

  # Generate the QR code
  qrencode -o "$OUTPUT_DIR/${ID}.png" "$FULL_URL"

  # Optional: Echo the generated QR code filename and URL
  echo "Generated: $OUTPUT_DIR/${ID}.png for URL: $FULL_URL"
done

echo "QR code generation complete."
