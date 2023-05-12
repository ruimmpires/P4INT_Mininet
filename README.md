# P4INT_Mininet
SDN P4 INT deployed in Mininet and security analysis
You can find a similar version running in P4PI, i.e. P4 for RaspBerry PI in https://github.com/ruimmpires/P4INT_P4PI

## WHY
This is an SDN implementation of P4 INT-MD for bmv2 in mininet.
This project is ongoing until hopefuly July 2023 as part of my thesis "SECURITY FOR SDN ENVIRONMENTS WITH P4" to be also available publicly.
The code is mostly not original and you may find most of it in the following repositories:
- https://github.com/lifengfan13/P4-INT
- https://github.com/GEANT-DataPlaneProgramming/int-platforms
- https://github.com/mandaryoshi/p4-int. You may also check the Mandar Joshi's thesis "Implementation and evaluation of INT in P4" here https://www.diva-portal.org/smash/get/diva2:1609265/FULLTEXT01.pdf.
- https://github.com/p4lang/p4pi/blob/master/packages/p4pi-examples/bmv2/arp_icmp/arp_icmp.p4

## INTRODUCTION

SDN with P4 brings a new set of possibilities as the way the packets are processed is not defined by the vendor, but rather by the P4 program. Using this language, developers can define data plane behavior, specifying how switches shall process the packets. P4 lets developers define which headers a switch shall parse, how tables match on each header, and which actions the switch shall perform on each header. This new programmability extends the capabilities of the data plane into security features, such as stateful packet inspection and filtering, thus relieving the control plane. This offloading of security is enhanced by the ability to run at line speed as P4 runs on the programmed devices.

## TOPOLOGY
As a away to mimic a standard topology in a data center, we have chosen the leaf-and-spine architecture as described in the figure.
![Scenario in Mininet](/pictures/int_scenario4_INT_MD.png)

In this scenario,the INT flow can be described in the following steps:
1. Source data: one host, e.g. client h1 or h3, sends some data to a server, h2, through a P4 network.
2. INT source: if the data sent from the clients matches the pre-programmed watchlist, then the switch, s1 or s5, adds the INT header and payload to this packet.
3. INT transit. The transit switches, s2 or s4, add their INT info to the same packet.
4. INT sink. The sink switch, s3, also adds its INT info to the same packet, but then strips all info and sends the original data to the server, h2. The INT information, of the 3 servers, is encapsulated in a UDP packet towards the INT collector.




## 

## HOW TO USE


### QUICK SETUP
You may disregard everything above and quickly start this mininet environment.
### Requirements
Tested in a VMWare virtualized Ubuntu 20.04LTS with 35GB of storage, 16GB of RAM and 8vCPUs. Probably any Debian system should support.
sudo apt install bridge-utils
**Install Influxdb:**
1. Install influxdb with https://docs.influxdata.com/influxdb/v1.8/introduction/install/
2. create the int databases
```
~$ influx
Connected to http://localhost:8086 version 1.8.10
InfluxDB shell version: 1.8.10
> show databases
name: databases
name
----
_internal
> create database int with duration 24h
> use int
Using database int
> show measurements
```
note: after having successfully generated INT stats and uploaded to the int database, you may check with:
```
~$ influx
Connected to http://localhost:8086 version 1.8.10
InfluxDB shell version: 1.8.10
> use int
> show measurements
name: measurements
name
----
flow_latency
link_latency
queue_occupancy
switch_latency
> select * from flow_latency
name: flow_latency
time                dst_ip   dst_port protocol src_ip   src_port value
----                ------   -------- -------- ------   -------- -----
1683387986735098368 10.0.3.2 80       17       10.0.1.1 57347    3666
```
4. ...
5. ...
**Install Graphana**
1. Install Graphana with https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/#install-from-apt-repository
2. 
### Steps
1. clone this repository to your machine or VM
2. change directory to the new P4INT_Mininet folder
3. type ```make run```
4. in the mininet CLI interface type mininet> ```xterm h1 h2 h3```
5. in another terminal window, start the collector with ```sudo python3 receive/collector_influxdb.py``` 
6. in the h2 type ```./receive/h2.sh``` which simulates a server listening to HTTP, HTTPS and PostgreSQL
7. in the h1 type ```./send/h1.sh```  which sends traffic from h1 and creates INT statistics
8. in the h3 type ```./send/h3.sh```  which sends traffic from h3 and creates INT statistics
9. 



### Requirements

### Collection of reports

### Visualization
If you have access to the FCTUC/DEI VPN or are locally connected, you may see the stas here http://10.254.0.171:3000/d/V8Ss1QY4k/int-statistics?orgId=1&refresh=1m&from=now-15m&to=now with the credentials readonly/readonly.

## Testing
