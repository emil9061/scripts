#!/bin/bash -e

if [ -z $1 ] && [ -z $2 ]
then
        echo -e "Options:\n  1.Virtual machine ID\n  2.Server IP\n  3.Restore option (-r)"
else
	cd /var/lib/vz/dump 
    
        if [ -z $3 ]
        then
		vzdump $1 --mode stop --compress zstd
		filename=`ls -t | grep "vma" | head -1`
		restore='qmrestore /var/lib/vz/dump/'$filename' '$1' --storage local'
    		
		scp $filename root@$2:/var/lib/vz/dump/
		ssh -T root@$2 "$restore && rm /var/lib/vz/dump/"$filename

        elif [ $3 = "-r" ]
        then
		echo "Backup name: "
		read -e filename
		restore='qmrestore /var/lib/vz/dump/'$filename' '$1' --storage local --force'
		
		scp $filename root@$2:/var/lib/vz/dump/
		ssh -T root@$2 "$restore"
				
        else
		echo "Option -r - restore backup"
		exit
        fi
fi
