#! /usr/bin/bash

#solves mrte dependency and concurrency
#             by AUT

workdir=/tmp/ulvi
cd $workdir
 
msisdn=$2
script=$1
p1=$3
p2=$4
p3=$5
p="$@"
echo bash $p  
 
for last; do true; done
if [[ $last != "unsync" ]]
then
cnt=$(ps -ef|grep "bash $script"|wc -l)
if [[ $cnt -gt 1 ]]
then
 
ps -ef|grep $script|grep -v grep
echo script zaten baslatilmis. Bitince baslatiniz.
exit 1
fi
fi 
source .profile  > /dev/null 2>&1
mrteid=$(echo $ORGADATA|sed 's/\(.*\)\(.\)/\2/')
aid=$(msisdn_to_accountid $msisdn )
 
if [[ $(echo $aid|grep ERR|wc -l) = 1 ]]
then
    if [[ $mrteid = 1 ]]
    then          
	#echo mrte2de
    ssh mrte2@localhost "source .profile  > /dev/null 2>&1;cd $workdir;bash $p 2>&1 " 2>&1|egrep -v '^\*'
    exit
    else
	echo mrte1de
    ssh mrte1@localhost "source .profile  > /dev/null 2>&1;cd $workdir;bash $p 2>&1 " 2>&1|egrep -v '^\*'
    exit
    fi
fi
#echo abone bu mrtede

  bash $p 2>&1|egrep -v '^\*'
 
 
 
