#! /usr/bin/bash

#script name: startCI
#Here CI is Wrapped by AUT

workdir=/tmp/CI
cd $workdir
msisdn0=$(cat no |head -1)
msisdn=$(expr $msisdn0 + 1)
echo $msisdn > no
msisdn=0$msisdn
sleep 2
cnt=$(ps -ef|grep startCI|grep -v grep|wc -l)
if [[ $cnt -gt 2 ]]
then
ps -ef|grep startCI|grep -v grep|wc -l
ps -ef|grep startCI|grep -v grep
echo script zaten baslatilmis. Bitince baslatiniz.
exit 1
fi

cleanup()

{
echo " ctrl+c?"

   for job in `cat pid.*`
do
    /usr/bin/kill -9 $job 
	echo please ignore if it gives permission errors. no problem.
	ssh mrte2@localhost "/usr/bin/kill -9 $job "

done
rm pid.* evdSMS9333* bonuslar* sms9333Log.*
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

gold_operation_handler terminate $msisdn 2
sleep 1
gold_operation_handler install $msisdn TP_00149
sleep 1
gold_operation_handler reload $msisdn 1000  
sleep 5

mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')
aid=$(msisdn_to_accountid $msisdn )

if [[ $(egrep '^Deployment_yaplilsin_mi=evet' servisID_Fiyat.txt|wc -l) -eq 1 ]]
then
cd /tmp/deploy
echo starting DEPLOYMENT
nohup ./deploy.sh
cd $workdir
fi

./start80100CI servisID_Fiyat.txt 2>&1  & >  /dev/null
if [[ $(echo $aid|grep ERR|wc -l) = 1 ]]
then
    if [[ $mrteid = 1 ]]
    then          
	echo mrte2de
    ssh mrte2@localhost "source .profile 2>&1;cd $workdir;./CIrem $msisdn 2>&1   "|tee output$msisdn 
    exit
    else
	echo mrte1de
    ssh mrte1@localhost "source .profile 2>&1;cd $workdir;./CIrem $msisdn 2>&1 "|tee output$msisdn
    exit
    fi
fi
echo abone bu mrtede
  ./CIrem $msisdn 2>&1|tee output$msisdn
 
 
 
