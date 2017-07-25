#                       
# AUTomationologist
# Argument is balance name like BLB_blahBlah10GB_09999
#!/usr/bin/python
import lxml.etree as et
import sys

def checkExistence (cntv):
         
               
        
		for pp1 in cntv:
                #et.dump(pp1)
				for pp in pp1.findall('use_balance'):
					#et.dump(pp)
                
					name = pp.get('name')
					print name
					if name == sys.argv[1]:
						print "Balance is there"
						sys.exit(0)
					
		print "CRE-Config.xml'deki BGB_DATA_ALL'a %s eklenmemis!" % (sys.argv[1])
    
if __name__=="__main__":
       
        parser = et.XMLParser(remove_blank_text=True)
        tree = et.parse(open("/rte/orgadata/mrte1/cnf/cre/config_19700101000000.xml"), parser)
        cntv=tree.xpath('/cre_config/balance_group[@name="BGB_DATA_ALL"]');
        checkExistence (cntv)


