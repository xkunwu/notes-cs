---
---
### Using gdb

- load the module:

```sh
$ python -m pdb file.py
```

- launch through terminal

```sh
$ gdb
(gdb) file python
Reading symbols from python...done.
(gdb) run file.py -arg
```

### Inline breakpoint triggering

```sh
# import pdb; pdb.set_trace()
```
