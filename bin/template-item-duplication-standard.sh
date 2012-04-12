#!/bin/bash
#
# v1.0
# To help create item duplication for Zabbix SNMP monitoring template
#
# create the item echo lines by:
# 1. cat -E recti-item-sample-xml |  sed -e 's/\"/\\"/g' \
#	| sed 's/^$*/echo \"/g' | sed -e 's/$./o/g' | sed -e 's/>\$/>\"/g' \
#	>> template-item-duplication-standard.sh
# 2. The new item will appear below the example loop
# 3. replace the loop & index needed (loop count)
# 4. replace the incremental part $i of duplicated item
# 5. run this script

for i in {2..9}
do
echo "        <item type=\"1\" key=\"rectifier-Reported-AC-Voltage.$i\" value_type=\"0\">"
echo "          <description>RPS-SMX5:Rectifier Reported AC Voltage $i</description>"
echo "          <ipmi_sensor></ipmi_sensor>"
echo "          <delay>30</delay>"
echo "          <history>30</history>"
echo "          <trends>365</trends>"
echo "          <status>0</status>"
echo "          <data_type>0</data_type>"
echo "          <units>Volt</units>"
echo "          <multiplier>0</multiplier>"
echo "          <delta>0</delta>"
echo "          <formula>0</formula>"
echo "          <lastlogsize>0</lastlogsize>"
echo "          <logtimefmt></logtimefmt>"
echo "          <delay_flex></delay_flex>"
echo "          <authtype>0</authtype>"
echo "          <username></username>"
echo "          <password></password>"
echo "          <publickey></publickey>"
echo "          <privatekey></privatekey>"
echo "          <params></params>"
echo "          <trapper_hosts></trapper_hosts>"
echo "          <snmp_community>public</snmp_community>"
echo "          <snmp_oid>.1.3.6.1.4.1.1918.2.12.10.60.30.1.90.$i</snmp_oid>"
echo "          <snmp_port>161</snmp_port>"
echo "          <snmpv3_securityname></snmpv3_securityname>"
echo "          <snmpv3_securitylevel>0</snmpv3_securitylevel>"
echo "          <snmpv3_authpassphrase></snmpv3_authpassphrase>"
echo "          <snmpv3_privpassphrase></snmpv3_privpassphrase>"
echo "          <valuemapid>0</valuemapid>"
echo "          <applications/>"
echo "        </item>"
done
