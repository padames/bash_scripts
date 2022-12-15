#!/bin/bash

# main driver foir system performance monitoring


THIS_PROG_NAME=$(basename "${BASH_SOURCE[@]}")

echo "$THIS_PROG_NAME"

while true ; do

    # getfilename outputs multiple files, linefeed separated
    "$(vmstat -nwa)" | while IFS='' read -r line
    do
        echo "$line"
    done
    sleep 5
done 

# iostat