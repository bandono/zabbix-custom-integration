#
# v1.0
#
# usage:
# ./zabbix_event_ack_normal.py someSensor1Trap.0 some-zabbix-host.dic [check]
# if optional argument `check` is omitted, no debug messages appear
#
# Implement Zabbix 1.8.x API in Python from
# https://github.com/gescheit/scripts
# to acknowledge (ACK) event with OK status once
# this event is actually a `normal` trigger so it is a self-ACK 
#  
# this script will look for the youngest event with OK status
# ACK it by API and return its ID printed in stdout
#
# this event ID comes from three RPC JSON calls to zabbix server API
#
# requires:
# 1. Python 2.6
# 2. zabbix_api.py
# 3. SimpleConfigParser.py
# 4. granted user privilege for API configured in Zabbix admin web-UI
#
# the script will read: 1) auth file 2) trigger ID dictionary
#
# trigger ID dictionary is specific to
# each trigger template linked to hostname
# (different IDs for each zabbix monitored hosts)

import sys
from zabbix_api import ZabbixAPI
import SimpleConfigParser

key=sys.argv[1]
triggerDict=sys.argv[2]
try:
	debugStatus=sys.argv[3]
except:
	debugStatus=0
	
authfile = 'zabbix-api-auth.conf'

myconf = SimpleConfigParser.SimpleConfigParser()
myconf.read(authfile)
server=myconf.getoption('server')
username=myconf.getoption('username')
password=myconf.getoption('password')

myconf.read(triggerDict)
trigger_id=myconf.getoption(key)


# change log level according to arguments passed (debug mode or not)
if debugStatus=='check':
	zapi = ZabbixAPI(server=server, path="", log_level=6)
else:
	zapi = ZabbixAPI(server=server, path="", log_level=0)

zapi.login(username, password)

ack_list=zapi.event.get({"acknowledged":[1]})
ok_list=zapi.event.get({"value":[0]})
event_trigger_list=zapi.event.get({"triggerids":[trigger_id]})

# if in debug mode, print JSON results to stdout
if debugStatus=='check':
	print '\nAcknowleged'
	print ack_list
	print '\nValue (1) OK'
	print ok_list
	print '\nEvent with Trigger %s' % trigger_id
	print event_trigger_list

'''
1. find matching OK and Event
2. Check whether the match is already acknowledged
3. remove the ackmowledged from Event list
'''
for eventids in event_trigger_list:
	for problemid in ok_list:
		if problemid==eventids:
			if problemid in ack_list:
				event_trigger_list.remove(problemid)


''' let the highest ID of Problem becomes the Event
that we're interested with'''
for eventids in event_trigger_list:
	for problemid in ok_list:
		if problemid==eventids:
			eventid=problemid['eventid']
'''
ACKNOWLEDGE the event
'''
ack_message="Self ACKNOWLEDGE of event %s" % eventid
zapi.event.acknowledge({"eventids":[eventid], "message":ack_message})
# print the event ID to stdout
print eventid
