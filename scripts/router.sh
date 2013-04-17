#!/bin/sh
echo Run as rooot.Starting routing...
echo "1" > /proc/sys/net/ipv4/ip_forward 
iptables -A POSTROUTING -t nat -j MASQUERADE
route del default gw 192.168.0.1
route add default gw 10.64.64.64
