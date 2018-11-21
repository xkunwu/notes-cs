#!/bin/bash

set -e

pre_id=$(ps aux | grep 'ssh -N -f ' | awk '/palau$/{print $0}' | tee /dev/tty | awk '{print $2}')

printf "\n"
read -p "reconnect? y/[n] >" -n 1 -r
printf "\n"

if [[ $REPLY =~ ^[Yy]$ ]]; then
    printf "closing processes: $pre_id ... "
    for id in $pre_id; do
        kill -9 $id
    done
    printf "done.\n"
    ssh -N -f \
        -L 5901:localhost:5901 \
        -L 5902:localhost:5902 \
        -L 8888:localhost:8888 \
        palau
    printf "tunnel established.\n"
fi
