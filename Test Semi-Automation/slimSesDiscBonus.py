#!/usr/bin/python
# Scientist: AUT

import time, sys;
import re


def getUsageRule(line):
    fields = line.split()
    #  print fields[2],"getUsageRule"
    return fields[2]

def checkManuelZones(usageRule):
    if usageRule.startswith('Turkcell'):
        return "05326117788", "TURKCELL".ljust(15)
    elif "Frd" in usageRule and "AriaService" not in usageRule:
        return "05556712299", "AVEA".ljust(15)
    elif usageRule.startswith('Aria') and "AriaService" not in usageRule:
        return "05556117788", "AVEA".ljust(15)
    elif usageRule.startswith('NationalGroup'):
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
        return "7583131".ljust(11), "CEPFLIRT".ljust(15)
    pattern = re.compile("\^O:(.*)\$\s+" + zone1 + "$")

    for i, line1 in enumerate(open("/rte/orgaroot/mrte1/si/rte/orgadata/cnf/reg/scp/zones/inss7moc", "r")):
        # for i, line1 in enumerate(open("D:\JazzWorkspaceSilme\si\\rte\orgadata\cnf\\reg\scp\zones\inss7moc", "r")):
        for match in re.finditer(pattern, line1):
            b = match.group(1).replace(".*", "").replace("[0-9]", "9").replace("[2-3]", "2")
    return b.ljust(11), zone1.ljust(15)


def get_usage_rule_part(usage_rule):
    m = re.search("([^_]*)", usage_rule)
    rule = m.group(1)
    return rule


def get_bonus_part(usage_rule):
    m = re.search("_tm([0-9]+)$", usage_rule)
    return str(int(m.group(1)))  # remove leading zero(s)


def get_duration_part(usage_rule):
    m = re.search(".*_([0-9]+)_tm0", usage_rule)
    if m is None:
        return 2
    d = m.group(1)
    return d


def print_change_bonus(prev, curr):
    if prev != " ":
        outfile.write("""
|reset bonus                  |
|msisdn               |balance|
|${MY_TARIFF_MSISDN_1}|%s   |
""" % prev)
    outfile.write("""
|set bonus                                                                  |
|msisdn               |blname                                  |amount|startdt                |enddt                  |
|${MY_TARIFF_MSISDN_1}|%s|1.0   |2017-01-29T00:00:00.000|2029-12-29T00:00:00.000|    
""" % get_balance_name(curr))


def get_balance_name(bonusID):
    pattern = re.compile("<balances .* name=\"([^\"]*_" + bonusID.zfill(5) + ")\"")
    for i, line1 in enumerate(open(
            "/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogPrePackages.xml",
            "r")):
        # for i, line1 in enumerate(open("D:\JazzWorkspaceSilme\si\cs\subversion\\branches\OPSC-CONF-Avea_r242\LOGICAL\ProductCatalog\ProductCatalogPrePackages.xml", "r")):
        for match in re.finditer(pattern, line1):
            b = match.group(1)
    return b.ljust(40)


def printFile():
    ii = 0

    for rule in rules:
        durations = rules[rule]
        print rule, durations
        # i = len(durations) - 1
        for i in range(0, len(durations)):
            totalDur = 0
            totalPrice = 0.0
            while i > -1:  # span durations of the rule
                totalDur += int(unitSizes[rule + "_" + str(durations[i])])
                totalPrice += float(prices[rule + "_" + str(durations[i])])
                i -= 1

            if ii % 22 == 0:
                ii = 0
                outfile.write("\n" + tabloHeader + "\n")
            ii += 1
            outfile.write("|${MY_TARIFF_MSISDN_1}|" + bNos[rule] + "|" + str(totalDur).ljust(8) +
                          "|" + zones[rule] + "|BLP_Main|" + ("%g" % totalPrice).ljust(6) + "|" + "\n")
        # boundary + 1 :
        for i in range(0, len(durations)):
            totalDur = 1
            if i < len(durations) - 1:
                totalPrice = float(prices[rule + "_" + str(durations[i + 1])])
            else:  # last duration
                totalPrice = float(prices[rule + "_" + str(durations[i])])

            while i > -1:  # span durations of the rule
                totalDur += int(unitSizes[rule + "_" + str(durations[i])])
                totalPrice += float(prices[rule + "_" + str(durations[i])])
                i -= 1

            if ii % 22 == 0:
                ii = 0
                outfile.write("\n" + tabloHeader + "\n")
            ii += 1
            outfile.write("|${MY_TARIFF_MSISDN_1}|" + bNos[rule] + "|" + str(totalDur).ljust(8) +
                          "|" + zones[rule] + "|BLP_Main|" + ("%g" % totalPrice).ljust(6) + "|" + "\n")

    rules.clear()
    unitSizes.clear()
    prices.clear()
    zones.clear()
    bNos.clear()


unitSizes = {}
prices = {}
rules = {}
zones = {}
bNos = {}
"""if __name__ == "__main__":
    print len("TPU_00019 usageRule: NationalGroupMobOgrReYInd_Dur_lt_10_tm01747        price: 0.1 unit size: 10.0 fixedUnit: 10.0 fixedCost: 0.1 MOC_PSTN".split())
    sys.exit()"""
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

tabloHeader = """|voice callAfter4M                                                         |
|aparty               |bparty     |duration|zone           |balance |cost  |"""

changeTariffStr = """
|change tariff               |
|msisdn               |tariff|
|${MY_TARIFF_MSISDN_1}|%s    |
"""
infile = open("Input.txt", "r")
outfile = open("Output.txt", "w")
# print(libraries, file=outfile)
# print(tabloHeader, file=outfile)
if not (len(sys.argv) > 1 and sys.argv[1] == "-a"):  # append mode
    outfile.write(libraries + "\n")
tarife = "149"
differentTariff = False
differentBonus = False
previousBonus = " "
bonus = " "
firstLoop = True
i = 0

for line in infile:
    fullUsageRule = getUsageRule(line)
    previousBonus = bonus
    bonus = get_bonus_part(fullUsageRule)
    if bonus != previousBonus:
        differentBonus = True
    else:
        differentBonus = False
    tarifePrevious = tarife
    tarife = str(int(line.split()[0][-5:]))
    if tarifePrevious != tarife:
        differentTariff = True
    else:
        differentTariff = False
    if firstLoop:
        firstLoop = False
        if differentTariff:
            if not (len(sys.argv) > 1 and sys.argv[1] == "-a"):  # not append mode
                outfile.write(changeTariffStr % tarife + "\n")
            differentTariff = False
        if differentBonus:
            print_change_bonus(previousBonus, bonus)
            differentBonus = False
    else:
        if differentTariff:  # first loop degil ve farkli tarifeye gecti. printle
            printFile()
            outfile.write(changeTariffStr % tarife + "\n")
            differentTariff = False
        if differentBonus:
            printFile()
            print_change_bonus(previousBonus, bonus)
            differentBonus = False

    # Aria Turkcell NationalGroup da manuel ver
    if len(line.split()) < 14:
        b, zone = checkManuelZones(getUsageRule(line))
        if b == "notFound":
            print ":E: Zone notFound: ", line
            continue
    else:
        b, zone = getBNumberZone(line)
    if b == "emptyy":
        print ":E: empty zone: " + line
        continue
    if b == "".ljust(11) or zone == "".ljust(15):
        # print "bNumber bulunamadi: " + line + "zone dosyasi eksik"
        continue

    rule = get_usage_rule_part(fullUsageRule)
    duration = int(get_duration_part(fullUsageRule))
    if rule not in rules:
        rules[rule] = [duration]
    else:
        rules[rule].append(duration)
        rules[rule].sort()

    zones[rule] = zone
    bNos[rule] = b
    unitSize = str(int(float(line.split()[7])))  # to remove decimal part
    unitSizes[rule + "_" + str(duration)] = unitSize
    price = float(line.split()[4])
    if price == 0:
        price = line.split()[11]

    prices[rule + "_" + str(duration)] = float(price)

if differentTariff:
    outfile.write(changeTariffStr % tarife + "\n")
if differentBonus:
    print_change_bonus(previousBonus, bonus)
    differentBonus = False
printFile()
outfile.write("""
|reset bonus                  |
|msisdn               |balance|
|${MY_TARIFF_MSISDN_1}|%s   |
""" % bonus)
print(localtime + " - " + time.asctime(time.localtime(time.time())) + " : Saved to Output.txt")


# Ind ve tm  _lt_ ler. constrainte git yada manuel isimden
# FRD ekle
# lt lere +1li ekle
# samecomm