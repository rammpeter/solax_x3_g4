#!/usr/bin/ruby
# Extract and explain the status data from the Solax X3 G4 Hybrid inverter using the WiFI adapter
# This inverter is also branded as QCells Q.HOME+ ESS HYB-G3
# Peter Ramm, 2023-11-23

require 'net/http'
require 'uri'
require 'json'

puts "\nexplain_solax_x3_g4.rb, Peter Ramm, 2023-11-23"
puts "All attributes whose interpretation is known or which have a value other than 0 or 1 are displayed.\n\n"

# Check if there are any command line arguments
if ARGV.empty? || ARGV.count != 2
  puts "Error: Exactly two paramaters are required: <IP address> <serial number>"
  exit 1
end

ip_address    = ARGV[0]
serial_number = ARGV[1]

puts "Time                : #{Time.now}\n"
puts "IP address          : #{ip_address}\n"
puts "WiFi serial number  : #{serial_number}\n"


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
  parsed = divisor.nil? ? nil : raw / divisor.to_f
  print(index, raw, parsed, unit, name) if name != '' || (raw != 0 && raw != 1)
end

def parse_32(index, divisor, low_value, high_value, unit, name, signed_32: false)
  raw = @data[index]
  sum = high_value * 2**16 + low_value
  sum = to_signed32(sum) if signed_32
  parsed = divisor.nil? ? nil : sum / divisor.to_f
  print(index, raw, parsed, unit, name) if name != '' || raw != 0
end

parse(0,  10, 'V', 'Inverter AC voltage phase 1')
parse(1,  10, 'V', 'Inverter AC voltage phase 2')
parse(2,  10, 'V', 'Inverter AC voltage phase 3')
parse(3,  10, 'A', 'Inverter AC current phase 1 (inaccurate)', signed_16: true)
parse(4,  10, 'A', 'Inverter AC current phase 2 (inaccurate)', signed_16: true)
parse(5,  10, 'A', 'Inverter AC current phase 3 (inaccurate)', signed_16: true)
parse(6,  1,  'W', 'Inverter AC power phase 1', signed_16: true)
parse(7,  1,  'W', 'Inverter AC power phase 2', signed_16: true)
parse(8,  1,  'W', 'Inverter AC power phase 3', signed_16: true)
parse(9,  1,  'W', 'Inverter AC power all phases, negativ = import from grid', signed_16: true)
parse(10, 10, 'V', 'PV1 Voltage')
parse(11, 10, 'V', 'PV2 Voltage')
parse(12, 10, 'A', 'PV1 Current')
parse(13, 10, 'A', 'PV2 Current')
parse(14, 1,  'W', 'PV1 Power')
parse(15, 1,  'W', 'PV2 Power')
parse(16, 100, 'Hz', 'Grid Frequency Phase 1')
parse(17, 100, 'Hz', 'Grid Frequency Phase 2')
parse(18, 100, 'Hz', 'Grid Frequency Phase 3')
parse(19, 1, '', 'Inverter Operation mode')
parse(20)
parse(21)
parse(22)
parse(23, 10, 'Y', 'EPS 1 Voltage')
parse(24, 10, 'Y', 'EPS 2 Voltage')
parse(25, 10, 'Y', 'EPS 3 Voltage')
parse(26, 10, 'A', 'EPS 1 Current', signed_16: true)
parse(27, 10, 'A', 'EPS 2 Current', signed_16: true)
parse(28, 10, 'A', 'EPS 3 Current', signed_16: true)
parse(29, 1, 'W', 'EPS 1 Power', signed_16: true)
parse(30, 1, 'W', 'EPS 2 Power', signed_16: true)
parse(31, 1, 'W', 'EPS 3 Power', signed_16: true)
parse(32)
parse(33)
parse_32(34, 1, @data[34], @data[35], 'W', 'Grid AC power: + export, - import', signed_32: true)
parse_32(35, 1, @data[34], @data[35], 'W', 'Grid AC power: + export, - import', signed_32: true)
parse(36)
parse(37)
parse(38)
parse(39, 100, 'V', 'Battery Voltage')
parse(40, 100, 'A', 'Battery Current, + charge, - discharge', signed_16: true)
parse(41, 1,   'W', 'Battery Power, + charge, - discharge', signed_16: true)
parse(42)
parse(43)
parse(44)
parse(45, 1, '', 'Battery BMS status (1=ok)')
parse(46, 1, '°C', 'Inverter inner temperature, 0 if shut off')
parse(47, 1, 'W', 'AC house consumption now', signed_16: true)
parse(48)
parse(49)
parse(50)
parse(51)
parse(52)
parse(53)
parse(54, 1, '°C', 'Inverter radiator temperature, 0 if shut off')
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
parse_32(68, 10, @data[68], @data[69], 'kWh', 'Energy yield total: PV - battery charge + battery discharge')
parse_32(69, 10, @data[68], @data[69], 'kWh', 'Energy yield total: PV - battery charge + battery discharge')
parse(70, 10, 'kWh', 'Energy yield today: PV - battery charge + battery discharge')
parse(71)
parse(72)
parse(73)
parse_32(74, 10, @data[74], @data[75], 'kWh', 'Total Battery Discharge Energy')
parse_32(75, 10, @data[74], @data[75], 'kWh', 'Total Battery Discharge Energy')
parse_32(76, 10, @data[76], @data[77], 'kWh', 'Total Battery Charge Energy')
parse_32(77, 10, @data[76], @data[77], 'kWh', 'Total Battery Charge Energy')
parse(78, 10, 'kWh', 'Battery Discharge Energy today')
parse(79, 10, 'kWh', 'Battery Charge Energy today')
parse_32(80, 10, @data[80], @data[81], 'kWh', 'Total PV Energy')
parse_32(81, 10, @data[80], @data[81], 'kWh', 'Total PV Energy')
parse(82,10, 'kWh', 'PV Energy today, not matter if loaded into battery or feed into grid or consumed by house')
parse(83)
parse(84)
parse(85)
parse_32(86, 100, @data[86], @data[87], 'kWh', 'Total Feed-in Energy')
parse_32(87, 100, @data[86], @data[87], 'kWh', 'Total Feed-in Energy')
parse_32(88, 100, @data[88], @data[89], 'kWh', 'Total energy consumption from grid')
parse_32(89, 100, @data[88], @data[89], 'kWh', 'Total energy consumption from grid')
parse(90, 100, 'kWh', 'Feed-in energy into grid today')
parse(91)
parse(92, 100, 'kWh', 'Energy consumption from grid today')
parse(93)
parse(94)
parse(95)
parse(96)
parse(97)
parse(98)
parse(99)
parse(100)
parse(101)
parse(102)
parse(103, 1, '%', 'Battery Remaining Capacity')
parse(104)
parse(105, 1, '°C', 'Battery Temperature')
parse(106, 10, 'kWh', 'Battery remaining energy')
parse(107)
parse(108)
parse(109)
parse(110)
parse(111)
parse(112)
parse(113)
parse(114)
parse(115)
parse(116)
parse(117)
parse(118)
parse(119)
parse(120)
parse(121)
parse(122)
parse(123)
parse(124)
parse(125)
parse(126)
parse(127)
parse(128)
parse(129)
parse(130)
parse(131)
parse(132)
parse(133)
parse(134)
parse(135)
parse(136)
parse(137)
parse(138)
parse(139)
parse(140)
parse(141)
parse(142)
parse(143)
parse(144)
parse(145)
parse(146)
parse(147)
parse(148)
parse(149)
parse(150)
parse(151)
parse(152)
parse(153)
parse(154)
parse(155)
parse(156)
parse(157)
parse(158)
parse(159)
parse(160)
parse(161)
parse(162)
parse(163)
parse(164)
parse(165)
parse(166)
parse(167)
parse(168, 1, '', 'Battery operation mode: 0=Self Use Mode, 1=Force Time Use, 2=Back Up Mode, 3=Feed-in Priority')
parse_32(169, 100, @data[169], @data[170], 'V', 'Battery voltage')
parse_32(170, 100, @data[169], @data[170], 'V', 'Battery voltage')
parse(171)
parse(172)
parse(173)
parse(174)
parse(175)
parse(176)













