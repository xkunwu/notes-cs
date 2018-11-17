#!/bin/bash

ps aux | grep 'ssh -N -f ' | awk '/palau$/{print $0}'

printf "\n"
read -p "reconnect? y/[n] >" -n 1 -r
printf "\n"

if [[ $REPLY =~ ^[Yy]$ ]]; then
    ssh -N -f \
        -L 5901:localhost:5901 \
        -L 5902:localhost:5902 \
        -L 8888:localhost:8888 \
        palau
fi
