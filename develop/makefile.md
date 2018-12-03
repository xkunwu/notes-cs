---
---
### Tips for writing shell scripts within makefiles

-   Escape the script's use of $ by replacing with $$
-   Convert the script to work as a single line by inserting ; between commands
-   If you want to write the script on multiple lines, escape end-of-line with \
-   Optionally start with set -e to match make's provision to abort on sub-command failure
-   This is totally optional, but you could bracket the script with () or {} to emphasize the cohesiveness of a multiple line sequence -- that this is not a typical makefile command sequence

Here's an example inspired by the OP:
```
mytarget:
    { \
    set -e ;\
    msg="header:" ;\
    for i in $$(seq 1 3) ; do msg="$$msg pre_$${i}_post" ; done ;\
    msg="$$msg :footer" ;\
    echo msg=$$msg ;\
    }
```

### System wide C++ change on Ubuntu:
Clang produces better error messages
GCC has much better and more complete support for C++11 features
```
sudo update-alternatives --config c++
```
