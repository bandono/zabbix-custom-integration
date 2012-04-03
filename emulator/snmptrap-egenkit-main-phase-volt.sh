#!/bin/bash
#
# v1.0
# simulate trap: Power Instruments Egenkit (SNMP v2c)
# items	:	multiple items with string
#
# usage: ./snmptrap-env-mini-smoke.sh <trap receiver> <trap sender>
#

trapReceiver="localhost"
trapSender="localhost"

if [ "$1" != "" ]; then
	if [ "$2" != "" ]; then
		trapSender="$2"
		trapReceiver="$1"
	else
		trapReceiver="$1"
	fi
fi

snmptrap -v 2c -c public $trapReceiver \
"" SNMPv2-SMI::enterprises.38337.1.1.3.7.3 \
SNMPv2-SMI::enterprises.38337.1.1.3.7.3.1 \
s "Tue Sep 20 14:56:01 2011" \
SNMPv2-SMI::enterprises.38337.1.1.3.7.3.2 \
s "Mains phase voltage L3 (V)" \
SNMPv2-SMI::enterprises.38337.1.1.3.7.3.3 \
s "232.00"
