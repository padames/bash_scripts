#! /bin/bash

if (( $# != 1 )); then
    >&2 echo "One argument required: the maximum time in seconds to pass by without archived video files before power cycling the unit."
else
    THRESHOLD_IN_SECONDS=$1
    echo "Threshold set to $THRESHOLD_IN_SECONDS seconds"

    i=0
    while read -a RECORD ; do
        a[i]=${RECORD[0]} # the camera_id
        b[i]=${RECORD[1]} # the |
        camera_name[i]=${RECORD[2]} 
        # echo "${camera_name[i]}"
        i=$((i + 1))
    done < <(sudo -i  -u intelliview psql ivtdb -t -c "WITH q2 AS ( WITH q1 AS ( SELECT camera_id, camera_name, now() - start_at FROM ivthvr.archive_video_recording JOIN ivthvr.camera_view USING (camera_id) WHERE now() - start_at > '$THRESHOLD_IN_SECONDS seconds'::interval ) INSERT INTO event_log(severity,subsystem,camera_id,message) select 'fatal','Monitor',camera_id,'Camera '|| camera_name || ' failed, rebooting' FROM q1 RETURNING camera_id ) SELECT camera_id, camera_name FROM q2 JOIN camera_view USING (camera_id);" )
    
    if (( i < 2 )); then  # the counter exits as 1 if no record was found
        echo "Cameras streaming video just fine"
    fi

    # echo "i= $i"
    
    for (( k=0; k<((i -1)); k++ ))
    do
        # echo "k=$k"
        echo "No video file has been archived from ${camera_name[$k]} (id=${a[$k]}) in the last $THRESHOLD_IN_SECONDS seconds"
    done
fi
