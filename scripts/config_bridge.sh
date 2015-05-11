#!/bin/bash
eth=`cat /etc/network/interfaces | grep "auto eth" | cut -d ' ' -f 2`
sed -i "s/iface $eth inet dhcp/iface $eth inet manual/g" /etc/network/interfaces
grep -q "auto br0" /etc/network/interfaces && echo 'bridge br0 already present' || cat <<EOF | sudo tee -a /etc/network/interfaces

auto br0
iface br0 inet dhcp
        bridge_ports $eth
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
EOF
ifup br0

