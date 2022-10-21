#!/bin/bash

# Purpose: find all the files older than first argument in current folder

if (( $# != 1 )); then
    >&2 echo "One argument required for the frequency of archived files in seconds"
else
    declare -i FILE_FREQUENCY_SECONDS=$1
    echo "Files to be saved every ${FILE_FREQUENCY_SECONDS} seconds~"  
fi

# find files that have been modified in the last minute and whose name has thermal in it
find . -type f -mmin 1 -and -name "*thermal*"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"