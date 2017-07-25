#! /usr/bin/bash
 
#API by AUT

 if [[ $# -ne 1 ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullaným: $0 ID "
	echo "ornek kullanim:"
	echo ""
	echo "$0 123"
	echo "$0 $$"
	exit
fi

pid=$1
	
rm sms9333Log.$pid.$(date +%Y%m%d)*

