#!/usr/bin/bash
tariff=$1

if [[ $# -ne 1&&$# -ne 0&&$# -ne 2 ]]
    then
        echo "illegal number of parameters"
        echo "Kullanim: $0  tarife(bu parametre istege bagli)"
        echo "ornek kullanim:"
        echo ""
        echo "$0 150"
        exit
fi
if [[ ! -z $tariff ]]
then
#tariff=$( printf "%05d" $tariff)
./usagePremium -t $tariff |egrep  "_lt_.*MOC"|grep -v _tm0| tee Input.txt 
else
./usagePremium            |egrep  "_lt_.*MOC"|grep -v _tm0|tee Input.txt 
fi
echo $(wc -l Input.txt | cut -d " " -f1) usage rules found. Check if it is missing.
./slimTiered.py "$2"

 