---
---
### Disk usage summary
```
du -smhc *
```

### Find disk & mount
```
lsblk
sudo mount disk_loc mount_loc
```

### ls directory with large list of file
```
ls -U | more
```

### Restart kwin when the KDE desktop hangs
```
DISPLAY=:0 kwin --replace
```

### monitor GPU usage in 1s intervals and highlights differences
```
watch -d -n 0.5 nvidia-smi
```