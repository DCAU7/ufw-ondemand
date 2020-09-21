#!/bin/bash
while read line; do ufw insert 1 deny from $line to any; done < /root/final.txt
