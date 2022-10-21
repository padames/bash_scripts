#!/bin/bash

# Purpose: to create a name string like YYYYMMDD where YYYY=year, example: 2022;
#          MM=month in two digit format from 01 to 12; and DD=day in two digit 
#          format from 01 to 31 maximum

t_stamp=$(date +'%Y%m%d')
echo $t_stamp