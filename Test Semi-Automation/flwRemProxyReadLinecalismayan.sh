#! /usr/bin/bash

filename="$1"
gun="$2"
msisdn=$3
c=0
#smslerin bas ve sonlarinda fazla bosluk varsa silinir. bu muhtemelen testerin visiodan kopyalama hatasidir.:
sed 's/^ //' $filename|sed 's/ $//'   > tmp$$
sed "s|DD.MM.YY tarihine kadar gecerli ||g" tmp$$ > .$filename
cat .$filename| tr 'ğüışçöÖÇŞİĞÜ’' "guiscoOCSIGU'" > tmp$$
mv tmp$$ .$filename

if [[ -z "${msisdn// }" ]] #skip empty or spacy   by  Shell Parameter Expansion
		then
		msisdn=$(./newNo TP_00149|tail -1)
	fi

echo $msisdn 
 

while read -r line
do
	if [[ -z "${line// }" ]] #skip empty or spacy lines by  Shell Parameter Expansion
		then
		continue
	fi
    #parse lines 3 by 3
    case $c in
    	0)
			srv=$(echo "$line"|grep -oP '[0-9]+$')
			;;
    	1)
			nodebtSMS="$line"
			;;
		2)
			debtSMS="$line"
			c=-1
			echo ./flwRemAUT $msisdn $srv $gun \"$debtSMS\" \"$nodebtSMS\"
			./flwRemAUT $msisdn $srv $gun "$debtSMS" "$nodebtSMS"
			;;
		
		*)
  			echo unexpected behaviour detected. pls contact codemaster
	  		;;
	esac

c=$(expr $c + 1)
done < ".$filename"
 