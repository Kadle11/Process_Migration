#!/bin/bash


# ReadMe
# Run top, press f
# Navigate to 'P' and press Space, Press q
# Press "Shift + w" to save the settings in .toprc 

# Usage : ./ThreadMigration.sh <PID> <No of Iterations of Top>

declare -a CPU_Array
declare -A CPU_Time
declare -a CPU_Time_Data
declare -a Threads

ps -e -T | grep "$1" > allThreads.txt
echo "Number of Threads: $(($(cat allThreads.txt|wc -l)))"

while read LINE; do
    T=$(echo ${LINE} | cut -d" " -f2)
    Threads+=( $T )
done < "allThreads.txt"

for PID in "${Threads[@]}"
do
    
    if [ -z "$2" ];
    then
	top -H -bn 5 | grep "$1" > TMig.txt
    else
	top -H -bn "$2" | grep "$1" > TMig.txt
    fi


    while read CMD; do
	CPU=$(echo $CMD | tr ' ' '\n' | tail -1)
	Time=$(echo ${CMD} | cut -d" " -f11) 
	CPU_Arr+=( $CPU )
	CPU_Time_Data+=( $Time )
    done < "TMig.txt"

    #for i in "${CPU_Arr[@]}"; do echo "$i"; done

    len=${#CPU_Time_Data[@]}

    for i in $(seq 1 $(($len-1)))
    do
	continue;
    done

    if [ "${#CPU_Arr[@]}" -gt 0 ] && [ $(printf "%s\000" "${CPU_Arr[@]}" | 
						LC_ALL=C sort -z -u |
						grep -z -c .) -eq 1 ] ; then
	echo "Process $PID does not Migrate"
    else
	echo "Process $PID Migrates"
    fi
done

