---
---
### Rule of Thumb

- Create a Git repository for every new project.
- Create a new branch for every new feature.
- Use Pull Requests to merge code to Master.

### task/issue branching

```sh
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

```sh
git remote add origin git_site
git branch --set-upstream-to=origin/master master
git pull --allow-unrelated-histories
git push
```

### Recover the file permissions

```sh
git diff -p -R --no-color \
    | grep -E "^(diff|(old|new) mode)" --color=never  \
    | git apply

git config --global --add alias.permission-reset '!git diff -p -R --no-color | grep -E "^(diff|(old|new) mode)" --color=never | git apply'
git permission-reset
```

### Compare HEAD with the previous commit

```sh
# note: @ is a alias for HEAD
# note: ~ and ^ are the same when only going one commit back
# note: comparison to HEAD is default
# note: Two dots is the default in git diff
# note: Diff with three dots shows the differences starting at the last *common* commit
git diff HEAD^ HEAD
git diff @~1..@
git show
git diff commit_id
```

### Discard unstaged changes

```sh
git checkout -- .
```

### Ignore file mode change (especially in Windows)

Checkout as-is, commit Unix-style
Note: umask might be different

```sh
git config --global core.fileMode false
# on Windows:
git config --global core.autocrlf true
# on Linux or OS X:
git config --global core.autocrlf input
```

### Patching

If you haven't yet committed the changes, then:

```sh
git diff > mypatch.patch
```

But sometimes it happens that part of the stuff you're doing are new files that are untracked and won't be in your git diff output. So, one way to do a patch is to stage everything for a new commit (but don't do the commit), and then:

```sh
git diff --cached > mypatch.patch
```

Add the 'binary' option if you want to add binary files to the patch (e.g. mp3 files):

```sh
git diff --cached --binary > mypatch.patch
```

You can later apply the patch:

```sh
git apply mypatch.patch
```

### Update a GitHub forked repository

Note that 'fetch' means without 'merge' (as in 'pull').

```sh
git remote add upstream remote_git
git fetch upstream
git checkout master
git rebase upstream/master
```

### Setting your Git username

```sh
git config --global user.name "xkunwu"
git config user.name "xw943"
```

### Permanently authenticating with Git repositories

```sh
git config credential.helper store
```

### Submodule

Add submodule (new version of git will init automatically:

```sh
git submodule add -b master https://github.com/xkunwu/notes-cs.git notes/notes-cs
git submodule update --remote
```

Update (2-way):

```sh
git submodule update --remote --merge
git submodule update --remote --rebase
```

Push:

```sh
git push --recurse-submodules=on-demand
```

### stage, add, stash

- “git stage” is an alias for “git add”: it is the step before making a commit.
- "git stash" will move your modified files into a stack: normally used for switching branches (for working on something else).
  - git stash pop: removes the changes from your stash.
  - git stash apply: keep the changes in your stash.

### [How to make a fork of public repository private?](https://stackoverflow.com/questions/10065526/github-how-to-make-a-fork-of-public-repository-private)

First, duplicate the repo as others said (details [here](https://help.github.com/articles/duplicating-a-repository/)):

Create a new repo (let's call it `private-repo`) via the [Github UI](https://github.com/new). Then:

```sh
git clone --bare https://github.com/exampleuser/public-repo.git
cd public-repo.git
git push --mirror https://github.com/yourname/private-repo.git
cd ..
rm -rf public-repo.git
```

Clone the private repo so you can work on it:

```sh
git clone https://github.com/yourname/private-repo.git
cd private-repo
make some changes
git commit
git push origin master
```

To pull new hotness from the public repo:

```sh
cd private-repo
git remote add public https://github.com/exampleuser/public-repo.git
git pull public master # Creates a merge commit
git push origin master
```

Awesome, your private repo now has the latest code from the public repo plus your changes.

Finally, to create a pull request private repo -> public repo:

Use the GitHub UI to create a fork of the public repo (the small "Fork" button at the top right of the public repo page). Then:

```sh
git clone https://github.com/yourname/the-fork.git
cd the-fork
git remote add private_repo_yourname https://github.com/yourname/private-repo.git
git checkout -b pull_request_yourname
git pull private_repo_yourname master
git push origin pull_request_yourname
```

Now you can create a pull request via the Github UI for public-repo, as described [here](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request-from-a-fork).

Once project owners review your pull request, they can merge it.

Of course the whole process can be repeated (just leave out the steps where you add remotes).
