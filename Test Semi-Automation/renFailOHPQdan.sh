#! /usr/bin/bash
  
 #Scientist: AUT 
 #Purpose: Bug WA
 
#msisdn=$1
servisID=$1 #650 gibi

#file=subsquery_$msisdn_m
#while ! grep -q $msisdn $file  ; do
#    echo checkMsisdn$$ loop
#        subsquery $msisdn m 2>&1 > $file
#done      

#imsi=`grep IMSI $file|/usr/local/bin/grep -o [0-9]*`

#/usr/local/bin/grep -o

msisdn=05070008334

sec=$(date +%Y%m%d%H%M%S)
cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
rm pid.${sec}
  return $?
}
 
control_c()
# run if user hits control-c
{
  #echo -en "\n*** Ouch! Exiting ***\n"
  cleanup
  exit $?
}
 
# trap keyboard interrupt (control-c)
trap control_c SIGINT

tail -f -n 0 /rte/orgadata/mrte?/OHPQ/EFD.smsdelay_0?-WA.smsdelay_spreader_0?/data.*&
echo $! >> pid.$sec
tail -f -n 0 /rte/orgadata/mrte?/OHPQ/WA.smsdelay_spreader_0?-WA.smsdelay_0?/data.*&
echo $! >> pid.$sec
tail -f -n 0 /rte/orgadata/mrte?/OHPQ/EFD.smsdelay_0?-EFD.sms9333_0?/data.*&
echo $! >> pid.$sec
tail -f -n 0 /rte/orgadata/mrte?/OHPQ/EFD.sms9333_0?-EVD.sms9333_0?/data.* > evdSMS9333&
echo $! >> pid.$sec

servisID=$(printf "%05d\n" $servisID)
ropName=$(  grep -oP "PP_.*_$servisID" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)
sed "s/PP_BimcellYeniGrupiciSinirsiz_Service_01506/$ropName/" ohpq > ohpq.tmp


PutOHPQ OHPQ/EFD.all-EFD.sms_01 ohpq.tmp

echo sleep 11 sec. to verify sms not coming immediately but later with SMS_DELAY WA
sleep 11
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple
#start log gathering
ip=$(grep SMS.Host\= $ORGADATA/site-config/port.cfg|grep -v \#|cut -d= -f2)
user=sms9333
ARGELA_LOG_DIR=/argela/APSA/deploy/logs


 /usr/bin/ssh $user@$ip "tail -0f $ARGELA_LOG_DIR/APSA_CORE_H*I0.log" 2>&1 > sms9333Log.$msisdn.$sec.$ip &
echo $! >> pid.$sec 
 
echo -e "${red2}11 saniye bitti. SMS_DELAY WA calistiriliyor $NC"
#log harvesting:
rm smsDelayLog
logFile=$(ls -1t $ORGADATA/avea/work/SMS_DELAY/log/$(date +%Y%m)/smsdelay*log|head -1)
tail -f -n 0 $logFile > smsDelayLog &
echo $! >> pid.$sec
OUPMclient -Q smsdelay_spreader_01 >> /dev/null       2>&1
sleep 2
OUPMclient -Q smsdelay_spreader_01   >> /dev/null       2>&1
sleep 2
OUPMclient -Q smsdelay_spreader_01       >> /dev/null       2>&1
sleep 5
OUPMclient -Q sms_delay_01  >> /dev/null       2>&1


mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')
if [[ $mrteid -eq 2 ]] 
    then 
	ssh mrte1@localhost 'source .profile;OUPMclient -Q smsdelay_spreader_01;sleep 2;OUPMclient -Q smsdelay_spreader_01;sleep 2;OUPMclient -Q smsdelay_spreader_01 ;sleep 5;OUPMclient -Q sms_delay_01'   > /dev/null       2>&1
	else
	ssh mrte2@localhost 'source .profile;OUPMclient -Q smsdelay_spreader_01;sleep 2;OUPMclient -Q smsdelay_spreader_01;sleep 2;OUPMclient -Q smsdelay_spreader_01 ;sleep 5;OUPMclient -Q sms_delay_01' > /dev/null       2>&1
	
fi

OUPMclient -Q smsdelay_spreader_01 >> /dev/null       2>&1
sleep 2
OUPMclient -Q smsdelay_spreader_01   >> /dev/null       2>&1
sleep 2
OUPMclient -Q smsdelay_spreader_01       >> /dev/null       2>&1
sleep 5
OUPMclient -Q sms_delay_01  >> /dev/null       2>&1
sleep 6
for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
rm pid.$sec
echo "SMS_DELAY Log:"
 echo ""

 grep "I:0:$ropName:$msisdn has been notified about package renewal." smsDelayLog
 echo ""
logGrep=$(grep "I:0:$ropName:$msisdn has been notified about renewal since renew failed and no renewal occured during night." smsDelayLog|wc -l)
 
 if [[ $logGrep -eq 0 ]] 
    then 
	 echo -e "\e[7m  SMS_DELAY WA Loguna gereken gelmedi  ${NC}"
	
fi

smsid=`egrep -av '==|^$|><MSGID>3</MSGID>|><MSGID>4</MSGID>'  evdSMS9333|grep $msisdn|grep -oP "(?<=<MSGID>)[^<]+"|tail -1`
echo $smsid
echo -e "${red}******--------------OHPQ'daki MSGID'nin DBdeki OUTBOUND_SMS_RULES kaydi:--------------------******${NC}"
result=$(sqlplus -s APSATl/apsatl234@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=sms9333t_cluster)(PORT=1529))(CONNECT_DATA=(SERVER=dedicated)(SERVICE_NAME=VAS93T)))"  << EOF
		set heading off

		select *  from apsatl.OUTBOUND_SMS_RULES where sms_id=${smsid} or MESSAGE_ID=${smsid};
		EXIT;
		EOF)
				echo -e "\e[7m$result"
		 
echo -e "${red}******--------------------------------------------------------------******${NC}"

echo -e "${red}******--------------OHPQ'daki MSGID'nin SMS metni:--------------------******${NC}"
		result=$(sqlplus -s APSATl/apsatl234@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=sms9333t_cluster)(PORT=1529))(CONNECT_DATA=(SERVER=dedicated)(SERVICE_NAME=VAS93T)))"  << EOF
		set heading off
		select distinct sms_text from apsatl.sms_text where sms_id=${smsid};
		EXIT;
		EOF)
	echo -e "\e[7m$result"
echo -e "${red}******--------------------------------------------------------------******${NC}"
echo SMS9333 LOGU - Aboneye giden SMSler :

echo -e "${red2}"
grep $msisdn sms9333Log.$msisdn.$sec.$ip|egrep -v '<CdrData>|Degerli musterimiz,Liralariniz kisa surede bitecektir.Turk Telekom Grup magazalari,ATMler veya www.turktelekom.com.tr online islemler sayfasindan mobil hattiniza yukleme yapabilirsiniz B001|Degerli musterimiz,mobil hattiniz icin TL yuklemeniz basariyla gerceklesmistir.Mevcut bakiyeniz '|grep -oP 'OutgoingSms.*'
echo
rm sms9333Log.$msisdn.$sec.$ip