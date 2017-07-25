#! /usr/bin/bash
 
 #All rights reserved AUT Productions
msisdn=$1
bonusID=$2
  testBilgi="$0 $@"

doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "\n*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"Defect: $testBilgi\" $EMAIL_LIST"
fi
done < .mail

}

if [[ $# -ne 2  ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullanim: $0 MSISDN bonusID   "
	echo "ornek kullanim:"
	echo "$0 05019144950 2537"
doMail "illegal number of parameters Kullanim: $0 MSISDN bonusID" 
	exit
fi
#export ORACLE_HOME=/export/home/mrte1/orgaroot/OracleClient11.2/client
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple
     
	 
	 
aid=$(msisdn_to_accountid $msisdn )
echo "AccountID:"$aid
bonusName=$(  grep -oP "BLB_.*0${bonusID}" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)
echo "bonusName:"$bonusName
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
 sec=$(date +%Y%m%d%H%M%S)
 
 
tail -f -n 0 /rte/orgadata/mrte?/OHPQ/*dpi*/data.*&
    echo $! >> pid.$sec
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/*dpi*/data.* > dpiOHPQHarvestCreate&
	echo $! >> pid.$sec
    
gold_operation_handler bonus $msisdn $bonusName 1234.0
 echo "#s    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
 
 echo sleep 29 seconds for notification to come after giving bonus 
 sleep 29
 #TODO:
 echo checking create dpi
 if [[ $(egrep '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><createSubscriptionRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId><ns1:GUID>.*</ns1:GUID></ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>.*</ns1:BusinessProcessId></ns1:RequestHeader><body><subscription><ns2:assignmentDate xmlns:ns2="http://www.avea.com.tr/om/VSME">201[6-9]-..-.*</ns2:assignmentDate><ns3:assignmentType xmlns:ns3="http://www.avea.com.tr/om/VSME">2</ns3:assignmentType><ns4:assignmentValue xmlns:ns4="http://www.avea.com.tr/om/VSME">-1</ns4:assignmentValue><ns5:msisdn xmlns:ns5="http://www.avea.com.tr/om/VSME">905011021230</ns5:msisdn><ns6:networkProfileId xmlns:ns6="http://www.avea.com.tr/om/VSME">nw_unlimited_prepaid</ns6:networkProfileId><ns7:recurrenceCount xmlns:ns7="http://www.avea.com.tr/om/VSME">0</ns7:recurrenceCount><ns8:startDate xmlns:ns8="http://www.avea.com.tr/om/VSME">201[6-9]-..-.*</ns8:startDate><ns9:subscriptionId xmlns:ns9="http://www.avea.com.tr/om/VSME">PRE_9'${msisdn}'_B_[0]{0,1}0'${bonusID}'</ns9:subscriptionId></subscription><channelCode>BC</channelCode></body></createSubscriptionRequest></soapenv:Body></soapenv:Envelope>' dpiOHPQHarvestCreate|wc -l) -eq 0  ]] 
    then 
    echo -e "$red2 Create DPI FAIL!!!!!!!!!!!!!!!!$NC"
	echo "Create DPI OHPQ record not found"
	echo 'Beklenen:  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><createSubscriptionRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId><ns1:GUID>.*</ns1:GUID></ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>.*</ns1:BusinessProcessId></ns1:RequestHeader><body><subscription><ns2:assignmentDate xmlns:ns2="http://www.avea.com.tr/om/VSME">201[6-9]-..-.*</ns2:assignmentDate><ns3:assignmentType xmlns:ns3="http://www.avea.com.tr/om/VSME">2</ns3:assignmentType><ns4:assignmentValue xmlns:ns4="http://www.avea.com.tr/om/VSME">-1</ns4:assignmentValue><ns5:msisdn xmlns:ns5="http://www.avea.com.tr/om/VSME">905011021230</ns5:msisdn><ns6:networkProfileId xmlns:ns6="http://www.avea.com.tr/om/VSME">nw_unlimited_prepaid</ns6:networkProfileId><ns7:recurrenceCount xmlns:ns7="http://www.avea.com.tr/om/VSME">0</ns7:recurrenceCount><ns8:startDate xmlns:ns8="http://www.avea.com.tr/om/VSME">201[6-9]-..-.*</ns8:startDate><ns9:subscriptionId xmlns:ns9="http://www.avea.com.tr/om/VSME">PRE_9'${msisdn}'_B_[0]{0,1}0'${bonusID}'</ns9:subscriptionId></subscription><channelCode>BC</channelCode></body></createSubscriptionRequest></soapenv:Body></soapenv:Envelope>'
    echo
    echo grep no:$msisdn
    grep $msisdn dpiOHPQHarvestCreate
        doMail "Create DPI OHPQ record not found:Paket alindiginda bonus icin nw_unlimited DPI istegi gonderilmeli."
else 
 echo "Mission is ***SUCCESS*** for CreateSubscription DPI "
fi
 
     for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
 rm pid.$sec
 echo making usage
msisdn5=$(echo $msisdn|sed 's/0\(.*\)/\1/' )
bash datausageSosyal $msisdn5 1234 silentforce

tail -f -n 0 /rte/orgadata/mrte?/OHPQ/*dpi*/data.*&
	echo $! >> pid.$sec
	tail -f -n 0 /rte/orgadata/mrte?/OHPQ/*dpi*/data.* > dpiOHPQHarvest&
	echo $! >> pid.$sec
	
 echo sleep30sec
 sleep 20
 echo -e "$red2 Sleeping 30 seconds Finished - Press Enter To Finish Logging $NC"
 echo "#s    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
# read a
	for job in `cat pid.${sec}`
do
    /usr/bin/kill -9 $job 

done
 rm pid.$sec
 echo
 echo -e "$red2 GREP RESULT:"
 echo
egrep '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><updateSubscriptionStatusRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId><ns1:GUID>.*</ns1:GUID></ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>0123456789</ns1:BusinessProcessId></ns1:RequestHeader><body><subscriptionId>PRE_9'${msisdn}'_B_[0]{0,1}0'${bonusID}'</subscriptionId><status>TERMINATED</status><channelCode>BC</channelCode></body></updateSubscriptionStatusRequest></soapenv:Body></soapenv:Envelope>' dpiOHPQHarvest
 
 echo
 
 if [[ $(egrep '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><updateSubscriptionStatusRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId><ns1:GUID>.*</ns1:GUID></ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>0123456789</ns1:BusinessProcessId></ns1:RequestHeader><body><subscriptionId>PRE_9'${msisdn}'_B_[0]{0,1}0'${bonusID}'</subscriptionId><status>TERMINATED</status><channelCode>BC</channelCode></body></updateSubscriptionStatusRequest></soapenv:Body></soapenv:Envelope>' dpiOHPQHarvest|wc -l) -eq 0  ]] 
    then 
	echo -e "$red2 DPI FAIL!!!!!!!!!!!!!!!!"
	echo -e "OHPQ record not found$NC"
	echo 'Beklenen:  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><updateSubscriptionStatusRequest xmlns="http://www.avea.com.tr/om/VSME/SubscriptionServices/Object"><ns1:RequestHeader xmlns:ns1="http://www.avea.com.tr/AveaFrameWork"><ns1:RequestId><ns1:GUID>.*</ns1:GUID></ns1:RequestId><ns1:CallingSystem>OPSC</ns1:CallingSystem><ns1:BusinessProcessId>0123456789</ns1:BusinessProcessId></ns1:RequestHeader><body><subscriptionId>PRE_9'${msisdn}'_B_[0]{0,1}0'${bonusID}'</subscriptionId><status>TERMINATED</status><channelCode>BC</channelCode></body></updateSubscriptionStatusRequest></soapenv:Body></soapenv:Envelope>'
    echo
    echo grep no:$msisdn
    grep $msisdn dpiOHPQHarvestCreate
        doMail "DPI useUp OHPQ record not found.Bonus bittiginde DPI istegi gonderilmeli. "
else 
 echo "Mission is ***SUCCESS***"
fi

echo -e $NC


