#! /usr/bin/bash

#AUT bulk solutions

cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.ses$$`
do
    /usr/bin/kill -9 $job 

done
rm pid.ses$$
 return 0
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
doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "\n*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"ses.sh: $testBilgi\" $EMAIL_LIST"
fi
done < .mail

}
 
#fiyat=$(awk -F'|' '{print $8}' slimses )
 
grep BLP_Main slimSes > slimSesTemp
cp slimSesTemp slimSes 

rm sesHatalar* sesLog*
echo Start $(date) > sesLog #percentage icin
while read tarif
do

tarif=TP_$(printf "%05d" $tarif)
msisdn=$(./newNo $tarif|tail -1)
#msisdn1=5070005836

echo $msisdn|grep ERROR &&  doMail "cannot create msisdn. system error" && exit
rm sesLog.$tarif sesHatalar.$tarif 2>&1 > /dev/null
#touch sesLog.$tarif sesHatalar.$tarif
#echo tarife:$tarif >> sesLog.$tarif
 #gold_operation_handler changetariff $msisdn $tarif
 echo msisdn: $msisdn
aid=$(msisdn_to_accountid $msisdn )
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
 sleep 1 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "sesLog";
 print "./ses " msisdn" "$4" "$3" "$7" "tarif"\n" >> "sesLog";
 print; print "./ses " msisdn" "$4" "$3" "$7" "tarif; 
 system("./ses " msisdn" "$4" "$3" "$7" "tarif) }' slimSes &
echo $! >> pid.ses$$
done < Sestarifs

echo 147 olustur ve slimSes kos:  ############# 
msisdn=$(./installSub TP_00147|tail -1)
tarif=TP_00147
echo msisdn: $msisdn
echo $msisdn|grep ERROR &&  doMail "cannot create msisdn TP_00147. system error" && exit
rm sesLog.$tarif sesHatalar.$tarif 2>&1 > /dev/null
aid=$(msisdn_to_accountid $msisdn )
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
sleep 1
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "sesLog";
 print "./ses " msisdn" "$4" "$3" "$7" "tarif"\n" >> "sesLog";
 print; print "./ses " msisdn" "$4" "$3" "$7" "tarif; 
 system("./ses " msisdn" "$4" "$3" "$7" "tarif) }' slimSes &
echo $! >> pid.ses$$
###########
wait
echo BITTI $(date)
echo BITTI $(date) >> sesLog
#doMail "ses Scripti tamamlandi"

if [ -n "$1" ]
then
rm seshatakomutlariDir/*
cat sesHatalarKomutlari.* > seshatakomutlari 
mv sesHatalarKomutlari.* seshatakomutlariDir
mv sesHatalar.TP_* seshatakomutlariDir
chmod 777 seshatakomutlari
bash seshatakomutlari

echo retry1 BITTI $(date)
echo retry1 BITTI $(date) >> sesLog

rm seshatakomutlariDir2/*
cat sesHatalarKomutlari.* > seshatakomutlari2 
mv sesHatalarKomutlari.* seshatakomutlariDir2
mv sesHatalar.TP_* seshatakomutlariDir2
chmod 777 seshatakomutlari2
bash seshatakomutlari2

echo retry2 BITTI $(date)
echo retry2 BITTI $(date) >> sesLog

rm seshatakomutlariDir3/*
cat sesHatalarKomutlari.* > seshatakomutlari3 
mv sesHatalarKomutlari.* seshatakomutlariDir3
mv sesHatalar.TP_* seshatakomutlariDir3
chmod 777 seshatakomutlari3
bash seshatakomutlari3

echo retry3 BITTI $(date)
echo retry3 BITTI $(date) >> sesLog
fi

rm pid.ses$$