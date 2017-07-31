#!/usr/bin/bash
tariff=$1
bns=$2

if [[ $# -ne 1&&$# -ne 0&&$# -ne 2 ]]
    then
        echo "illegal number of parameters"
        echo "Kullanim: $0  tarife(bu parametre istege bagli) bonusNo(bu parametre istege bagli)"
        echo "ornek kullanim:"
        echo ""
        echo "$0 150"
        exit
fi
if [[ $# -eq 1 ]]
then
	./usagePremium -t $tariff |egrep  "_tm0.*MOC" |sed 's/_tm0\(....\)/+\1+/g'|sed 's/^TPU_0\(....\)/TPU_0\1+/'|sort  -t+ -k1,1 -k3,3 -k2,2|sed 's/+\(....\)+/_tm0\1/g'|sed 's/^TPU_0\(....\)+/TPU_0\1/'   | tee Input.txt 
elif [[ $# -eq 2 ]]
then
	bns=$( printf "%05d" $bns)
	if [[ $1 = b ]]
	then
		./usagePremium  |egrep  "_tm$bns.*MOC"|sed 's/_tm0\(....\)/+\1+/g'|sed 's/^TPU_0\(....\)/TPU_0\1+/'|sort  -t+ -k1,1 -k3,3 -k2,2|sed 's/+\(....\)+/_tm0\1/g'|sed 's/^TPU_0\(....\)+/TPU_0\1/' | tee Input.txt 
	else	
		./usagePremium -t $tariff |egrep  "_tm$bns.*MOC"|sed 's/_tm0\(....\)/+\1+/g'|sed 's/^TPU_0\(....\)/TPU_0\1+/'|sort  -t+ -k1,1 -k3,3 -k2,2|sed 's/+\(....\)+/_tm0\1/g'|sed 's/^TPU_0\(....\)+/TPU_0\1/' | tee Input.txt 
	fi
else
	./usagePremium            |egrep  "_tm0.*MOC"|sed 's/_tm0\(....\)/+\1+/g'|sed 's/^TPU_0\(....\)/TPU_0\1+/'|sort  -t+ -k1,1 -k3,3 -k2,2|sed 's/+\(....\)+/_tm0\1/g'|sed 's/^TPU_0\(....\)+/TPU_0\1/'    |tee Input.txt 
fi
echo $(wc -l Input.txt | cut -d " " -f1) discount bonus usage rules found. Check if it is missing.
./slimSesDiscBonus.py  

 