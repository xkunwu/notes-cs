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

### 禁止设备唤醒电脑

打开带有管理员权限的 `powershell` 窗口：`Win + x, a`

- 哪些设备可以唤醒电脑：`powercfg /devicequery wake_armed`
- 禁止该设备唤醒电脑：`powercfg /devicedisablewake "设备名"`
- 禁用掉所有的设备唤醒：`powercfg /devicequery wake_armed | ForEach{ powercfg /devicedisablewake $_ }`
