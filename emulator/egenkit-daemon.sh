#!/bin/bash
# ./egenkit-daemon.sh

while true
do {
	snmpd -C -I vacm_vars -c /home/zabbix/emulator/egenkit-emulator.conf
	sleep 43
	/etc/init.d/snmpd stop
}
done
