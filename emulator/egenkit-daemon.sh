#!/bin/bash
# ./egenkit-daemon.sh
#
# v1.2	to cope with unreachable network
# 		if unreachable snmpd will be stop
#		without restarted
#
#		need to add entry of the egenkit IP

egenkitIP="10.254.134.11"

while true
do {
	reachable_status=`ping -c 3 $egenkitIP | awk -F"time=" '{print $2}' | grep -v "^$" | wc -l`
	if [ $reachable_status -gt 0 ]; then
		snmpd -C -I vacm_vars -c /home/zabbix/emulator/egenkit-emulator.conf
		sleep 43
		/etc/init.d/snmpd stop
	else
		/etc/init.d/snmpd stop
	fi
}
done
