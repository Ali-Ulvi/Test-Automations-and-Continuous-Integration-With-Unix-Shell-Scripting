#! /usr/bin/bash
 
#AUTech

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
 cat output$msisdn|egrep -v '^\*' >> tmp$msisdn 
 scp out$file mrte1@10.248.68.122:/tmp > /dev/null
 ssh mrte1@10.248.68.122 "source .profile; cat /tmp/out$file| mailx -s \"ROPS: $testBilgi\" $EMAIL_LIST"
 
fi
done < .mail
  
}

  
msisdn=$1
if [ -z "$msisdn" ]
then
msisdn=05040000236
fi
file=bonusFile$msisdn
rm out$file
setMoney $msisdn 1100
tumPaketSil $msisdn
while read rop
do
if [ ! -z "$rop" ]
then
rm $file
 tumBonusSil $msisdn > /dev/null 2>&1 
subsquery $msisdn b |grep -v BLC_ROP_MinChk > $file  2>&1
while ! grep -q balanceName $file  ; do
    echo check | tee -a out$file
        subsquery $msisdn b |grep -v BLC_ROP_MinChk > $file 2>&1
done


money=$(cat $file|  grep BLP_Main|awk  -F"|" '{print $3}'|cut -d. -f1 )

serviceName=$rop
serviceName=$(printf "%05d\n" $serviceName 2>/dev/null) 
if [ $? -eq 0 ]
then
ropName=$(  grep -oP "PP_.*_$serviceName" $ORGADATA/cnf/cre/config_19700101000000.xml|head -1)
echo $ropName| tee -a out$file
fi

 echo rop: "$rop"| tee -a out$file
   gold_operation_handler package $msisdn $rop ACT 2>&1 |grep ERROR| tee -a out$file
rm $file
subsquery $msisdn b |grep -v BLC_ROP_MinChk  > $file  2>&1
while ! grep -q balanceName $file  ; do
    echo check | tee -a out$file
        subsquery $msisdn b |grep -v BLC_ROP_MinChk  > $file  2>&1
done

cat $file|grep -v "                                                  |          |          |          |               |                    |                    "|sort -r| tee -a out$file
money2=$(cat $file|  grep BLP_Main|awk  -F"|" '{print $3}'|cut -d. -f1 )
echo Dusen para: $(expr $money - $money2)| tee -a out$file
echo -------------------------------------------------*************-------------------------------------| tee -a out$file
fi


done < rops
doMail
rm bonusFile$msisdn
