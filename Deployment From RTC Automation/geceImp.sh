#!/bin/bash

#AUT Implementations

#sleep until next day's 2:00 AM 
sleep $(/usr/bin/python calcDate.py|tail -1 | cut -d. -f1)  
echo starting
./deploy.sh
