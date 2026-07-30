---
title: Tags
---
Tags are used to mark certain commits. Usually used for versioning. By default, these are not pushed when you run `git push`. To push a specific tag, run `git push <remote> <tag-name>`. To push all tags, run `git push --tags`.

# Lightweight tags
These are basically just a pointer to a commit. They store a commit checksum.

# Annotated tags
These are full objects in Git. They contain a checksum, tagger name/email, date, message, and can be tagged with GNU Privacy Guard [[GPG]]. These are the recommended tags to use most of the time.



# Commands
- `git tag` lists all tags
- `git tag -l <filter>` lists tags containing `<filter>`. Useful for looking for subversions.
- `git tag <tag-name>` creates a lightweight tag.
- `git tag -a <tag-name> -m <message>` creates an _annotated_ tag `<tag-name>` with message `<message>` at the current commit.
- `git tag -a <tag-name> <commit-hash> ...` creates an annotated tag at the commit whose has is/starts with `<commit-hash>`
- `git show <tag-name>` shows the tag message (if annotated) along with the commit it was tagged to.
- `git push <remote> <tag-name>` pushes a specific tag
- `git push --tags`  pushes all tags
- `git tag -d <tag-name>` deletes a tag locally
- `git push --delete <tag-name>` deletes the tag name on the remote.
