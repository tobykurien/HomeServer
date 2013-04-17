#!/usr/bin/ruby
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
