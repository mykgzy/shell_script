#!/bin/bash
# nic_balance.sh
# usage: nic_balance.sh NIC num_of_cpu

cpu=0

grep $1 /proc/interrupts | awk '{print $1}'| sed 's/://' | while read a
do
	echo $cpu > /proc/irq/$a/smp_affinity_list
	echo "echo $cpu > /proc/irq/$a/smp_affinity_list"
 	if [ $cpu = $2 ]
 	then
 		cpu=0
 	fi
 	    let cpu=cpu+1
done
