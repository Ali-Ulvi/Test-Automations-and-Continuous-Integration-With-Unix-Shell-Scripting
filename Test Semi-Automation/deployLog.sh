#!/bin/bash

#Tested by 07(10000+200+4)

cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
rm pid.${sec}
rm locked
ls -lrt  
date
sleep 1

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

doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "\n*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s 'Deploy Hata - Agile Ortami' $EMAIL_LIST"
fi
done < .mail
  
}


mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')
if [[ $mrteid -eq 2 ]] 
    then 
	echo mrte1 useriyla calistiriniz
	exit
	
fi
#if [[ -s locked ]]
#then
#echo "script zaten calisiyor."
#exit
#fi
#

if [[ $(ps -ef|grep deploy.shSleep|grep -v grep|grep -v /bin/bash|wc -l) -ne 0 ]]
then
ps -ef|grep deploy.shSleep|grep -v grep
echo
	echo -e "Script ileri tarihte calismak uzere acilmis. Onu kill ettikten sonra tekrar deneyiniz. kill etmek icin bu komutu kosunuz:\\nps -ef|grep deploy.shSleep|grep -v grep|awk '{print $2}'|xargs /usr/bin/kill"
	exit
fi

if [[ $(ps -ef|grep deploy.sh|grep -v grep|grep -v /bin/bash|wc -l) -ne 0 ]]
then
ps -ef|grep deploy.sh|grep -v grep
	echo "script zaten calisiyor."
	#exit
fi

#sleep 7200
cat maillist.txt |xargs echo > .mail
 sec=$(date +%Y%m%d%H%M%S)

if [ "$(head -1 patchTest)" -gt ${sec} ]
then
        echo Patch Testi yapiliyor. Yarin deneyiniz ya da DEV ortamini kullaniniz. Developerlarin test ortamini kullanmamasini rica ederiz.
        exit
fi

echo locked > locked
 cat maillist.txt |xargs echo > .mail
echo script baslangic: > log
date >> log
echo script baslangic:
date
 

 #notify subscribers
 while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;echo -en \"Starting to deploy to Agile Environment from $(grep RTC_TST1_STREAM /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/scripts/rtc_refresh_gold_config.properties) \\n 5 dakika RTEde 10dk BASda kesinti bekleniyor.\"  | mailx -s 'Agile ortamina Deployment Basliyor ^_^' $EMAIL_LIST"
fi
done <.mail

 
echo komut: rtc_refresh_gold_config
rtc_refresh_gold_config 2>&1|tee rtc_refresh_gold_config.log
echo ---
  ls -lrt $ORGAROOT; ls -lrt $ORGAROOT/si
#yea
if [ -s /tmp/deploy/warning_list.mail ]
then 
#cd /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/scripts
scp /tmp/deploy/warning_list.mail mrte1@10.248.68.122:/tmp
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;cat /tmp/warning_list.mail| mailx -s 'Check Comment sonucu - Agile Ortami' $EMAIL_LIST"
fi
done < /tmp/deploy/.mail
#cd -
fi
  
  #�nemli bir hata olmadigi halde hata basarsa if den fi ye  7 satiri silip kaldiriniz.
  if [[ $(grep -i 'nvalid password' rtc_refresh_gold_config.log|wc -l) -gt 0 || $(grep :P: rtc_refresh_gold_config.log|wc -l) -gt 0 || $(grep 'ERROR\s:' rtc_refresh_gold_config.log|wc -l) -gt 0 || $(grep -i 'Could not create' rtc_refresh_gold_config.log|wc -l) -gt 0 ]]
then
	echo   "rtc_refresh_gold_config hata verdi galiba. /tmp/deploy/rtc_refresh_gold_config.log dosyasini kontrol ediniz"
	cat rtc_refresh_gold_config.log 
	doMail "rtc_refresh_gold_config hata verdi galiba. /tmp/deploy/rtc_refresh_gold_config.log dosyasini kontrol ediniz"
	cleanup;exit
fi

#cp $ORGAROOT/si/bas/db/cr_property.sql  cr_property.sql.orj
#sed "/setProperty (oid_bas_rte, 'instances', '1,3,5,7');/s|setProperty (oid_bas_rte, 'instances', '1,3,5,7');|setProperty (oid_bas_rte, 'instances', '1,3');|" $ORGAROOT/si/bas/db/cr_property.sql  > tmpdosya
#mv tmpdosya  $ORGAROOT/si/bas/db/cr_property.sql
#diff $ORGAROOT/si/bas/db/cr_property.sql  cr_property.sql.orj
#
#
#scp $ORGAROOT/si/bas/db/cr_property.sql bas@10.248.68.128:/bas/orgaroot/bas/si/bas/db/cr_property.sql
#scp $ORGAROOT/si/bas/db/cr_property.sql mrte2@localhost:/rte/orgaroot/mrte2/si/bas/db/cr_property.sql
#
# ssh bas@10.248.68.128 'source .profile;which sql;  sql bas @ /bas/orgaroot/bas/si/bas/db/cr_property.sql'

 oupm_stop
 ssh mrte2@localhost 'source .profile;oupm_stop'

op_date=$(date +%Y%m%d)
#alias l='ls -lrt'
tail -F /rte/orgadata/mrte2/log/OUPMRTELOG_${op_date}.[0-9]*[^gz] > mrte2OUPMLog.txt &
echo $! > pid.$sec   
tail -F /rte/orgadata/mrte1/log/OUPMRTELOG_${op_date}.[0-9]*[^gz] > mrte1OUPMLog.txt&
echo $! >> pid.$sec   
 ssh bas@10.248.68.128 '/usr/local/bin/tail -F /bas/orgadata/bas/log/bascs_01_02/CSLOG' > bascs_01_02_CSLOG.txt&
echo $! >> pid.$sec   
 ssh bas@10.248.68.128 '/usr/local/bin/tail -F /bas/orgadata/bas/log/bascs_01_01/CSLOG' > bascs_01_01_CSLOG.txt&
echo $! >> pid.$sec 

#link degilse cf yi sil
#if [[ $( ls -l $ORGADATA/cnf/reg/scp/zones/cf|grep inss7moc|wc -l) -eq 0 ]]
#then
#echo moving cf 
#mv $ORGADATA/cnf/reg/scp/zones/cf $ORGADATA/cnf/reg/scp
#ssh mrte2@localhost 'source .profile;mv $ORGADATA/cnf/reg/scp/zones/cf $ORGADATA/cnf/reg/scp' 
#fi

echo komut: si-check-orgadata --fix-data --fix-conf --fix-env --fix-struct > mrte1.si-check-orgadata.log 2>&1  
si-check-orgadata --fix-data --fix-conf --fix-env --fix-struct > mrte1.si-check-orgadata.log 2>&1  
hata=$(grep -v ':E:Old entry cnf/reg/scp/zones/cf.old replaced by symlinked should be checked.' mrte1.si-check-orgadata.log|egrep ':E:|:P:'|grep -v ':P:Errors occured in checking $ORGADATA.'|grep -v 'that do not belong here'|wc -l)
hata2=$(grep 'that do not belong here' mrte1.si-check-orgadata.log|wc -l)
if [[ $hata -ne 0||$hata2 -ne 1 ]]
then
	echo   "si-check-orgadata mrte1de hata verdi galiba. kontrol ediniz"
	cat mrte1.si-check-orgadata.log
	doMail "si-check-orgadata mrte1de hata verdi galiba. kontrol ediniz"
	cleanup;exit
fi
#chmod 750 $ORGADATA/CmRoot/config-no_renew_status_oz81548.py
#chmod 750 $ORGADATA/CmRoot/config-no_renew_status_oz81548_ET.py
chmod +x $ORGADATA/CmRoot/*.py
chmod +x $ORGADATA/CmRoot/*.sh
cp $ORGADATA/cnf/extComm/config.cfg $ORGADATA/cnf/extComm/config.cfg.si-check-orgadatadanGelen
cp $ORGADATA/cnf/extComm/config.cfg.PRE_060 $ORGADATA/cnf/extComm/config.cfg
echo komut: "ssh mrte2@localhost 'source .profile;si-check-orgadata --fix-data --fix-conf --fix-env --fix-struct ' > mrte2.si-check-orgadata.log 2>&1"
ssh mrte2@localhost 'source .profile;si-check-orgadata --fix-data --fix-conf --fix-env --fix-struct;chmod +x $ORGADATA/CmRoot/*.py;chmod +x $ORGADATA/CmRoot/*.sh  ' > mrte2.si-check-orgadata.log 2>&1
hata=$(grep -v ':E:Old entry cnf/reg/scp/zones/cf.old replaced by symlinked should be checked.' mrte2.si-check-orgadata.log|egrep ':E:|:P:'|grep -v ':P:Errors occured in checking $ORGADATA.'|grep -v 'that do not belong here'|wc -l)
hata2=$(grep 'that do not belong here' mrte2.si-check-orgadata.log|wc -l)
if [[ $hata -ne 0||$hata2 -ne 1 ]]
then
	echo   "si-check-orgadata mrte2de hata verdi galiba. kontrol ediniz"
	cat mrte2.si-check-orgadata.log
	doMail "si-check-orgadata mrte2de hata verdi galiba. kontrol ediniz"
	cleanup;exit
fi

chmod +x $ORGADATA/CmRoot/*
chmod +x $ORGADATA/CmRoot/*.py
chmod +x $ORGADATA/CmRoot/*.sh
mv $ORGADATA/cnf/reg/scp/zones/cf.old $ORGADATA/cnf/reg/scp
ssh mrte2@localhost 'source .profile;chmod +x $ORGADATA/CmRoot/*;chmod +x $ORGADATA/CmRoot/*.py ' 
ssh mrte2@localhost 'source .profile;mv $ORGADATA/cnf/reg/scp/zones/cf.old $ORGADATA/cnf/reg/scp;cp $ORGADATA/cnf/extComm/config.cfg $ORGADATA/cnf/extComm/config.cfg.si-check-orgadatadanGelen;cp $ORGADATA/cnf/extComm/config.cfg.PRE_060 $ORGADATA/cnf/extComm/config.cfg' 
oupm_start -N&
ssh mrte2@localhost 'source .profile;oupm_start -N' &

 ssh bas@10.248.68.128 'source .profile;oupm_stop'
 echo komut: "ssh bas@10.248.68.128 'source .profile;si-check-orgadata --fix-data --fix-conf --fix-env --fix-struct ' > bas.si-check-orgadata.log 2>&1"
 ssh bas@10.248.68.128 'source .profile;si-check-orgadata --fix-data --fix-conf --fix-env --fix-struct ' > bas.si-check-orgadata.log 2>&1
hata=$(grep -v ':E:Old entry cnf/reg/scp/zones/cf.old replaced by symlinked should be checked.' bas.si-check-orgadata.log|egrep ':E:|:P:'|grep -v ':P:Errors occured in checking $ORGADATA.'|grep -v 'that do not belong here'|wc -l)
#hata2=$(grep 'that do not belong here' bas.si-check-orgadata.log|wc -l)
#if [[ $hata -ne 0||$hata2 -ne 1 ]]
if [[ $hata -ne 0 ]]
then
 echo   "si-check-orgadata basda hata verdi galiba. kontrol ediniz"
 cat bas.si-check-orgadata.log
 doMail "si-check-orgadata basda hata verdi galiba. kontrol ediniz"
 cleanup;exit
fi
 echo komut: "ssh bas@10.248.68.128 'source .profile;si-check-orgadata --fix-svn;echo ---;cs_client "Update Agile$(date +%Y%m%d%H%M)" submit;echo ---;oupm_start -N'"
ssh bas@10.248.68.128 'source .profile;si-check-orgadata --fix-svn;svn resolved  /bas/orgadata/bas/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/Label.txt;echo ---;cs_client "Update Agile$(date +%Y%m%d%H%M)" submit;echo ---;oupm_start -N' > bas.svn.log 2>&1
hata=$(egrep -i 'Commit failed|fail|:P:' bas.svn.log|grep -v ':P:Errors occured in checking $ORGADATA'|wc -l)
if [[ $hata -ne 0 ]]
then
 echo   "svn: cs_client UpdateAgile submit hata verdi galiba"
 cat bas.svn.log 
 doMail "svn: cs_client UpdateAgile submit hata verdi galiba kontrol ediniz: cat /tmp/deploy/bas.svn.log   8 dakika icinde unixde ctrl+c basilmazsa ya da kill yapilmazsa deploya baslanacak. Sleeping 8mins"
 #cleanup;exit
fi
date
echo sleep for 360 seconds For Bas to Start
sleep 360

ssh bas@10.248.68.128 'source .profile;c=0;while [ true ]; do   level=$(OUPMclient -R  2>&1|grep "Run-Level: Run"|wc -l);  if [[ $level -eq 1 ]]; then echo bas:;OUPMclient -R ; break; fi; echo waiting bas to open successfully..$level;echo ' 'cnt:$c;c=$(expr $c + 1);if [[ c -gt 11 ]];then echo bas acilmiyor;date;exit; fi; sleep 60; done '

date
level=$(ssh bas@10.248.68.128 'source .profile;   OUPMclient -R  2>&1|grep "Run-Level: Run"|wc -l   '|tail -1)


if [[ $level -ne 1 ]]
then
echo bas level run degil
date
doMail "BAS acilmiyor. Loglara bakiniz."
cleanup;exit
fi

level=$(OUPMclient -R  2>&1|grep "Run-Level: Run"|wc -l) #;  if [[ $level -ne 1 ]]; then OUPMclient -R ; break; fi; 


if [[ $level -ne 1 ]]
then
oupm_stop
oupm_start -N
echo sleep420
sleep 420

fi

echo mrte1:
si-check-processes
si-check-processes 2>&1 |grep :P: > chk1
if [[ -s chk1 ]]
then
doMail "mrte1de si-check-processes hatasi: ilk hata:  $(si-check-processes 2>&1|grep :E:|head -1).  3 dakika icinde unixde ctrl+c basilmazsa ya da kill yapilmazsa deploya baslanacak. Sleeping 3mins"
echo "mrte1de si-check-processes hatasi:    $(si-check-processes 2>&1).  3 dakika icinde unixde ctrl+c basilmazsa ya da kill yapilmazsa deploya baslanacak. Sleeping 3mins"
sleep 180
fi
echo bas:
ssh bas@10.248.68.128 'source .profile;si-check-processes' 
ssh bas@10.248.68.128 'source .profile;si-check-processes' 2>&1 |grep :P: > chk1
if [[ -s chk1 ]]
then
doMail "basda si-check-processes hatasi: ilk hata:   $(ssh bas@10.248.68.128 'source .profile;si-check-processes' 2>&1|grep :E:|head -1 ).  3 dakika icinde unixde ctrl+c basilmazsa deploya baslanacak. Sleeping 3mins"
echo "basda si-check-processes hatasi:    $(ssh bas@10.248.68.128 'source .profile;si-check-processes'  ).  3 dakika icinde unixde ctrl+c basilmazsa deploya baslanacak. Sleeping 3mins"
sleep 180
fi

echo mrte2:
ssh mrte2@localhost 'source .profile;si-check-processes' 
ssh mrte2@localhost 'source .profile;si-check-processes' 2>&1 |grep :P: > chk1
if [[ -s chk1 ]]
then

doMail "mrte2de si-check-processes hatasi:  son hata:  $(ssh mrte2@localhost 'source .profile;si-check-processes' 2>&1|grep :E:|tail -1)  3 dakika icinde unixde ctrl+c basilmazsa ya da kill yapilmazsa deploya baslanacak. Sleeping 3mins"
echo "mrte2de si-check-processes hatasi:    $(ssh mrte2@localhost 'source .profile;si-check-processes' 2>&1).  3 dakika icinde unixde ctrl+c basilmazsa ya da kill yapilmazsa deploya baslanacak. Sleeping 3mins"
sleep 180
fi

echo mrte1:;OUPMclient -R
level=$(OUPMclient -R  2>&1|grep "Run-Level: Run"|wc -l)
if [[ $level -ne 1 ]]
then
echo MRTE1 acilmiyor. OUPM Loglara bakiniz.
doMail "MRTE1 acilmiyor. Loglara bakiniz."
cleanup;exit
fi

ssh mrte2@localhost 'source .profile;while [ true ]; do   level=$(OUPMclient -R  2>&1|grep "Run-Level: Run"|wc -l);  if [[ $level -eq 1 ]]; then echo mrte2:;OUPMclient -R ; break; fi; echo waiting Mrte2 to open..$level;sleep 61;  done '

level=$(ssh mrte2@localhost 'source .profile;   OUPMclient -R  2>&1|grep "Run-Level: Run"|wc -l   '|tail -1)


if [[ $level -ne 1 ]]
then
echo mrte2 level run degil:

doMail "MRTE2 acilmiyor. Loglara bakiniz."
ssh mrte2@localhost 'source .profile;   OUPMclient -R '
cleanup;exit
fi

 cp  $ORGADATA/CmRoot/CmRefreshConfig.xml  CmRefreshConfig.xml.orig
 sed "s|check timeout=\"[0-9]*\"|check timeout=\"3000\"|" $ORGADATA/CmRoot/CmRefreshConfig.xml|sed "s|refresh timeout=\"[0-9]*\"|refresh timeout=\"3000\"|" > CmRefreshConfig.xml.tst1
 mv CmRefreshConfig.xml.tst1 $ORGADATA/CmRoot/CmRefreshConfig.xml
 chmod +x $ORGADATA/CmRoot/*
chmod +x $ORGADATA/CmRoot/*.sh
chmod +x $ORGADATA/CmRoot/*.py

echo -e Merhaba\\n\\nLoglar "/tmp/deploy" klasorunde. Hata varsa acil mudahele ediniz > out.txt
echo komut: "ssh bas@10.248.68.128 'source .profile;cs_client cluster_01/bascs_01 -D -c Avea_r242 --force -s REFDB,RTE,CBF -p deploy' 2>&1|tee out.txt"
#ORGA piton:  ssh bas@10.248.68.128 'source .profile;cs_client cluster_01/bascs_01 -D -c Avea_r242 --force --clean -s REFDB,RTE,CBF -p deploy;sleep 5' 2>&1|tee -a out.txt
ssh bas@10.248.68.128 'source .profile;cs_client cluster_01/bascs_01 -D -c Avea_r242 --force -s REFDB,RTE,CBF -p deploy;sleep 3' 2>&1|tee -a out.txt
echo >>out.txt
echo script bitis zamani:>> log
date >> log
date
echo
echo ---
echo -en "\n---" >>out.txt
ls -lrt $ORGADATA/cnf >>out.txt
ls -lrt ~/orgadata/cnf/cre/config_19700101000000.xml>>out.txt
echo >>out.txt
echo Terminate a subscriber for test:
gold_operation_handler terminate 05551234567 1 > /dev/null 2>&1
gold_operation_handler terminate 05551234568 1 
echo >>out.txt
echo Install Subscriber for test:
echo Install Subscriber for test: >>out.txt
 gold_operation_handler install 05551234568 TP_00019
 gold_operation_handler install 05551234567 TP_00019 >>out.txt 2>&1
 echo  >> out.txt
 #echo chk db: >>out.txt 
 #echo "idbm_print MrteSubscriberLookup 2>&1| grep 05551234567"  >>out.txt
 idbm_print MrteSubscriberLookup | grep 05551234567 >>out.txt 2>&1
 
 grep -oP ":SERVICE .DeployConfigBundle.IO.Output: \[Deployed=true" bascs_01_0?_CSLOG.txt
 
 grep -oP ":SERVICE .DeployConfigBundle.IO.Output: \[Deployed=true" bascs_01_0?_CSLOG.txt >> out.txt
 echo  Finished >> out.txt
 #echo Have a good day >> out.txt
 scp out.txt mrte1@10.248.68.122:/tmp
 cat maillist.txt |xargs echo > .mail
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;cat  /tmp/out.txt| mailx -s 'Deployment sonucu - Agile Ortami' $EMAIL_LIST"
fi
done < .mail

for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
rm pid.${sec}
ls -lrt  
 
sleep 1
echo
echo ---
echo grep -i cmdeployed mrte2OUPMLog.txt mrte1OUPMLog.txt 
grep -i cmdeployed mrte2OUPMLog.txt mrte1OUPMLog.txt 
ls -lrt $ORGADATA/cnf 
ls -lrt ~/orgadata/cnf/cre/config_19700101000000.xml
echo chk db:
idbm_print MrteSubscriberLookup | grep 05551234568
echo bas_client cluster_01/bascs_01 product-cache in background
ssh bas@10.248.68.128 'source .profile;bas_client cluster_01/bascs_01 product-cache  '&
echo running bas refresh in background
ssh bas@10.248.68.128 'source .profile;bas_client cluster_01/bascs_01 domain-properties  '&
ssh bas@10.248.68.128 'source .profile;bas_client cluster_01/bascs_02 domain-properties  '&
echo bas_client cluster_01/bascs_02 product-cache 
ssh bas@10.248.68.128 'source .profile;bas_client cluster_01/bascs_02 product-cache  '  >p2.txt 2>&1

hata=$(egrep -i 'fail|:P:' p2.txt|wc -l)
if [[ $hata -ne 0 ]]
then
 echo   "prdc cache failed. trying again"
 cat p2.txt 
 ssh bas@10.248.68.128 'source .profile;bas_client cluster_01/bascs_02 product-cache  ' 
 ssh bas@10.248.68.128 'source .profile;bas_client cluster_01/bascs_01 product-cache  ' 
 #cleanup;exit
fi
rm locked
egrep 'Commiting.to.+done' *CSLOG*

