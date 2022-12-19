#!/bin/bash

# main driver foir system performance monitoring


THIS_PROG_NAME=$(basename "${BASH_SOURCE[@]}")

echo "$THIS_PROG_NAME"

declare -A DESCRIPTIONS
declare -i FREE_MEMORY_KB
declare -i INACTIVE_MEMORY_KB
declare -i ACTIVE_MEMORY_KB


DESCRIPTIONS=(
    [r]="The number of runnable processes. These are processes that have been launched and are either running or are waiting for their next time-sliced burst of CPU cycles"
    [b]="The number of processes in uninterruptible sleep. The process isn’t sleeping, it is performing a blocking system call, and it cannot be interrupted until it has completed its current action. Typically the process is a device driver waiting for some resource to come free. Any queued interrupts for that process are handled when the process resumes its usual activity."
    [swpd]="The amount of virtual memory used. In other words, how much memory has been swapped out, MB"
    [free]="The amount of idle (currently unused) memory, MB"
    [buff]="The amount of memory used as buffers, MB"
    [active]="The amount of active memory, MB"
    [inactive]="The amount of inactive memory, MB"
    [cache]="the amount of memory used as cache, MB"
    [si]="Amount of virtual memory swapped in from swap space, MB"
    [so]="Amount of virtual memory swapped out to swap space, MB"
    [bi]="Blocks received from a block device. The number of data blocks used to swap virtual memory back into RAM"
    [bo]="Blocks sent to a block device. The number of data blocks used to swap virtual memory out of RAM and into swap space"
    [in]="The number of interrupts per second, including the clock"
    [cs]="The number of context switches per second. A context switch is when the kernel swaps from system mode processing into user mode processing"
    [us]="Time spent running non-kernel code. That is, how much time is spent in user time processing and in nice time processing, s"
    [sy]="Time spent running kernel code, s"
    [id]="Time spent idle, s"
    [wa]="Time spent waiting for input or output, s"
    [st]="Time stolen from a virtual machine. This is the time a virtual machine has to wait for the hypervisor to finish servicing other virtual machines before it can come back and attend to this virtual machine, s"

)

TIMESTAMP_TODAY=$(date +'%Y%m%d')

DATAFILENAME="$TIMESTAMP_TODAY"_vmstat

#  sample output:
# --procs-- -----------------------memory---------------------- ---swap-- -----io---- -system-- --------cpu-------- -----timestamp-----
#    r    b         swpd         free        inact       active   si   so    bi    bo   in   cs  us  sy  id  wa  st                 MST
#    2    0            0      9911284     15693816      4984188    0    0    18    41   35   98   4   1  94   1   0 2022-12-18 23:25:07

while true ; do

    # getfilename outputs multiple files, linefeed separated
       
    LINE=$(/usr/bin/vmstat -nwat -S m | grep : | tr -s ' ') # megabytes=1000^2, MB 
    TIME_STAMP=$(echo "$LINE" | cut -f19-20 -d' ' | tr ' ' ',')
    echo "$TIME_STAMP"
    DATA=$(echo "$LINE" | tr -s ' ' | cut -f1-17 -d' ' | tr ' ' ',')
    printf "%s%s\n" "$TIME_STAMP"  "$DATA" >> "$DATAFILENAME"
    sleep 5
done 

# iostat