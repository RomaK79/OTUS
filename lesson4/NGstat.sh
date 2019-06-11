#!/bin/bash

function get_help {
	echo
	echo "Usage: "$0" FILE... OPTION..."
	echo
	echo " -ip	get the most frequent requests from IP"
	echo " -code	get the most frequently returned codes"
	echo " -url	to the most frequently requested URLs"


}

function extract() {

	local log_file=$1
	local field=$2

	awk "{print $"$field"}"  $log_file | sort | uniq -c | sort -rn
}


case $# in

2)
	log_file=$1

	case $2 in
	-ip)
	 echo "most frequent requests from IP"
	 extract $log_file 1
	 ;;
	-code)
	 echo "most frequently returned codes"
	 extract $log_file 9
	 ;;
	-url)
	 echo "most frequently requested URLs"
	 extract $log_file 7
	 ;;
	*)
	 get_help
	 ;;
	esac
;;

*)
 get_help
;;


esac
