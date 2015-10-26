#!/bin/bash
for i in /dev/da?; do 
  smartctl -A $i | awk -v drive=$i '$2 ~ /Temperature_Celsius/ { printf("Drive %s: Current %s, Highest %s\n", drive, 150 - $4, 150 - $5)}'
done
# vim: set ts=2 sw=2 tw=0 et ft=sh :
