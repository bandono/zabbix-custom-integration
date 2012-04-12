#!/bin/bash
# ./egenkit-trap-converter.sh
# v1.2.x
# Arif Kusbandono
#
# requires:
# 1. awk, sed
# 2. snmptranslate from NET-SNMP
# 3. egenkit-oid-generator.pl script
#
# normal usage: ./egenkit-trap-converter.sh
# usage for checking parsed items to stdout: ./egenkit-trap-converter.sh check
#
# will convert trap from eGen kit to OID continue list of values
# generated as `egenkit-dynamic.lst`
#
# this `x` version is a workaround to `Battery` trap string issue

unset checkStatus
if [ "$1" == "check" ]; then
	checkStatus="yes"
fi

OID_INDEX_GENERATOR="/home/zabbix/bin/egenkit-oid-generator.pl"
RADDLE_FILE="/home/zabbix/bin/egenkit-dynamic.lst";

# egenkit specific trap OID that contains value of interest
OID_DESC=".1.3.6.1.4.1.38337.1.1.3.7.3.2"
OID_VAL=".1.3.6.1.4.1.38337.1.1.3.7.3.3"
ENTERP_NUMB=38337

read hostname
HOST=$hostname

insert_val() {
	# workaround for `Battery` string issue===
	battFound=`echo $1 | grep Battery | wc -l`
	if [ $battFound -gt 0 ]; then
		index=18
	else
		# call the OID index generator perl script 
		index=`$OID_INDEX_GENERATOR "${1}"`
	fi
	
	# find & replace value of relevant OID
	if [ $index -gt 0 ]; then
	{
		perl -pi -e "s/.1.3.6.1.4.1.38337.1.1.3.7.4.${index}.0=\w+/.1.3.6.1.4.1.38337.1.1.3.7.4.${index}.0=${2}/g" $RADDLE_FILE
		echo $index", "$1", "$2
	}
	fi
}
 
while read oid val
do
	READ_STATUS=`echo $oid | grep $ENTERP_NUMB | wc -l`
	if [ $READ_STATUS -gt 0 ]; then 
		OID_RECEIVED=`snmptranslate $oid -On`
		if [ "$OID_RECEIVED" == "$OID_DESC" ]; then
			ITEM_DESC=`echo $val | sed -e 's/\"//g'`
		elif [ "$OID_RECEIVED" == "$OID_VAL" ]; then
			ITEM_VAL=`echo $val | sed -e 's/\"//g' | sed -e 's/\.//g'`
			# call function `insert_val`
			insert_val "$ITEM_DESC" "$ITEM_VAL"
		fi	
	fi	
done

if [ "$checkStatus" == "yes" ]; then
	echo $HOST
fi
