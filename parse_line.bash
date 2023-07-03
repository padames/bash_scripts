#!/bin/bash
# This script pases a row in a comma separated file with the following specifications
# 1. Each rtow corresponds to the 30-second video clips that contain a leak and the information necessary to edit them into a single video file
# 2. Each token in a file is separated by a comma
# 3. The first entries are the names of the video files of extension mp4
# 4. The names are entered in sequential time order such that when stitched together they form a continuous video file
# 5. The last entry of a video file name is followed by two two-digit numbers representing the start time and the end time 
# 6. The next two entries are text strings contaning the relative paths to the source of the video files and the destinaton path of the edited file

TOKENS=()
# Examples of rows follow:

ROW_1='15.03_0.mp4,15.03_1.mp4,15.04_0.mp4,04,25,"relative/path/to/input/files","relative/path/to/output/files"'
# 16.56_0.mp4,16.56_1.mp4,16.57_0.mp4,16.57_1.mp4,46,01,"relative/path/to/input/files","relative/path/to/output/files"
# 00.29_1.mp4,00.30_0.mp4,00.30_1.mp4,00.31_0.mp4,00.31_1.mp4,32,16,"another/relative/path/to/input/files","another/relative/path/to/output/files"

# FUNCTION: TOKENIZE
# ARGUMENTS: $1, [IN]: the comma-separated string to tokenize
#            $2, [OUT]: the array where the tokens will be stored
function tokenize () {
    declare -n tokens="$2"
    # the -a argument to read puts the values into an array
    IFS=',' read -ra tokens <<< "$1"
}

function is_mp4 () { 
    local -l token=$1
    MP4_EXT=${token##*.} # bash parameter expansion: ## deletes longest match of pattern *. from the beginning 
    
    if [[ "$MP4_EXT" == "mp4" ]]; then
        return 0 # success, an mp4 was found
    else
        return 255 # failed, not an mp4 file found 
    fi
}


function is_number () {
    local token=$1
    if [[ "$token" =~ ^[0-3][0-9]$ ]] # using regular expressions to match signature of number
    then
        return 0 # Success, a number was found
    else
        return 255 # failed, not a number between 00 and 39
    fi       
}

function parse () {

    for tok in "${TOKENS[@]}"; do
        if is_mp4 "$tok"
        then
            mp4s+=("$tok")
            continue 
        fi

        if is_number "$tok" && (( start < 0 )) 
        then
            start=$tok
        elif is_number "$tok" && (( end < 0 ))
        then
            end=$tok      
        fi
    done
}

# global scrip variables:
mp4s=()
declare -i start=-1
declare -i end=-1
source_rel_path=""
destination_rel_path=""


# echo "Before call to tokenize function: ${TOKENS[*]}"
tokenize "$ROW_1" TOKENS
# echo "After call to tokenize function: ${TOKENS[*]}"
parse 


echo "start clipping at ${start} seconds into the file ${mp4s[1]}"
end_video_pos=$((${#mp4s[@]}-1))
echo "end clipping at ${end} seconds into the file ${mp4s[${end_video_pos}]}" 