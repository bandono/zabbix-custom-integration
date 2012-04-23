#!/bin/sh
# env-mux-mini.sh
# v2.0
# Arif Kusbandono
#
# requires:
# 1. awk, sed
# 2. snmptranslate from NET-SNMP
# 3. NIT Enviromux MIB installed in path (/usr/share/snmp/mibs)
# 4. zabbix_event_ack.py which requires Python 2.6
#    (Please specify Python 2.6 bin)
#
# normal usage: ./env-mux-mini.sh
# usage for checking parsed items to stdout: ./env-mux-mini.sh check
#
# To work exclusively with Enviromux Mini & Zabbix, the normal trap
# after incident is compromised to be seen from Zabbix as change of
# status (from PROBLEM (1) to OK (0))
#
# 1. To be seen as OK, the string must not contain the word "Alert"
# 2. & the other way around
# 3. The same Key of Zabbix trigger must be used, therefore `Ret` must
#    removed from each key expression i.e. `waterSensor1RetTrap.0`
#    becomes `waterSensor1Trap.0`

unset checkStatus
if [ "$1" == "check" ]; then
	checkStatus="yes"
fi

MIB=NETWORK-TECHNOLOGIES-GLOBAL-REG
ZABBIX_SERVER="localhost";
ZABBIX_PORT="10051";
ZABBIX_SENDER="/home/zabbix/bin/zabbix_sender";
PYTHON26="/usr/bin/python26"
API_DIR="/home/zabbix/bin/api"
ACK_API="$API_DIR/zabbix_event_ack.py";

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

# evaluate before sending to zabbix: whether it is incident trap or
# normal trap
incidentStatus=`echo $key | grep "Ret" | wc -l`
if [ $incidentStatus -gt 0 ]; then
	vkey=`echo $key | sed -e 's/Ret//g'`
	vstr=`echo $str | sed -e 's/Alert//g'`
	
	key=$vkey
	
	# put things to do (script) before sending them to zabbix below:
	cd $API_DIR
	ack_eventid=`$PYTHON26 $ACK_API $key $HOST.dic`
	echo $ack_eventid
	str=`echo $vstr "acknowledge event " $ack_eventid`
fi


# send to zabbix with -vv and stdout debug or clean
if [ "$checkStatus" == "yes" ]; then
	echo $str
	echo $key
	echo $HOST
	$ZABBIX_SENDER -vv -z $ZABBIX_SERVER -p $ZABBIX_PORT -s $HOST -k $key -o "$str"
else
	$ZABBIX_SENDER -z $ZABBIX_SERVER -p $ZABBIX_PORT -s $HOST -k $key -o "$str"
fi
