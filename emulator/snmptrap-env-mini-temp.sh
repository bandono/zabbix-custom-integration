#!/bin/bash
#
# v1.1
# simulate trap: NTI Enviromux-Mini
# items	:	SNMPv2-SMI::enterprises.3699.1.1.3.100.6.0 alert
#			SNMPv2-SMI::enterprises.3699.1.1.3.100.16.0 normal
# configured as : smoke detector
#
# usage: ./snmptrap-env-mini-smoke.sh alert|normal <trap receiver> <trap sender>
#
# The string itself is configurable via the NTI device' web interface

trapReceiver="localhost"
trapSender="localhost"

if [ "$2" != "" ]; then
	if [ "$3" != "" ]; then
		trapSender="$3"
		trapReceiver="$2"
	else
		trapReceiver="$2"
	fi
fi
	

if [ "$1" == "alert" ]; then
	snmptrap -v 1 -c public $trapReceiver \
	SNMPv2-SMI::enterprises.3699.1.1.3 $trapSender 6 1 '' \
	SNMPv2-SMI::enterprises.3699.1.1.3.100.2.0 \
	s "Alert, Temperature DC of ENVIROMUX-MINI at some_string_configured_on_admin_web, 25.4, C, "
elif [ "$1" == "normal" ]; then
	snmptrap -v 1 -c public $trapReceiver \
	SNMPv2-SMI::enterprises.3699.1.1.3 $trapSender 6 1 '' \
	SNMPv2-SMI::enterprises.3699.1.1.3.100.12.0 \
	s "Alert, Temperature DC of ENVIROMUX-MINI at some_string_configured_on_admin_web returned to normal, 25.4, C, "
fi
