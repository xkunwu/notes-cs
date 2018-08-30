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
### Server setup
landscape-common
