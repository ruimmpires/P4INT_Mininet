#!/bin/bash
watch -n 150 python3 send/send.py --ip 10.0.3.2 --l4 udp --port 80 --m INTH3 --c 1 &
echo H3 sending packets to H2 on port 80
watch -n 20 python3 send/send.py --ip 10.0.3.2 --l4 udp --port 443 --m INTH3 --c 1 &
echo H3 sending packets to H2 on port 443
watch -n 90 python3 send/send.py --ip 10.0.3.2 --l4 udp --port 5432 --m INTH3 --c 1 &
echo H3 sending packets to H2 on port 5432
