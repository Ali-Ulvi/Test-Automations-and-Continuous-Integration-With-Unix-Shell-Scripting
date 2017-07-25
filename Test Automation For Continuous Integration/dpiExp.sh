#! /usr/bin/bash
 
 #All rights reserved AUT Productions
msisdn=$1
bonusID=$2
 
if [[ $# -ne 2  ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullaným: $0 MSISDN bonusID   "
	echo "ornek kullanim:"
	echo ""
	echo "$0 05019144950 2537"

	exit
fi
#export ORACLE_HOME=/export/home/mrte1/orgaroot/OracleClient11.2/client
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple
     
	 
	  sec=$(date +%Y%m%d%H%M%S)
aid=$(msisdn_to_accountid $msisdn )
echo "AccountID:"$aid
bonusName=$(  grep -oP "BLB_.*0${bonusID}" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)
echo "bonusName:"$bonusName

echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance

 sleep 3
  sec2=$(date +%Y%m%d%H%M%S)

  sleep 3
  sec3=$(date +%Y%m%d%H%M%S)
echo gold_operation_handler bonus $msisdn $bonusName 1234.0 $sec $sec3
gold_operation_handler bonus $msisdn $bonusName 1234.0 $sec $sec3
#echo "#u  :End $ and  = :AccountID '$aid' = :Value '1234' &  '$sec' " | idbm_adb -s CreBalance  
    echo "#u  :LastThrCheck $      = :AccountID '$aid'   &  '$sec2' "
 echo "#u  :LastThrCheck $      = :AccountID '$aid'   &  '$sec2' " | idbm_adb -s CreAccount
echo $sec $sec2 $sec3

echo LastThrCheck:
echo "#s  :LastThrCheck $ = :AccountID '$aid'  " | idbm_adb -s CreAccount
#OUPMclient -Ds -M THR.check 
 
# rte_showdb -l $aid

#tail -f -n 0 /rte/orgadata/mrte?/OHPQ/*dpi*/data.*&
#	echo $! >> pid.$sec
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/*dpi*/data.* > dpiOHPQHarvest&
	echo $! >> pid.$sec
	sleep 2
	echo $ORGAROOT/si/scripts/gcp.pl -w -n BAL.rmn -e $(date +%Y%m%d%H%M%S) 
chmod +x $ORGAROOT/si/scripts/gcp.pl
	$ORGAROOT/si/scripts/gcp.pl -w -n BAL.rmn -e $(date +%Y%m%d%H%M%S) 2&>1 > gcp.pl.output.txt
	
 echo sleep24sec
 sleep 24
 echo -e "$red2 Sleeping 24 seconds Finished - Press Enter To Finish Logging $NC"
 read a
	for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
 rm pid.$sec
 echo
 echo -e "$red2 GREP RESULT:"
 echo
egrep '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><updateSubscriptionStatusRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId>(<ns1:GUID/>|<ns1:GUID>.*</ns1:GUID>)</ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>0123456789</ns1:BusinessProcessId></ns1:RequestHeader><body><subscriptionId>P'RE_9${msisdn}_B_'[0]{0,1}'0${bonusID}'</subscriptionId><status>TERMINATED</status><channelCode>BC</channelCode></body></updateSubscriptionStatusRequest></soapenv:Body></soapenv:Envelope>' dpiOHPQHarvest
 
 echo
 
 if [[ $(egrep '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><updateSubscriptionStatusRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId>(<ns1:GUID/>|<ns1:GUID>.*</ns1:GUID>)</ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>0123456789</ns1:BusinessProcessId></ns1:RequestHeader><body><subscriptionId>P'RE_9${msisdn}_B_'[0]{0,1}'0${bonusID}'</subscriptionId><status>TERMINATED</status><channelCode>BC</channelCode></body></updateSubscriptionStatusRequest></soapenv:Body></soapenv:Envelope>' dpiOHPQHarvest|wc -l) -eq 0  ]] 
    then 
	echo -e "$red2 DPI FAIL!!!!!!!!!!!!!!!!"
	echo -e "OHPQ record not found$NC"
	echo 'Beklenen: <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><updateSubscriptionStatusRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId>(<ns1:GUID/>|<ns1:GUID>.*</ns1:GUID>)</ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>0123456789</ns1:BusinessProcessId></ns1:RequestHeader><body><subscriptionId>P'RE_9${msisdn}_B_'[0]{0,1}'0${bonusID}'</subscriptionId><status>TERMINATED</status><channelCode>BC</channelCode></body></updateSubscriptionStatusRequest></soapenv:Body></soapenv:Envelope>' 
else 
 echo "Mission is ***SUCCESS***"
fi

echo -e $NC
 
 
