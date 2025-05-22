# Proxmox setup instructions

In order to support iGPU mapping, perform the following steps on your Proxmox hosts:

If AMD:
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&iommu=pt amd_iommu=full_flush pcie_acs_override=downstream,multifunction /' /etc/default/grub
update-grub

If Intel:
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&intel_iommu=on iommu=pt /' /etc/default/grub
update-grub

Prevent the Proxmox host from reserving the GPU before VMs can use it:
If AMD:
echo -e "blacklist amdgpu\nblacklist radeon" > /etc/modprobe.d/blacklist-amdgpu.conf

If Intel:
echo "blacklist i915" >> /etc/modprobe.d/blacklist.conf

Perform lspci -nn | egrep -i "VGA|Audio"
Record the PCI address of the output. For example: [1002:1681], [1002:1640]
Run the following command, setting "ids=" to the outputs from above
echo "options vfio-pci ids=1002:1681,1002:1640" > /etc/modprobe.d/vfio.conf

update-initramfs -u -k all
reboot

verify the commands work:
dmesg | grep -Ei "IOMMU|vfio-pci"

Go into Proxmox GUI > Datacenter > Resource mappings > Map each GPU PCI address to "iGPU"
