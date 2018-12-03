---
---
rsync -auvh -e ssh source target
    -a: equals -rlptgoD (no -H,-A,-X); archive mode
        -l: copy symlinks as symlinks
        -p: preserve permissions
        -t: preserve modification times
        -g: preserve group
        -o: preserve owner (super-user only)
        -D: preserve device files and special files
        -H: preserve hard links
        -A: preserve ACLs (implies -p)
        -X: preserve extended attributes
    -u: only update new
    -v: verbose
    -h: human readable
    -e ssh: execute ssh

if not sure, use:
    -n: dry-run without actual sync

especially, test it before using any delete option:
    --delete: delete extraneous files from dest dirs

scp is also ok, but remember to add:
    -p: preserve timestamp
