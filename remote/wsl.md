---
---

### Ping to Windows 10 not working if "file and printer sharing" is turned off?

Windows Firewall > Advanced Settings > Inbound Rules, enable all the rules with the following title:

- File and Printer Sharing (Echo Request - ICMPv4-In)

### SSH into WSL2

#### [Ubuntu 源](https://mirrors.ustc.edu.cn/help/ubuntu.html)

```sh
sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
```

#### OpenSSH server

```sh
sudo apt install openssh-server
sudo vim /etc/ssh/sshd_config
```

```text
Port 22
#AddressFamily any
ListenAddress 0.0.0.0
#ListenAddress ::
PasswordAuthentication yes
```

```sh
sudo service ssh --full-restart
sudo service ssh start
service ssh status
```

#### Forward port

```powershell
wsl --list
wsl hostname -I
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8231 connectaddress=(wsl hostname -I).trim() connectport=22

netsh interface portproxy show v4tov4
netsh interface portproxy reset all
```

#### Open firewall port

```powershell
netsh advfirewall firewall add rule name="Open Port 8231 for WSL2" dir=in action=allow protocol=TCP localport=8231
netsh advfirewall firewall show rule name=all | find "Open Port 8231"
```

#### WSL config script

```ps1
netsh interface portproxy reset all
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=8231 connectaddress=(wsl hostname -I).trim() connectport=22
```

##### execution of scripts is disabled on this system

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
Set-ExecutionPolicy -ExecutionPolicy Restricted
```

```powershell
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:15
Register-ScheduledJob -Trigger $trigger -FilePath C:\bin\ssh_to_wsl.ps1 -Name RouteSSHtoWSL

Register-ScheduledJob -Trigger (New-JobTrigger -AtStartup -RandomDelay 00:00:15) -FilePath C:\bin\ssh_to_wsl.ps1 -Name RouteSSHtoWSL

Get-ScheduledJob
```

#### auto-start the SSH server

```text
sudo vim /etc/wsl.conf

[boot]
command="service ssh start"
```
