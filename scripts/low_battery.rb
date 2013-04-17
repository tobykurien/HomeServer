#!/usr/bin/ruby
# This script must be run as root (i.e. via root's crontab)
batt = 9999
mode = "charging"

File.open("/proc/acpi/battery/BAT0/state", "r") do |infile|
    while (line = infile.gets)
	tok = line.split(" ")
        batt = tok[2] if tok[0] == "remaining"
	mode = tok[2] if tok[0] == "charging"        
    end
end

puts "Battery #{mode} with #{batt} mAh remaining"
if (mode == "discharging" && batt < 500)
  puts "Shutting down..."
  `shutdown -now`
end
