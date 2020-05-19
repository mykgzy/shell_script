#!/bin/bash


 j=0
 tftp=
 user=netadmin
 passwd=baidu.com
 dev_cfg=

MGip=(`cat iplist`)
LENTH=${#MGip[*]}

SEND_THREAD_NUM=4
tmp_fifofile="/tmp/$$.fifo"
mkfifo "$tmp_fifofile"
exec 6<>"$tmp_fifofile"
rm $tmp_fifofile

for ((i=0; i<$SEND_THREAD_NUM; i++))
    do
    echo
    let j++
    done >&6

for ((i=0; i<$LENTH; i++,j++))
    do
    read -u 6
    {
        sleep 1
        ./expect $tftp $user $passwd ${MGip[$i]} $dev_cfg
        echo ${MGip[$j]} >&6
    } &
done

wait
exec 6>&-

exit 0
