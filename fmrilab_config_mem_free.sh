#!/bin/bash

host_group="@allhosts"
hosts=`qstat -f | grep all.q | sort | awk -F@ '{print $2}' | awk '{print $1}'`

for h in $hosts
do
  MEMFREE=`qhost -F mem_total -h $h|tail -n 1|cut -d: -f3|sed -e s/total/free/`
  echo qconf -mattr exechost complex_values $MEMFREE $h
done
