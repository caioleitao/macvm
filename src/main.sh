#!/bin/sh
vmdir="/Volumes/Nebula/VirtualMachines"
vmname=$2

createvm (){
    qemu-img -t raw create $vmdir/$vmname/$vmname.raw $storagegb

	qemu-system-aarch64 \
         -machine virt,accel=hvf,highmem=off \
         -cpu cortex-a72 -smp 4 -m 4G \
         -device intel-hda -device hda-output \
         -device qemu-xhci \
         -device virtio-gpu-gl-pci \
         -device usb-kbd \
         -device virtio-net-pci,netdev=net \
         -device virtio-mouse-pci \
         -display cocoa,gl=es \
         -netdev user,id=net,ipv6=off \
         -drive "if=pflash,format=raw,file=$vmdir/$vmname/edk2-aarch64-code.fd,readonly=on" \
         -drive "if=pflash,format=raw,file=$vmdir/$vmname/edk2-arm-vars.fd,discard=on" \
         -drive "if=virtio,format=raw,file=$vmdir/$vmname/$vmname.raw,discard=on" \	
	 -cdrom $4 -boot d
}

launchvm (){
	qemu-system-aarch64 \
         -machine virt,accel=hvf,highmem=off \
         -cpu cortex-a72 -smp 4 -m 4G \
         -device intel-hda -device hda-output \
         -device qemu-xhci \
         -device virtio-gpu-gl-pci \
         -device usb-kbd \
         -device virtio-net-pci,netdev=net \
         -device virtio-mouse-pci \
         -display cocoa,gl=es \
         -netdev user,id=net,ipv6=off \
         -drive "if=pflash,format=raw,file=$vmdir/$vmname/edk2-aarch64-code.fd,readonly=on" \
         -drive "if=pflash,format=raw,file=$vmdir/$vmname/edk2-arm-vars.fd,discard=on" \
         -drive "if=virtio,format=raw,file=$vmdir/$vmname/$vmname.raw,discard=on" \	
}

case $1 in
	launch)
		echo "Launch $vmname Virtual Machine"
        launchvm
        ;;
	create|cdrom|storage)
		echo "Creating $vmname Virtual Machine..."
        createvm
        ;;
	list)
		echo "All Virtual Machines existent in $vmdir\n"
        ls $vmdir 
        echo "\n"
        ;;
	help)
        echo "\nMacVM is a cli tool for manage Virtual Machines for Apple Silicon\n"
		echo "launch             open a existent virtual machine"
        echo "create             create a virtual machine"
        echo "list               list all existent virtual machines\n"
        echo "                   for each command you can add help for search more options"
        echo "\n"
        ;;
    *)
        echo "Invalid Command"
        ;;
esac


