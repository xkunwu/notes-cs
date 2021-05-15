---
---
## Setup
### Install
```
sudo apt update
sudo apt install vsftpd
sudo systemctl status vsftpd
```

### Config
```
sudo vim /etc/vsftpd.conf
===============================
#
listen=NO
listen_ipv6=YES

# 1. FTP Access
anonymous_enable=NO
local_enable=YES

# 2. Enabling uploads
write_enable=YES

#
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES

# 3. Chroot Jail
chroot_local_user=YES
user_sub_token=$USER
local_root=/home/$USER/ftp

# 5. Limiting User Login
userlist_enable=YES
userlist_file=/etc/vsftpd.user_list
userlist_deny=NO

#
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd

# 6. Securing Transmissions with SSL/TLS
rsa_cert_file=/etc/ssl/private/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.pem
ssl_enable=YES

# 4. Passive FTP Connections
pasv_min_port=30000
pasv_max_port=31000
===============================
sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
sudo systemctl restart vsftpd
```
### Firewall
```
sudo ufw allow 20:21/tcp
sudo ufw allow 30000:31000/tcp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable
sudo ufw status
```
### User
```
echo "xwu" | sudo tee -a /etc/vsftpd.user_list
sudo mkdir -p /home/xwu/ftp/upload
sudo chmod 550 /home/xwu/ftp
sudo chmod 750 /home/xwu/ftp/upload
sudo chown -R xwu: /home/xwu/ftp
```
### Disabling Shell Access
```
echo -e '#!/bin/sh\necho "This account is limited to FTP access only."' | sudo tee -a  /bin/ftponly
sudo chmod a+x /bin/ftponly
echo "/bin/ftponly" | sudo tee -a /etc/shells
sudo usermod ftpuser -s /bin/ftponly
```
