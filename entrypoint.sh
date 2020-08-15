#!/usr/bin/env sh
if $6 == "true"; then
    rocketchat-notification -u "$1" -p "$2" -m "$3" -s "$4" -c "$5" -code
else
    rocketchat-notification -u "$1" -p "$2" -m "$3" -s "$4" -c "$5"
fi
