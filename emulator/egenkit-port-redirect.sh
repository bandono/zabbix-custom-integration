#!/bin/bash

redirect_port() {
	iptables -t nat --flush
	iptables -t nat -A OUTPUT --dst 10.254.134.11 -p udp --dport 3303 -j REDIRECT --to-port 3303
}

clean_nat() {
	iptables -t nat --flush
}

case $1 in

start)
	redirect_port
	;;
stop)
	clean_nat
	;;
esac
