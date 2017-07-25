#! /usr/bin/bash

filename="$1"
gun="$2"
msisdn=$3
c=0
#smslerin bas ve sonlarinda fazla bosluk varsa silinir. bu muhtemelen testerin visiodan kopyalama hatasidir.:
sed 's/^ //' $filename|sed 's/ $//'   > tmp$$
sed "s|DD.MM.YY tarihine kadar gecerli ||g" tmp$$ > .$filename
cat .$filename| tr 'ğüışçöÖÇŞİĞÜ’' "guiscoOCSIGU'" > tmp$$
grep '[a-zA-Z0-9]' tmp$$   >.$filename
rm tmp$$
IFS=$'\r\n' GLOBIGNORE='*' command eval  'smsler=($(cat .$filename))'
  echo :DEBUG: first srv:
  echo "${smsler[0]}"
  len=${#smsler[@]}
if [[ -z "${msisdn// }" ]] #skip empty or spacy   by  Shell Parameter Expansion
		then
		msisdn=$(./newNo TP_00149|tail -1)
	fi

echo $msisdn 
counter=0
popSMS()
{
#using array for file lines
sms="${smsler[$counter]}"
#echo popped sms: "$sms"
counter=$(($counter+1)) 
return "$sms"
}
tLen=`expr $len / 3`
for (( counter=0; counter<${len}; a=2 ));
do
	srv="${smsler[$counter]}"
	counter=$(($counter+1)) 
	smsNoDebt="${smsler[$counter]}"
	counter=$(($counter+1)) 
	smsDebt="${smsler[$counter]}"
	counter=$(($counter+1)) 
  ./flwRemAUT $msisdn $(echo $srv|grep -oP '[0-9]+$') $gun "$smsDebt" "$smsNoDebt"

done
			
