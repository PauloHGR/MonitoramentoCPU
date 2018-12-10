#!/bin/bash

while $(pgrep pkt-gen > 0);
do

	CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
        unset CPU[0]                          # Discard the "cpu" prefix.
        IDLE=${CPU[4]}                        # Get the idle CPU time.

        # Calculate the total CPU time.
        TOTAL=0
        for VALUE in "${CPU[@]}"; do
            let "TOTAL=$TOTAL+$VALUE"
        done

        # Calculate the CPU usage since we last checked.
        let "DIFF_IDLE=$IDLE-$PREV_IDLE"
        let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
        let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
        echo -en "\rCPU: $DIFF_USAGE%  \b\b"
	echo $DIFF_USAGE >> cpu_usage_$1_$2.txt
        # Remember the total and idle CPU times for the next check.
        PREV_TOTAL="$TOTAL"
        PREV_IDLE="$IDLE"

        # Wait before checking again.
	sleep 1

done

