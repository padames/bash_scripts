#!/bin/bash

t_stamp=$(date +'%Y%m%d')

if [[ ! -d $t_stamp ]]
then
    echo "Created folder $t_stamp"
    mkdir "$t_stamp"
fi