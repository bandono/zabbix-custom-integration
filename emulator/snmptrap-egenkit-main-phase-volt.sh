#!/bin/bash
#
# v1.1
# simulate trap: Power Instruments Egenkit (SNMP v2c)
# items	:	multiple items with string
#
# usage: ./snmptrap-egenkit-main-phase-volt.sh <trap receiver> <trap value>
#

defaultVal="232.00"
trapReceiver="localhost"
trapVal=$defaultVal

if [ "$1" != "" ]; then
	if [ "$2" != "" ]; then
		trapVal="$2"
		trapReceiver="$1"
	else
		# value of trap will become default here
		trapReceiver="$1"
	fi
fi

snmptrap -v 2c -c public $trapReceiver \
"" SNMPv2-SMI::enterprises.38337.1.1.3.7.3 \
SNMPv2-SMI::enterprises.38337.1.1.3.7.3.1 \
s "`date +%a\ %b\ %d\ %T\ %Y`" \
SNMPv2-SMI::enterprises.38337.1.1.3.7.3.2 \
s "Mains phase voltage L3 (V)" \
SNMPv2-SMI::enterprises.38337.1.1.3.7.3.3 \
s $trapVal
