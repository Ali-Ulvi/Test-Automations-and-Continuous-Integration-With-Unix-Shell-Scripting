#! /usr/bin/bash

#flawlessed by AUT
cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.${sec2}`
do
    /usr/bin/kill -9 $job 

done
rm pid.${sec2}
sleep 2
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

msisdn=$1
serviceID=$2
newServiceID=$3
bonusID=$4
fiyat=$5
fiyat2=$6
gun=$7
AVEA_DIR=$ORGADATA/avea
if [[ $# -ne 6&&$# -ne 7 ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullan�m: $0 MSISDN oldServiceID newServiceID FlagBonusID oldServicePrice newServicePrice "
	echo ya da paketKacGunluk opsiyonel parametetresi ile:
		echo "Kullan�m: $0 MSISDN oldServiceID newServiceID FlagBonusID oldServicePrice newServicePrice paketKacGunluk"
	echo "ornek kullanim:"
	echo ""
	echo "$0  05518170318 842 867 2110 23 25"
	echo 7 gunlukse paket:
	echo "$0  05518170318 842 867 2110 23 25 7"
	echo "Default is 30-day pkg. Tested with 30-day package"
	exit
fi
#export ORACLE_HOME=/export/home/mrte1/orgaroot/OracleClient11.2/client
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple

./renReloadinGrace $msisdn ${serviceID} $fiyat
ropName=$(  grep -oP "PP_.*0${serviceID}" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)         
aid=$(msisdn_to_accountid $msisdn )
echo "AccountID:"$aid
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
#echo "#d    $   = :AccountID '$aid'  " | idbm_adb -s CreTrigger
echo "#u  :Value   $  and     = :AccountID '$aid'   = :ID '1'   & '1'  " | idbm_adb -s CreBalance
  bundleid=$(grep $ropName $ORGADATA/cnf/cre/config_19700101000000.xml|  grep -oP "(?<=<bundle id=\")[^\"]+"   )
 echo bundleid:$bundleid  
#gold_operation_handler package $msisdn $ropName  INACT   > /dev/null 2>&1
#gold_operation_handler package $msisdn $ropName  ACT  # 2>&1 |grep ERROR
later=$(mu_date -6)"000000"
if [[ x$gun != "x" ]]
then
echo gun verilmis. not tested script area detected.
gun=$(expr $gun + 1)
if [ $gun -gt 0 ]
then
later=$(mu_date -$gun)"000000"
else
later=$(mu_date $gun)"000000"
fi
fi
ropName=$(  grep -oP "PP_.*0${newServiceID}" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1) 
gold_operation_handler package $msisdn $ropName  INACT   > /dev/null 2>&1
kalanPara=$(echo "#s  :Value   $  and     = :AccountID '$aid'   = :ID '1'      " | idbm_adb -s CreBalance|grep -v END|sed s/\'//g|perl -nl -MPOSIX -e 'print ceil($_);') 
 sec2=$(date +%Y%m%d%H%M%S)
 sec=$(date +%Y%m%d%H%M%S)

 #ruleid=$(echo "#s  :RuleID $  and = :AccountID '$aid' = :BundleID '$bundleid'   " | idbm_adb -s CreTrigger|grep -v END|sed s/\'//g)
#echo ruleid:$ruleid
if [[ $kalanPara -ne $(expr 100100 - $fiyat) ]]
then
	echo -e "\e[7m alis  ucreti yanlis.  ${NC}"
	echo eski paketi alirken dusen para:
	echo $(expr 100100 - $kalanPara) TL
fi
 

echo "#s :ID :Value :Start :End  $ and  and and and = :AccountID '$aid'  != :ID '2' != :ID '3' != :ID '7' != :Value '0' " | idbm_adb -s CreBalance

	
	tail -f -n 0 /rte/orgadata/mrte1/log/OUPM*[0-9]  > mrte1OUPMLog.txt&
	echo $! >> pid.$sec2
	tail -f -n 0 /rte/orgadata/mrte2/log/OUPM*[0-9]  > mrte2OUPMLog.txt&
	echo $! >> pid.$sec2
	 ssh bas@10.248.68.128 '/usr/local/bin/tail -F -n 0 /bas/orgadata/bas/log/bascs_01_02/BASLOG' > bascs_01_02_BASLOG.txt&
echo $! >> pid.$sec2   
 ssh bas@10.248.68.128 '/usr/local/bin/tail -F -n 0 /bas/orgadata/bas/log/bascs_01_01/BASLOG' > bascs_01_01_BASLOG.txt&
echo $! >> pid.$sec2 
ssh bsg@10.248.68.129 '/usr/local/bin/tail -F -n 0 /export/home/bsg/BSG_HOME/data/log/diag.log ' > bsgLog.txt&
echo $! >> pid.$sec2   

bonusName=$(  grep -oP "BL(B|C)_.*0${bonusID}" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)
echo "bonusName:"$bonusName
 
goldID=$(grep $bonusName $ORGADATA/cnf/cre/config_19700101000000.xml| grep -oP '(?<=<balance allow_negative="no" has_pockets="yes" id=")[^"]+')

sleep 2
sec=$(date +%Y%m%d%H%M%S)
echo "#u  :LastThrCheck $      = :AccountID '$aid'   &  '$sec' " | idbm_adb -s CreAccount
sleep 2
 sec=$(date +%Y%m%d%H%M%S)
   echo "#u    :End   $  and and   = :AccountID '$aid'   = :ID '$goldID' != :End '' & '$sec'  " | idbm_adb -s CreBalance|grep -v END|sed s/\'//g
later=$sec
   echo "#u  :ChargedToDate :NextTriggerDate $  and = :AccountID '$aid' = :BundleID '$bundleid' & '$later' '$later'" | idbm_adb -s CreTrigger 
echo trigger: $later
   
   echo bonusID start end:
    echo "#s :ID :Start  :End   $  and and   = :AccountID '$aid'   = :ID '$goldID' != :End ''  " | idbm_adb -s CreBalance|grep -v END|sed s/\'//g 
echo LastThrCheck:
echo "#s  :LastThrCheck $ = :AccountID '$aid'  " | idbm_adb -s CreAccount
#OUPMclient -Ds -M THR.check 
cre_threshold_check -R OHPQ/THR.check-EFD.thr -DID THR.check 2>&1 | grep -v nfa2dfa

sleep 11

mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')

if [[ $mrteid -eq 2 ]] 
    then 
	echo ssh mrte1: subsquery $msisdn B -- subsquery $msisdn P
	ssh mrte1@localhost "source .profile  > /dev/null 2>&1;subsquery $msisdn B;echo ---;subsquery $msisdn P"   
	else
	echo subsquery $msisdn B -- subsquery $msisdn P
	subsquery $msisdn B;echo ---;subsquery $msisdn P
	
fi
echo press enter for scheduler part
read a
sec=$(date +%Y%m%d%H%M%S)
 
sleep 3
rm BASDB
read pp < $AVEA_DIR/dbLogin  


echo 'update lc_sold_component_tbl set lc_date_from=to_date("'$sec'" , 'yyyymmDDhh24:MI:ss') where account_fk = "'$aid'" and lc_date_from =to_date("'$later'" , 'yyyymmDDhh24:MI:ss');'
#for UAT#  sqlplus -s >> BASDB  bastst2/bas123@10.248.68.124:1529/BAS2T << EOF
sqlplus -s >> BASDB  bastst1/bas123@10.248.68.135:1529/BAS1T << EOF
spool basSql
set pagesize 1000;
set linesize 1000

update lc_sold_component_tbl set lc_date_to=to_date('$sec' , 'yyyymmDDhh24:MI:ss')
where account_fk = '$aid'
and lc_date_to = to_date('$later' , 'yyyymmDDhh24:MI:ss');

update lc_sold_component_tbl set lc_date_from=to_date('$sec' , 'yyyymmDDhh24:MI:ss')
where account_fk = '$aid'
and lc_date_from = to_date('$later' , 'yyyymmDDhh24:MI:ss');

commit;

EXIT;
EOF
sleep 11
ssh bas@10.248.68.128 'source .profile; OUPMclient -Q scheduler'
echo sleep 180 seconds for the scheduler
sleep 180

kalanPara=$(echo "#s  :Value   $  and     = :AccountID '$aid'   = :ID '1'      " | idbm_adb -s CreBalance|grep -v END|sed s/\'//g|perl -nl -MPOSIX -e 'print ceil($_);') 

if [[ $kalanPara -ne $(expr 100100 - $fiyat - $fiyat2) ]]
then
	echo -e "\e[7m yenileme  ucreti yanlis.  ${NC}"
	echo yeni paket yenilenirken dusen para:
	echo $(expr 100100 - $fiyat - $kalanPara) TL
fi


   for job in `cat pid.${sec2}`
do
    /usr/bin/kill -9 $job > /dev/null 2>&1

done
rm pid.${sec2}
echo
echo Uzerinde 2ser bonus olmali. yenilemeden gelenle ve eski paketten gelenler:
echo
if [[ $mrteid -eq 2 ]] 
    then 
	echo ssh mrte1: subsquery $msisdn B -- subsquery $msisdn P
	ssh mrte1@localhost "source .profile  > /dev/null 2>&1;subsquery $msisdn B;echo ---;subsquery $msisdn P"   
	else
	echo subsquery $msisdn B -- subsquery $msisdn P
	subsquery $msisdn B;echo ---;subsquery $msisdn P
	
fi
echo
echo "#s :ID :Value :Start :End  $ and  and and and = :AccountID '$aid'  != :ID '2' != :ID '3' != :ID '7' != :Value '0' " | idbm_adb -s CreBalance

echo yenilenmediyse 1dk daha bekleyin. goodbye.
