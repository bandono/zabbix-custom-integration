#!/bin/bash
#
# v1.0
# simulate trap: Power Instruments Egenkit (SNMP v2c)
# items	:	multiple items with string read from FILE
#
# usage: ./snmptrap-egenkit.sh <trap receiver>
#

FILE="fake_oid_items_with_value.lst"
trapReceiver="localhost"
trapVal=$defaultVal

send_trap() {
	snmptrap -v 2c -c public $1 \
	"" SNMPv2-SMI::enterprises.38337.1.1.3.7.3 \
	SNMPv2-SMI::enterprises.38337.1.1.3.7.3.1 \
	s "`date +%a\ %b\ %d\ %T\ %Y`" \
	SNMPv2-SMI::enterprises.38337.1.1.3.7.3.2 \
	s $2 \
	SNMPv2-SMI::enterprises.38337.1.1.3.7.3.3 \
	s $3
}

processLine(){
  line="$@" # get all args
}

if [ "$1" != "" ]; then
	if [ "$2" != "" ]; then
		trapVal="$2"
		trapReceiver="$1"
	else
		# value of trap will become default here
		trapReceiver="$1"
	fi
fi
 
# Set loop separator to end of line
BAKIFS=$IFS
IFS=$(echo -en "\n\b")
exec 3<&0
exec 0<$FILE
while read line
do
	processLine $line
	trapDesc=`echo $line | awk -F"," '{print $1}' | sed -e 's/\"//g'`
	trapVal=`echo $line | awk -F"," '{print $2}' | sed -e 's/\"//g'`
	send_trap "$trapReceiver" "$trapDesc" "$trapVal"
done
exec 0<&3
 
# restore $IFS which was used to determine what the field separators are
IFS=$BAKIFS
exit 0

