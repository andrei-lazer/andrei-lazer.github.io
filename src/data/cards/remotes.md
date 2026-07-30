---
title: Remotes
---
One local git repo can have multiple remotes. These are essentially version of the repo in other places. A repo stored on GitHub is a good example of a remote repo. 

# Facts

- `origin` is the default name of the remote server you clone the repo from.

# Commands

- `git remote` shows your remotes.
- `git remote show <remote>` shows information about a specific remote.
- `git remote add <shortname> <url>` adds the remote repo at `<url>` as a remote with the nickname `<shortname>`
- `git fetch <shortname|url>` fetches new data from the remote. It doesn't make any changes to your local repo, it just updates git with what the remote repo looks like
- `git pull` attempts to merge the remote with the local
- `git push <remote> <branch>` pushes the local branch called `<branch>` to the remote server called `<remote>`.
