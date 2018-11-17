### feed password (INSECURE!)
```
sudo apt-get install sshpass
export SSHPASS='my_pass_here'
sshpass -e ssh server command
```

### X-server authority problem
-   check the ownership of .Xauthority and remove .Xauthority-*
-   or use of xauth -b to break any lock files that may be hanging around


### start Cygwin/X
```
XWin :0 -multiwindow -clipboard -silent-dup-error
DISPLAY=:0.0 ssh -X palau
DISPLAY=:0.0 ssh -f -X palau xterm
```

### x11vnc
sudo apt install xfce4 xfce4-goodies tightvncserver
sudo apt install tightvnc-java

ssh -N -f -L 5901:localhost:5901 palau
vncviewer localhost:1
vncviewer palau:1

### To display open ports and established TCP connections:
```
netstat -vatn
```

### change line ending recursively

```
find . -type f -print0 | xargs -0 dos2unix
```

### Mount remote file system over ssh:

```
sshfs user@domain:/remote/directory/ /local/directory/
fusermount -u /local/directory/
```

Example:

```
sudo mkdir /mnt/linbath

sudo sshfs -o allow_other xw943@linux.bath.ac.uk:/u/q/xw943/ /mnt/linbath/

sudo umount /mnt/linbath
```

Permanently mounting the remote file system:

```
sudo vim /etc/fstab

sshfs#xw943@linux.bath.ac.uk:/u/q/xw943/ /mnt/linbath
```

---

### Scp from remote server:

```
ssh ${1:-sipadan} 'rm -rf /tmp/calibre && mkdir /tmp/calibre && find $HOME/calibre/ -name "*.epub" -mtime -'${2:-1}' -type f -exec echo {} ; -exec cp {} /tmp/calibre ;' && scp -p ${1:-sipadan}:/tmp/calibre/*.epub ./
```

### Collect files and sync up to Baidu cloud server:

```
find /home/xwu/calibre/calibre -name "*.epub" -type f -exec echo {} \; -exec mv {} /home/xwu/calibre/bysync \; && /home/xwu/anaconda2/bin/bypy -v syncup /home/xwu/calibre/bysync/ calibre/
```

### Schedule a tast and redirect log:

```
crontab -e

10 20 * * * /home/xwu/calibre/.bysync.sh>> /var/log/cronlog 2>&1
```

---

### Syncronize with remote server:

```
rsync -avh -e ssh --exclude=.git --exclude=.rsync-proj.sh ./ ${1:-sipadan}:projects/${PWD##*/}
```

### Wget remote directory:

```
wget -r --no-parent --no-host-directories
```

---

### Public Key Authentication
-   Create files and set the permissions correctly (*both* side):
mkdir ~/.ssh/
chmod 0700 ~/.ssh/

-   Create a key pair (*client* side).
ssh-keygen -t ed25519 -f ~/.ssh/palau_key

-   Transfer *only* the public key to remote machine.
scp ~/.ssh/palau_key.pub palau:.ssh/

-   Add the new public key to the authorized_keys file (*server* side)
touch ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
cat ~/.ssh/palau_key.pub >> ~/.ssh/authorized_keys

-   Test the keys
ssh -i ~/.ssh/palau_key palau

-   Associating Keys Permanently with a Server ()
# ~/.ssh/config
Host palau
	IdentityFile ${HOME}/.ssh/palau_key

-   Add Identity until next restart
ssh-add ~/.ssh/keyfile
ssh-add -l

### Server setup to show info at login
landscape-common


---
### What is the difference between .bash_profile and .bashrc?
.bash_profile is executed for login shells, while .bashrc is executed for interactive non-login shells.

When you login (type username and password) via console, either sitting at the machine, or remotely via ssh: .bash_profile is executed to configure your shell before the initial command prompt.

But, if you’ve already logged into your machine and open a new terminal window (xterm) then .bashrc is executed before the window command prompt. .bashrc is also run when you start a new bash instance by typing /bin/bash in a terminal.
