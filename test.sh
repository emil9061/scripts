#!/usr/bin/env bash

if [ -z $1 ]
then
        echo "Enter arg" && exit 2
else
        for iter in $(seq 1 $1)
        do
                sleep 3 && echo `date '+%Y.%m.%d Time: %H:%M:%S'`
                echo 'Iteration:' $iter
        done
fi
