#!/usr/bin/python
# Scientist: AUT
# Parameters: B Number, Other Zone(Optional)
import time, sys;

zone = ""
if len(sys.argv) == 3:
    zone = sys.argv[2].ljust(12)
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
|${MY_TARIFF_IMSI_1}|${MY_TARIFF_MSISDN_1}|19|${MY_TARIFF_ICCID_1}|9999999|

|voice call                                                         |
|aparty               |bparty     |duration|zone    |balance |cost  |
|${MY_TARIFF_MSISDN_1}|05442442424|60      |VODAFONE|BLP_Main|0.6   |
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
# print(libraries, file=outfile)
# print(tabloHeader, file=outfile)
outfile.write(libraries + "\n")

for line in infile:
    tarife = str(int(line.split()[0][-5:]))
    price = float(line.split()[4])
    if price == int(price):
        price = int(price)  # to remove decimal part if integer
    unitSize = str(int(float(line.split()[7])))  # to remove decimal part
    unitSize2 = str(int(unitSize) + 1)
    price2 = str(price * 2)
    outfile.write(changeTariffStr % tarife + "\n")
    outfile.write(tabloHeader + "\n")
    outfile.write("|${MY_TARIFF_MSISDN_1}|" + sys.argv[1].ljust(11) + "|" + unitSize.ljust(8) +
                  "|" + zone + "|BLP_Main|" + str(price).ljust(6) + "|" + "\n")
    outfile.write("|${MY_TARIFF_MSISDN_1}|" + sys.argv[1].ljust(11) + "|" + unitSize2.ljust(8) +
                  "|" + zone + "|BLP_Main|" + price2.ljust(6) + "|" + "\n")
outfile.write("\nThis Script was Produced by AUT Technologies")
print(localtime + " : Saved to Output.txt")
