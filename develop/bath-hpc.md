---
---
## the .bash_history of meeting on 12.10.2018
```
lsb_release -a
```
### require GPU
```
sinteractive --constraint=p100
module load cuda/toolkit/9.2.148
nvcc -V
nvidia-smi
sinfo --partition=batch-acc --format="%10P %.5D %.4c %.7m %7G %8f %N"
sinfo -p itd
sinfo-gres
```
### check jobs: use --test-only
```
squeue --state=PENDING | more
man sbatch
squeue --state=RUNNING
```
### patch python
```
which python
cd ~/miniconda3/bin/
ll python
module load patchelf/0.8
patchelf --print-interpreter ~/bin/python
patchelf --print-rpath ~/bin/python
patchelf --set-interpreter /apps/gnu/glibc/2.23/lib/ld-linux-x86-64.so.2 ~/bin/python
patchelf --print-interpreter ~/bin/python
patchelf --force-rpath --set-rpath \$ORIGIN/../lib:/apps/gnu/glibc/2.23/lib ~/bin/python
patchelf --print-rpath ~/bin/python
python
```
### add privatemodules
```
cat ~/.bashrc
module avail tensorflow
module show tensorflow/1.8.0
module avail 2>&1 | more
module show use.own
cd
ls
pwd
mkdir privatemodules
module load use.own
module avail
ls
cd privatemodules/
ls
mkdir
mkdir test
cd test/
module avail python
module show python/3.6
/apps/modules/compilers-langs/python/3.6
cp /apps/modules/compilers-langs/python/3.6 .
ls
vim 3.6
module avail
ls
rm 3.6
module list
bash -l
```
