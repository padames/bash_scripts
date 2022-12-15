#!/bin/bash
# Author: Pablo Adames
# Purpose: demonstrate associative array creation
# Date: March 14, 2021
# Modified: march 14, 2021

echo "running process #$$", called "$(basename "$0")"
echo "with arguments: $*"
HOUSE=house
BOTTLES=bottles
CARS=cars
labels[0]=$HOUSE
labels[1]=$CARS
labels[2]=$BOTTLES
# create associative array explicitly
declare -A a
a=([${labels[0]}]=770 [${labels[1]}]=5 [${labels[2]}]=0.004)
counter=0
echo "---"
for i in "${a[@]}"
do
	echo "${labels[$counter]}": "$i"
	echo "${labels[$counter]}": "${a[${labels[$counter]}]}"
	echo "---"
	counter=("$counter"+1)
done

# use key to reference array value
echo $BOTTLES " :" "${a[$BOTTLES]}"
echo $BOTTLES " :" "${a[bottles]}"
