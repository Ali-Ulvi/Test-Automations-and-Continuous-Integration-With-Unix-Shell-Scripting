#!/usr/bin/bash
tariff=$1

if [[ $# -ne 1&&$# -ne 0&&$# -ne 2 ]]
    then
        echo "illegal number of parameters"
        echo "Kullanim: $0  tarife(bu parametre istege bagli)"
        echo "ornek kullanim:"
        echo ""
        echo "$0 150"
        exit
fi
if [[ ! -z $tariff ]]
then
#tariff=$( printf "%05d" $tariff)
./usagePremium -t $tariff |grep "MOC"|egrep -v "RMOC|_lt_|_tm[0-9]{5}\s+price|Global Zone: PEG$|usageRule: RehberlikBNTelekom\s*price: 1.68 unit size: 60.0 fixedUnit: 60.001 fixedCost: 1.68 MOC_VAS\s*Premium Zone: REHBERLIK11880"|sort|tee Input.txt 
else
./usagePremium  |grep "MOC"|egrep -v "RMOC|_lt_|_tm[0-9]{5}\s+price|Global Zone: PEG$|usageRule: RehberlikBNTelekom\s*price: 1.68 unit size: 60.0 fixedUnit: 60.001 fixedCost: 1.68 MOC_VAS\s*Premium Zone: REHBERLIK11880"|sort|tee Input.txt 
fi
echo $(wc -l Input.txt | cut -d " " -f1) usage rules found. Check if it is missing.
./slim.py "$2"

 