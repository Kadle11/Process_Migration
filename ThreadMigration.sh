#!/bin/bash


# ReadMe
# Run top, press f
# Navigate to 'P' and press Space, Press q
# Press "Shift + w" to save the settings in .toprc 

# Usage : ./ThreadMigration.sh <PID> <No of Iterations of Top>

declare -a CPU_Array
if [ -z "$2" ];
then
    top -bn 5 | grep "$1" > TMig.txt
else
    top -bn "$2" | grep "$1" > TMig.txt
fi

while read CMD; do
    CPU=$(echo $CMD | tr ' ' '\n' | tail -1)
    CPU_Arr+=( $CPU )
done < "TMig.txt"

for i in "${CPU_Arr[@]}"; do echo "$i"; done

if [ "${#CPU_Arr[@]}" -gt 0 ] && [ $(printf "%s\000" "${CPU_Arr[@]}" | 
       LC_ALL=C sort -z -u |
       grep -z -c .) -eq 1 ] ; then
  echo "Process $1 does not Migrate"
else
  echo "Process $1 Migrates"
fi

