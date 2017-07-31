#!/usr/bin/python
# Scientist: AUT

import time, sys;
import re


def getUsageRule(line):
    fields = line.split()
    #  print fields[2],"getUsageRule"
    return fields[2]


def giveBonus(b):
    outfile.write("""
|set bonus                                                                  |
|msisdn               |blname                                  |amount|startdt                |enddt                  |
|${MY_TARIFF_MSISDN_1}|%s|1.0   |2017-01-29T00:00:00.000|2029-12-29T00:00:00.000|    
""" % b)

    if tarifePrevious == tarife and i % 22 != 0:
        outfile.write("\n" + tabloHeader + "\n")




def delBonus(b):
    outfile.write("""
|set bonus                                                                  |
|msisdn               |blname                                  |amount|startdt                |enddt                  |
|${MY_TARIFF_MSISDN_1}|%s|0.0   |2017-01-29T00:00:00.000|2029-12-29T00:00:00.000|    
""" % b)
    if tarifePrevious == tarife and i % 22 != 0:
        outfile.write("\n" + tabloHeader + "\n")



has23bitBonus = False
hasAhlanBonus = False
hasMerhabaBonus = False


def handle23bitBonus(usage_rule):
    global has23bitBonus, hasAhlanBonus, hasMerhabaBonus
    if usage_rule == "IntAhlanGroupInd":
        if not hasAhlanBonus:
            giveBonus("BLC_Ahlan_Reload_Discount_Bonus_03190")
            hasAhlanBonus = True
    elif hasAhlanBonus:
        delBonus("BLC_Ahlan_Reload_Discount_Bonus_03190")
        hasAhlanBonus = False

    if usage_rule == "IntMerhabaGroupInd":
        if not hasMerhabaBonus:
            giveBonus("BLC_Merhaba_Reload_Discount_Bonus_03595")
            hasMerhabaBonus = True
    elif hasMerhabaBonus:
        delBonus("BLC_Merhaba_Reload_Discount_Bonus_03595")
        hasMerhabaBonus = False

    if not re.search("Ind$", usage_rule):
        if has23bitBonus:
            delBonus("BLC_ServiceBit_b23")
            has23bitBonus = False
    elif not usage_rule == "IntMerhabaGroupInd" and not usage_rule == "IntAhlanGroupInd":
        if not has23bitBonus:
            giveBonus("BLC_ServiceBit_b23")
            has23bitBonus = True


def checkManuelZones(usageRule):
    if usageRule == ('Turkcell'):
        return "05326117788", "TURKCELL".ljust(15)
    elif "Frd" in usageRule and "AriaService" not in usageRule:
        return "05556712299", "AVEA".ljust(15)
    elif usageRule == ('Aria'):
        return "05556117788", "AVEA".ljust(15)
    elif usageRule == ('NationalGroup'):
        return "02726117788", "AFYON".ljust(15)
    else:
        return "notFound", "notFound"


def getBNumberZone(line):
    fields = line.split()
    b = ""
    if len(fields) < 16:
        return "emptyy", "emptyy"
    # Aria Turkcell NationalGroup da manuel ver
    zone1 = fields[15]
    if zone1 == "CEPMASTER":
        return "7583131".ljust(11), "CEPFLIRT".ljust(12)
    pattern = re.compile("\^O:(.*)\$\s+" + zone1 + "$")
    for i, line1 in enumerate(open("/rte/orgaroot/mrte1/si/rte/orgadata/cnf/reg/scp/zones/inss7moc", "r")):
        for match in re.finditer(pattern, line1):
            b = match.group(1).replace(".*", "").replace("[0-9]", "9").replace("[2-3]", "2")
    return b.ljust(11), zone1.ljust(12)


"""if __name__ == "__main__":
    getBNumberFromZone("TPU_00011 usageRule: Turkcell  price: 1.99 unit size: 60.0 fixedUnit: 60.001 fixedCost: 1.99 MOC_VAS")
    sys.exit(2)"""
zone = ""

localtime = time.asctime(time.localtime(time.time()))
libraries = """!include -c <FrontPage.SuiteAveaUat.SuiteTariffs.TariffSubData
!include -c <FrontPage.SuiteAveaUat.SuiteTariffs.TariffCallData
!include -c <FrontPage.SuiteAveaUat.SuiteTariffs.TariffScenarios

!define MY_TARIFF_MSISDN_1 {05012211155}
!define MY_TARIFF_IMSI_1 {286037201111655}
!define MY_TARIFF_ICCID_1 {89902860302111349655}

|terminate sub        |
|msisdn               |
|${MY_TARIFF_MSISDN_1}|

|install Sub balance                                                      |
|imsi               |msisdn               |tariffId|iccid         |balance|
|${MY_TARIFF_IMSI_1}|${MY_TARIFF_MSISDN_1}|149|${MY_TARIFF_ICCID_1}|9999999|

|voice call                                                         |
|aparty               |bparty     |duration|zone    |balance |cost  |
|${MY_TARIFF_MSISDN_1}|05442442424|60      |VODAFONE|BLP_Main|0.6   |

|wait seconds|4|

|update  friend	|
|msisdn|opType|slot|friend|cost|
|${MY_TARIFF_MSISDN_1}|ADD | 1|05556712299 |1|
"""

tabloHeader = """|voice callAfter4M                                                  |
|aparty               |bparty     |duration|zone        |balance |cost  |"""

changeTariffStr = """
|change tariff               |
|msisdn               |tariff|
|${MY_TARIFF_MSISDN_1}|%s    |
"""
infile = open("Input.txt", "r")
outfile = open("Output.txt", "w")
if not (len(sys.argv) > 1 and sys.argv[1] == "-a"):  # not append mode
    outfile.write(libraries + "\n")
tarife = "149"
i = 0
tarifePrevious = ""
for line in infile:
    tarifePrevious = tarife
    tarife = str(int(line.split()[0][-5:]))
    price = float(line.split()[4])

    unitSize = str(int(float(line.split()[7])))  # to remove decimal part
    unitSize2 = str(int(unitSize) + 1)
    price2 = price * 2

    if price == 0:
        price = line.split()[11]
        price2 = price
    if float(price) == int(float(price)):
        price = int(float(price))  # to remove decimal part if integer
    if float(price2) == int(float(price2)):
        price2 = int(float(price2))  # to remove decimal part if integer
    price2 = str(price2)

    handle23bitBonus(line.split()[2])
    if tarifePrevious != tarife:
        if not (len(sys.argv) > 1 and sys.argv[1] == "-a"):  # not append mode
            outfile.write(changeTariffStr % tarife + "\n")
            outfile.write("\n" + tabloHeader + "\n")
            i = 1
    # Aria Turkcell NationalGroup da manuel ver
    b, zone = checkManuelZones(getUsageRule(line))
    if b == "notFound":
        b, zone = getBNumberZone(line)
    if b == "emptyy":
        print "empty zone: " + line
        continue
    if b == "".ljust(11) or zone == "".ljust(12):
        # print "bNumber bulunamadi: " + line
        continue
    if i % 22 == 0:
        i = 0
        outfile.write("\n" + tabloHeader + "\n")
    i += 1
    outfile.write("|${MY_TARIFF_MSISDN_1}|" + b + "|" + unitSize.ljust(8) +
                  "|" + zone + "|BLP_Main|" + str(price).ljust(6) + "|" + "\n")
    outfile.write("|${MY_TARIFF_MSISDN_1}|" + b + "|" + unitSize2.ljust(8) +
                  "|" + zone + "|BLP_Main|" + price2.ljust(6) + "|" + "\n")

print(localtime + " : Saved to Output.txt")


# Ind ve tm  _lt_ ler. constrainte git yada manuel isimden