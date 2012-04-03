#!/bin/sh
# unconfigured-traphandle.sh
# v1.1
# Arif Kusbandono
#
# requires:
# 1. awk, sed
#
# normal usage: ./unconfigured-traphandle.sh
# usage for checking parsed items to stdout: ./unconfigured-traphandle.sh check
#

unset checkStatus
if [ "$1" == "check" ]; then
	checkStatus="yes"
fi

ZABBIX_SERVER="localhost";
ZABBIX_PORT="10051";
ZABBIX_SENDER="/home/zabbix/bin/zabbix_sender";
# default key for unconfigured trap received by snmptrapd:
key="unconfiguredTraphandle.0"

# as there are possibilities of unregistered hosts
# trap is registered as localhost
HOST="Zabbix server"

vars=
 
while read oid val
do
  if [ "$vars" = "" ]
  then
    vars="$oid = $val"
  else
    vars="$vars, $oid = $val"
  fi
done


str=$vars

#send to zabbix
$ZABBIX_SENDER -z $ZABBIX_SERVER -p $ZABBIX_PORT -s "$HOST" -k $key -o "$str"

if [ "$checkStatus" == "yes" ]; then
	echo $str
	echo $key
	echo $HOST
fi
