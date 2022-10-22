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
    # # find . -type f -newermt "-$((FILE_FREQUENCY_SECONDS - 20)) seconds" -and -name "*Thermal*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n"
    # fns=$(find . -type f -newermt "-$((FILE_FREQUENCY_SECONDS)) seconds" -and -name "*TrendNet Thermal*mp4"  -printf "%m\t%s bytes\t%t\t%u\t%g\t%p\n")
    
    # if [ "$(cut -d$'\n' -f1 <<<"$fns" | wc -l)" == 0 ]; then
    #     #files are not being archived at the expected time interval
    #     sudo systemctl stop tickler-intelliview.service
    # fi

    # the most appropriate way to sccomplish this is to avoid using commands that list files
    # due to the flaw in Linux for allowing any character as part of a file name except null.
    # So if the file names are time stamped or otherwise are created with numbers that follow an
    # monotonic numeric sequence then one can use a pipeline of bash commands to grab a specific
    # entry based on numeric order of the file names. Using find . -maxdepth 1 -name '<PATTERN>' one can 
    # accomodate for any unusual charcaters in the file names.  
    # Sources:
    # http://mywiki.wooledge.org/ParsingLs
    # https://stackoverflow.com/questions/15932356/bash-script-how-to-fill-array
    find . -maxdepth 1 -name "*TrendNet Thermal*mp4" | sort -g | tail -n 1

    # for i in "${fns[*]}"; do
    # for i in $fns; do
    #      echo $i
    # done
        
fi