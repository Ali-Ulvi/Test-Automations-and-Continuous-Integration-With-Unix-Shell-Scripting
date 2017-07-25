#! /usr/bin/bash

# ci layer only Reminder SMSes

#TestBae
#      _
#       \
#		/\\
		 #
		   #
	   #   
msisdn=$1
ilkMsisdn=$1
work_dir=/tmp/CI
cd $work_dir

testBilgi="$0 $@"
doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "\n*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
  echo -en Merhaba\\n\\n $1 '\n\nIyi Calismalar\n\nAUT\nKafein CI Solutions\n\n' > tmp$ilkMsisdn

cat output$ilkMsisdn|egrep -v '^\*' >> tmp$ilkMsisdn
 scp tmp$ilkMsisdn mrte1@10.248.68.122:/tmp
 ssh mrte1@10.248.68.122 "source .profile; cat /tmp/tmp$ilkMsisdn| mailx -s \"$testBilgi $(cat servisID_Fiyat.txt|grep [0-9]|egrep -v '^#' |xargs echo)\" $EMAIL_LIST"
#ssh mrte1@10.248.68.122 "source .profile;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"Defect: $testBilgi\" $EMAIL_LIST"
fi
done < .mail
  
}
grep [0-9] servisID_Fiyat.txt|egrep -v '^#' > .servisIDler.txt

grep '[a-zA-Z]' yenilemeSMSleri.txt |egrep -v '^#' >.yenilemeSMSleri.txt
#smslerin bas ve sonlarinda fazla bosluk varsa silinir. bu muhtemelen testerin visiodan kopyalama hatasidir.:
sed 's/^ //' .yenilemeSMSleri.txt|sed 's/ $//'   > tmp
cp tmp .yenilemeSMSleri.txt
#sed "s|30 gun boyunca|<TARIH> saat <SAAT>'a kadar|g" tmp > .yenilemeSMSleri.txt

if [[ $(wc -l .servisIDler.txt |awk '{print $1}') -gt 10 ]]
then
echo ayni anda en fazla 10 servis test edilebiliyor.
doMail "ayni anda en fazla 10 servis test edilebiliyor. inputta verilen:$(wc -l .servisIDler.txt |awk '{print $1}')  TESTE BASLANAMADI."
exit 1
fi

if [[ $(( $(wc -l .servisIDler.txt |awk '{print $1}') * 4 )) -ne $(wc -l .yenilemeSMSleri.txt |awk '{print $1}') ]]
then
echo input sayilari tutmadi. exiting.
doMail "yenilemeSMSleri.txt dosyasindaki sms sayisi servisID_Fiyat.txt dosyasindaki servis sayisinin 4 kati olmal�. $(( $(wc -l .servisIDler.txt |awk '{print $1}') * 4 )) -ne $(wc -l .yenilemeSMSleri.txt |awk '{print $1}') TESTE BASLANAMADI."
exit 1
fi



if [[ $(egrep '�|�|�|�|�|�|�|�|�|�|�|�|�' .yenilemeSMSleri.txt|wc -l) -ne 0 ]]
then
echo Turkce Karakterli veya ters tirnak isaretli  satirlar:
egrep '�|�|�|�|�|�|�|�|�|�|�|�|�' .yenilemeSMSleri.txt
echo
echo yenilemeSMSleri.txt de Turkce karakterler veya ters tirnak isareti var. Bunlar ingilizce karsiliklariyla degistiriliyor.
doMail "yenilemeSMSleri.txt de Turkce karakterler veya ters tirnak isareti var. Bunlar ingilizce veya normal kesme isareti karsiliklariyla otomatik degistiriliyor. Developer da ayni seyi yapmamissa metinler eslesmeyeceginden scriptten hata mailleri gelecektir. sms9333 Turkce ve UTF-8 desteklemediginden Turkce karakter vs. kullanilmamali."
fi 

cat .yenilemeSMSleri.txt| tr '�����������ܒ' "guiscoocsigu'" > tmp$msisdn
mv tmp$msisdn .yenilemeSMSleri.txt

split -l 4 -d .yenilemeSMSleri.txt yenilemeSMSleri_
filecnt=0
while read serviceid_fiyat
do
serviceid=$(echo "$serviceid_fiyat"|awk '{print $1}')
fiyat=$(echo "$serviceid_fiyat"|awk '{print $2}')
counter=0
if [ ! -z "$fiyat" ]
then

	while read sms
	do
		if [ ! -z "$sms" ]
		then
		
			if [[ $(( $counter % 4 )) -eq 3 ]]
			then
			
				sms29gunSonra=$sms
				#changing msisdn due to smsdelay WA bugs
				msisdn1=$(./newNo |tail -1)
				echo $msisdn1|grep ERROR || msisdn=$msisdn1 || echo could not create msisdn. using the old one
				
 
				 
                if [[ $(grep $serviceid yenilemeikinciSmsleri.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) -eq 0 ]]
                	then
					echo ./renew $msisdn $serviceid $fiyat "$smsRenew"   2>&1 |tee -a output$msisdn
					 
				elif [[ $(grep $serviceid yenilemeikinciSmsleri.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) -eq 1 ]]
                	then
                	echo ./renew $msisdn $serviceid $fiyat "$smsRenew" "$(grep $serviceid yenilemeikinciSmsleri.txt|sed  -n 's/[0-9]* \(.*\)/\1/p')"  2>&1 |tee -a output$msisdn
				 
				else  
                	
                	doMail "yenilemeikinciSmsleri.txt de OSMID:$serviceid icin $(grep $serviceid yenilemeikinciSmsleri.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) tane sms bulundu. grep kullanildi. tek smsli gibi test ediliyor"
                	echo "yenilemeikinciSmsleri.txt de OSMID:$serviceid icin $(grep $serviceid yenilemeikinciSmsleri.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) tane sms bulundu. grep kullanildi."|tee -a output$msisdn
					echo ./renew $msisdn $serviceid $fiyat "$smsRenew"   2>&1 |tee -a output$msisdn
					./renew $msisdn $serviceid  $fiyat "$smsRenew" 2>&1 |tee -a output$msisdn
                fi

 
				 
				echo '***-------------------------------------***----------------------------------------***'
				echo ./1day $msisdn $serviceid "$sms1day"  $fiyat 2>&1 |tee -a output$msisdn
				./1day $msisdn $serviceid "$sms1day" $fiyat 2>&1 |tee -a output$msisdn
                if [[ $(grep $serviceid 1daySmsWithTaxDebt.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) -eq 0 ]]
                	then
					echo no reminder with tax sms found|tee -a output$msisdn
					
				elif [[ $(grep $serviceid 1daySmsWithTaxDebt.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) -eq 1 ]]
                	then
                echo ./1dayTax $msisdn $serviceid "$(grep $serviceid 1daySmsWithTaxDebt.txt|sed  -n 's/[0-9]* \(.*\)/\1/p')"  $fiyat 2>&1 |tee -a output$msisdn
				./1dayTax $msisdn $serviceid "$(grep $serviceid 1daySmsWithTaxDebt.txt|sed  -n 's/[0-9]* \(.*\)/\1/p')" $fiyat 2>&1 |tee -a output$msisdn
                	
				else  
                	
                	doMail "1daySmsWithTaxDebt.txt de OSMID:$serviceid icin $(grep $serviceid 1daySmsWithTaxDebt.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) tane sms bulundu. grep kullanildi. 2. sms testi atlaniyor"
                	echo "1daySmsWithTaxDebt.txt de OSMID:$serviceid icin $(grep $serviceid 1daySmsWithTaxDebt.txt|sed  -n 's/[0-9]* \(.*\)/\1/p'|wc -l) tane sms bulundu. grep kullanildi. 2. sms testi atlaniyor"|tee -a output$msisdn
                fi

				 
				counter=$(( $counter + 1 ))
				
				
			else
				case "$(( $counter % 4 ))" in
					0)  sms1day=$sms
					;;
					1)  smsRenew=$sms
					;;
					2)  smsRenewFail=$sms
					;;
			esac
			counter=$(( $counter + 1 ))
			fi
		else #sms bos satirsa
			doMail "grepe ragmen bos satir detected in smses. ignoring.. this may cause a problem please check input files format and line numbers"
			continue
		fi
	done < yenilemeSMSleri_0$filecnt
	echo filecnt $filecnt
	filecnt=$(expr $filecnt + 1)
	
else #fiyat bos satirsa
doMail "fiyat kismi bos in serviceIDs. ignoring line.. servisID_Fiyat.txt dosyasinda yanlis format. "
continue

fi
done < .servisIDler.txt
rm yenilemeSMSleri_*  

  doMail "Yenileme reminder SMSleri Test kosumu tamamlandi. $ilkMsisdn $msisdn"
  
