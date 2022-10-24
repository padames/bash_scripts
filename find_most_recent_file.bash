#!/bin/bash

# Purpose: find the most recent file in today's folder

# Avoid using commands that list files
# due to the flaw in Linux for allowing any character as part of a file name except null.
# So if the file names are time stamped or otherwise are created with numbers that follow an
# monotonic numeric sequence then one can use a pipeline of bash commands to grab a specific
# entry based on numeric order of the file names. Using find . -maxdepth 1 -name '<PATTERN>' one can 
# accomodate for any unusual charcaters in the file names.  
# Sources:
# http://mywiki.wooledge.org/ParsingLs
# https://stackoverflow.com/questions/15932356/bash-script-how-to-fill-array
FILENAME=$(find . -maxdepth 1 -name "*TrendNet Thermal*mp4" | sort -g | tail -n 1)
echo "LATEST_FILE=$FILENAME" > latest_archived_filename
echo "$FILENAME"

NOW_SECONDS=$(date +'%s')
LAST_FILE_SECONDS=$(stat --format=%Y "$FILENAME")
DIFF=$((NOW_SECONDS - LAST_FILE_SECONDS))

echo "Now in seconds from epoch = $NOW_SECONDS"
echo "File seconds since last modified = $LAST_FILE_SECONDS"

echo "Difference = $DIFF"

if (( DIFF > 30 ))
then
    echo "I should power cycle this unit"
else
    echo "Boson camera is well"
fi