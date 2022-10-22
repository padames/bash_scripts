#!/bin/bash

# Purpose: find all the files older than first argument in current folder

if (( $# != 1 )); then
    >&2 echo "One argument required for the frequency of archived files in seconds"
else
    # declare -i FILE_FREQUENCY_MINUTES=$1
    declare -i FILE_FREQUENCY_SECONDS=$1
    # echo "Files to be saved every $FILE_FREQUENCY_MINUTES minutes"  
    echo "Files to be saved every $FILE_FREQUENCY_SECONDS seconds"  

    # find files that have been modified in the last minute and whose name has thermal in it
    # find . -type f -mmin "$FILE_FREQUENCY_MINUTES"s -and -name "*Thermal*mp4" 
    # find . -type f -mmin "$FILE_FREQUENCY_MINUTES" -and -name "*Thermal*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"
    # find . -type f -mmin "$FILE_FREQUENCY_MINUTES" -and -name "*colour*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"
    # find . -type f -newermt "-$FILE_FREQUENCY_SECONDS seconds" -and -name "*colour*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"
    # find . -type f -newermt "-$((FILE_FREQUENCY_SECONDS - 20)) seconds" -and -name "*Thermal*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"
    fns=$(find . -type f -newermt "-$((FILE_FREQUENCY_SECONDS)) seconds" -and -name "*TrendNet Thermal*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n")
    
    echo "$fns"

    for i in ${fns[*]}; do
        echo $i
    done
    



    # echo $(date +%s)
    # f_=$(find . -type f -newermt "-10 seconds" -and -name "* *Thermal*mp4")
    # echo "$f_"
    # stat -L --format %Y "$f_"
    # find . -type f -newermt "-10 seconds" -and -name "*Thermal* *mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"
    
fi