#!/usr/bin/python
# Author: you know
import lxml.etree as et
import re
import sys

if __name__ == "__main__":
    r=''

    NSMAP = {'xsl': "http://www.w3.org/1999/XSL/Transform"}

    parser = et.XMLParser(remove_blank_text=True)
    tree = et.parse(open("/rte/orgaroot/mrte1/si/rte/orgadata/cnf/efd/pocr/efd_config.xml"), parser)
    f = tree.xpath('/route/event[@name="DPI_POCKET_CREATION" and @active="1"]/trigger/filter');
    regexp = re.compile(r'(^|\|)'+sys.argv[1]+r'(\||$)')
    if regexp.search(f[0].text):
        r+= 'efd_config.xml matched'
    tree = et.parse(open("/rte/orgaroot/mrte1/si/rte/orgadata/cnf/efd/pocr/idx_pocr.xsl"), parser)
    f = tree.xpath('/xsl:stylesheet/xsl:variable[@name="balances"]' , namespaces=NSMAP)
    regexp = re.compile(r'(\'|\|)' + sys.argv[1] + r'(\||\')')
    if regexp.search(f[0].get('select')):
        r += ' idx_pocr.xsl matched'
    print r



