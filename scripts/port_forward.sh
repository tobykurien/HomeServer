#!/bin/sh
echo Run as rooot.Starting routing...
echo "1" > /proc/sys/net/ipv4/ip_forward 
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 4567 -j REDIRECT --to-port 80
