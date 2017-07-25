#!/usr/bin/python
import lxml.etree as et
import sys, getopt

usageName=''
tariffName=''

productcatalog="http://www.global.gold.opsc.orga.com/3_10_0/productcatalog"

NSMAP = {'productcatalog' : productcatalog  }

def main(argv):
        global usageName,tariffName
        try:
                opts, args=getopt.getopt(argv,"hu:t:",["usageRule=","tariffName="]);
        except getopt.GetoptError:
                print "test.py -u usageRuleName"        
                sys.exit(2)
        print opts
        for opt,arg in opts:
                if opt == '-h':
                        print "test.py -u usageRuleName -t tariffName"
                        sys.exit()
                elif opt in ("-u","--usageRule"):
                        usageName=arg;
                elif opt in ("-t","--tariffName"):
                        tariffName=arg
        print 'usage Name', usageName 
        print 'tariff name', tariffName 


def printUsagePrice (cntv):
        for usageRule in cntv:
                tariff=usageRule.getparent()
 
                print tariff.attrib['name'] + " " + usageRule.attrib['name']   
#                print '-------------------------------------'     
    
if __name__=="__main__":
        main(sys.argv[1:])

parser = et.XMLParser(remove_blank_text=True)
tree = et.parse(open("/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogPreTariffs.xml"), parser)
#
def printPackages (cntv):
        for comp in cntv:
 
 
                print    comp.attrib['name']
#                print    tree.getpath(comp)


def printFacade ():
	if (usageName) and (not tariffName):
	        cntv=tree.xpath("/productcatalog:ProductCatalog/TariffElements/usageTariffs/usageRules[@name='"+usageName+"']/revisions/prices/costPerUnit",namespaces=NSMAP	);
	        printUsagePrice (cntv)
	elif (usageName) and (tariffName):
	        cntv=tree.xpath("/productcatalog:ProductCatalog/TariffElements/usageTariffs[@name='"+tariffName+"']/usageRules[@name='"+usageName+"']/revisions/prices/	costPerUnit",namespaces=NSMAP);  
	        printUsagePrice (cntv)
	elif (not usageName) and (tariffName):
	        cntv=tree.xpath("/productcatalog:ProductCatalog/TariffElements/usageTariffs[@name='"+tariffName+"']/usageRules",namespaces=NSMAP);
	        printUsagePrice (cntv)  
	elif (not usageName) and (not tariffName):
	        cntv=tree.xpath("/productcatalog:ProductCatalog/TariffElements/usageTariffs/usageRules",namespaces=NSMAP);
	        printUsagePrice (cntv)
print '-----------------ProductCatalogPreTariffs--------------------'  
printFacade ()
cntv=tree.xpath("//products",namespaces=NSMAP);
printPackages (cntv)
print '-----------------ProductCatalogCTNPreTariffs--------------------'  
tree = et.parse(open("/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogCTNPreTariffs.xml"), parser)
printFacade ()
print '-----------------ProductCatalogPromoPreTariff--------------------'  
tree = et.parse(open("/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogPromoPreTariff.xml"), parser)
printFacade ()



print '-----------------ProductCatalogPrePackages--------------------'  
tree = et.parse(open("/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogPrePackages.xml"), parser)
cntv=tree.xpath("//balanceGroups",namespaces=NSMAP);
printPackages (cntv)
cntv=tree.xpath("//products",namespaces=NSMAP);
printPackages (cntv)
cntv=tree.xpath("/productcatalog:ProductCatalog/TariffElements/balances",namespaces=NSMAP);
printPackages (cntv)

print '-----------------ProductCatalogCore--------------------'  
tree = et.parse(open("/rte/orgaroot/mrte1/si/cs/subversion/branches/OPSC-CONF-Avea_r242/LOGICAL/ProductCatalog/ProductCatalogCore.xml"), parser)
cntv=tree.xpath("//constraints",namespaces=NSMAP);
printPackages (cntv)
cntv=tree.xpath("//eventVariables",namespaces=NSMAP);
printPackages (cntv)
