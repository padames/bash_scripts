#!/bin/bash

# Date: April 26, 2021
# Author: Pablo Adames
# Description: Read arguments from file into local variables. 
#              The name of the file is hard-coded in the script.
# Modified: April 16, 2021
# Modified: Oct 24, 2022

if [[ -f args.file ]]; then
    while IFS= read -r LINE
    do
        eval $LINE
    done < args.file
fi

echo "$CopyFrom"
echo "$CopyTo"