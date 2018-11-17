#!/bin/bash

sudo openvpn --config "$(find ~/Documents/ -name "xw943_*.ovpn")"
#sudo openvpn --config "$(find ~/Documents/ -name "xw943_*.ovpn")" --daemon

#read -n1 -s -r -p "Press any key to continue ..."
#printf "\n"
#
#tunnel2palau.sh

