#! /usr/bin/bash

#AUT Integrations
 
ENDPOINT="http://10.248.66.212/WEB/IWIS"
 

testBilgi="$0 $@"
doMail()
# run to send mail notifications
{
cat maillist.txt |xargs echo > .mail
  echo -en "*** Mailing ***\n"
while read EMAIL_LIST
do
if [ ! -z "$EMAIL_LIST" ]
then
 
ssh mrte1@10.248.68.122 "source .profile ;echo -en $1 '\\n\\nIyi Calismalar\\nAUT' | mailx -s \"Defect: $testBilgi\" $EMAIL_LIST" > /dev/null 2>&1

fi
done < .mail
  
}
echo sending hsbq
if [ $(curl --silent \
     --data \
     @- \
     --header 'Content-Type: application/soap+xml; charset=utf-8' \
     --user-agent "" \
     ${ENDPOINT} <<EOF | xmllint --format -|egrep "<IWIS_RETURN_CODE>0</IWIS_RETURN_CODE>|<NUMFREESMS>2800</NUMFREESMS>"|wc -l 
<IWIS_IN_DATA_UNIT>
   <IWIS_IN_HEADER version="1.0">
      <SYSTEM>VAS_IVR</SYSTEM>
      <SERVICE>PREPAID_QUERY_BALANCE</SERVICE>
      <TID>62C778E7589012964A9D1111</TID>
   </IWIS_IN_HEADER>
   <IWIS_SERVICE_PARAMS>
      <MSISDN>05053001034</MSISDN>
   </IWIS_SERVICE_PARAMS>
</IWIS_IN_DATA_UNIT>
EOF
) -ne 2 ] 
then
doMail "hsbq patlak"
fi

 