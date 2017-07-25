#! /usr/bin/bash
 
#Encapsulation by AUT

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
	
   for job in `cat pid.$pid.*`  #dead
do
    /usr/local/bin/kill  $job 
echo kill
done
rm  pid.$pid.$(date +%Y%m%d)*
#rm sms9333Log.$pid.* #removed to another sh

