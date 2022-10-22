#!/bin/bash
# Purpose: return the number of letters in user input
# Author: Pablo Adames
# Created: Mar 10, 2021
# Modified: Mar 10, 2021
echo
echo Will count number of non-space characteres in input
echo

while [ 1 ]; do
	read -p  "Please type text here:" itex
      	if [ -z "$itex" ]; then
		echo "Empty? try again"
	else
		echo "Total text length is ${#itex}"
      		clean_itex=${itex//[[:space:]]/}
		echo "number of characters without spaces is ${#clean_itex}"   
	fi
	read -p "Do you want to quit? (y/n): " yesno
	if [ "$yesno" == "y" ]; then
		echo "done!"
		break
	fi
done

#`grep -v "\S" "${itext}"`
#echo "$clean_text"
#nc="${#clean_text}"
#echo the text \'${itext}\' has $nc characters

