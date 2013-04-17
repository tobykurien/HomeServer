#!/bin/sh
cd /home/eeepc/Downloads/wget
wget -c -t 0 -i wget.txt &
/usr/bin/youtube-dl --no-progress -c -f 18 -o "%(stitle)s.%(ext)s" -a youtube.txt > youtube.log

