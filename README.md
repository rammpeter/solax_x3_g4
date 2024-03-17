# Solax X3 G4 (aka QCells Q.HOME+ ESS HYB-G3-3P)
## Get the current parameter values for hybrid inverter
The current parameter values can be read from WiFi adapter by http post request.
Replace "&lt;SN&gt;" with the serial number of WiFi adapter. 
```
> curl -d "optType=ReadRealTimeData&pwd=<SN>" -X POST http://192.168.178.xx
```
produces a result like this:
```
{"sn":"Sxxxxxxxxxx","ver":"3.006.04","type":14,"Data":[2387,2438,2403,71,72,71,1689,1739,1702,5130,2970,2997,90,89,2700,2668,5001,5000,5001,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1273,0,0,0,0,32310,0,0,3183,0,0,1,49,3857,256,4121,4365,6147,100,0,40,0,0,0,0,0,0,0,0,0,0,0,0,0,10577,0,150,126,0,0,4205,0,4917,0,30,79,11964,0,210,0,0,0,27156,0,4437,1,173,0,2,0,0,0,0,0,0,0,0,0,1,100,1,22,92,256,3504,2400,0,300,237,217,35,33,51,1620,783,15163,14906,15163,0,0,0,3508,3341,35072,14,20564,12339,18753,12599,18736,12612,12345,20564,12339,18754,12610,18740,13895,13881,20564,12339,18754,12856,18742,12614,13618,20564,12339,18754,12610,18740,13127,14647,0,0,0,0,0,0,0,4354,8195,1027,258,0,32310,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"Information":[8.000,14,"H34C08I9162381",8,1.26,0.00,1.26,1.09,0.00,1]}
```

## With similar request you can get the current parameter values also for the wallbox EDrive A11T
```
> curl -d "optType=ReadRealTimeData&pwd=Sxxxxxxxxx" -X POST http://192.168.178.xx
```
produces
```
{"SN":"Sxxxxxxxx","ver":"3.005.31","type":1,"Data":[0,0,23727,23467,23482,0,0,0,1,0,1,2,0,0,120,0,35,35463,41,105,4,65408,65030,0,26,1,0,14,0,0,0,0,0,4994,5000,5000,2339,4370,6147,7,0,0,0,0,0,0,0,0,0,100,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1586,4367,6147,0,0,1,1,0,0,51,1204,1000,60,49],"Information":[11.000,1,"C31101J8134016",1,1.11,1.01,0.00,0.00,0.00,1],"OCPPServer":"","OCPPChargerId":""}
```

## Get interpreted values
To get human readable values for some of the parameters here are two Ruby scripts
### explain_solax_x3_g4.rb 
Call this script with command line parameters serial number and host name / IP address:
```
> ./explain_solax_x3_g4.rb 192.168.178.xx Sxxxxxxxxx
```
produces a result like this:
```
explain_solax_x3_g4.rb, Peter Ramm, 2023-11-23
All attributes whose interpretation is known or which have a value other than 0 or 1 are displayed.

Time                : 2024-03-17 13:29:37 +0100
IP address          : 192.168.178.93
WiFi serial number  : SRK22XXDDZ
Firmware version    : 3.006.04
Inverter max. power : 8.0 KW

Inverter serial no. : H34C08I9162381

Data attributes     :
---------------------------------------------
  0:   2388    238.8 V    Inverter AC voltage phase 1
  1:   2444    244.4 V    Inverter AC voltage phase 2
  2:   2421    242.1 V    Inverter AC voltage phase 3
  3:     78      7.8 A    Inverter AC current phase 1 (inaccurate)
  4:     78      7.8 A    Inverter AC current phase 2 (inaccurate)
  5:     77      7.7 A    Inverter AC current phase 3 (inaccurate)
  6:   1841   1841.0 W    Inverter AC power phase 1
  7:   1895   1895.0 W    Inverter AC power phase 2
  8:   1862   1862.0 W    Inverter AC power phase 3
  9:   5598   5598.0 W    Inverter AC power all phases, negativ = import from grid
 10:   2933    293.3 V    PV1 Voltage
 11:   2924    292.4 V    PV2 Voltage
 12:    100     10.0 A    PV1 Current
 13:     99      9.9 A    PV2 Current
 14:   2944   2944.0 W    PV1 Power
 15:   2908   2908.0 W    PV2 Power
 16:   5001    50.01 Hz   Grid Frequency Phase 1
 17:   4999    49.99 Hz   Grid Frequency Phase 2
 18:   4999    49.99 Hz   Grid Frequency Phase 3
 19:      2      2.0      Inverter Operation mode
 23:      0      0.0 Y    EPS 1 Voltage
 24:      0      0.0 Y    EPS 2 Voltage
 25:      0      0.0 Y    EPS 3 Voltage
 26:      0      0.0 A    EPS 1 Current
 27:      0      0.0 A    EPS 2 Current
 28:      0      0.0 A    EPS 3 Current
 29:      0      0.0 W    EPS 1 Power
 30:      0      0.0 W    EPS 2 Power
 31:      0      0.0 W    EPS 3 Power
 34:   1612   1612.0 W    Grid AC power: + export, - import
 35:      0   1612.0 W    Grid AC power: + export, - import
 39:  32270    322.7 V    Battery Voltage
 40:      0      0.0 A    Battery Current, + charge, - discharge
 41:      0      0.0 W    Battery Power, + charge, - discharge
 42:   3177               
 45:      1      1.0      Battery BMS status (1=ok)
 46:     49     49.0 °C   Inverter inner temperature, 0 if shut off
 47:   3986   3986.0 W    AC house consumption now
 48:    256               
 49:   7452               
 50:   4365               
 51:   6147               
 52:    100               
 54:     41     41.0 °C   Inverter radiator temperature, 0 if shut off
 68:  10587   1058.7 kWh  Energy yield total: PV - battery charge + battery discharge
 69:      0   1058.7 kWh  Energy yield total: PV - battery charge + battery discharge
 70:    160     16.0 kWh  Energy yield today: PV - battery charge + battery discharge
 71:    126               
 74:   4205    420.5 kWh  Total Battery Discharge Energy
 75:      0    420.5 kWh  Total Battery Discharge Energy
 76:   4917    491.7 kWh  Total Battery Charge Energy
 77:      0    491.7 kWh  Total Battery Charge Energy
 78:     30      3.0 kWh  Battery Discharge Energy today
 79:     79      7.9 kWh  Battery Charge Energy today
 80:  11975   1197.5 kWh  Total PV Energy
 81:      0   1197.5 kWh  Total PV Energy
 82:    220     22.0 kWh  PV Energy today, not matter if loaded into battery or feed into grid or consumed by house
 86:  27175   271.75 kWh  Total Feed-in Energy
 87:      0   271.75 kWh  Total Feed-in Energy
 88:   4438   699.74 kWh  Total energy consumption from grid
 89:      1   699.74 kWh  Total energy consumption from grid
 90:    192     1.92 kWh  Feed-in energy into grid today
 92:      3     0.03 kWh  Energy consumption from grid today
103:    100    100.0 %    Battery Remaining Capacity
105:     22     22.0 °C   Battery Temperature
106:     92      9.2 kWh  Battery remaining energy
107:    256               
108:   3504               
109:   2400               
111:    300               
112:    233               
113:    215               
114:     35               
115:     33               
116:     51               
117:   1620               
118:    783               
119:  15163               
120:  14906               
121:  15163               
125:   3482               
126:   3339               
127:  35073               
128:     14               
129:  20564               
130:  12339               
131:  18753               
132:  12599               
133:  18736               
134:  12612               
135:  12345               
136:  20564               
137:  12339               
138:  18754               
139:  12610               
140:  18740               
141:  13895               
142:  13881               
143:  20564               
144:  12339               
145:  18754               
146:  12856               
147:  18742               
148:  12614               
149:  13618               
150:  20564               
151:  12339               
152:  18754               
153:  12610               
154:  18740               
155:  13127               
156:  14647               
164:   4354               
165:    257               
166:    771               
167:    257               
168:      0      0.0      Battery operation mode: 0=Self Use Mode, 1=Force Time Use, 2=Back Up Mode, 3=Feed-in Priority
169:  32270    322.7 V    Battery voltage
170:      0    322.7 V    Battery voltage
```



### explain_edrive_a11t.rb 




