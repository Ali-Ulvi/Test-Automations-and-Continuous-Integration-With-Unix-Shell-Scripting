#!/bin/bash

#AUT Productions present

if [ $# -ne 1 ]
then
    echo "AccountID must be provided as parameter"
    exit 1
fi
	aid=$1
	echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
	
