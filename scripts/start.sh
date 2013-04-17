#!/bin/sh
export DISPLAY=:0.0
rygel &
transmission-gtk &

cd alarm
nohup python alarm.py &
cd ..

cd www/home_server/
nohup ruby app.rb &
cd ../../

#xrandr --output LVDS1 --off
#cat 
#xrandr --output LVDS1 --on
