import re
import sys



try:
  from lxml import etree
  import lxml.etree as et
#  print("running with lxml.etree")
except ImportError:
  try:
    # Python 2.5
    import xml.etree.cElementTree as etree
    print("running with cElementTree on Python 2.5+")
  except ImportError:
    try:
      # Python 2.5
      import xml.etree.ElementTree as etree
      print("running with ElementTree on Python 2.5+")
    except ImportError:
      try:
        # normal cElementTree install
        import cElementTree as etree
        print("running with cElementTree")
      except ImportError:
        try:
          # normal ElementTree install
          import elementtree.ElementTree as etree
          print("running with ElementTree")
        except ImportError:
          print("Failed to import ElementTree from any known place")

thr=sys.argv[1]
bns=sys.argv[2]
cre=sys.argv[3]
def checkBalanceNameInGivenThreshold(balance_name,threshold_name):
	 
	for dumy in tree.xpath("/cre_config/threshold[@name='"+threshold_name+"']"):
		#print("Balance Name is being checked in "+threshold_name)
		#print (dumy.attrib['balances'])
		match = re.search(r"^"+balance_name+",|,"+balance_name+"($|,)", dumy.attrib['balances'])
		if match:
			print ("found")
	 

parser = etree.XMLParser(remove_blank_text=True)	
tree = etree.parse(open(cre), parser)
checkBalanceNameInGivenThreshold (bns,thr)
