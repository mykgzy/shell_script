#!/bin/bash
# nic_balance.sh
# usage: nic_balance.sh NIC_NAME

nic_name=$1

# 消息通知字段
function msg ()
{
    echo "$(date +%F) $(date +%T) | $nic_name"
    return 0
}

# 主函数定义
function main()
{
	# 获取 node1 节点上的 CPU ID,组合成数组
	cpu=(`numactl --hardware | grep "node 1 cpus" | awk -F: '{print $2}'`)
	len_cpu=${#cpu[@]}

	# 获取某网卡接口上的中断 ID，并组合成数组
	nic_irq=(`grep ${nic_name}-TxRx /proc/interrupts|awk '{print $1}'|tr ':|\n' ' '`)
	len_nic_irq=${#nic_irq[@]}

	# 将 node1 上的 CPU 与对应网卡上的 ID 进行绑定
	for ((n=0; n<$len_nic_irq; n++))
	do
	    if [ $n -lt $len_cpu ]
	    then
	        echo ${cpu[n]} > /proc/irq/${nic_irq[n]}/smp_affinity_list
	        echo "echo ${cpu[n]} > /proc/irq/${nic_irq[n]}/smp_affinity_list"
	    else
	        m=`expr $n - $len_cpu`
	        echo ${cpu[m]} > /proc/irq/${nic_irq[n]}/smp_affinity_list
	        echo "echo ${cpu[m]} > /proc/irq/${nic_irq[n]}/smp_affinity_list"
	    fi
	done
}


# 判断是否安装 numactl
numactl -H >/dev/null 2>&1
if [ $? -eq 0 ]
then
	main
else
	msg "Please check numactl module installed or not"
	exit 1
fi

