#! /usr/bin/bash
 
#Pattern by AUT
 


cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.$pid.$sec`  #dead
do
    /usr/local/bin/kill  $job 
echo kill
done
rm  pid.$pid.$sec #hata alir
rm sms9333Log.$pid.$sec.$ip
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
trap control_c SIGINT SIGTERM

 if [[ $# -ne 1 ]] 
    then 
	echo "illegal number of parameters"
	echo "Kullaným: $0 ID "
	echo "ornek kullanim:"
	echo ""
	echo "$0 123"
	echo "$0 $$"
	exit
fi

pid=$1
ip=$(grep SMS.Host\= $ORGADATA/site-config/port.cfg|grep -v \#|cut -d= -f2)
user=sms9333
ARGELA_LOG_DIR=/argela/APSA/deploy/logs

 sec=$(date +%Y%m%d%H%M%S)
 /usr/bin/ssh $user@$ip "tail -0f $ARGELA_LOG_DIR/APSA_CORE_H*I0.log" 2>&1 > sms9333Log.$pid.$sec.$ip &
 	echo $! >> pid.$pid.$sec 

