#! /usr/bin/bash
 
#AUThor

 if [[ $# -ne 3&&$# -ne 4&&$# -ne 5 ]] 
    then 
        echo "illegal number of parameters"
        echo "Kullanim: $0 ID msisdn sms [gun]"
        echo "ornek kullanim:"
        echo ""
        echo "$0 $$ 0501135135 'Degerli musterimiz, daha cok harcayiniz.'"
         echo "$0 $$ 0501135135 'Degerli musterimiz, daha cok harcayiniz.' 60"
        exit
fi
pid=$1
msisdn=$2
sms=$3 
gun=$4
ikinciSms=$5
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple

#SMSlere tarih saat ekleme project start
tarih=$(mu_date -30)  
if [[ $# -gt 3 ]] 
    then 
tarih=$(mu_date -$gun)
echo tarih $tarih
fi	
gun=$(echo $tarih|sed 's/\(.*\)\(..\)/\2/')
ay=$(echo $tarih|sed 's/\(.*\)\(..\)../\2/')
yil=$(echo $tarih|sed 's/\(.*\)\(..\)../\1/')
saat=23:59
tarih2=$gun\/$ay\/$yil
sms=$(echo "$sms"|sed "s|a kadar|a kadar ?|g"|sed "s|<TARIH>|$tarih2|g"|sed "s|<SAAT>|$saat|g" |sed "s|HH:MI|$saat|g"|sed "s|DD\/MM\/YYYY|$tarih2|g"|sed "s|’|'|g"|sed 's/^ //'|sed 's/ $//'|sed 's/\.$//'|sed "s|*|\\\*|g"|sed "s|\.|\\\.|g"|sed -e "s|(|\\\(|g"|sed -e "s|\[|\\\[|g"|sed -e "s|\]|\\\]|g"|sed -e "s|)|\\\)|g"|sed -e "s|baslayabilirsin J$|baslayabilirsin :\\\)|g"|sed "s|DD.MM.YY tarihine kadar gecerli ||g")
ikinciSms=$(echo "$ikinciSms"|sed "s|a kadar|a kadar ?|g"|sed "s|<TARIH>|$tarih2|g"|sed "s|<SAAT>|$saat|g" |sed "s|HH:MI|$saat|g"|sed "s|DD\/MM\/YYYY|$tarih2|g"|sed "s|’|'|g"|sed 's/^ //'|sed 's/ $//'|sed 's/\.$//'|sed "s|*|\\\*|g"|sed "s|\.|\\\.|g"|sed -e "s|(|\\\(|g"|sed -e "s|\[|\\\[|g"|sed -e "s|\]|\\\]|g"|sed -e "s|)|\\\)|g"|sed -e "s|baslayabilirsin J$|baslayabilirsin :\\\)|g"|sed "s|DD.MM.YY tarihine kadar gecerli ||g")
#project finished

if [[ $(grep "OutgoingSms to Msisdn :9${msisdn}smsText :" sms9333Log.$pid.$(date +%Y%m%d)*|egrep "smsText :\s?\s?\s?$sms\.?\s?\s?\s?\s?( B001)?$"|wc -l) -ne 1 ]]
then
echo cat log:
cat sms9333Log.$pid.$(date +%Y%m%d)*
echo tail:
tail sms9333Log.$pid.$(date +%Y%m%d)*
echo
echo grep msisdn:
egrep ${msisdn} sms9333Log.$pid.$(date +%Y%m%d)*
echo BULUNAMADI
else
#grep ${msisdn} sms9333Log.$pid.$(date +%Y%m%d)*
grep "OutgoingSms to Msisdn :9${msisdn}smsText :" sms9333Log.$pid.$(date +%Y%m%d)*|egrep "smsText :\s?\s?\s?$sms\.?\s?\s?\s?\s?"
	if [[ "$ikinciSms" != "" ]]
	then
		if [[ $(grep "OutgoingSms to Msisdn :9${msisdn}smsText :" sms9333Log.$pid.$(date +%Y%m%d)*|egrep "smsText :\s?\s?\s?$ikinciSms\.?\s?\s?\s?\s?( B001)?$"|wc -l) -eq 1 ]]
		then
			grep "OutgoingSms to Msisdn :9${msisdn}smsText :" sms9333Log.$pid.$(date +%Y%m%d)*|egrep "smsText :\s?\s?\s?$ikinciSms\.?\s?\s?\s?\s?"
			echo BASARILI
		else
			echo 2. SMS bulunamadi veya yanlis
		fi
	else #tek sms
	echo BASARILI
	fi
fi

if [[ "$ikinciSms" != "" ]]
then
	if [[ `egrep -v '<MSGID>6384</MSGID>|<MSGID>1</MSGID>|^$|><MSGID>3</MSGID>|<MSGID>4</MSGID>|<MSGID>1833</MSGID>|<MSGID>18..</MSGID>'  sms9333Log.$pid.$(date +%Y%m%d)*|grep $msisdn|grep -oP "(?<=<MSGID>)[^<]+"|wc -l` -gt 2 ]] 
    then 
	grep ${msisdn} sms9333Log.$pid.$(date +%Y%m%d)*    
	echo  " ikiden fazla sms belirlendi. Fazladan bir SMS gidiyor mu kontrol ediniz."
	fi
else
	if [[ `egrep -v '<MSGID>6384</MSGID>|<MSGID>1</MSGID>|^$|><MSGID>3</MSGID>|<MSGID>4</MSGID>|<MSGID>1833</MSGID>|<MSGID>18..</MSGID>'  sms9333Log.$pid.$(date +%Y%m%d)*|grep $msisdn|grep -oP "(?<=<MSGID>)[^<]+"|wc -l` -gt 1 ]] 
    then 
	grep ${msisdn} sms9333Log.$pid.$(date +%Y%m%d)*    
	echo  " Birden fazla sms belirlendi. Fazladan bir SMS gidiyor mu kontrol ediniz."
	fi
fi


