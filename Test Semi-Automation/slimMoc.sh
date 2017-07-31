#!/usr/bin/bash
tariff=$1
bns=$2
if [[ $# -ne 1&&$# -ne 0&&$# -ne 2 ]]
    then
        echo "illegal number of parameters"
        echo "Kullanim: $0  tarife indirimBonusu(bu parametre istege bagli)"
        echo "ornek kullanim:"
        echo ""
        echo "$0 19 1768"
        exit
fi

if [[ $# -eq 1 ]]
then
	./slimSesDiscBonus.sh $tariff 
	cp Output.txt Output2.txt
	echo >> Output2.txt
	echo ------------ >> Output2.txt
	echo >> Output2.txt
	./slimSesTiered.sh $tariff -a
	echo >> Output2.txt
	echo ------------ >> Output2.txt
	echo >> Output2.txt
	cat Output.txt >> Output2.txt
	./slimSesAUTo.sh $tariff -a
	echo >> Output2.txt
	echo ------------ >> Output2.txt
	echo >> Output2.txt
	cat Output.txt >> Output2.txt
	cp Output2.txt Output.txt
	echo $(grep BLP_Main Output.txt|wc -l) "test cases have been saved to Output.txt  Pls check."
elif [[ $# -eq 2 ]]
then
	./slimSesDiscBonus.sh $tariff $bns
fi

#/rte/orgaroot/mrte1/SLIM/fitnesse/FitNesseRoot/FrontPage/AutOmation/content.txt