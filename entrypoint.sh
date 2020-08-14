#!/usr/bin/env bash
echo $1 $2 $3 $4 $5
rocketchat-notification -u $1 -p $2 -m $3 -s $4 -c $5
