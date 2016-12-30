Rebase
======

Reapplies commits on top of another base tip.

Common syntax: `git rebase <upstream [<branch>]` which specifies the "base" branch first on which the current branch (or the branch specified by <branch>) is applied.

Where the current branch is "topic", `git rebase master` and `git rebase master topic` are equivalent.

###--onto option

Without this option, the --onto base is the tip of the upstream branch.  

Merge vs. Rebase
=================

Pros of Rebase:
* cleaner, linear history that can be traced to project inception
* no merge commits polluting the history

Cons of Rebase:
* Doesn't tell you when upstream features were merged, which could affect your feature
* Rebase modifies the history, so you can lose information
* Have to remember the golden rule of rebasing, which is never do it on public branches since it will modify the history and the everyone will see that branch appeared to have completely changed and diverged.

###Fast-foward vs. Non-fast-foward Merge

When you pull an upstream branch, if the upstream branch hadn't been changed, your merge can just be rebased.  This is essentially the same as a rebase.  Your commits will be applied to the tip of the upstream branch and no merge commit will be added.  Consider the pros and cons of merge vs. rebase before doing a fast-foward merge.  In general, people use non-ff because they can pin-point the branch/pull request.


Stash
=====

Save your current work into a changeset.

Tagging
=======

`git tag -a "<tag name>" -m "<message>"`
 
For example:

`git tag v1.0.0 -m "Release 1"`

Then push the tags to the remote server

`git push origin --tags`

Reset
=====

Reset will actually modify the history and brings HEAD to the specified commit.

Syntax: `git reset [<mode>] [<commit>]`

Ex: HEAD becomes d0cb69

`git reset d0cb69`

Three reset modes:

1. soft - all changes between now and the specified commit are staged to be commited and the HEAD is brought to the specified commit.
2. mixed - all changes between now and the specified commit are marked as modified and are not staged to be commited.  HEAD is brought to the specified commit
3. hard - any committed and uncommited changes after the specified commit are removed and your HEAD now points to the specified commit. 

Revert
======

Revert will modify your files to make it identical to a different version

Example: Can revert multiple unrelated commits in a single command.

`git revert 0b810a eca5cd`

Cherry-pick
============

`git cherry-pick <commit>...`

Example that commits the two commits specified: `git cherry-pick 1c480cae 8de553a0eb`

-m option allows you to specify a parent number.  If the `cherry-pick`ed commit is a merge, then the command doesn't know which parent to use as the mainline in order to replay (or not replay) the changes.

Archive
=======

Creates a bbpack/standalone package of a revision or a subset of its files.

Example: `git archive --format zip --output ./dbsetupfiles.zip HEAD~3:./db/`

Roughly equivalent: `git archive --format zip --output ./dbsetupfiles.zip HEAD~3 ./db/`

The former just has the files within db, but the latter has the db directory including the files within db.

Bisect
======

Commands for finding binary searching for  a checkin that broke your feature.

Squash
======

Squash is not a git command, but you can do it in several ways:

1. Do a soft reset (`git reset --soft <rev>;`) which will stage your changes since the specified rev and make it ready for you to commit as a single unit. 
2. Do a `git rebase -i` which allows you to interactively choose which changes to pick and squash.
3. `git merge --squash` 

Log
====

Show
====

Tips
=====

### Commit Amend - Amends to the previous commit

Amend option replaces the tip of the current branch with a new commit that will use the same parents and author as the current HEAD's. It adds most recent changes as well as gives you the ability to modify the commit message: `git commit --amend`

### Bash auto-complete for git commands:

`curl http://git.io/vfhol > ~/.git-completion.bash && echo '[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash' >> ~/.bashrc`

Then source it: `. ~/.bashrc`

###Interactive staging tool

`git add -i`

###Interactive committing
`git commit --interactive` Note: -i is not for interactive mode

Strange Syntax
===============

### ^ (caret)

^ (caret) means the parent/previous revision

`HEAD^1` is the revision prior to HEAD.  It is also the equivalent of HEAD~1.

`HEAD^2` is the first commit of the merged branch, IF HEAD is a merge commit. This is called the **second parent**

### ~ (tilde) 

~ (tilde) means the parent/previous revision of the commit.  Similar to ^ but it doesn't trace merged branches.

```
G   H   I   J
 \ /     \ /
  D   E   F
   \  |  / \
    \ | /   |
     \|/    |
      B     C
       \   /
        \ /
         A
A =      = A^0
B = A^   = A^1     = A~1
C = A^2  = A^2
D = A^^  = A^1^1   = A~2
E = B^2  = A^^2
F = B^3  = A^^3
G = A^^^ = A^1^1^1 = A~3
H = D^2  = B^^2    = A^^^2  = A~2^2
I = F^   = B^3^    = A^^3^
J = F^2  = B^3^2   = A^^3^2
```

Git Vocabulary
==============

###Tree-ish

"Tree-ish" is a term that refers to any identifier (as specified in the Git revisions documentation) that ultimately leads to a (sub)directory tree (Git refers to directories as "trees" and "tree objects").

Basically it can be a file or folder (folders are files in linux) of a particular revision. It can also be a revision because a revision is simply the version of the root directory tree.

```
----------------------------------------------------------------------
| Commit-ish AND Tree-ish   |                Examples
----------------------------------------------------------------------
|  1. <sha1>                | dae86e1950b1277e545cee180551750029cfe735
|  2. <describeOutput>      | v1.7.4.2-679-g3bee7fb
|  3. <refname>             | master, heads/master, refs/heads/master
|  4. <refname>@{<date>}    | master@{yesterday}, HEAD@{5 minutes ago}
|  5. <refname>@{<n>}       | master@{1}
|  6. @{<n>}                | @{1}
|  7. @{-<n>}               | @{-1}
|  8. <refname>@{upstream}  | master@{upstream}, @{u}
|  9. <rev>^                | HEAD^, v1.5.1^0
| 10. <rev>~<n>             | master~3
| 11. <rev>^{<type>}        | v0.99.8^{commit}
| 12. <rev>^{}              | v0.99.8^{}
| 13. <rev>^{/<text>}       | HEAD^{/fix nasty bug}
| 14. :/<text>              | :/fix nasty bug
----------------------------------------------------------------------
|       Tree-ish only       |                Examples
----------------------------------------------------------------------
| 15. <rev>:<path>          | HEAD:README, :README, master:./README
----------------------------------------------------------------------
|         Tree-ish?         |                Examples
----------------------------------------------------------------------
| 16. :<n>:<path>           | :0:README, :README
----------------------------------------------------------------------
```

###Blob

This just refers to a file, even text files.


###Upstream Downstream

Upstream is where other features go and will eventually propagate down to your branch when you pull.  The other features flow downstream to you.  Your feature branch is the downstream branch because your changes don't affect anything upstream.


###Squash

Combines (squashes) multiple commits into one.  Very useful when you create temporary commits and commit on top of it and you want to make things cleaner by reducing to a single commit.


