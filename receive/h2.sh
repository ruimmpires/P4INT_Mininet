#!/bin/bash
while true; do nc -ul -p 80; done &
echo listening on port on port 80
while true; do nc -ul -p 443; done &
echo listening on port on port 443
while true; do nc -ul -p 5432; done &
echo listening on port on port 5432
