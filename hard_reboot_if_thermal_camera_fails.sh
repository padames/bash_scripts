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
            MSG="Could not start the tickler, please check systemct status tickler-intelliview"
            THIS_PROG_NAME=$(basename "${BASH_SOURCE[*]}")
            printf "%s\n" "${FUNCNAME[0]}, Line ${BASH_LINENO[0]}: ${MSG}"
            SHOULD_REBOOT=0 # reboot (true)
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
            MSG="Could not stop the tickler, please check systemct status tickler-intelliview"
            THIS_PROG_NAME=$(basename "${BASH_SOURCE[*]}")
            printf "%s\n" "$THIS_PROG_NAME, Line ${BASH_LINENO[*]}: ${MSG}"
            SHOULD_REBOOT=0 # reboot (true)
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
    if [[ $FILENAME == "" ]]
    then 
        MSG="Could not find any video files."
        THIS_PROG_NAME=$(basename "${BASH_SOURCE[0]}")
        printf "%s\n" "${FUNCNAME[0]}, Line ${BASH_LINENO[0]}: ${MSG}"
        return 1
    else
        return 0
    fi
}

# A new folder gets created according to UTM time
function change_into_todays_folder {
    TODAYS_FOLDER=$(date -u +'%Y%m%d')
    PATH_TO_CHECK="$ARCHIVED_VIDEO_SYSTEM_PATH"/"$TODAYS_FOLDER"/local
    
    if [[ ! -d $PATH_TO_CHECK ]]; then
        sudo mkdir "$PATH_TO_CHECK"
    fi

    # if
    cd "$PATH_TO_CHECK" && return 0

    # else
    MSG="Could not move into $PATH_TO_CHECK."
    THIS_PROG_NAME=$(basename "${BASH_SOURCE[0]}")
    printf "%s\n" "${FUNCNAME[0]},  Line ${BASH_LINENO[0]}: ${MSG}"
    return 1
}

function is_there_a_current_video_file {
    return 0
}

function main () {
    local SHOULD_REBOOT=1 # no reboot (false)

    CUR_PATH=$(pwd -L)
    change_into_todays_folder

    if ! find_latest_file
    then
        MSG="Performing a hard reboot."
        THIS_PROG_NAME=$(basename "${BASH_SOURCE[@]}")
        printf "%s\n" "$THIS_PROG_NAME, ${FUNCNAME[0]}, Line ${BASH_LINENO[0]}: ${MSG}"
     
        SHOULD_REBOOT=0 # reboot (true)
    else

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
            SHOULD_REBOOT=0
        else
            echo "Boson camera is well"
            SHOULD_REBOOT=1
        fi
        if ! cd "$CUR_PATH"; then
            MSG="Could not return to original path."
            THIS_PROG_NAME=$(basename "${BASH_SOURCE[@]}")
            printf "%s\n" "$THIS_PROG_NAME, Line ${BASH_LINENO[*]}: ${MSG}"            
        fi
    fi

    if (( SHOULD_REBOOT == 0 ))
    then
        stop_tickler
    else
        start_tickler
    fi
}

main