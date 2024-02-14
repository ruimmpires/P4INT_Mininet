#!/bin/bash
watch -n 120 python3 send.py --ip 10.0.3.2 --l4 udp --port 80 --m ' INTH1 ' --c 1 &
echo H1 sending packets to H3 on port 80
watch -n 10 python3 send.py --ip 10.0.3.2 --l4 udp --port 443 --m ' INTH1 ' --c 1 &
echo H1 sending packets to H3 on port 443
watch -n 60 python3 send.py --ip 10.0.3.2 --l4 udp --port 5432 --m ' INTH1 ' --c 1 &
echo H1 sending packets to H3 on port 5432
