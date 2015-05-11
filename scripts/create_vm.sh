#!/bin/bash
NAME=$1
RAM_MB=$((2*1024))
DISK_GB=10
VCPUS=2
qemu-img create -f raw /var/lib/libvirt/images/$NAME.img 10G
virt-install                            \
        --connect qemu:///system        \
        --virt-type kvm                 \
        --os-type linux                 \
        --os-varian virtio26            \
        --boot network                  \
        --name $NAME                    \
        --ram $RAM_MB                   \
        --disk path=/var/lib/libvirt/images/$NAME.img,format=raw,size=$DISK_GB      \
        --pxe                           \
        --network bridge=br0            \
        --vcpus $VCPUS                  \
        --graphics vnc                  \
        --noautoconsole                 \
        --hvm
