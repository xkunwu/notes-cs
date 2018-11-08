### Rule of Thumb
-   Create a Git repository for every new project.
-   Create a new branch for every new feature.
-   Use Pull Requests to merge code to Master.

### task/issue branching
```
git checkout master
git fetch origin
git checkout -b tas/iss

git remote
git branch
git push -u origin tas/iss

git checkout master
git merge tas/iss
git branch -d tas/iss
```

### Connect to remote for the first time
```
git remote add origin git_site
git branch --set-upstream-to=origin/master master
git pull --allow-unrelated-histories
git push
```

### recover the file permissions
git diff -p -R --no-color \
    | grep -E "^(diff|(old|new) mode)" --color=never  \
    | git apply

git config --global --add alias.permission-reset '!git diff -p -R --no-color | grep -E "^(diff|(old|new) mode)" --color=never | git apply'
git permission-reset

### discard unstaged changes
git checkout -- .

### Ignore file mode change (especially in Windows)
Checkout as-is, commit Unix-style
Note: umask might be different
```
git config --global core.fileMode false
git config --global core.autocrlf input
```

### patching
If you haven't yet committed the changes, then:
```
git diff > mypatch.patch
```
But sometimes it happens that part of the stuff you're doing are new files that are untracked and won't be in your git diff output. So, one way to do a patch is to stage everything for a new commit (but don't do the commit), and then:
```
git diff --cached > mypatch.patch
```
Add the 'binary' option if you want to add binary files to the patch (e.g. mp3 files):
```
git diff --cached --binary > mypatch.patch
```
You can later apply the patch:
```
git apply mypatch.patch
```

### update a GitHub forked repository
Note that 'fetch' means without 'merge' (as in 'pull').
```
git remote add upstream remote_git
git fetch upstream
git checkout master
git rebase upstream/master
```


### Setting your Git username
```
git config --global user.name "xkunwu"
git config user.name "xw943"
```

### Permanently authenticating with Git repositories
```
git config credential.helper store
```

### Tracking of Executable Bit Change
```
git config --get --local core.filemode
git config --local core.fileMode false
git config --global core.fileMode false
```

### submodule
git submodule update --recursive

### stage, add, stash
-   “git stage” is an alias for “git add”: it is the step before making a commit.
-   "git stash" will move your modified files into a stack: normally used for switching branches (for working on something else).
    -   git stash pop: removes the changes from your stash.
    -   git stash apply: keep the changes in your stash.
