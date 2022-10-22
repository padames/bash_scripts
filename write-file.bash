#!/bin/bash

# Date: April 26, 2021
# Author: Pablo Adames
# Description: write the two arguments as entries for bundling with build/deploy artifact
#              once deployed the file created will be read by another script to read the
#              values stored in it.
# Modified: April 16, 2021


if [[ $# -lt 2 ]]; then
    echo "must receive two arguments: \$CopyFrom and \$CopyTo"
    exit 1
else
    CopyFrom=$1
    CopyTo=$2
fi

echo "CopyFrom=$CopyFrom" > args.file
echo "CopyTo=$CopyTo" >> args.file

exit 0