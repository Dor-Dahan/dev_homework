#!/bin/bash
func_procss()
{
i=1
#looping the search of the process by changing the num_pings var or to stay lopping 
while (( $i <= $NUM_PINGS || $NUM_PINGS == TRUE ))
do
	sleep "$NUM_TIMEOUT"
	number_of_process=$(ps $USR| grep "$process_name" |wc -l)
	echo "$process_name: $number_of_process instance(s)..."
	let i++
done
}

NUM_TIMEOUT=1
NUM_PINGS=TRUE
USR="-A"

#handle arguments
for arg in "$@"
do
	case $arg in
	-c|c)
		shift
		NUM_PINGS="$1"
		shift
	;;
	-t|t)
		shift
		NUM_TIMEOUT="$1"
		shift
	;;
	-u|u|U|-U)
		shift
		USR="-U $1"
		shift
	;;
	esac
done
process_name="$1"
func_procss "$process_name"
