#!/bin/bash
# Author: Pablo Adames
# Purpose: Learn array definition and operations on arrays
# Date: March 14, 2021
# Modified: March 14, 2021

# define
a1=({1..10..2})
#echo ${a1[2]}
a2=({A..Z})

for i in "${a1[@]}"; do
	echo "$i"
done

for i in ${a1[*]}; do
	echo "$i"
done

# for i in "${a2[@]}"; do
# 	echo "$i"
# done

echo "${a1[*]}"
echo "======"
echo "${a1[@]}"
