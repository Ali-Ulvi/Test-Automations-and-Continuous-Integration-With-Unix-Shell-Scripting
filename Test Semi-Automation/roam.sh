#! /usr/bin/bash

#Game changed by AUT

cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.roam$$`
do
    /usr/bin/kill -9 $job 

done
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
ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"roam.sh: $testBilgi\" $EMAIL_LIST"
fi
done < .mail

}
#mcc=$(awk -F'|' '{print $9}' slimRoam )
#fiyat=$(awk -F'|' '{print $8}' slimRoam )
#vol=$(awk -F'|' '{print $5}' slimRoam )

 
#
 

rm roamHatalar*
echo Start $(date) > roamLog #percentage icin
while read tarif
do

tarif=TP_$(printf "%05d" $tarif)
msisdn1=$(./newNo $tarif|tail -1)
#msisdn1=5070005836
msisdn=$(echo $msisdn1|sed 's/.\(.*\)/\1/')
#echo $msisdn1|grep ERROR || msisdn=$msisdn1 # if could not create msisdn. using the old one
echo $msisdn1|grep ERROR &&  doMail "cannot create msisdn. system error" && exit
rm roamLog.$tarif roamHatalar.$tarif 2>&1 > /dev/null
#touch roamLog.$tarif roamHatalar.$tarif
#echo tarife:$tarif >> roamLog.$tarif
 #gold_operation_handler changetariff $msisdn $tarif
 echo msisdn: $msisdn
 sleep 4
  ./allowData  $msisdn1|grep ErrorDescription
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "roamLog";
 print "./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif"\n" >> "roamLog";
 print; print "./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif; 
 system("./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif) }' slimRoam &
echo $! >> pid.roam$$
done < tarifs

while read tarif
do

tarif=TP_$(printf "%05d" $tarif)
msisdn1=$(./newNo $tarif|tail -1)
#msisdn1=5070005836
msisdn=$(echo $msisdn1|sed 's/.\(.*\)/\1/')
#echo $msisdn1|grep ERROR || msisdn=$msisdn1 # if could not create msisdn. using the old one
echo $msisdn1|grep ERROR &&  doMail "cannot create msisdn. system error" && exit
rm roamLog.$tarif roamHatalar.$tarif 2>&1 > /dev/null
#touch roamLog.$tarif roamHatalar.$tarif
#echo tarife:$tarif >> roamLog.$tarif
 #gold_operation_handler changetariff $msisdn $tarif
 echo msisdn: $msisdn
 sleep 4
  ./allowData  $msisdn1|grep ErrorDescription
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "roamLog";
 print "./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif"\n" >> "roamLog";
 print; print "./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif; 
 system("./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif) }' slimRoam131 &
echo $! >> pid.roam$$
done < tarifs131
echo 147 olustur ve slimRoam131 kos:  ############# 
msisdn1=$(./installSub TP_00147|tail -1)
msisdn=$(echo $msisdn1|sed 's/.\(.*\)/\1/')
tarif=TP_00147
echo msisdn: $msisdn
echo $msisdn1|grep ERROR &&  doMail "cannot create msisdn TP_00147. system error" && exit
rm roamLog.$tarif roamHatalar.$tarif 2>&1 > /dev/null
sleep 4
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "roamLog";
 print "./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif"\n" >> "roamLog";
 print; print "./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif; 
 system("./datausage.whereverRoam " msisdn" "$5" "$9" "$8" "tarif) }' slimRoam131 &
echo $! >> pid.roam$$
###########
wait
echo BITTI $(date)
echo BITTI $(date) >> roamLog
#doMail "Roam Scripti tamamlandi"

if [ -n "$1" ]
then
cat roamHatalarKomutlari.* > roamhatakomutlari 
mv roamHatalarKomutlari.* roamhatakomutlariDir
chmod 777 roamhatakomutlari
bash roamhatakomutlari

echo retry1 BITTI $(date)
echo retry1 BITTI $(date) >> roamLog

cat roamHatalarKomutlari.* > roamhatakomutlari2 
mv roamHatalarKomutlari.* roamhatakomutlariDir2
chmod 777 roamhatakomutlari2
bash roamhatakomutlari2

echo retry2 BITTI $(date)
echo retry2 BITTI $(date) >> roamLog


cat roamHatalarKomutlari.* > roamhatakomutlari3 
mv roamHatalarKomutlari.* roamhatakomutlariDir3
chmod 777 roamhatakomutlari3
bash roamhatakomutlari3

echo retry2 BITTI $(date)
echo retry2 BITTI $(date) >> roamLog
fi
