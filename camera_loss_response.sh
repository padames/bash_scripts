#!/bin/bash


# Purpose: shutdown the OS if archived video files from the thermal camera
#          stop being saved to file system for the duration of time in seconds 
#          passed as argument to the script

function is_SmrtHVRService_up () {
    
    PID="$(pgrep SmrtHVRService)"

    if [ "$PID" = "" ]; then
        return 1 # process is down
    else
        return 0 # success the process is up
    fi
}

function infer_camera_loss () {
    THRESHOLD_IN_SECONDS=$1
    
    echo "$(date): Threshold set to $THRESHOLD_IN_SECONDS seconds"

<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
    function infer_camera_loss () {
=======
>>>>>>> Stashed changes
    i=0
    while read -a RECORD ; do
        a[i]=${RECORD[0]} # the camera_id
        # b[i]=${RECORD[1]} # the |
        camera_name[i]=${RECORD[2]} 
        # echo "${camera_name[i]}"
        i=$((i + 1))
<<<<<<< Updated upstream
    done < <(sudo -i  -u intelliview psql ivtdb -t -c "WITH q2 AS ( WITH q1 AS ( SELECT camera_id, camera_name, now() - start_at FROM ivthvr.archive_video_recording JOIN ivthvr.camera_view USING (camera_id) WHERE now() - start_at > '$THRESHOLD_IN_SECONDS seconds'::interval ) INSERT INTO event_log(severity,subsystem,camera_id,message) select 'fatal','Monitor',camera_id,'Camera '|| camera_name || ' failed, rebooting now' FROM q1 RETURNING camera_id ) SELECT camera_id, camera_name FROM q2 JOIN camera_view USING (camera_id);" )
=======
    done < <(sudo -i  -u intelliview psql ivtdb -t -c "WITH q2 AS ( WITH q1 AS ( SELECT camera_id, camera_name, now() - start_at FROM ivthvr.archive_video_recording JOIN ivthvr.camera_view USING (camera_id) WHERE now() - start_at > '$THRESHOLD_IN_SECONDS seconds'::interval ) INSERT INTO event_log(severity,subsystem,camera_id,message) select 'fatal','Monitor',camera_id,'Camera '|| camera_name || ' (id=' || camera_id || ') failed, rebooting now' FROM q1 RETURNING camera_id ) SELECT camera_id, camera_name FROM q2 JOIN camera_view USING (camera_id);" )
>>>>>>> Stashed changes
>>>>>>> Stashed changes
    
    if (( i < 2 )); then  # the counter exits as 1 if no record was found
        echo "$(date): All good, video files have been created within the last $THRESHOLD_IN_SECONDS seconds from both cameras"
        return 1
    else
    # echo "i= $i"
        for (( k=0; k<((i -1)); k++ ))
        do
            # echo "k=$k"
            echo "$(date): No video file has been archived from ${camera_name[$k]} (id=${a[$k]}) in the last $THRESHOLD_IN_SECONDS seconds"

        done
        return 0
    fi
}


function main () {
    if [ "$1" = "" ]; then
        >&2 echo "One argument required: the maximum time in seconds to accept without new archived video files before power cycling the unit."
    else
        echo "--------"
        if is_SmrtHVRService_up; then
            
            if infer_camera_loss "$1"
            then
                MSG="$(date): Shutting down now, watchdog will power cycle after 5 minutes 30 seconds"
                echo "$MSG"
                # The following works if script ran by intelliview and the entry: "intelliview ALL=(ALL) NOPASSWD: /sbin/reboot,/sbin/shutdown" exists in etc/sudoers.d/reboot
                sudo shutdown -h now 
            fi
        else
            echo "$(date): SmrtHVRService is down, nothing to do"
        fi
    fi
}

main "$1"