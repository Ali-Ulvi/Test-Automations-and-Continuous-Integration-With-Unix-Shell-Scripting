#!/usr/bin/python

import lxml.etree as et
import sys, getopt

usageName = ''
tariffName = ''

productcatalog = "http://www.global.gold.opsc.orga.com/3_10_0/productcatalog"

NSMAP = {'productcatalog': productcatalog}


def main(argv):
    global usageName, tariffName
    try:
        opts, args = getopt.getopt(argv, "hu:t:", ["usageRule=", "tariffName="]);
    except getopt.GetoptError:
        print "test.py -u usageRuleName"
        sys.exit(2)
    print opts
    for opt, arg in opts:
        if opt == '-h':
            print "test.py -u usageRuleName -t tariffName"
            sys.exit()
        elif opt in ("-u", "--usageRule"):
            usageName = arg;
        elif opt in ("-t", "--tariffName"):
            tariffName = "TPU_" + arg.zfill(5)
    print 'usage Name', usageName
    print 'tariff name', tariffName


def printUsagePrice(cntv):
    for price in cntv:
        usageRule = price.getparent().getparent().getparent()
        tariff = usageRule.getparent()
        # unitSize=price.getparent().xpath("/unitSize")
        # print tree.xpath("/productcatalog:ProductCatalog/TariffElements/usageTariffs/usageRules/revisions/prices/unitSize",namespaces=NSMAP).text;
        # et.dump(price.getparent())
        # print ''
        premium = usageRule.find('.//premiumNumber')
        ####if (premium is None ):
        ####	continue
        str = tariff.attrib['name'] + " usageRule: " + usageRule.attrib[
            'name'] + "\tprice: " + price.text + " unit size: " + price.getparent().find(
            'unitSize').text + " fixedUnit: " + price.getparent().find(
            'fixedUnit').text + " fixedCost: " + price.getparent().find(
            'fixedCost').text + " " + price.getparent().find('eventClass').text
        if (premium is not None):
            # continue ####
            p = tre.xpath("//premiumNumbers[@id='" + premium.text[1:] + "']/matchingValue", namespaces=NSMAP);
            for a in p:
                str = str + "\tPremium Zone: " + a.text
                break
        else:
            globalOptionRef = usageRule.find('.//globalOptionRef')

        print str
        # print '-------------------------------------'


if __name__ == "__main__":
    main(sys.argv[1:])

parser = et.XMLParser(remove_blank_text=True)
tree = et.parse(open(
    "/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogPreTariffs.xml"),
                parser)
tre = et.parse(open(
    "/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogCore.xml"),
               parser)
if (usageName) and (not tariffName):
    cntv = tree.xpath(
        "/productcatalog:ProductCatalog/TariffElements/usageTariffs/usageRules[@name='" + usageName + "']/revisions/prices/costPerUnit",
        namespaces=NSMAP);
    printUsagePrice(cntv)
elif (usageName) and (tariffName):
    cntv = tree.xpath(
        "/productcatalog:ProductCatalog/TariffElements/usageTariffs[@name='" + tariffName + "']/usageRules[@name='" + usageName + "']/revisions/prices/costPerUnit",
        namespaces=NSMAP);
    printUsagePrice(cntv)
elif (not usageName) and (tariffName):
    cntv = tree.xpath(
        "/productcatalog:ProductCatalog/TariffElements/usageTariffs[@name='" + tariffName + "']/usageRules/revisions/prices/costPerUnit",
        namespaces=NSMAP);
    printUsagePrice(cntv)
elif (not usageName) and (not tariffName):
    cntv = tree.xpath(
        "/productcatalog:ProductCatalog/TariffElements/usageTariffs/usageRules/revisions/prices/costPerUnit",
        namespaces=NSMAP);
    printUsagePrice(cntv)
