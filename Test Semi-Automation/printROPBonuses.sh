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
 
cat out$file | mailx -s rop-bonus "$EMAIL_LIST"
fi
done < .mail
  
}

  
msisdn=$1
msisdn=05040000236
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
subsquery $msisdn b > $file  2>&1
while ! grep -q balanceName $file  ; do
    echo check | tee -a out$file
        subsquery $msisdn b  > $file 2>&1
done


money=$(cat $file|  grep BLP_Main|awk  -F"|" '{print $3}'|cut -d. -f1 )

 echo rop: "$rop"| tee -a out$file
   gold_operation_handler package $msisdn $rop ACT 2>&1 |grep ERROR| tee -a out$file
rm $file
subsquery $msisdn b  > $file  2>&1
while ! grep -q balanceName $file  ; do
    echo check | tee -a out$file
        subsquery $msisdn b  > $file  2>&1
done

cat $file| tee -a out$file
money2=$(cat $file|  grep BLP_Main|awk  -F"|" '{print $3}'|cut -d. -f1 )
echo Dusen para: $(expr $money - $money2)| tee -a out$file
echo -------------------------------------------------*************-------------------------------------| tee -a out$file
fi


done < rops
doMail
rm bonusFile$msisdn
