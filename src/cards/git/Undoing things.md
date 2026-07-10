- `git commit --amend` adds a patch to a commit. Can be viewed in things like gerrit which supports microcommits, but usually just modifies a previous commit. Should be used when you forget stuff, not for large changes.

# reset and restore 
In older versions of Git, `git reset` is used for two very common undo operations.
- `git reset HEAD <file>` unstages a file. No changes are made to the file, this is just in Git.
- `git checkout -- <file>` discards changes made to _unstaged_ files since the last commit. This is a destructive operation that cannot be undone.

In newer versions of Git, `git restore` replaces both of these functionalities.
- `git restore --staged <file>` unstages a file.
- `git restore <file>` discards changes made to unstaged files since the last commit.