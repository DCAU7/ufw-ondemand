#!/bin/sh -e
myservername=`hostname`
/usr/sbin/ufw status | grep DENY | awk '{print $NF}' | grep -vwE "(Anywhere|(v6)|active|From|----)" | grep -v -e '^$' > /root/$myservername.txt
