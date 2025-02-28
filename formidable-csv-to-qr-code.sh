#!/bin/bash

# Check to see if dependencies are installed, duckDB and qrencode
if ! command -v duckdb &> /dev/null; then
  echo "Error: duckdb is not installed or not in PATH."
  exit 1
fi

if ! command -v qrencode &> /dev/null; then
  echo "Error: qrencode is not installed or not in PATH."
  exit 1
fi

# Input CSV file
INPUT_CSV="mfr.csv"
COLUMN="id"

# Base URL
BASE_URL="https://claytoncountyforms.claytoncountyga.gov/mfr/entry/"

# Output directory for QR codes
OUTPUT_DIR="qrcodes"

# Delete directory and recreate it
rm -r "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

# Use duckdb to extract the 'id' column
duckdb -c "COPY (SELECT $COLUMN FROM read_csv('$INPUT_CSV')) TO STDOUT (HEADER FALSE)" | while read ID; do
  # Construct the full URL
  FULL_URL="$BASE_URL$ID"

  # Generate the QR code
  qrencode -o "$OUTPUT_DIR/${ID}.png" "$FULL_URL"
  if [ $? -ne 0 ]; then
    echo "Error: qrencode failed for ID: $ID"
  fi

  # Optional: Echo the generated QR code filename and URL
  echo "Generated: $OUTPUT_DIR/${ID}.png for URL: $FULL_URL"
done

echo "QR code generation complete."
