#! /usr/bin/bash

# ci layer by AUT C8H10N4O2 
 
msisdn=$1
servislerDosyasi=$2
smslerDosyasi=$3
deploy=$4 #4. parametre yerine deploy yazilirsa deploy yapar.
work_dir=/tmp/CI
cd $work_dir
aid=$(msisdn_to_accountid $msisdn )
if [   -z "$servislerDosyasi" ]
then
#echo srv bos
servislerDosyasi=servisID_Fiyat.txt
fi


if [  -z "$smslerDosyasi" ]
then
#echo smsler bos
smslerDosyasi=100SMSleri.txt
fi

popSMS()
{
#using array for file lines
sms="${smsler[$counter]}"
#echo popped sms: "$sms"
#counter=$(($counter+1)) 
}

testBilgi="$0 $@"
doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "\n *** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
  echo -en Merhaba\\n\\n $1 '\n\nIyi Calismalar\n\nAUT\nKafein CI Solutions\n\n' > tmp$msisdn

cat output$msisdn|egrep -v '^\*' >> tmp$msisdn
 scp tmp$msisdn mrte1@10.248.68.122:/tmp
 ssh mrte1@10.248.68.122 "source .profile; cat /tmp/tmp$msisdn| mailx -s \"$testBilgi $(cat .servisIDler$msisdn.txt|grep [0-9]|egrep -v '^#' |xargs echo)\" $EMAIL_LIST"
#ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"Defect: $testBilgi\" $EMAIL_LIST"
fi
done < .mail
  
}
grep '[0-9]' $servislerDosyasi|egrep -v '^#' > .servisIDler$msisdn.txt

grep '[a-zA-Z]' $smslerDosyasi |egrep -v '^#' >.100SMSleri$msisdn.txt
#smslerin bas ve sonlarinda fazla bosluk varsa silinir. bu muhtemelen testerin visiodan kopyalama hatasidir.:
sed 's/^ //' .100SMSleri$msisdn.txt|sed 's/ $//'   > tmp80
cp tmp80 .100SMSleri$msisdn.txt

if [[ "$deploy" = "deploy" ]]
then
cd /tmp/deploy
echo starting DEPLOYMENT
nohup ./deploy.sh
cd $work_dir
fi
  rm checkedBonuses$msisdn  > /dev/null  2>&1
if [[ $(egrep 'ð|ü|ý|þ|ç|ö|Ö|Ç|Þ|Ý|Ð|Ü|’' .100SMSleri$msisdn.txt|wc -l) -ne 0 ]]
then
echo Turkce Karakterli veya ters tirnak isaretli  satirlar:
egrep 'ð|ü|ý|þ|ç|ö|Ö|Ç|Þ|Ý|Ð|Ü|’' .100SMSleri$msisdn.txt
echo
echo $smslerDosyasi de Turkce karakterler veya ters tirnak isareti var. Bunlar ingilizce karsiliklariyla degistiriliyor.
doMail "$smslerDosyasi de Turkce karakterler veya ters tirnak isareti var. Bunlar ingilizce veya normal kesme isareti karsiliklariyla otomatik degistiriliyor. Developer da ayni seyi yapmamissa metinler eslesmeyeceginden scriptten hata mailleri gelecektir. sms9333 Turkce ve UTF-8 desteklemediginden Turkce karakter vs. kullanilmamali."
fi 

cat .100SMSleri$msisdn.txt| tr 'ðüýþçöÖÇÞÝÐÜ’' "guiscoocsigu'" > tmp$msisdn
mv tmp$msisdn .100SMSleri$msisdn.txt
 IFS=$'\r\n' GLOBIGNORE='*' command eval  'smsler=($(cat .100SMSleri$msisdn.txt))'
  echo :DEBUG: first sms:
  echo "${smsler[0]}"
###################dana - kuyruk
counter=0
servisCnt=0
while read serviceid_fiyat
do
serviceid=$(echo "$serviceid_fiyat"|awk '{print $1}')
bncnt=$(cat checkedBonuses$msisdn|wc -l)
if [ ! -z "$serviceid" ]
then
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
if [ $(gold_operation_handler package $msisdn $serviceid  ACT   2>&1 |grep ERROR|wc -l) -gt 0 ]
then
#fatality
echo " paket verilemedi: gold_operation_handler package $msisdn $serviceid  ACT"
doMail "fatality: paket verilemedi: gold_operation_handler package $msisdn $serviceid  ACT    bu paket atlaniyor."
continue
fi

#bonusCount=`echo "#s :ID   $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance|grep -v END| sed "s/'//g" |sort|uniq|wc -l`
#bonusCnt=0
	for bonus in `echo "#s :ID   $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance|grep -v END| sed "s/'//g" |sort|uniq`
	do
#bonusCnt=$(($bonusCnt+1))
	#  sorry for verbose code as it is a one-man test project	
	if [[ $(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="Seconds"'|wc -l) -eq 1 ]]
	then
	bonusid=$(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="Seconds"'| grep -oP '(?<=name=")[^"]+'|sed 's/\(.*\)\(....\)/\2/')
	if [ ! -z "$bonusid" ]
	then
		if [[ $(grep $bonusid checkedBonuses$msisdn|wc -l) -eq 0 ]]
		then
			
			counter=$(expr $counter   + 1) #counter is to detect which sms should be used
			popSMS #fills "$sms" variable. it is a function above
			echo ./100 $msisdn $serviceid $bonusid dk "$sms" 
			./100 $msisdn $serviceid $bonusid dk "$sms" 
			echo $bonusid >> checkedBonuses$msisdn
		fi
	else
		echo bonus id $ORGADATA/cnf/cre/config_19700101000000.xml den cekilemedi. $bonus
		doMail "bonus id $ORGADATA/cnf/cre/config_19700101000000.xml den cekilemedi $bonus"
	fi
	elif [[ $(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="SMS"'|wc -l) -eq 1 ]]
	then
	bonusid=$(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX| grep -oP '(?<=name=")[^"]+'|sed 's/\(.*\)\(....\)/\2/')
	if [ ! -z "$bonusid" ]
	then
		if [[ $(grep $bonusid checkedBonuses$msisdn|wc -l) -eq 0 ]]
		then
	counter=$(expr $counter   + 1) #counter is to detect which sms should be used
	
	popSMS #fills "$sms" variable. it is a function above
	echo ./100 $msisdn $serviceid $bonusid sms "$sms" 
	./100 $msisdn $serviceid $bonusid sms "$sms" 
	echo $bonusid >> checkedBonuses$msisdn
		fi
	else
		echo bonus id $ORGADATA/cnf/cre/config_19700101000000.xml den cekilemedi. $bonus
		doMail "bonus id $ORGADATA/cnf/cre/config_19700101000000.xml den cekilemedi $bonus"
	fi
	elif [[ $(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="Bytes"'|wc -l) -eq 1 ]]
	then
	bonusid=$(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX| grep -oP '(?<=name=")[^"]+'|sed 's/\(.*\)\(....\)/\2/')
	if [ ! -z "$bonusid" ]
	then
		if [[ $(grep $bonusid checkedBonuses$msisdn|wc -l) -eq 0 ]]
		then
	counter=$(expr $counter   + 1) #counter is to detect which sms should be used
	popSMS #fills "$sms" variable. it is a function above
	echo ./100 $msisdn $serviceid $bonusid data "$sms" 
	./100 $msisdn $serviceid $bonusid data "$sms" 
	echo $bonusid >> checkedBonuses$msisdn
		fi
	else
		echo bonus id $ORGADATA/cnf/cre/config_19700101000000.xml den cekilemedi. $bonus
		doMail "bonus id $ORGADATA/cnf/cre/config_19700101000000.xml den cekilemedi $bonus"
	fi
 fi #sms data dk mi
	done #read bonuses
	bncnt2=$(cat checkedBonuses$msisdn|wc -l)
	if [[ "$bncnt2" != "$bncnt" ]]
		then
	servisCnt=$(($servisCnt+1)) 
	fi
else #srvid bos satirsa
doMail "srvid empty in serviceids. ignoring line.. servisID_Fiyat.txt dosyasinda yanlis format. "
continue

fi
done < .servisIDler$msisdn.txt
 
sleep 1
  doMail " 100  Test kosumu tamamlandi $msisdn"
    sleep 11
  rm .servisIDler$msisdn.txt .100SMSleri$msisdn.txt checkedBonuses$msisdn


