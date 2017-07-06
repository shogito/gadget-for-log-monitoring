#!/bin/bash
MONITORED="./grateful.log"
DEST="./target.log"

# trap
trap() {
    while read i
    do
        echo ${i} >> ${DEST}
    done
}

main() {
    if [ ! -f ${MONITORED} ]; then
        echo "${MONITORED} not exists" >&2
        exit 127
    fi
    tail -n 0 -F ${MONITORED}| trap
}

main

