#! /usr/bin/bash

#AUTology
if [[ $# -ne 3 ]] 
    then 
        echo "illegal number of parameters"
        echo "Kullanim: $0 MSISDN bonusismi miktar    "
        echo "ornek kullanimlar:"
        echo "$0 05011011111  BLB_Matador32TLBonus_01771  0.0003  "
         
  
        exit
fi
msisdn=$1
bonusName=$2
amount=$3
ortam=$(whoami|sed 's/.*\(.\)/\1/')
aid=$(msisdn_to_accountid $msisdn )
goldID=$(grep $bonusName $ORGADATA/cnf/cre/config_19700101000000.xml| grep -oP '(?<=<balance allow_negative="no" has_pockets="yes" id=")[^"]+')
if [[ $(echo $aid|grep ERR|wc -l) = 1 ]]
then
	if [ $ortam -eq 1 ]
	then
		aid=$(ssh mrte2@localhost "source .profile 2>&1 ;msisdn_to_accountid $msisdn;"  2>&1  |egrep -v '^\*')
		echo "AccountID:"$aid
		aid=$(ssh mrte2@localhost "source .profile 2>&1 ;echo \"#u  :Value  $   and and  = :AccountID '$aid' = :ID '$goldID' != :End '' & '$amount' \" | idbm_adb -s CreBalance"  2>&1  |egrep -v '^\*')
		echo ":"$aid
		exit
	fi
	if [ $ortam -eq 2 ]
	then
		aid=$(ssh mrte1@localhost "source .profile 2>&1 ;msisdn_to_accountid $msisdn;"  2>&1  |egrep -v '^\*')
		echo "AccountID:"$aid
		aid=$(ssh mrte1@localhost "source .profile 2>&1  ;echo \"#u  :Value  $   and and  = :AccountID '$aid' = :ID '$goldID' != :End '' & '$amount' \" | idbm_adb -s CreBalance"  2>&1  |egrep -v '^\*')
		echo ":"$aid
		exit
	fi
fi
 
echo "AccountID:"$aid
echo "#u  :Value  $   and and  = :AccountID '$aid' = :ID '$goldID' != :End '' & '$amount' " | idbm_adb -s CreBalance