#!/bin/bash
# This script pases a row in a comma separated file with the following specifications
# 1. Each row corresponds to the 30-second video clips that contain a leak and the information necessary to edit them into a single video file
# 2. Each token in a file is separated by a comma
# 3. The first entries are the names of the video files of extension mp4
# 4. The names are entered in sequential time order such that when stitched together they form a continuous video file
# 5. The last entry of a video file name is followed by two two-digit numbers representing the start time and the end time
# 6. The next two entries are text strings contaning the relative paths to the source of the video files and the destinaton path of the edited file

# FUNCTION:     tokenize
# ARGUMENTS:    $1, [IN]: the comma-separated string to tokenize
#               $2, [OUT]: the array where the tokens will be stored
# DESCRIPTION:  The output is passed as a reference (as of bash 4.3) via the '-n' switch for the local variable 'tokens'
function tokenize() {
    declare -n tokens="$2"
    # the -a argument to read puts the values into an array
    IFS=',' read -ra tokens <<<"$1"
}

# FUNCTION:     is_mp4
# ARGUMENT:     $1, [IN]: a string
# DESCRIPTION:  if string ends in "mp4" function exit status is 0, otherwise 255.
#               The string is turned to lowercase via the "-l" switch for the local variable 'token'
function is_mp4() {
    local -l token=$1
    MP4_EXT=${token##*.} # bash parameter expansion: ## deletes longest match of pattern *. from the beginning

    if [[ "$MP4_EXT" == "mp4" ]]; then
        return 0 # success, an mp4 was found
    else
        return 255 # failed, not an mp4 file found
    fi
}

# FUNCTION:     is_number
# ARGUMENT:     $1, [IN]: a string
# DESCRIPTION:  if string can be interpreted as a two-digit number between 00 and 39 the function exits with status 0, otherwise 255
function is_number() {
    local token=$1
    if [[ "$token" =~ ^[0-3][0-9]$ ]]; then # using regular expressions to match signature of number
        return 0                            # Success, a number was found
    else
        return 255 # failed, not a number between 00 and 39
    fi
}

# FUNCTION:     is_path
# ARGUMENT:     $1, [IN]: a string
# DESCRIPTION:  if string can be interpreted as a path then the exit status is set to 0 (success), otherwise is set to 255 (failed)
function is_path() {
    declare -l token=$1 # lower case via the -l switch
    if [[ "$token" =~ ([a-zA-Z0-9_\-]+\/)+ ]]; then
        return 0 # success, the string can be interpreted as a path
    else
        return 255 # failed to identify the token as a file path
    fi

}

# FUNCTION:     parse
# ARGUMNETS:    $1, [IN]: an array with tokens, passed in as array_name[@] to the script
# DESCRIPTION:  It interpretes the tokens cerated form reading a row entry of a given structure
#               Two or more mp4 filenames, the start and end time to clip in the first and last video file, the input path for the video files, the output path for the edited file
function parse() {
    declare -a tokens=("${!1}")
    for tok in "${tokens[@]}"; do
        if ((start < 0)) && [ -z "$source_rel_path" ] && is_mp4 "$tok"; then
            mp4s+=("$tok")
            continue
        fi

        if ((start < 0)) && [ -z "$source_rel_path" ] && is_number "$tok"; then
            start=$tok
            continue
        elif ((end < 0)) && [ -z "$source_rel_path" ] && is_number "$tok"; then
            end=$tok
            continue
        fi

        if is_path "$tok" && [ -z "${source_rel_path}" ]; then
            source_rel_path=$tok
            continue
        elif is_path "$tok" && [ -z "${destination_rel_path}" ]; then
            destination_rel_path=$tok
        fi
    done
}