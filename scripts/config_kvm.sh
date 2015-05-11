#!/bin/bash
#Install libvirt and virt-inst packages
apt-get update
apt-get -y install qemu-kvm libvirt-bin bridge-utils
apt-get -y install virtinst

#Configure bridge
./config_bridge.sh

#Confire SSH access for remote virt VM management
grep -q "^PermitRootLogin without-password" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && restart ssh
grep -q "^StrictModes yes" /etc/ssh/sshd_config && sed -i "s/^StrictModes yes/#StrictModes yes/g" /etc/ssh/sshd_config && restart ssh
grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config && sed -i "s/^PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config && restart ssh

hname=`hostname`

./create_vm.sh $hname-vm001
