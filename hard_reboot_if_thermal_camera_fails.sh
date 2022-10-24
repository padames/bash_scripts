#!/bin/bash

# Purpose: stop the tickler if archived videos from the thermal camera
#          stop being saved to file



# Script constants:
declare -r SERVICE_FILENAME="tickler-intelliview.service"
declare -r ARCHIVED_VIDEO_SYSTEM_PATH="/opt/ivt/photography/ArchiveVideo"

# Script variables:
declare FILENAME=""


function is_active () {

    REENTRANT=$1
    COUNTER=$2
    local STATUS

    STATUS=$(systemctl is-active $SERVICE_FILENAME)

    if [[ -z $REENTRANT ]] # only do if REENTRANT is the empty string
    then
        sudo systemctl daemon-reload
    fi

    case $STATUS in
    active)
        [[ -n $REENTRANT ]] && sudo systemctl daemon-reload # reload if just became active after being in activating state
        return 0 # success
        ;;
    activating)
        if ((COUNTER>10)); then return 1; fi

        sleep 1
        COUNTER=$((COUNTER + 1))
        is_active "yes" $COUNTER
        ;;
    inactive)
        return 1
        ;;
    failed)
        return 1 # to try starting it
        ;;
    *)
        return 1 # ibidem
        ;;
    esac
}

function start_it () {
    # systemd runs the ExecStart in the unit file for this service
    sudo systemctl start $SERVICE_FILENAME
}

function stop_it () {
    # enabled services are started by systemd on reboot
    sudo systemctl stop $SERVICE_FILENAME
}


function start_tickler () {

    if is_active
    then
        return 0 # not needed, tickler is already running
    else
        start_it

        if is_active
        then
            return 0 # success
        else
            return 1 # failure
        fi
    fi
}


function stop_tickler () {
    if is_active
    then
        stop_it

        if is_active
        then
            return 1 # failure
        else
            return 0 # success
        fi
    else
        return 0 # not needed, tickler is already stopped
    fi
}

function find_latest_file () {
    unset FILENAME
    FILENAME=$(find . -maxdepth 1 -name "*TrendNet Thermal*mp4" | sort -g | tail -n 1)
    # echo "LATEST_FILE=$FILENAME" > latest_archived_filename
    # echo "$FILENAME"
    return 0
}




function main () {
    find_latest_file

    NOW_SECONDS=$(date +'%s')
    # LAST_FILE_SECONDS=$(stat --format=%Y "$FILENAME") # last modification seconds from epoch
    LAST_FILE_SECONDS=$(stat --format=%X "$FILENAME") # last access seconds from epoch
    DIFF=$((NOW_SECONDS - LAST_FILE_SECONDS))

    # echo "Now in seconds from epoch = $NOW_SECONDS"
    # echo "File seconds since last modified = $LAST_FILE_SECONDS"

    echo "Latest video file was modified $DIFF seconds ago"

    declare -i THRESHOLD_IN_SECONDS=30

    if (( DIFF > THRESHOLD_IN_SECONDS ))
    then
        echo "I should power cycle this unit"
    else
        echo "Boson camera is well"
    fi
}

main