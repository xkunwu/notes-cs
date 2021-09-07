---
---
### Disk usage summary

```sh
du -smhc *
```

### Find disk & mount

```sh
lsblk
sudo mount disk_loc mount_loc
```

### ls directory with large list of file

```sh
ls -U | more
```

### Restart kwin when the KDE desktop hangs

```sh
DISPLAY=:0 kwin --replace
```

### monitor GPU usage in 1s intervals and highlights differences

```sh
watch -d -n 0.5 nvidia-smi
```
