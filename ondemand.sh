#!/bin/bash
myip=`echo $SSH_CLIENT | awk '{ print $1}'`

# NOTE - all IPs have been changed
# Running UFW dump cmds
/opt/scripts/ufw-dump.sh
ssh root@192.168.0.30 "/opt/scripts/ufw-dump.sh"
ssh root@192.168.0.20 "/opt/scripts/ufw-dump.sh"

# Copying files from remote servers
scp root@192.168.0.30:/root/server1.txt .
scp root@192.168.0.20:/root/server.txt .

# Joining files
cat /root/mail.txt /root/server1.txt /root/server.txt > /root/joined.txt
cat joined.txt | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | grep -vwE "($myip|192.168.0.10|192.168.0.20|192.168.0.30)" | sort | uniq -u > complete.txt

# Removing duplicate IP addresses
sort /root/complete.txt | uniq -u > /root/final.txt
while read line; do ufw insert 1 deny from $line to any; done < /root/final.txt
scp final.txt root@192.168.0.30:/root/
scp final.txt root@192.168.0.20:/root/

# Inserting rules into remote servers
ssh root@192.168.0.30 "/opt/scripts/ufw-insert.sh"
ssh root@192.168.0.20 "/opt/scripts/ufw-insert.sh"

# Removing text files
rm complete.txt
rm final.txt
rm server1.txt
rm server.txt
rm mail.txt
rm joined.txt
ssh root@192.168.0.30 "rm -Rf /root/final.txt|rm -Rf /root/server1.txt"
ssh root@192.168.0.20 "rm -Rf /root/final.txt|rm -Rf /root/server.txt"

# Completed
