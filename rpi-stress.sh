#!/bin/bash

[ "$(whoami)" == "root" ] || { echo "Must be run as sudo!"; exit 1; }

if [ ! `which sysbench` ]; then
  apt-get install -y sysbench
clear
sync
echo -e "RPIStressTest"
echo -e "Author: SavageThor"
echo -e "Version: 0.1"

vcgencmd measure_temp
vcgencmd get_config int | grep arm_freq
vcgencmd get_config int | grep core_freq
vcgencmd get_config int | grep sdram_freq
vcgencmd get_config int | grep gpu_freq
grep "actual clock" /sys/kernel/debug/mmc0/ios 2>/dev/null | awk '{printf("%0.3f MHz", $3/1000000)}'

echo -e "Running CPU test..."
sysbench --num-threads=4 --validate=on --test=cpu --cpu-max-prime=5000 run | grep 'total time:\|min:\|avg:\|max:' | tr -s [:space:]
vcgencmd measure_temp

echo -e "SavageThor's RPIStressTest finished"
