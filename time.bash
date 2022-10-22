#!/bin/bash

TIME=`date +%H:%M`
HOUR="$TIME"
echo $HOUR
while [ 1 ]; do
    HOUR=`date +%H:%M`
    if [ "$TIME" != "$HOUR" ]; then
	    echo $HOUR
	    TIME="$HOUR"
    fi
    sleep 10	
done
