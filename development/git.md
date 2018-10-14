## Rule of Thumb
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

## Connect to remote for the first time
```
git remote add origin git_site
git branch --set-upstream-to=origin/master master
git pull --allow-unrelated-histories
git push
```

## Ignore file mode change (especially in Windows)
```
git config core.filemode false
```


## update a GitHub forked repository
Note that 'fetch' means without 'merge' (as in 'pull').
```
git remote add upstream remote_git
git fetch upstream
git checkout master
git rebase upstream/master
```


## Setting your Git username
```
git config --global user.name "xkunwu"
git config user.name "xw943"
```

## Permanently authenticating with Git repositories
```
git config credential.helper store
```

## Tracking of Executable Bit Change
```
git config --get --local core.filemode
git config --local core.fileMode false
git config --global core.fileMode false
```
