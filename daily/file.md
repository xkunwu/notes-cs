---
---
### Bash variable manipulation
```
Delete the shortest match of string in $var from the beginning:
${var#string}
Delete the longest match of string in $var from the beginning:
${var##string}
Delete the shortest match of string in $var from the end:
${var%string}
Delete the longest match of string in $var from the end:
${var%%string}
example:
${PWD##*/}
${var*.zip}
```

### Add file header to each of the files
```
find . -type f -name "*.md" -exec sed -i '1s/^/---\n---\n/' {} \;
find . -regextype posix-extended -regex ".*\.py($|\..*)" -type f -exec sed -i '1 e cat HEADER' {} \;
```

### This prints the file count per directory for the current directory level:
```
find . -maxdepth 1 -type d -print0 | while read -d '' -r dir; do num=$(find "$dir" -ls | wc -l); printf "%5d files in directory %s\n" "$num" "$dir"; done | sort -rn -k1
```
Or just simply output file count:
```
find . -type f | wc -l
```

### Count all the lines of code in a directory recursively
```
find . \( -name '*.py' -o -name '*.h' -o -name '*.cpp' \) | xargs wc -l
```

### Copy & Paste
```
# cp - force overwrite without confirmation prompt:
yes | cp -rf
# cp - skip existing files
cp -n
# recursively move a tree:
cp -al source/* dest/ && rm -r source/*
```

### To recursively give proper privileges:
Note: '+' means arguments to a single command, in contrast to ';' which means run command separately.
```
find . -type d -exec chmod 755 {} \+
find . -type f -exec chmod 644 {} \+
find . -type f -name "*.sh" -exec chmod +x {} \+
```

### Recursively rename file extension:
```
find . -name '*.PNG' -exec rename -v 's/\.PNG$/\.png/i' {} \;
```

