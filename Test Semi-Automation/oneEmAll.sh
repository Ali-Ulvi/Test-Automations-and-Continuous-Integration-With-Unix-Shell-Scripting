#!/bin/bash
if [ $# -ne 1 ]
then
    echo "AccountID must be provided as parameter"
    exit 1
fi
aid=$1
echo "#u :Value \$ and and = :AccountID '$aid' != :ID '1' != :End ''   & '1'" | idbm_adb -s CreBalance
