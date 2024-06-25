#!/usr/bin/ruby
# Extract and explain the status data from the Solax X3 EVC 11k wallbox 
# This wallbox is also branded as QCells EDrive A11T
# Peter Ramm, 2024-03-17

require 'net/http'
require 'uri'
require 'json'

puts "\nexplain_solax_x3_evc11k.rb, Peter Ramm, 2024-03-17"
puts "All attributes whose interpretation is known or which have a value other than 0 or 1 are displayed.\n\n"

# Check if there are any command line arguments
if ARGV.empty? || ARGV.count != 2
  puts "Error: Exactly two paramaters are required: <IP address> <serial number>"
  exit 1
end

ip_address    = ARGV[0]
serial_number = ARGV[1]

puts "Time           : #{Time.now}\n"
puts "IP address     : #{ip_address}\n"
puts "Serial number  : #{serial_number}\n"


# Set the URL of the endpoint you want to send the POST request to
url = URI.parse("http://#{ip_address}/")

# Create a new HTTP POST request
request = Net::HTTP::Post.new(url.path)

# Set the request body if needed
request.body = "optType=ReadRealTimeData&pwd=#{serial_number}"

# Set any additional headers if required
request['Content-Type'] = 'application/x-www-form-urlencoded'

# Send the POST request
response = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https') do |http|
  http.request(request)
end

# Print the response
body = JSON.parse(response.body)
@data = body['Data']
info = body['Information']

puts "Firmware version    : #{body['ver']}\n"
puts "Inverter max. power : #{info[0]} KW\n\n"
puts "Inverter serial no. : #{info[2]}\n\n"
puts "Data attributes     :\n"
puts "---------------------------------------------\n"

def to_signed16(val)
  val -= 2**16 if val > 32767
  val
end

def to_signed32(val)
  val -= 2**32 if val > 2147483647
  val
end

def print(index, raw, parsed, unit, name)
  puts "#{index.to_s.rjust(3)}: #{raw.to_s.rjust(6)} #{parsed.to_s.rjust(8)} #{unit.ljust(4)} #{name}"
end

# print parsed value, unit and text representation of the response
def parse(index, divisor=nil, unit='', name = '', signed_16: false)
  raw = @data[index]
  raw = to_signed16(raw) if signed_16
  parsed = divisor.nil? ? nil : raw / divisor.to_f rescue nil
  print(index, raw, parsed, unit, name) if name != '' || (raw != 0 && raw != 1)
end

def parse_32(index, divisor, low_value, high_value, unit, name, signed_32: false)
  raw = @data[index]
  sum = high_value * 2**16 + low_value
  sum = to_signed32(sum) if signed_32
  parsed = divisor.nil? ? nil : sum / divisor.to_f
  print(index, raw, parsed, unit, name) if name != '' || raw != 0
rescue 
  nil
end

# parse(0,  10, 'V', 'Inverter AC voltage phase 1')
# parse(4,  10, 'A', 'Inverter AC current phase 2 (inaccurate)', signed_16: true)
# parse_32(34, 1, @data[34], @data[35], 'W', 'Grid AC power: + export, - import', signed_32: true)
# parse_32(35, 1, @data[34], @data[35], 'W', 'Grid AC power: + export, - import', signed_32: true)

parse(0,  1,   '-', 'Run mode: 
                          0: Available,
                          1: Preparing,
                          2: Charging,
                          3: Finishing,
                          4: Fault Mode,
                          5: Unavailable,
                          6: Reserved,
                          7: Suspended EV,
                          8: Suspended EVSE,
                          9: Update,
                         10: RFID Activation')
parse(1,  1,   '-', 'Charge mode:
                          0: Stop
                          1: Fast
                          2: Eco
                          3: Green')
parse(2,  100, 'V', 'AC voltage phase 1')
parse(3,  100, 'V', 'AC voltage phase 2')
parse(4,  100, 'V', 'AC voltage phase 3')
parse(5,  100, 'A', 'Charge Current L1')
parse(6,  100, 'A', 'Charge Current L2')
parse(7,  100, 'A', 'Charge Current L3')
parse(8,  1  , 'W', 'Charge Power L1')
parse(9,  1  , 'W', 'Charge Power L2')
parse(10, 1  , 'W', 'Charge Power L3')
parse(11, 1  , 'W', 'Charge Power total')
parse(12, 10 , 'kWh', 'Charge Energy added')
parse(13)
parse_32(14, 10, @data[14], @data[15], 'kWh', 'Charge Energy total', signed_32: false)
parse(16, 100, 'A', 'Grid Current L1 ???', signed_16: true)
parse(17, 100, 'A', 'Grid Current L2 ???', signed_16: true)
parse(18, 100, 'A', 'Grid Current L3 ???', signed_16: true)
parse(19, 1,   'W', 'Grid Power L1 ???',   signed_16: true)
parse(20, 1,   'W', 'Grid Power L2 ???',   signed_16: true)
parse(21, 1,   'W', 'Grid Power L3 ???',   signed_16: true)
parse(22, 1,   'W', 'Available PV Power ???',  signed_16: true)
parse(23)
parse(24, 1,   '°C', 'Charger Temperature')
parse(25)
parse(26)
parse(27)
parse(28)
parse(29)
parse(30)
parse(31)
parse(32)
parse(33,  100, 'Hz', 'Grid frequency phase 1')
parse(34,  100, 'Hz', 'Grid frequency phase 2')
parse(35,  100, 'Hz', 'Grid frequency phase 3')
parse(36)
parse(37)
parse(38)
parse(39)
parse(40)
parse(41)
parse(42)
parse(43)
parse(44)
parse(45)
parse(46)
parse(47)
parse(48)
parse(49)
parse(50)
parse(51)
parse(52)
parse(53)
parse(54)
parse(55)
parse(56)
parse(57)
parse(58)
parse(59)
parse(60)
parse(61)
parse(62)
parse(63)
parse(64)
parse(65)
parse(66)
parse(67)
parse(68)
parse(69)
parse(70)
parse(71)
parse(72)
parse(73)
parse(74)
parse(75)
parse(76)
parse(77)
parse(78)
parse(79)
parse(80)
parse(81)

print(82, @data[82], (@data[82]/256).to_i, 'min',   'Charge start time')
print(82, @data[82], @data[82]%256,        'sec',   'Charge start time')
print(83, @data[83], (@data[83]/256).to_i, 'day',   'Charge start time')
print(83, @data[83], @data[83]%256,        'hour',  'Charge start time')
print(84, @data[84], (@data[84]/256).to_i, 'year',  'Charge start time')
print(84, @data[84], @data[84]%256,        'month', 'Charge start time')
parse(85)
parse(86)
parse(87)
parse(88)
parse(89)
parse(90)
parse(91)
parse(92)
parse(93)
parse(94)
parse(95)













