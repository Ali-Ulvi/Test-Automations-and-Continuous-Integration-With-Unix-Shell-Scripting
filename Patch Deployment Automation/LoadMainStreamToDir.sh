op_date=$(date +%Y%m%d)
rm -rf /tmp/patch/RTC_Prepaid_GOLDConfig_Stream_WS_P$$_$op_date
echo $1
dir=/tmp/patch/RTC_Prepaid_GOLDConfig_Stream_WS_P$$_$op_date
exe=/rte/orgadata/mrte1/avea/work/AveaRtcScmTools/jazz/scmtools/eclipse/lscm
        /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/jazz/scmtools/eclipse/lscm login -r https://10.4.49.154:9443/ccm -u RTCBuild -P 'Sagopa4567' -n PatchRTC_RTCBuild -c
        /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/jazz/scmtools/eclipse/lscm create workspace -r PatchRTC_RTCBuild -d 'RTC command line workspace for GOLD config patch deployment' --stream 'Prepaid - GOLD Config - Main Stream' RTC_Prepaid_GOLDConfig_Stream_WS_$$
        /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/jazz/scmtools/eclipse/lscm load -f -d /tmp/patch/RTC_Prepaid_GOLDConfig_Stream_WS_P$$_$op_date -i RTC_Prepaid_GOLDConfig_Stream_WS_$$ -r PatchRTC_RTCBuild
        /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/jazz/scmtools/eclipse/lscm workspace delete -r PatchRTC_RTCBuild RTC_Prepaid_GOLDConfig_Stream_WS_$$
        /rte/orgadata/mrte1/avea/work/AveaRtcScmTools/jazz/scmtools/eclipse/lscm logout -r PatchRTC_RTCBuild
 

if [ -n "$1" ]
then
mv /tmp/patch/RTC_Prepaid_GOLDConfig_Stream_WS_P$$_$op_date /tmp/patch/$1
if [ $? -eq 0 ]
	then
	dir=/tmp/patch/$1
fi
fi
testBilgi="$0 $@"
doMail()
# run to send mail notifications
{
  echo -en "\n *** Mailing hsbq***\n"
 ssh mrte1@10.248.68.122 "source .profile; echo $1| mailx -s \"$testBilgi\" aliulvi.talipoglu@partner.turktelekom.com.tr" 
  
}

cp /rte/orgadata/mrte1/hsbq/config/Config.from_classic /rte/orgadata/mrte1/hsbq/config/Config.from_classic.bck
cp $dir/Prepaid-GoldConfig/hsbq/config/Config.from_classic /rte/orgadata/mrte1/hsbq/config/Config.from_classic_$op_date

if [ $? -ne 0 ]
	then
	doMail "Config.from_classic kopyalanamadi"
fi
cd /rte/orgadata/mrte1/hsbq/config
ln -sf  Config.from_classic_$op_date  Config.from_classic
pkill hsbq
OUPMclient -L Run
ssh mrte2@10.248.68.127 "source .profile; cp $dir/Prepaid-GoldConfig/hsbq/config/Config.from_classic /rte/orgadata/mrte2/hsbq/config/Config.from_classic_$op_date;cd /rte/orgadata/mrte2/hsbq/config;ln -sf  Config.from_classic_$op_date  Config.from_classic;pkill hsbq;OUPMclient -L Run" 
 
cp /rte/orgadata/mrte1/avea/work/AdditionalSmsTool/ini/ttsmessages.txt /rte/orgadata/mrte1/avea/work/AdditionalSmsTool/ttsmessages.txt.bck 
cp $dir/Prepaid-GoldConfig/avea/work/AdditionalSmsTool/ini/ttsmessages.txt /rte/orgadata/mrte1/avea/work/AdditionalSmsTool/ini/ttsmessages.txt_$op_date
if [ $? -ne 0 ]
	then
	doMail "ttsmessages kopyalanamadi"
fi
cd /rte/orgadata/mrte1/avea/work/AdditionalSmsTool/ini
ln -sf  ttsmessages.txt_$op_date  ttsmessages.txt
OUPMclient -K ASTool TERM
OUPMclient -L Run
ssh mrte2@10.248.68.127 "source .profile; cp /rte/orgadata/mrte2/avea/work/AdditionalSmsTool/ini/ttsmessages.txt /rte/orgadata/mrte2/avea/work/AdditionalSmsTool/ttsmessages.txt.bck;cp $dir/Prepaid-GoldConfig/avea/work/AdditionalSmsTool/ini/ttsmessages.txt /rte/orgadata/mrte2/avea/work/AdditionalSmsTool/ini/ttsmessages.txt_$op_date;cd /rte/orgadata/mrte2/avea/work/AdditionalSmsTool/ini;ln -sf  ttsmessages.txt_$op_date  ttsmessages.txt;OUPMclient -K ASTool TERM;OUPMclient -L Run " 
rm -rf /tmp/patch/RTC_Prepaid_GOLDConfig_Stream_WS_P$$_$op_date
