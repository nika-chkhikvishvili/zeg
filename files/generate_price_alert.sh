#!/bin/sh
# Price alert yml generator for prometheus alert
# By Nika Chkhikvishvili - 2019




filename="/etc/prometheus/price_alert.yml"

# set static header:
echo "groups:
- name: price
  rules:
">$filename

for coin in $(curl -s localhost:8080 | sed -e 's/#.*$//'   -e '/^$/d'  |awk '{print $1}') 
  do 
    echo "# Fire alert if $coin value changes for $10 (up or down) for the last 1h
  - alert: $coin:min5m
    expr: (max_over_time($coin[1h])) - (min_over_time($coin[1h])) > 10
    for: 10s">>$filename

done
