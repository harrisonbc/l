#!/bin/bash

VMID=9000
# BASEDIR=/root/build
BASEDIR=$(pwd)

RAM=4096
CPUS=4
DISK=20 # GB

# RELEASE=noble   
# RELEASE=jammy   
RELEASE=mantic   

CLOUDIMG=$RELEASE-server-cloudimg-amd64.img
CLOUDURL=https://cloud-images.ubuntu.com/$RELEASE/current/$CLOUDIMG

CLOUDINIT=$BASEDIR/cloudinit-user-data.yaml

T_NAME=$RELEASE
VMID=$RELEASE

T_NAME=Ubuntu-$RELEASE

echo "ceate_vm_$RELEASE.sh started..."

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

virt-install --virt-type kvm --name $VMID --ram $RAM --disk=size=$DISK,backing_store=$BASEDIR/$CLOUDIMG,format=img --network network=default --graphics vnc,listen=0.0.0.0,keymap=local --noautoconsole --os-variant=ubuntu$RELEASE --import --cloud-init user-data=$BASEDIR/$CLOUDINIT 


#virt-customize -a $CLOUDIMG --install qemu-guest-agent
#virt-customize -a $CLOUDIMG --run-command "useradd -m -s /bin/bash sles"
#virt-customize -a $CLOUDIMG --root-password password:"#Munchkin58509166"
#virt-customize -a $CLOUDIMG --ssh-inject sles:file:$BASEDIR/ssh_key.txt 
#virt-customize -a $CLOUDIMG --copy-in $BASEDIR/local-ca.crt:/etc/pki/trust/anchors
#virt-customize -a $CLOUDIMG --run-command "update-ca-certificates"
#virt-customize -a $CLOUDIMG --run-command "SUSEConnect -e brynn.harrison@suse.com -r INTERNAL-USE-ONLY-cfd0-393f"
#virt-customize -a $CLOUDIMG --run-command "zypper -n in iptables"
#virt-customize -a $CLOUDIMG --run-command "localectl set-keymap gb"


#qm create $VMID --memory 2048 --net0 virtio,bridge=vmbr1 --scsihw virtio-scsi-pci --name $T_NAME

#qm set $VMID --scsi0 $STORE:0,import-from=$BASEDIR/$CLOUDIMG
#qm set $VMID --ide2 $STORE:cloudinit
#qm set $VMID --boot order=scsi0
#qm set $VMID --serial0 socket --vga serial0
#qm set $VMID -agent 1
#qm set $VMID --ipconfig0 ip=dhcp,ip6=dhcp

#qm template $VMID

#rm $BASEDIR/$CLOUDIMG

echo "create_vm_$VMID completed."
