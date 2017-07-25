#! /usr/bin/bash

#AUT bulk solutions

cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.indata1$$_$tarif`
do
    /usr/bin/kill -9 $job 

done
rm pid.indata1$$_$tarif
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
ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"indata1.sh: $testBilgi\" $EMAIL_LIST"
fi
done < .mail

}
 
#fiyat=$(awk -F'|' '{print $8}' slimindata1 )

grep BLP_Main slimSes > slimSesTemp
cp slimSesTemp slimSesCopy
 
rm indata1Hatalar* indata1Log*
echo Start $(date) > indata1Log #percentage icin
while read tarif
do

tarif=TP_$(printf "%05d" $tarif)
msisdn=$(./newNo $tarif|tail -1)
#msisdn1=5070005836

echo $msisdn|grep ERROR &&  doMail "cannot create msisdn. system error" && exit
rm indata1Log.$tarif indata1Hatalar.$tarif 2>&1 > /dev/null
#touch indata1Log.$tarif indata1Hatalar.$tarif
#echo tarife:$tarif >> indata1Log.$tarif
 #gold_operation_handler changetariff $msisdn $tarif
 echo msisdn: $msisdn
aid=$(msisdn_to_accountid $msisdn )
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
 sleep 1 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "indata1Log";
 print "./useIndata1Auto " msisdn" "$4" "$3" "$7" "tarif"\n" >> "indata1Log";
 print; print "./useIndata1Auto " msisdn" "$4" "$3" "$7" "tarif; 
 system("./useIndata1Auto " msisdn" "$4" "$3" "$7" "tarif) }' slimSesCopy &
echo $! >> pid.indata1$$_$tarif
done < Sestarifs

echo 147 olustur ve slimindata1 kos:  ############# 
msisdn=$(./installSub TP_00147|tail -1)
tarif=TP_00147
echo msisdn: $msisdn
echo $msisdn|grep ERROR &&  doMail "cannot create msisdn TP_00147. system error" && exit
rm indata1Log.$tarif indata1Hatalar.$tarif 2>&1 > /dev/null
aid=$(msisdn_to_accountid $msisdn )
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
sleep 1
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "indata1Log";
 print "./useIndata1Auto " msisdn" "$4" "$3" "$7" "tarif"\n" >> "indata1Log";
 print; print "./useIndata1Auto " msisdn" "$4" "$3" "$7" "tarif; 
 system("./useIndata1Auto " msisdn" "$4" "$3" "$7" "tarif) }' slimSesCopy &
echo $! >> pid.indata1$$_$tarif
###########
wait
echo BITTI $(date)
echo BITTI $(date) >> indata1Log
#doMail "indata1 Scripti tamamlandi"

if [ -n "$1" ]
then
rm indata1hatakomutlariDir/*
cat indata1HatalarKomutlari.* > indata1hatakomutlari 
mv indata1HatalarKomutlari.* indata1hatakomutlariDir
mv indata1Hatalar.* indata1hatakomutlariDir
chmod 777 indata1hatakomutlari
bash indata1hatakomutlari

echo retry1 BITTI $(date)
echo retry1 BITTI $(date) >> indata1Log

rm indata1hatakomutlariDir2/*
cat indata1HatalarKomutlari.* > indata1hatakomutlari2 
mv indata1HatalarKomutlari.* indata1hatakomutlariDir2
mv indata1Hatalar.* indata1hatakomutlariDir2
chmod 777 indata1hatakomutlari2
bash indata1hatakomutlari2

echo retry2 BITTI $(date)
echo retry2 BITTI $(date) >> indata1Log

rm indata1hatakomutlariDir3/*
cat indata1HatalarKomutlari.* > indata1hatakomutlari3 
mv indata1HatalarKomutlari.* indata1hatakomutlariDir3
mv indata1Hatalar.* indata1hatakomutlariDir3
chmod 777 indata1hatakomutlari3
bash indata1hatakomutlari3

echo retry3 BITTI $(date)
echo retry3 BITTI $(date) >> indata1Log
fi
rm pid.indata1$$_$tarif