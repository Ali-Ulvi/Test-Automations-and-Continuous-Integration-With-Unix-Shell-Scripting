#!/usr/bin/bash
rule=$1
numara=$2
zone=$3

if [[ $# -ne 2&&$# -ne 3 ]]
    then
        echo "illegal number of parameters"
        echo "Kullanim: $0  usageRule aranacakNumara Zone(bu parametre istege bagli)"
        echo "ornek kullanim:"
        echo ""
        echo "$0 NationalGroup 150"
        echo "$0 NationalGroup 150 TTOZELSERVIS"
        exit
fi

./usagePremium |egrep " $rule\s.* MOC"|tee Input.txt
echo $(wc -l Input.txt | cut -d " " -f1) tariffs found for $rule. Check if it is missing.
./slimmer.py "$numara" "${zone}"