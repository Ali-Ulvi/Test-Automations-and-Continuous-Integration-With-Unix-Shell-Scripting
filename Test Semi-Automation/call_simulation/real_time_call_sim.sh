#!/bin/ksh
cd /tmp/ulvi/call_simulation
#echo "a number?"
#read msisdn

#echo "b number?"



#read bnum

#echo "call duration?"
#read duration

#echo "call start time?(yyyymmddhh24miss)"

#read tarih



now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then 
tarih=$now
fi

ESC=$(echo '\033')
vi moc.req.start_tmp >/dev/null <<END
:%s/ANUM/$1/g
:%s/BNUM/$2/g
:%s/CALLSTART/$4/g
:wq! moc.req.start
END

ESC=$(echo '\033')
vi moc.req.extend_tmp >/dev/null <<END  
:%s/ANUM/$1/g    
:%s/BNUM/$2/g       
:%s/CALLSTART/$4/g
:%s/CDURATION/$3/g
:wq! moc.req.extend
END

ESC=$(echo '\033')
vi moc.req.end_tmp >/dev/null <<END       
:%s/ANUM/$1/g    
:%s/BNUM/$2/g       
:%s/CALLSTART/$4/g
:%s/CDURATION/$3/g 
:wq! moc.req.end
END

./sim_comlayer -f MOC_1 -D
echo "success"
