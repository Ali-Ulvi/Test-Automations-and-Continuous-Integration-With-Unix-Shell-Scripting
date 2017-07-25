#! /usr/bin/bash

#ART by AUT

cleanup()
# example cleanup function
{
echo " ctrl+c?"

   for job in `cat pid.disc$$`
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
#trap control_c SIGINT
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

 
bonusVer()

{
#parameter like 0452
echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
bns=$(grep '<balance ' $ORGADATA/cnf/cre/config_19700101000000.xml|grep -oP "BL._.*_0$1"  )
gold_operation_handler bonus $msisdn1 $bns 1 20151212235959 20301212235959 2>&1|grep ERROR && gold_operation_handler bonus $msisdn1 $bns 1 20151212235959 20301212235959 2>&1|grep ERROR && exit
 
}

rm discHatalar*
#rm discLog*
echo Start $(date) > discLog #percentage icin
 

echo 19 olustur ve slimdisc kos:  ############# 
msisdn1=$(./installSub TP_00019|tail -1)
msisdn=$(echo $msisdn1|sed 's/.\(.*\)/\1/')

echo msisdn: $msisdn
echo $msisdn1|grep ERROR &&  doMail "cannot create msisdn TP_00019. system error" && exit
aid=$(msisdn_to_accountid $msisdn1 )
echo "AccountID:"$aid
 sleep 4
gold_operation_handler reload $msisdn1 1

 sleep 3
./allowData  $msisdn1|grep ErrorDescription

while read tarif
do
bonusVer $tarif
#rm discLog.$tarif discHatalar.$tarif 2>&1 > /dev/null

nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscTivibu " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscTivibu " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscTivibu " msisdn" "$5" 28603 "$8" "tarif) }' slimDiscTivi 
 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscTivibuWap " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscTivibuWap " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscTivibuWap " msisdn" "$5" 28603 "$8" "tarif) }' slimDiscTivi
 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDisc " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDisc " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDisc " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 
 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscSosyal " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscSosyal " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscSosyal " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 
 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscSosyal2 " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscSosyal2 " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscSosyal2 " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 
 
nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscSosyal2Wap " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscSosyal2Wap " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscSosyal2Wap " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 

nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscSosyalWap " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscSosyalWap " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscSosyalWap " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 

nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscWap " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscWap " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscWap " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 

nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscWhatsapp " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscWhatsapp " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscWhatsapp " msisdn" "$5" 28603 "$8" "tarif) }' slimDiscWhats 

nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscWhatsappWap " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscWhatsappWap " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscWhatsappWap " msisdn" "$5" 28603 "$8" "tarif) }' slimDiscWhats 

nawk -v tarif="$tarif" -v msisdn="$msisdn" -F'|' '{print >> "discLog";
 print "./datausage.whereverRoamDiscWifi " msisdn" "$5" 28603 "$8" "tarif"\n" >> "discLog";
 print; print "./datausage.whereverRoamDiscWifi " msisdn" "$5" 28603 "$8" "tarif; 
 system("./datausage.whereverRoamDiscWifi " msisdn" "$5" 28603 "$8" "tarif) }' slimDisc 

done < indBonuslar.txt 
#echo $! > pid.disc$$
###########
echo wait
wait
#rm pid.disc$$
echo BITTI $(date)
echo BITTI $(date) >> discLog
#doMail "disc Scripti tamamlandi"
