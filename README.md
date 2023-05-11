# P4INT_Mininet
SDN P4 INT deployed in Mininet and security analysis
You can find a similar version running in P4PI, i.e. P4 for RaspBerry PI in https://github.com/ruimmpires/P4INT_P4PI

## WHY
This is an SDN implementation of P4 INT-MD for bmv2 in mininet.
This project is ongoing until hopefuly July 2023 as part of my thesis "SECURITY FOR SDN ENVIRONMENTS WITH P4" to be also available publicly.
The code is mostly not original and you may find most of it in the repositories of:
- https://github.com/lifengfan13/P4-INT
- https://github.com/GEANT-DataPlaneProgramming/int-platforms
- https://github.com/mandaryoshi/p4-int. You may also check the Mandar Joshi's thesis "Implementation and evaluation of INT in P4" here https://www.diva-portal.org/smash/get/diva2:1609265/FULLTEXT01.pdf.

## INTRODUCTION

SDN with P4 brings a new set of possibilities as the way the packets are processed is not defined by the vendor, but rather by the P4 program. Using this language, developers can define data plane behavior, specifying how switches shall process the packets. P4 lets developers define which headers a switch shall parse, how tables match on each header, and which actions the switch shall perform on each header. This new programmability extends the capabilities of the data plane into security features, such as stateful packet inspection and filtering, thus relieving the control plane. This offloading of security is enhanced by the ability to run at line speed as P4 runs on the programmed devices.

## TOPOLOGY
As a away to mimic a standard topology in a data center, we have chosen the leaf-and-spine architecture as described in the figure.
![Scenario in Mininet](/pictures/int_scenario4_INT_MD.png)

In this scenario,the INT flow can be described in the following steps:
1. Source data: one host, e.g. client h1 or h3, sends some data to a server, h2, through a P4 network.
2. INT source: if the data sent from the clients matches the pre-programmed watchlist, then the switch, s1 or s5, adds the INT header and payload to this
packet.
3. INT transit. The transit switches, s2 or s4, add their INT info to the same packet.
4. INT sink. The sink switch, s3, also adds its INT info to the same packet, but then strips all info and sends the original data to the server, h2. The INT information, of the 3 servers, is encapsulated in a UDP packet towards the INT collector.




## HOW TO USE


### 

...
Run the P4 code as follows
```
$SDE/run_switchd.sh -p int_md_2_1
```


### Requirements

### Collection of reports

### Visualization

## Testing
