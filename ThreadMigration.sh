#!/bin/bash


# ReadMe
# Run top, press f
# Navigate to 'P' and press Space, Press q
# Press "Shift + w" to save the settings in .toprc 

# Usage : ./ThreadMigration.sh <PID> <No of Iterations of Top>

declare -a Threads

ps -e -T | grep "$1" > allThreads.txt
echo "Number of Threads: $(($(cat allThreads.txt|wc -l)))"

if [ -z "$2" ];
then
    top -H -bn 5 -p "$1" > TopData.txt
else
    top -H -bn "$2" -p "$1" > TopData.txt
fi

while read LINE; do
    T=$(echo ${LINE} | cut -d" " -f2)
    Threads+=( $T )
done < "allThreads.txt"

for PID in "${Threads[@]}"
do
    SleepFlag=1

    cat TopData.txt | grep "$PID" > TMig.txt


    declare -a CPU_Arr

    while read CMD; do
	CPU=$(echo $CMD | tr ' ' '\n' | tail -1)
	Sleep=$(echo ${CMD} | cut -d" " -f8)
	if [ "$Sleep" == "R" ] && [ $SleepFlag -eq 1 ]
	then
	    SleepFlag=0
	fi
	CPU_Arr+=( $CPU )
    done < "TMig.txt"

    echo "${CPU_Arr[*]}"

    if [ "${#CPU_Arr[@]}" -gt 0 ] && [ $(printf "%s\000" "${CPU_Arr[@]}" | 
						LC_ALL=C sort -z -u |
						grep -z -c .) -eq 1 ] ; then
	if [ $SleepFlag -eq 1 ]
	then
	    echo "Process $PID is Sleeping and does not Migrate"
	else
	    echo "Process $PID is Active and does not Migrate"
	fi
    else
	if [ $SleepFlag -eq 1 ]
	then
	    echo "Process $PID is Sleeping and Migrates"
	else
	    echo "Process $PID is Active and Migrates"
	fi
    fi

    unset CPU_Arr
done

#rm "TMig.txt"
rm "allThreads.txt"
#rm "TopData.txt"
