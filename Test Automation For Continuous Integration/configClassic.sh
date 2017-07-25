#! /usr/bin/bash
  
msisdn=$1

testBilgi="$0 $@"
doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
 
ssh mrte1@10.248.68.122 "source .profile ;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"Defect: $testBilgi\" $EMAIL_LIST" > /dev/null 2>&1

fi
done < .mail
  
}

if [[ $# -ne 1 ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullaným: $0 MSISDN  "
	echo "ornek kullanim:"
	echo ""
	echo "$0 05011011111  "
	  doMail "illegal number of parameters. Kullaným: $0 MSISDN" 

	exit
fi
#export ORACLE_HOME=/export/home/mrte1/orgaroot/OracleClient11.2/client
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple

check()
{
if ! grep -qP "^$1=($2,[0-9]|.*[0-9],$2,[0-9]|.*[0-9],$2\r$)" $ORGADATA/hsbq/config/Config.from_classic ;then 

echo bulunamadi $1 $2
doMail "configFrom_Classicde eksik: $1 $2"
fi 

}
 
aid=$(msisdn_to_accountid $msisdn )
echo "AccountID:"$aid


for bonus in `echo "#s :ID   $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance|grep -v END| sed "s/'//g" |sort|uniq`
do
echo
	 	#  sorry for verbose code as it is a one-man CI Automation from scratch project with no time/resource given
	if [[ $(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="SMS"'|wc -l) -gt 0 ]]
	then
		bns=$(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep -oP BLB_[^\"]*|sed "s/.*\(....\)/\1/")
		echo bonus: $bns
		check "OPSC\.Incall\.NumFreeSMS" $bns
		check "OPSC\.Ext\.OBMS31"  $bns
		if [[  $(grep -cP "=($bns,[0-9]|.*[0-9],$bns,[0-9]|.*[0-9],$bns\r$)" $ORGADATA/hsbq/config/Config.from_classic) -ne 2   ]]
		then
			doMail "configFrom_Classicde eksik veya fazla SMS bonus: $bns"
			echo "configFrom_Classicde eksik veya fazla SMS bonus: $bns"
		fi
		
	elif [[ $(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="Bytes"'|wc -l) -eq 1 ]]
	then
		bns=$(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep -oP BLB_[^\"]*|sed "s/.*\(....\)/\1/")
		echo bonus: $bns

		check "OPSC\.Ext\.OBMS45"  $bns
		if [[   $(grep -cP "=($bns,[0-9]|.*[0-9],$bns,[0-9]|.*[0-9],$bns\r$)" $ORGADATA/hsbq/config/Config.from_classic) -ne 1   ]]
		then
			doMail "configFrom_Classicde eksik veya fazla data bonus: $bns"
			echo "configFrom_Classicde eksik veya fazla data bonus: $bns"
		fi
	elif [[ $(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep 'type="Seconds"'|wc -l) -eq 1 ]]
	then
		bns=$(grep -i priority $ORGADATA/cnf/cre/config_19700101000000.xml|grep id=\"$bonus\"|grep -v CHARGE|grep -v cost_function|grep -v AUX|grep -oP BLB_[^\"]*|sed "s/.*\(....\)/\1/")
		echo bonus: $bns

		check "OPSC\.Incall\.Bonus2" $bns
		check "OPSC\.Ext\.OBMS04"  $bns
		if [[ $(grep -cP "=($bns,[0-9]|.*[0-9],$bns,[0-9]|.*[0-9],$bns\r$)" $ORGADATA/hsbq/config/Config.from_classic) -ne 2  ]]
		then
			doMail "configFrom_Classicde eksik veya fazla ses bonus: $bns"
			echo "configFrom_Classicde eksik veya fazla ses bonus: $bns"
		fi
	fi
	
done

