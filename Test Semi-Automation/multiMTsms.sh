#!/usr/bin/ksh


while read msisdn shortno tp 
do
echo "TP_000"$tp
echo $(bash useMTSMS $msisdn $shortno) 
exit
done<msisdnlist.dat
