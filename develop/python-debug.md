---
---
### Using gdb
-   load the module:
```
$ python -m pdb file.py
```
-   launch through terminal
```
$ gdb
(gdb) file python
Reading symbols from python...done.
(gdb) run file.py -arg
```

### Inline breakpoint triggering
```
# import pdb; pdb.set_trace()
```
