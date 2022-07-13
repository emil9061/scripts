#!/bin/bash

if [ -z $1 ]
then
        echo "Enter IP"
else
		remove_old=`find /var/lib/vz/dump/* -mtime 2 -exec rm -f {} \; && find /var/lib/vz/dump/* -mtime 1 -exec rm -f {} \;`
        
        edit_onboot(){
                # configs dir
                dir=/etc/pve/nodes/`hostname`/qemu-server

                # for all conf
                for config in $dir/*.conf
                do
                        # edit current
                        echo "replace 'onboot: $1' to 'onboot: $2'"
                        num=`grep -n "onboot: " $config | cut -d : -f 1`
                        echo "string num: $num"
                        grep -e 'onboot: '$1'' $config

                        if [ $? -eq 0 ]
                        then
                                sed -i $num' c\onboot: '$2'' $config
                        else
                                grep 'onboot: '$2'' $config
                                if [ $? -eq 0 ]
                                then
                                        :
                                else
                                        echo 'onboot: '$2'' >> $config
                                fi
                        fi
                done
        }

        edit_onboot 1 0

        for vm_id in $(cat /etc/pve/.vmlist | grep node | tr -d '":,' | awk '{print $1}' | sort -r ); do
                echo "VM: $vm_id"
                dumpdir='/var/lib/vz/dump'
                vzdump $vm_id --mode stop --compress zstd

                filename=`ls -t $dumpdir | grep "vma" | head -1`
                scp $dumpdir/$filename root@$1:$dumpdir
                
                # remove old backups on remote server
                ssh -T root@$1 "find /var/lib/vz/dump/* -mtime 4 -exec rm -f {} \;"
                echo "VM: $vm_id [OK]"
        done

        edit_onboot 0 1
        $remove_old
fi