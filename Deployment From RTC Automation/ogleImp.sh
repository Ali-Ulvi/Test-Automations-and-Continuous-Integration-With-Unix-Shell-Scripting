#!/bin/bash

#AUT Quartz

#sleep until today's 12:07 PM 
sleep $(/usr/bin/python calcDateOgle.py|tail -1 | cut -d. -f1)  
echo starting
./deploy.sh
