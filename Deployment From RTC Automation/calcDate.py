import datetime as dt
import time

a = dt.datetime.now()
today = dt.datetime.today()
one_day = dt.timedelta(days=1)
tomorrow = today + one_day   
newdate = tomorrow.replace(hour=2, minute=0)
print newdate
#print (newdate-a).total_seconds()
print (newdate-a).seconds
