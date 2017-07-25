cd /tmp/ulvi/call_simulation

print_result ()
{

echo "CDR RESULT is being prepared......."       
sleep 1

cat $ORGADATA/OHPQ/CRE-EFD.cre*/data.0* | grep $1 |grep `date +%Y-%m-%d`|tail -1 |while read line; do echo $line | sed 's/^..........//' | sed 's/..............$//' | xmllint --format - ; echo "=========================="; done

}

echo "Call type?"
echo "1-Voice Call"
echo "2-SMS"
echo "3-Data"
echo "4-MTC Voice Call"
echo "5-MTSMS Call"
echo "6-Video Call"
echo "7-MMS"

read calltype

case $calltype in

1)
echo "a number?"
read msisdn

echo "b number?"

read bnum

echo "call duration?"
read duration

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then 
tarih=$now
fi

ESC=$(echo '\033')
vi moc.req.start_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:wq! moc.req.start
END

ESC=$(echo '\033')
vi moc.req.extend_tmp >/dev/null <<END  
:%s/ANUM/$msisdn/g    
:%s/BNUM/$bnum/g       
:%s/CALLSTART/$tarih/g
:%s/CDURATION/$duration/g
:wq! moc.req.extend
END

ESC=$(echo '\033')
vi moc.req.end_tmp >/dev/null <<END       
:%s/ANUM/$msisdn/g    
:%s/BNUM/$bnum/g       
:%s/CALLSTART/$tarih/g
:%s/CDURATION/$duration/g 
:wq! moc.req.end
END

./sim_comlayer -f MOC_1 -D  ;;

#print_result 1111

2)

echo "a number?"
read msisdn

echo "b number?"

read bnum

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then
tarih=$now
fi

ESC=$(echo '\033')
vi mosms.req.charge_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:wq! mosms.req.charge
END

#ESC=$(echo '\033')
#vi mosms.rsp.charge_tmp >/dev/null <<END
#:%s/ANUM/$msisdn/g
#:%s/BNUM/$bnum/g
#:%s/CALLSTART/$tarih/g
#:wq! mosms.rsp.charge
#END

./sim_comlayer -f MOSMS_1 -D  ;;

3)

echo "a number?"
read msisdn

echo "call duration(volume)?"
read duration

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then
tarih=$now
fi

ESC=$(echo '\033')
vi gprs.req.start_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/VOLUME/$duration/g
:%s/CALLSTART/$tarih/g
:wq! gprs.req.start
END

ESC=$(echo '\033')
vi gprs.req.end_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/CALLSTART/$tarih/g
:%s/VOLUME/$duration/g
:wq! gprs.req.end
END


./sim_comlayer -f GPRS_1 -D ;;

4)
echo "aranan no?"
read msisdn

echo "arayan no?"

read bnum

echo "call duration?"
read duration

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then 
tarih=$now
fi

ESC=$(echo '\033')
vi mtc.req.start_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:wq! mtc.req.start
END

ESC=$(echo '\033')
vi mtc.req.extend_tmp >/dev/null <<END  
:%s/ANUM/$msisdn/g    
:%s/BNUM/$bnum/g       
:%s/CALLSTART/$tarih/g
:%s/CDURATION/$duration/g
:wq! mtc.req.extend
END

ESC=$(echo '\033')
vi mtc.req.end_tmp >/dev/null <<END       
:%s/ANUM/$msisdn/g    
:%s/BNUM/$bnum/g       
:%s/CALLSTART/$tarih/g
:%s/CDURATION/$duration/g 
:wq! mtc.req.end
END

./sim_comlayer -f MTC_1 -D  ;;

5)

echo "a number?"
read msisdn

echo "b number?"

read bnum

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then
tarih=$now
fi

ESC=$(echo '\033')
vi mtsms.req.charge_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:wq! mtsms.req.charge
END

./sim_comlayer -f MTSMS_1 -D  ;;

6)
echo "a number?"
read msisdn

echo "b number?"

read bnum

echo "call duration?"
read duration

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then
tarih=$now
fi

ESC=$(echo '\033')
vi movideo.req.start_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:wq! movideo.req.start
END


ESC=$(echo '\033')
vi movideo.req.end_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:%s/CDURATION/$duration/g
:wq! movideo.req.end
END

./sim_comlayer -f MOVIDEO_1 -D  ;;


7)

echo "a number?"
read msisdn

echo "b number?"

read bnum

echo "call start time?(yyyymmddhh24miss)"

read tarih

now=$(date +%Y%m%d%H%M%S)

if [ -z $tarih ] || [ $tarih == "now" ]
then
tarih=$now
fi

ESC=$(echo '\033')
vi mms.req.charge_tmp >/dev/null <<END
:%s/ANUM/$msisdn/g
:%s/BNUM/$bnum/g
:%s/CALLSTART/$tarih/g
:wq! mms.req.charge
END


./sim_comlayer -f MMS_1 -D  ;;

*)
echo "Call type is not supported for now" ;;

esac

print_result $msisdn
