#!/bin/bash
apt-get -y install qemu-kvm libvirt-bin bridge-utils
apt-get -y install virtinst
sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config
sed -i "s/StrictModes yes/#StrictModes yes/g" /etc/ssh/sshd_config
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
restart ssh
./config_bridge.sh
hname=`hostname`
./create_vm.sh $hname-vm003
