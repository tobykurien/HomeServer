#!/bin/sh
echo Before:
free -m
sudo sync
sudo sysctl -w vm.drop_caches=3
echo After:
free -m

