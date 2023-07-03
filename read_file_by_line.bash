#!/bin/bash

echo "Current folder $(dirname "$0")"

while IFS= read -r line; do
  printf '%s\n' "$line"
done < ./input_file.txt