---
---

### References

- [RegexOne](https://regexone.com/)

### Match first, or "non-greedy match"

```
[ ! -f $(targ_dir) ] && [ -f $(srce_dir) ]
\$\((.*)\)  #--> $(targ_dir) ] && [ -f $(srce_dir)
\$\((.*?)\)  #--> $(targ_dir)
```
