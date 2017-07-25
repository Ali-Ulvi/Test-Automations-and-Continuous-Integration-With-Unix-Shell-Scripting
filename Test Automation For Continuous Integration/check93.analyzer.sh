#! /usr/bin/bash
 
#AUThor


pid=$1
msisdn=$2
sms=$3 
gun=$4




grep ${msisdn} sms9333Log.$pid.$(date +%Y%m%d)*|egrep -v "Tebrikler! Mobil Heryone Tarifesi ile 30 gun boyunca yurtici heryone 10 dakikasi 60 kurusa konusabilirsiniz.|setPackageOrBonusExpiryDate|<MSGID>6384</MSGID>"


