#!/bin/bash

# Automatically adjust blue light with redshift
# By Masterccc
### Config ###

# Normal color temp
BASE_TEMP=5500
# Maximum level of adjustement
MAX_TEMP=3000
# Hour when adjustement begin
START_HOUR=15
# Delay between check
DELAY_MIN=30

function setTemp(){

	hour=$1
	min=$2

	[[ "$hour" -le "15" ]] && return
	
	h_coeff=$[ $hour - 15 ]
	current=$[ $BASE_TEMP - h_coeff * 300 ]
	[[ "$min" -ge "30" ]] && current=$[ $current - 150 ]
	[[ "$current" -lt "$MAX_TEMP" ]] && current=$MAX_TEMP
	redshift -O $current &> /dev/null
	echo "change - lum $current" >> ./reds.logs

}

redshift -O $BASE_TEMP &> /dev/null

delay=$[DELAY_MIN * 60]

rm ./reds.logs


echo "start" >> ./reds.log

while true
do
	H=$(date +'%H')
	M=$(date +'%M')
	setTemp "$H" "$M"
	sleep ${DELAY_MIN}m
done


## TEST ##
#for i in `seq 15 23`
#do
#echo "$i:00"
#setTemp "$i" "00"
#sleep 1s
#echo "$i:30"
#setTemp "$i" "30"
#sleep 1s
#done
## END TEST ##

