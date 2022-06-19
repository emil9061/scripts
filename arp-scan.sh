#!/bin/bash

# this is script that scans local network for active hosts
# and writes ip addresses in the file hosts.txt

hosts=`pwd`/hosts.txt
lf=`pwd`/scan.log
echo "Interface:" && read nic
echo -e "Active hosts:\n`sudo arp-scan --retry=3 --interface=$nic --localnet 2>>$lf \
	| grep -Eo '([0-9]{1,3}\.){3}([0-9]{1,3})' | tee $hosts`"
