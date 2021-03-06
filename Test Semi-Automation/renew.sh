#! /usr/bin/bash
 
msisdn=$1
serviceID=$2
price=$3
AVEA_DIR=$ORGADATA/avea
if [[ $# -ne 2&&$# -ne 3 ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullan�m: $0 MSISDN serviceID yenilemeUcreti "
	echo "ornek kullanim:"
	echo ""
	echo "$0 05011011111 650"
	echo "$0 05011011111 650 17"

	exit
fi
#export ORACLE_HOME=/export/home/mrte1/orgaroot/OracleClient11.2/client
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple

ropName=$(  grep -oP "PP_.*0${serviceID}" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)         
aid=$(msisdn_to_accountid $msisdn )


echo "AccountID:"$aid
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
#echo "#d    $   = :AccountID '$aid'  " | idbm_adb -s CreTrigger
echo "#u  :Value   $  and     = :AccountID '$aid'   = :ID '1'   & '1000'  " | idbm_adb -s CreBalance

gold_operation_handler package $msisdn $ropName  INACT   > /dev/null 2>&1
gold_operation_handler package $msisdn $ropName  ACT   2>&1 |grep ERROR
kalanPara=$(echo "#s  :Value   $  and     = :AccountID '$aid'   = :ID '1'      " | idbm_adb -s CreBalance|grep -v END|sed s/\'//g|perl -nl -MPOSIX -e 'print ceil($_);') 
 sec=$(date +%Y%m%d%H%M%S)
 bundleid=$(grep $ropName $ORGADATA/cnf/cre/config_19700101000000.xml|  grep -oP "(?<=<bundle id=\")[^\"]+"   )
 echo bundleid:$bundleid  
 ruleid=$(echo "#s  :RuleID $  and = :AccountID '$aid' = :BundleID '$bundleid'   " | idbm_adb -s CreTrigger|grep -v END|sed s/\'//g)
echo ruleid:$ruleid
if [[ $kalanPara -ne `expr 1000 - $price` ]]
then
	echo -e "\e[7m Kayit ucreti yanlis.  ${NC}"
	echo $kalanPara
fi

 
#eksikUcret=$(echo  "$price-0.0001"|bc -l) 
later=$(mu_date -31)"000000"


			echo "#u  :Value   $  and     = :AccountID '$aid'   = :ID '1'   & '$price'  " | idbm_adb -s CreBalance
 



	
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/EFD.smsdelay_0?-WA.smsdelay_spreader_0?/data.*&
	echo $! >> pid.$sec
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/WA.smsdelay_spreader_0?-WA.smsdelay_0?/data.*&
	echo $! >> pid.$sec
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/EFD.smsdelay_0?-EFD.sms9333_0?/data.*&
	echo $! >> pid.$sec
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/EFD.sms9333_0?-EVD.sms9333_0?/data.* > evdSMS9333&
	echo $! >> pid.$sec

	
	
 	echo -e "******----------------RENEW TEST EDILIYO--------------------******${NC}"
	#echo -e "${red}******--------------------------------------------------------------******${NC}"
 today_isodate=$(ots_date -S `date +%'Y'%'m'%'d'000000` +31d)
  echo "SMS OHPQ'lar tail'lendi"
 echo -e "${red2}cre_batch kosuluyor"
$ORGAROOT/run/bin/cre_batch -e $today_isodate -r 70,$ruleid  -DID BAT.manually  -a $aid > /dev/null 2>&1
kalanPara=$(echo "#s  :Value   $  and     = :AccountID '$aid'   = :ID '1'      " | idbm_adb -s CreBalance|grep -v END|sed s/\'//g|perl -nl -MPOSIX -e 'print ceil($_);') 
if [[ $kalanPara -ne 0 ]]
then
	echo -e "\e[7m Yenileme ucreti yanlis.  ${NC}"
	echo $kalanPara
fi
gold_operation_handler reload $msisdn 1000   2>&1|grep ERROR
echo "#s :ID :Value :Start :End  $ and and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' != :Value '0' " | idbm_adb -s CreBalance

echo -e "${red2}SMS'in kendili�inden gitmedi�ini g�rmek i�in 20 saniye bekliyoruz. SMS9333 loglar�na bir �ey gelmemeli.${NC}"
sleep 20
echo -e "${red2}20 saniye bitti. SMS_DELAY WA calistiriliyor"
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
 logGrep=$(grep "I:0:$ropName:$msisdn has been notified about package renewal." smsDelayLog|wc -l)
 
 if [[ $logGrep -eq 0 ]] 
    then 
	 echo -e "\e[7m  SMS_DELAY WA Loguna gereken gelmedi  ${NC}"
	
fi

smsid=`egrep -v '==|^$|><MSGID>3</MSGID>'  evdSMS9333|grep $msisdn|grep -oP "(?<=<MSGID>)[^<]+"|tail -1`
echo -e "${red}******--------------OHPQ'daki MSGID'nin SMS metni:--------------------******${NC}"
		result=$(sqlplus -s APSATl/apsatl234@"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=sms9333t_cluster)(PORT=1529))(CONNECT_DATA=(SERVER=dedicated)(SERVICE_NAME=VAS93T)))"  << EOF
		set heading off
		select distinct sms_text from apsatl.sms_text where sms_id=${smsid};
		EXIT;
		EOF)
	echo -e "\e[7m$result"
echo -e "${red}******--------------------------------------------------------------******${NC}"

rm BASDB
sleep 5
read pp < $AVEA_DIR/dbLogin  
#for UAT#  sqlplus -s >> BASDB  bastst2/bas123@10.248.68.124:1529/BAS2T << EOF
sqlplus -s >> BASDB  bastst1/bas123@10.248.68.135:1529/BAS1T << EOF
whenever sqlerror exit sql.sqlcode
set feedback off;
set head off;
set pagesize 0;
set linesize 1000

select b.lc_state|| '|' || to_char(B.LC_DATE_FROM,'YYYYMMDDHH24MISS')|| '|' ||to_char(B.LC_DATE_TO,'YYYYMMDDHH24MISS') from SOLD_COMPONENT_TBL a, LC_SOLD_COMPONENT_TBL b where a.account_fk=${aid} and  A.SOLD_COMPONENT_ID=B.SOLD_COMPONENT_FK and a.SOLD_COMPONENT_NAME like '%0${serviceID}%'  and b.LC_STATE='ACT' and B.LC_DATE_TO>sysdate;

EXIT;
EOF

 
actTO=$(grep ACT BASDB|cut -d'|' -f3)
 

if [[ $actTO -ne '22000101000000' ]] 
    then 
	 echo -e "\e[7m  ACT TO_DATE 2200 degil: $actTO  ${NC}"
	
fi
  
