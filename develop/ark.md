---
---
### Prepare
```
echo '--pager=less -RFX' >> ~/.ackrc
```

### Simple Searching
```
files that ack cares about
ack -f | wc -l

word boundaries
ack -w 
```

### Analyzing Search Focus
```
return only the count of matching lines
ack -c 

single number of lines
ack -ch
```

### Modifying the Search Output
```
only return numbers for files where the match was found
ack -cl 

see the column
ack -w --column

see above/below/both
ack -w --python -A 2
ack -w --python -B 5 
ack -w --python -C 3

just print the files that have matches
ack -f --python

specify a pattern for the file/directory structure
ack -g log --cc
```

### Working with File Types
```
ack --help-types

modify a type categorization
echo "--type-add=css:ext:sass,less" >> ~/.ackrc

match the file name
echo "--type-set=example:is:example.txt" >> ~/.ackrc

define matches with normal regular expressions
echo "--type-set=bashcnf:match:/.bash(rc|_profile)/" >> ~/.ackrc
```
