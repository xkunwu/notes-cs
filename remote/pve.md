---
...

### Burn ISO into USB stick

- Use 'dd' mode.
- Enable special boot in Security of BIOS.
- Enable hardware virtualization.

### (Hardware) Passthrough

https://pve.proxmox.com/pve-docs/pve-admin-guide.html#qm_pci_passthrough

CPU

```sh
vi /etc/default/grub
####
# GRUB_CMDLINE_LINUX_DEFAULT="quiet"
### Intel
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
### AMD
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
####

update-grub
```

Modules

```sh
vi /etc/modules
####
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
####

update-initramfs -u -k all
```

### RouterOS

https://mikrotik.com/download
