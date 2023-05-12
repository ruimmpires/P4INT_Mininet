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
You may also look into the official INT code available in the [p4 official repository for INT](https://github.com/p4lang/p4factory/tree/master/apps/int)


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

This scenario can thus be split in the following parts:
1. simulate an INT platform;
2. demonstrate the collection of INT statistics;
3. rogue host attacks;
4. detection and protection against a rogue host.

This network is simulated in mininet. Search here for more information in the [Mininet waltk trhough](http://mininet.org/walkthrough/)

## SIMULATE INT PLATFORM
This platform must create INT statistics and send those to the collector. In this scenario, if the data sent by h1 matches the watch list, then there will be some INT statistics generated and sent to h4.
As part of the scenario, the h2 server is simulating 3 services: PostgreSQL, HTTPS and HTTP. So, the switches s1 and s5 are pre-configured as INT source and also pre-configured the match list for source and destination IPs and l4 ports: 5432 for PostgreSQL, 443 for HTTPS and 80 for HTTP.
### Packet source
NT packets are only generated if a specific packet matches the watchlist. So, we used the scapy library within a python script to craft the packets. This is a simple script that takes as input parameters the destination IP, the l4 protocol UDP/TCP, the destination port number, an optional message and the number of packets sent. Additionally, we included a command to simulate recurrent accesses to the server, e.g., every 5 seconds access to HTTPS, from the h1 and h3 hosts’ CLI:
```watch -n 5 python3 send.py --ip 10.0.3.2 -l4 udp --port 443 --m INTH1 --c 1```
You can find ready-made scripts for h1 and h3 in [h1 to h2](send/h1.sh) and [h3 to h4](send/h1.sh)
### Packet forwarding
The L3 forwarding tables are pre-established in the switches with MAT using Longest Prefix Match (LPM). So the hosts h1, h2 and h3 are pre-registered in each switch’s MAT as e,g, for s2:
```
table_add l3_forward.ipv4_lpm ipv4_forward 10.0.1.1/32 => 00:00:0a:00:01:01 1
table_add l3_forward.ipv4_lpm ipv4_forward 10.0.3.2/32 => 00:00:0a:00:03:02 2
table_add l3_forward.ipv4_lpm ipv4_forward 10.0.5.3/32 => 00:00:0a:00:05:03 3
```
The hosts h4 and h5 are not required to have routing.
These MATs are already done:
* [table for s1](tables/s1-commands.txt)
* [table for s2](tables/s2-commands.txt)
* [table for s3](tables/s3-commands.txt)
* [table for s4](tables/s4-commands.txt)
* [table for s5](tables/s5-commands.txt)
### INT source
The INT source switch must identify the flows via its watchlist. When there is a match, the switch adds the INT header and its INT data accordingly. In this lab, the source switches are s1 and s5. The code below is the configuration of switch s1, which defines the switch ID, the INT domain and the matchlist.
```
//set up ipv4_lpm table
table_add l3_forward.ipv4_lpm ipv4_forward 10.0.1.1/32 => 00:00:0a:00:01:01 1
table_add l3_forward.ipv4_lpm ipv4_forward 10.0.3.2/32 => 00:00:0a:00:03:02 2
table_add l3_forward.ipv4_lpm ipv4_forward 10.0.5.3/32 => 00:00:0a:00:05:03 3
//set up switch ID
table_set_default process_int_transit.tb_int_insert init_metadata 1
//set up process_int_source_sink
table_add process_int_source_sink.tb_set_source int_set_source 1 =>
//matchlist h1 to h2, PostGreSQL 5432 Hex1538
table_add process_int_source.tb_int_source int_source \
10.0.1.1&&&0xFFFFFFFF 10.0.3.2&&&0xFFFFFFFF 0x00&&&0x00 0x1538&&&0xFFFF\
=> 11 10 0xF 0xF 10
```
The last line includes:
• source-ip, source-port, destination-ip, destination-port defines 4-tuple flow which will be monitored using INT functionality;
• int-max-hops - how many INT nodes can add their INT node metadata to packets of this flow;
• int-hop-metadata-len - INT metadata words are added by a single INT node;
• int-hop-instruction-cnt - how many INT headers must be added by a single INT node;
• int-instruction-bitmap - instruction mask defining which information (INT headers types) must added to the packet;
• table-entry-priority - general priority of entry in match table (not related to INT)

## HOW TO USE


### QUICK SETUP
You may disregard everything above and quickly start this mininet environment.
#### Pre-requisites
Tested in a VMWare virtualized Ubuntu 20.04LTS with 35GB of storage, 16GB of RAM and 8vCPUs. Probably any Debian system should support.
sudo apt install bridge-utils
#### Install Influxdb
1. Install influxdb with https://docs.influxdata.com/influxdb/v1.8/introduction/install/
2. create the int database
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
No measurements are there yet. These will be created when the data is uploaded.
#### Install Graphana
Install Graphana with https://grafana.com/docs/grafana/latest/setup-grafana/installation/debian/#install-from-apt-repository

### Steps
1. clone this repository to your machine or VM
2. change directory to the new P4INT_Mininet folder
3. type ```make run```
4. in the mininet CLI interface type mininet> ```xterm h1 h2 h3```
5. in another terminal window, start the collector with ```sudo python3 receive/collector_influxdb.py``` 
6. in the h2 type ```./receive/h2.sh``` which simulates a server listening to HTTP, HTTPS and PostgreSQL
7. in the h1 type ```./send/h1.sh```  which sends traffic from h1 and creates INT statistics
8. in the h3 type ```./send/h3.sh```  which sends traffic from h3 and creates INT statistics

#### Check InfluxDB
After having successfully generated INT stats and uploaded to the int database, you may check with:
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
You may also check the logs with ```sudo journalctl -u influxdb.service | grep “POST /write”```

#### Add the InfluxDB datasource
1.  In the Graphana web interface, usually ```localhost:3000/```, go to Configuration > Data sources, select InfluxDB and use the default ```http://localhost:8086```
2.  Select the database int
3.  Test and all is ok, you will see the message ![Scenario in Mininet](/pictures/graphana_influx_datasource_success.png)




### 



### Requirements

### Collection of reports

### Visualization
If you have access to the FCTUC/DEI VPN or are locally connected, you may see the stas here http://10.254.0.171:3000/d/V8Ss1QY4k/int-statistics?orgId=1&refresh=1m&from=now-15m&to=now with the credentials readonly/readonly.

## Testing
