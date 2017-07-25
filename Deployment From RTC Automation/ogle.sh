#!/bin/bash

#Orchestration by AUT

if [[ $(ps -ef|egrep '/bin/bash .*ogleImp.sh'|grep -v grep|wc -l ) -gt 0 ]] 
    then 
	echo Script zaten acik:
	ps -ef|grep ogleImp|grep -v grep
	exit
	
fi

mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')
if [[ $mrteid -eq 2 ]] 
    then 
	echo mrte1 useriyla calistiriniz
	exit
	
fi

sec=$(date '+%H%M%S')
if [[ $sec -gt 120648 ]] 
    then 
	echo script sadece ogleden once yani 12:07den once kullanim icindir. deploy.sh scriptini manuel calistirmayi deneyiniz. Gece deploy icin gece.sh i kullanabilirsiniz. Sistem zamani yanlissa unix adminlere danisiniz.
	exit
	
fi

echo "12:07 de deployment'a baslanacak. Bilgisayari kapatabilirsiniz; sonuc mail atilacak. iptal etmek icin komut:"
echo "ps -ef|egrep '/bin/bash .*ogleImp.sh'|grep -v grep|awk '{print \$2}'|xargs /usr/bin/kill "
echo
echo Ekran ciktisi dosyasi: nohupOgle.out
cd /tmp/deploy

nohup ./ogleImp.sh > nohupOgle.out 2>&1&
