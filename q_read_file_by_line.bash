#!/bin/bash

echo "Current folder $(dirname "$0")"

source ./q_parse_line.bash
#source ./videoEditingNoble.bash

mp4s=()
fluid=""
start=""
end=""
flow_rate=-1 # ground truth
source_rel_path=""
destination_rel_path=""

# shellcheck disable=SC2034  # TOKENS is used by reference in tokenize and passed as agument to parse below
TOKENS=()

echo -e '\n'
while IFS= read -r line; do
  #printf '%s\n' "$line"
  tokenize "$line" TOKENS
  parse TOKENS[@]
  echo "start clipping at ${start} seconds into the file ${mp4s[1]}"
  end_video_pos=$((${#mp4s[@]} - 1)) # in python end_video_pos=mp4s[len(pm4s) -1]
  echo "end clipping at ${end} seconds into the file ${mp4s[${end_video_pos}]}"
  echo "input files will be sought in the relative path ${source_rel_path}"
  echo "the edited video file will be written to the path ${destination_rel_path}"
  echo -e '\n'

  edit_video source_rel_path mp4s[1] mp4s[$end_video_pos] start end destination_rel_path

  mp4s=()
  fluid=""
  start=""
  end=""
  flow_rate=-1
  source_rel_path=""
  destination_rel_path=""
done <./q_input_file.txt
