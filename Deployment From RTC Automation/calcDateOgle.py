import datetime as dt
import time

a = dt.datetime.now()
today = dt.datetime.today()
  
newdate = today.replace(hour=12, minute=07)
print newdate
#print (newdate-a).total_seconds()
print (newdate-a).seconds
