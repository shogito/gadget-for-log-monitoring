#!/bin/bash

MONITORED="grateful.log"
DEST="target.log"


write_log() {
   while true
   do
       echo "$(date) some message" >> ${MONITORED}
       sleep 10
   done
}

write_log &
tail -F ${DEST}
