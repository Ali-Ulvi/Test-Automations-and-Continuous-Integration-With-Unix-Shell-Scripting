#! /usr/bin/bash

# AUT Inventions (R)
#imlicit desicion matrix creator

testBilgi="$0 $@"
echo start > gore 
date >> gore
doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "\n*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
ssh mrte1@10.248.68.122 "source .profile;echo -en '$1' '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"Defect: $testBilgi\" $EMAIL_LIST" 2>&1 |egrep -v "^*    "
fi
done < .mail
  
}
red='\e[0;33m' #33m sari :)
NC='\e[0m' # No Color
red2='\e[1;35m' #purple
gun=30
reload()
 
{
	#$1=amount
sleep 4
if [[ $(gold_operation_handler reload $msisdn $1 2>&1 |grep -o ERROR|head -1) = ERROR ]]
then
echo reload yapilamadi trying again 
hata=$(gold_operation_handler reload $msisdn $1 2>&1 |grep  ERROR|head -1)
	if [[ -n "$hata" ]]
		then
		doMail "reload yapilamadi exiting '$hata'"
		echo "reload yapilamadi exiting '$hata'"
		exit
	fi
fi
sleep 7
}
pack()
 {
sleep 4
hata=$(gold_operation_handler package $msisdn  $1 ACT 2>&1 |grep  ERROR|head -1)
	if [[ -n "$hata" ]]
		then
		doMail "otf alinamadi exiting '$hata'"
		echo "$otf otf alinamadi exiting '$hata'"
		exit
	fi
sleep 6
}
bonus()
{
echo "#d $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance
sleep 3

while read bns
do
if [[ ! -z "$bns" ]]
		then
		
hata=$(gold_operation_handler bonus $msisdn  $bns 1 20121212121212 20291212000000 2>&1 |grep  ERROR|head -1)
	if [[ -n "$hata" ]]
		then
		doMail "$bns bonus alinamadi exiting '$hata'"
		echo "$bns bonus alinamadi exiting '$hata'"
		exit
	fi
	sleep 2
else
echo bns bos
fi
done < verilecekBonuslar
sleep 1
pack 1167
sleep 5
bonusSayisi1=$(echo "#s :ID :Value :Start :End  $ and and and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' != :ID '752' != :ID '1520' " | idbm_adb -s CreBalance|grep -v END|wc -l)

}

varsa()
{
if grep -Fxq "$1" verilecekBonuslar
then
    return 0 #0 means true. bns var yane
else
    return -1
fi


}

checkCount()
{
bonusSayisi2=$(echo "#s :ID :Value :Start :End  $ and and and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' != :ID '752' != :ID '1520' " | idbm_adb -s CreBalance|grep -v END|wc -l)
if [[ "$bonusSayisi2" -ne $(expr 6 + "$bonusSayisi1") ]]
then
	echo -e "\e[7m  bonusSayisi2 wrong  ${NC}"
	doMail " bonus sayisi degisti. önce:$bonusSayisi1 sonra:$bonusSayisi2 check Condition.xml"
	echo önce:$bonusSayisi1 sonra:$bonusSayisi2
	subsquery $msisdn b
fi
}

checkCountNoWin()
{
bonusSayisi2=$(echo "#s :ID :Value :Start :End  $ and and and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' != :ID '752' != :ID '1520' " | idbm_adb -s CreBalance|grep -v END|wc -l)
if [[ "$bonusSayisi2" -ne "$bonusSayisi1" ]]
then
	echo -e "\e[7m  bonusSayisi2 wrong  ${NC}"
	doMail "NoWin bonus sayisi degisti. önce:$bonusSayisi1 sonra:$bonusSayisi2 check Condition.xml"
	echo önce:$bonusSayisi1 sonra:$bonusSayisi2
	subsquery $msisdn b
fi
}

check50()
{
cat verilecekBonuslar
./checkBonus  $msisdn BLB_PaketimeGore_2GBBonus_02771 2147483648 Bytes 1 $gun
./checkBonus  $msisdn BLC_GenericData_DiscountPromoBonus_00452 1 CNT 1 $gun
./checkBonus  $msisdn BLC_PaketimeGore_2GBNotifyBonus_02774 1 CNT 1 1
checkCount
}
check40()
{
cat verilecekBonuslar
./checkBonus  $msisdn BLB_PaketimeGore_1GBBonus_02770 1073741824 Bytes 1 $gun
./checkBonus  $msisdn BLC_GenericData_DiscountPromoBonus_00452 1 CNT 1 $gun
./checkBonus  $msisdn BLC_PaketimeGore_1GB40TLNotifyBonus_02775 1 CNT 1 1
checkCount
}

check30()
{
cat verilecekBonuslar
./checkBonus  $msisdn BLB_PaketimeGore_1GBBonus_02770 1073741824 Bytes 1 $gun
./checkBonus  $msisdn BLC_GenericData_DiscountPromoBonus_00452 1 CNT 1 $gun
./checkBonus  $msisdn BLC_PaketimeGore_1GBNotifyBonus_02773 1 CNT 1 1
checkCount
}
 
check35()
{
cat verilecekBonuslar
./checkBonus  $msisdn BLB_PaketimeGore_1GBBonus_02770 1073741824 Bytes 1 $gun
./checkBonus  $msisdn BLC_GenericData_DiscountPromoBonus_00452 1 CNT 1 $gun
./checkBonus  $msisdn BLC_PaketimeGore_1GB35TLNotifyBonus_03002 1 CNT 1 1
checkCount
}

newno()
{
msisdn=$(./newNo |tail -1)
if [[ $(echo $msisdn|egrep "[0-9]{8}"|wc -l) -eq 0 ]]
    then
    echo msisdn olusmadi
    doMail "'$msisdn' msisdn olusturulamadi. check the system."
    exit
fi
aid=$(msisdn_to_accountid $msisdn )
}

cases()
{

bonus
reload 52

if varsa BLC_PaketimeGore50tlFlagBonus_02757; then  
echo check50
check50   
elif varsa BLC_PaketimeGore40tlFlagBonus_02756; then 
echo check40
check40
elif varsa BLC_PaketimeGore35tlFlagBonus_03001; then 
echo check35
check35
elif varsa BLC_PaketimeGore30tlFlagBonus_02755; then 
echo check30
check30
else     
echo code if not found 50 
checkCountNoWin
fi 
###AUTomations40###
newno
bonus
reload 45

if varsa BLC_PaketimeGore40tlFlagBonus_02756; then 
echo check40
check40
elif varsa BLC_PaketimeGore35tlFlagBonus_03001; then 
echo check35
check35
elif varsa BLC_PaketimeGore30tlFlagBonus_02755; then 
echo check30
check30
else     
echo code if not found 40
checkCountNoWin 
fi 

###AUTomations35###
newno
bonus
reload 36

if varsa BLC_PaketimeGore35tlFlagBonus_03001; then 
echo check35
check35
elif varsa BLC_PaketimeGore30tlFlagBonus_02755; then 
echo check30
check30
else     
echo code if not found 35
checkCountNoWin 
fi 

###AUTomations30###
newno
bonus
reload 34

if varsa BLC_PaketimeGore30tlFlagBonus_02755; then 
echo check30
check30
else     
echo code if not found 30
checkCountNoWin 
fi 
}

declare -a c1=(BLC_PaketimeGore30tlFlagBonus_02755 "")
declare -a c2=(BLC_PaketimeGore40tlFlagBonus_02756 "")
declare -a c3=(BLC_PaketimeGore50tlFlagBonus_02757 "")
declare -a c4=(BLC_PaketimeGore35tlFlagBonus_03001 "")

rm matrix
#loading decision matrix:
for ((i=0;i<${#c1[@]};i++)) do
    for ((j=0;j<${#c2[@]};j++)) do
		for ((k=0;k<${#c3[@]};k++)) do
			for ((l=0;l<${#c4[@]};l++)) do
				echo "${c1[i]} ${c2[j]} ${c3[k]} ${c4[l]}" >> matrix
				#matrix[$i,$j]=$RANDOM
			done
		done
    done
done
#matrix reloaded.

#@Test
while read case
do
echo $case|sed "s/ /\n/g" > verilecekBonuslar

newno
#echo "#d    $ and and and and = :AccountID '$aid' != :ID '1' != :ID '2' != :ID '3' != :ID '7' " | idbm_adb -s CreBalance

cases
done < matrix
echo finish >> gore 
date >> gore
