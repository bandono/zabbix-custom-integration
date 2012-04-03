#!/bin/sh
# env-mux-mini.sh
# v1.1
# Arif Kusbandono
#
# requires:
# 1. awk, sed
# 2. snmptranslate from NET-SNMP
# 3. NIT Enviromux MIB installed in path (/usr/share/snmp/mibs)
#
# normal usage: ./env-mux-mini.sh
# usage for checking parsed items to stdout: ./env-mux-mini.sh check
#

unset checkStatus
if [ "$1" == "check" ]; then
	checkStatus="yes"
fi

MIB=NETWORK-TECHNOLOGIES-GLOBAL-REG
ZABBIX_SERVER="localhost";
ZABBIX_PORT="10051";
ZABBIX_SENDER="/home/zabbix/bin/zabbix_sender";

read hostname 
vars=
HOST=$hostname
 
while read oid val
do
  if [ "$vars" = "" ]
  then
    vars="$oid = $val"
  else
    vars="$vars, $oid = $val"
  fi
done

# we'll rely on "comma" as field separator of the trap
# hence, "comma" found inside OID string value must be cleaned
# i.e NIT-MIB::temperatureSensor2Trap.0 = "Alert, Temperature DC, 25.4, C,"
# contains four "comma"
# we'll remove the above value during further check

ori_str=`echo $vars | awk -F'"' '{print $2}'`
rep_str=`echo $ori_str | sed -e 's/\,/\\\,/g' | sed -e 's/\s/\\\s/g'`

# replace OID string value with some dummy 
sanitized_vars=`echo $vars | sed -e 's/'${rep_str}'/dummy/g'`

# now separate the key from the whole comma-separated trap information
# where the key is in the 4th field
ori_key=`echo -n $sanitized_vars | awk -F',' '{print $4}' | awk -F'=' '{print $1}' | sed -e 's/\s//g'`

# use snmptranslate to translate the key OID against Enviromux-Mini MIB 
keyOID=`snmptranslate -On $ori_key`
key=`snmptranslate -m +$MIB $keyOID`

# final key is the child only:
key=`echo -n $key | awk -F'::' '{print $2}'`
str=$ori_str

#send to zabbix
$ZABBIX_SENDER -z $ZABBIX_SERVER -p $ZABBIX_PORT -s $HOST -k $key -o "$str"

if [ "$checkStatus" == "yes" ]; then
	echo $str
	echo $key
	echo $HOST
fi
