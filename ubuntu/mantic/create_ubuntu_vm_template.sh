#!/bin/bash

VMID=9002
# BASEDIR=/root/build
BASEDIR=$(pwd)

RAM=4096
CPUS=2
DISK=20

# RELEASE=noble   
# RELEASE=jammy   
RELEASE=mantic   

CLOUDIMG=$RELEASE-server-cloudimg-amd64.img
CLOUDURL=https://cloud-images.ubuntu.com/$RELEASE/current/$CLOUDIMG

CLOUDINITUD=user-data.yaml
CLOUDINITNC=network-config.yaml

T_NAME=$RELEASE
VMID=$RELEASE

T_NAME=Ubuntu-$RELEASE

echo "create_vm_$RELEASE.sh started..."

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

FILE1=$BASEDIR/$CLOUDIMG.original
#echo $FILE1
if test -f "$FILE1"; then
     echo "found img file skipping download..."
     cp $BASEDIR/$CLOUDIMG.original $BASEDIR/$CLOUDIMG
else
     echo "downloading img file..."
     cd $BASEDIR/
     wget $CLOUDURL
fi

#virt-install --virt-type kvm --name $VMID --ram $RAM --disk=size=$DISK,backing_store=$BASEDIR/$CLOUDIMG,format=qcow2 --disk path=$BASEDIR/cidata.iso,device=cdrom --network network=default --graphics vnc,listen=0.0.0.0,keymap=local --noautoconsole --os-variant=ubuntu$RELEASE --import  
#virt-install --virt-type kvm --name $VMID --ram $RAM --disk=size=$DISK,backing_store=$BASEDIR/$CLOUDIMG,format=qcow2 --network network=default --graphics vnc,listen=0.0.0.0,keymap=local --noautoconsole --os-variant=ubuntu$RELEASE --import --cloud-init user-data=$CLOUDINITUD,network-config=$CLOUDINITNC 
virt-install --virt-type kvm --name $VMID --ram $RAM --disk=size=$DISK,backing_store=$BASEDIR/$CLOUDIMG,format=qcow2 --network network=default --graphics vnc,listen=0.0.0.0,keymap=local --noautoconsole --os-variant=ubuntu$RELEASE --import --disk seed.iso,readonly=on

echo "create_vm_$VMID completed."