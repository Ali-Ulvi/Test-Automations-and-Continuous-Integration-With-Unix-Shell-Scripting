#!/bin/bash

#Orchestration by AUT

if [[ $(ps -ef|egrep '/bin/bash .*geceImp.sh'|grep -v grep|wc -l ) -gt 0 ]] 
    then 
	echo Script zaten acik:
	ps -ef|grep geceImp|grep -v grep
	exit
	
fi

mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')
if [[ $mrteid -eq 2 ]] 
    then 
	echo mrte1 useriyla calistiriniz
	exit
	
fi

echo "Gece 2 de deployment'a baslanacak. Bilgisayari kapatabilirsiniz; sonuc mail atilacak. iptal etmek icin komut:"
echo "ps -ef|egrep '/bin/bash .*geceImp.sh'|grep -v grep|awk '{print \$2}'|xargs /usr/bin/kill "
echo
echo Ekran ciktisi dosyasi: nohupGece.out
cd /tmp/deploy

nohup ./geceImp.sh > nohupGece.out 2>&1&
