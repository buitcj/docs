Git Workflows
=============
[https://www.atlassian.com/git/tutorials/comparing-workflows](Workflows - Atlassian)

###Centralized Workflow

Central repository is shared by all.  All devs commit to the master branch.  Pushing is done on top of the origin master HEAD, so pulling the latest code is necessary before the push.  Pulling with rebase is preferred here because this is a *linear* history model.

###Feature Branch Workflow

Development occurs in a dedicated feature branch and devs should never commit directly into the master branch.  Developers push committed changes to a feature branch and then making a pull request with a code review to merge the feature branch into master. 

###Gitflow workflow

This is like the Feature Branch Workflow but dedicates roles to different branches for preparing, maintaining, and recording releases.

The master branch stores release history and is meant to be tagged.

The develop branch is an integration branch for feature branches;

A feature branch is to work on a specific feature and is merged into feature - never directly to master.

A release branch is used when all your features are completing.  This branch is meant for polishing and bug fixes that occur to make your product ready for release.  Upon release, the branch is merged back into master and tagged.  This allows a team to focus on fixes and polishing while another team works on features for the next release.

A hotfix branch branches from master and is meant to fix bugs in production code.  This branch is made to quickly patch things and get the fix to the customer.  Fixes get merged back into master and develop.

###Forking workflow
TODO

Rebase
======

"Reapplies commits on top of another base tip" - git documentation.  Phrased another way: it "is the process of taking a fragment of git change history and rewriting that history as if it had begun at a different commit."  In short, it lets you move around commits and even change the history.

Common syntax: `git rebase upstream [branch]` which specifies the "base" branch first on which the current branch (or the branch specified by <branch>) is applied.

Where the current branch is "topic", `git rebase master` and `git rebase master topic` are equivalent.

###`--onto <newbase>` option

Without this option, the --onto newbase is the tip of the upstream branch. 

In the git man page, it is called `--onto <newbase>` but you can think of it as `--onto <graft-point>`.  Matthew brett renames the syntax: `git rebase [--onto <graft-point>] <exclude-from> <include-from>`.  If you don't specify a `<graft-point>` it defaults to the `<exclude-from>`

###Which commits will rebase apply? 

Everything from `<exclude-from>` to `<include-from>`

###Common Usecase #1: Checking in code to the upstream branch

If you want to push your changes remotely but the remote branch has changed, git won't let you push, effectively saying that your branch's HEAD is not up-to-date. 

```
Ex: X -- A (Remote Master)
      \
       B (Local Master)

> git push origin master
To https://github.com/buitcj/rebase_on_checkin.git
 ! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs to 'https://github.com/buitcj/rebase_on_checkin.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```

If you pushed your branch (X and B) then you'd lose branch history since you'd be erasing A. You need to fetch the new history by doing a merge or a rebase.  By running `git rebase master` git would effectively move your changes onto the tip of the remote Master's HEAD like so:

```
Ex: X -- A -- B 
```

###Common Usecase #2: Cleaning up history

I want to combine two non-consecutive local commits to clean up the history before making commits public:

`git rebase -i <upstream branch/commit>`

Delete a commit by using the `drop` keyword

Merge a commit by using `squash` or `fixup` to merge it into the previous commit.

###Common Usecase #3: Adding to something that you already committed but didn't push to the public branch.

Can use `git rebase -i` to squash.


Merge vs. Rebase
=================

Pros of Rebase:
* cleaner, linear history that can be traced to project inception
* no merge commits polluting the history
* other tools can make better use of the linear history (e.g., `git bisect`)

Cons of Rebase:
* Doesn't tell you when upstream features were merged, which could affect your feature
* Upstream branch doesnt know which branch the changes came from or when the changes entered the upstream branch.
* Rebase modifies the history, so you can lose information
* Have to remember the golden rule of rebasing, which is never do it on public branches since it will modify the history and the everyone will see that branch appeared to have completely changed and diverged.

###Fast-foward vs. Non-fast-foward Merge

When you pull or push an upstream branch, if the upstream branch hadn't been changed (i.e., there's nothing between its HEAD and your first commit), then your merge can just be rebased.  This is essentially the same as a rebase.  Your commits will be applied to the tip of the upstream branch and no merge commit will be added.  Consider the pros and cons of merge vs. rebase before doing a fast-foward merge.  In general, people use non-ff because they can pin-point the branch/pull request.


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

Syntax: `git reset [--<mode>] [<commit>]`

Ex: You want commit d0cb69 to be the HEAD of your branch.

`git reset d0cb69`

Three reset modes:

1. soft - all changes between now and the specified commit are staged to be commited and the HEAD is brought to the specified commit.
2. mixed - all changes between now and the specified commit are marked as modified and are not staged to be commited.  HEAD is brought to the specified commit
3. hard - any committed and uncommited changes after the specified commit are removed and your HEAD now points to the specified commit. 

Revert
======

Revert will modify your files to make it identical to a different version.

Example: Can revert multiple unrelated commits in a single command.

`git revert 0b810a eca5cd`

Cherry-pick
============

`git cherry-pick <commit>...`

Example that commits the two commits specified: `git cherry-pick 1c480cae 8de553a0eb`

-m option allows you to specify a parent number.  If the `cherry-pick`ed commit is a merge, then the command doesn't know which parent to use as the mainline in order to replay (or not replay) the changes.

Archive
=======

Creates a standalone package (like a bbpack) of a revision or a subset of its files.

Example: `git archive --format zip --output ./dbsetupfiles.zip HEAD~3:./db/`

Roughly equivalent: `git archive --format zip --output ./dbsetupfiles.zip HEAD~3 ./db/`

The former just has the files within db, but the latter has the db directory including the files within db.

Bisect
======

Commands for finding binary searching for a checkin that broke your feature. At each step it bisects the remaining search space for you and you have to tell it whether the commit is good or bad, when talking about correctness or functionality.  For finding when something was introduced, you can also use the syntax "new" and "old". Specify the last known good and bad points to narrow down its search window for faster searching.

```
jbu@jbot:~/git_jbu/rebase_test$ git bisect start
jbu@jbot:~/git_jbu/rebase_test$ git bisect bad
jbu@jbot:~/git_jbu/rebase_test$ git bisect next
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[8d25e2813c54afca4946bd2ba724112f7d1a5bec] 5
jbu@jbot:~/git_jbu/rebase_test$ ./test.sh 
false
jbu@jbot:~/git_jbu/rebase_test$ git bisect bad
jbu@jbot:~/git_jbu/rebase_test$ git bisect next
Bisecting: 2 revisions left to test after this (roughly 1 step)
[b88ac5cd3805abce9d81cdd1ca54321ac0d902e5] 2
jbu@jbot:~/git_jbu/rebase_test$ ./test.sh 
true
jbu@jbot:~/git_jbu/rebase_test$ git bisect good
Bisecting: 0 revisions left to test after this (roughly 1 step)
[bd948a402226300b789ed8a2f1cfcc122846ac8d] 4
jbu@jbot:~/git_jbu/rebase_test$ ./test.sh 
false
jbu@jbot:~/git_jbu/rebase_test$ git bisect bad
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[563e7a286d111c54a14462b74951a112c1969326] 3
jbu@jbot:~/git_jbu/rebase_test$ ./test.sh 
false
jbu@jbot:~/git_jbu/rebase_test$ git bisect bad
563e7a286d111c54a14462b74951a112c1969326 is the first bad commit
commit 563e7a286d111c54a14462b74951a112c1969326
Author: buitcj <julianbui@gmail.com>
Date:   Fri Dec 30 22:47:20 2016 +0700

    3

:100755 100755 f44a70ddab941428ae9df026356ac30db8c05cfd 7abed58a41496afcbe73f0a737493e3066a68ce2 M	test.sh
jbu@jbot:~/git_jbu/rebase_test$ git bisect reset
Previous HEAD position was 563e7a2... 3
Switched to branch 'master'
Your branch is up-to-date with 'origin/master'.

```

Squash
======

Squash is not a git command - it is just the action of combining multiple commits.  You can do it in several ways:

1. Do a soft reset (`git reset --soft <rev>;`) which will stage your changes since the specified rev and make it ready for you to commit as a single unit. 
2. Do a `git rebase -i` which allows you to interactively choose which changes to pick and squash.
3. `git merge --squash` //TODO: expand
4. `git commit --amend` amends the previous commit with currently staged files.

Data Recovery
=============

Pre-requisites: Read about the content-addressable filesystem that git implements and also read about `git reflog`.

Every commit is stored in the .git directory and only cleaned up periodically by running `git gc` automatically for the user which garbage collects.  Likely you can always find the data you thought you lost by finding the missing commit and referencing it with a new branch.  

###Find a missing commit

You can find a missing/lost/deleted commit in one of two ways:

####1. Reflog

Use `git reflog` which tells you the history of where your HEAD was pointing.  Point your HEAD to the commit that was previously reachable.  Now you will see all the commits that were reachable from that HEAD in the log.

####2. Find dangling commits.

Use the `git fsck --full` command which shows all objects that aren't pointed to by another object.  Find the commit object and point a branch HEAD to it.

```
$ git fsck --full
Checking object directories: 100% (256/256), done.
Checking objects: 100% (18/18), done.
dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293
```

###Find a missing staged file

If a file was added but not committed, don't worry.  This file was also saved by git into the .git/index directory.

```
> echo "important, don't delete" > ./test.txt
> git add -i // add the test.txt
> git reset --hard
> git log // shows no test.txt
> git fsck --lost-found
notice: HEAD points to an unborn branch (master)
Checking object directories: 100% (256/256), done.
notice: No default references
dangling blob 634f2a4b6d3eb45cb771756cac113f920f3393e0
missing tree 4b825dc642cb6eb9a060e54bf8d69288fbee4904
> git cat-file -p 634f2a
important, don't delete
> cat ./.git/lost-found/other/634f2a4b6d3eb45cb771756cac113f920f3393e0 
important, don't delete
```

Navigating the content-addressable filesystem
==============================================

The plumbing commands can be used to view objects in .git/objects.  They also allow you to view files from other branches in your local git repo.

###Traversing the file system

Dereference a specific branch until a tree (root) is found.

```
jbu@ubuntu:~/git_jbu/docs$ git cat-file -p master^{tree}
040000 tree c9c134b29d3cbc9e9cd3bcd7660e3e87ef328cd2    academic
040000 tree f7d273d172689c7b14cf57e2b537a23fe3b21a10    notes
040000 tree 8113accd6dbc8ce65247395f352ca6a898c8e7b0    presentations
```

We found some more trees which are just (sub)directories.  Now let's see what's in one of those.

```
jbu@ubuntu:~/git_jbu/docs$ git cat-file -p f7d273d172689c7b14cf57e2b537a23fe3b21a10
100644 blob edd3d1bada1e134f3842edad50f19e5dffef93f5    AlgorithmNotes.pdf
100644 blob 5496e509b59abe3d7fea7c4a9dc8c73b2f96128a    git_notes.md
```

Now we've encountered blobs, which are just files.  We can view what's in a file using the same command.

```
jbu@ubuntu:~/git_jbu/docs$ git cat-file -p 5496e509b59abe3d7fea7c4a9dc8c73b2f96128a
```

This prints out the file.

We can also repeat the commands for different branches.  Github and bitbucket likely use these plumbing commands to quickly show you what's in those branches without having to check out each branch every time you navigate to a different branch.

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

###Staging tips

Issue: `git add .` is quite overkill and can actually get you in trouble because you blindly add everything.

`git add -i` interactively adds files by letting you choose which modified files to stage.

`git add -p` adds in patch mode which allows you to review each of your changes.

###Interactive committing
`git commit --interactive` Note: -i is not for interactive mode

###Visual UI tools

Difftool: `git difftool HEAD --tool=winmerge --no-prompt`

Merge tool: `git mergetool --tool=meld`


###Command line visualization

`git log --oneline --decorate --all --graph` shows all the local branches in pretty printed format

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

###SHA-1 hash

Commands requiring a commit can be specified by the SHA-1 of the commit: `git show a5bec062afe1348b8317651c93cf5049e6b4e55e`

You can also use the partial SHA-1 hash, provided that the partial hash can uniquely identify your commit: `git show a5bec`

###Double dot (..)

Specifies a range of commits.  "Resolve a range of commits that are reachable from one commit but aren't reachable from another".

```
Ex: A - B - E - F (Master)
         \
          C - D (Experiment)
```

`git log master..experiment` returns D and C, as they are the commits reachable from Experiment but not from Master

`git log experiment..master` returns F and E, as they are the commits reachable from Master but not from Experiment.

Useful command: 

`git log origin/master..HEAD` will show you the commits in your local repo but not on the remote master.

###Triple dot (...)

"Specifies all the commits that are reachable by either of two references but not by both of them"

In the previous example, `git log master...experiment` would return F E D C as this is the not the set of commits that both references can reach.

###Ordinal (@{n})

`git reflog` shows the history of how your HEAD was affected recently.  

```
$ git reflog
734713b HEAD@{0}: commit: fixed refs handling, added gc auto, updated
d921970 HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
1c002dd HEAD@{2}: commit: added some blame and merge stuff
1c36188 HEAD@{3}: rebase -i (squash): updating HEAD
95df984 HEAD@{4}: commit: # This is a combination of two commits.
1c36188 HEAD@{5}: rebase -i (squash): updating HEAD
7e05da5 HEAD@{6}: rebase -i (pick): updating HEAD
```

`git show HEAD@{5}` specifies a shortname of the HEAD 5 changes ago.

You can also specify times like `master@{yesterday}` and `master@{1.week.ago}`

###^@

###^!


Git Vocabulary
==============

###Tree-ish

"Tree-ish" is a term that refers to any identifier (as specified in the Git revisions documentation) that ultimately leads to a (sub)directory tree (Git refers to directories as "trees" and "tree objects").

Basically it can be a file or folder (folders are files in linux) of a particular revision. It can also be a revision because a revision is simply the version of the root directory tree.

```
------------------------------------------------------------------------------------------------
| Commit-ish AND Tree-ish   |                Examples                 |           Notes
------------------------------------------------------------------------------------------------
|  1. <sha1>                | dae86e1950b1277e545cee180551750029cfe735|
|  2. <describeOutput>      | v1.7.4.2-679-g3bee7fb                   | Output from git describe
|  3. <refname>             | master, heads/master, refs/heads/master | Symbolic ref name - can be tag or commit object 
|  4. <refname>@{<date>}    | master@{yesterday}, HEAD@{5 minutes ago}| 
|  5. <refname>@{<n>}       | master@{1}                              | Ordinal specification - ordinal prior to that ref
|  6. @{<n>}                | @{1}                                    | Ordinal specification - nth prior entry in git reflog
|  7. @{-<n>}               | @{-1}                                   | nth branch/commit checkout out before the current one
|  8. <refname>@{upstream}  | master@{upstream}, @{u}                 | The branch that the branch specified by refname is set to build on top of.
|  9. <rev>^                | HEAD^, v1.5.1^0                         | ^ and ^0 mean the first parent (previous revision commit)
| 10. <rev>~<n>             | master~3                                | Nth generation ancestor, only following first parents
| 11. <rev>^{<type>}        | v0.99.8^{commit}                        | Dereference <rev> until object of type is found.  Can be tree, commit, tag, object.
| 12. <rev>^{}              | v0.99.8^{}                              | <rev> could be a tag, so deference the tag until a non-tag is found
| 13. <rev>^{/<text>}       | HEAD^{/fix nasty bug}                   | Finds the earliest commit reachable from <rev> whose commit message matches <text>
| 14. :/<text>              | :/fix nasty bug                         | Finds the commit whose commit message matches <text>
----------------------------------------------------------------------|------------------------- 
|       Tree-ish only       |                Examples                 |           Notes
------------------------------------------------------------------------------------------------
| 15. <rev>:<path>          | HEAD:README, :README, master:./README   | Finds the blob or tree specified as a path relative to the tree-ish object specified by <rev>
------------------------------------------------------------------------------------------------
|         Tree-ish?         |                Examples                 |           Notes
------------------------------------------------------------------------------------------------
| 16. :<n>:<path>           | :0:README, :README                      | Stage notation - 1=CommonAncestor, 2=TargetBranch'sVersion, 3=version from the branch which is being merged
------------------------------------------------------------------------------------------------
```

Any identifier leading to a commit object is also a (sub)directory tree object - i.e. the root directory of the commit. Stated another way, every commit-ish identifier is also a tree-ish identifier.

###Blob

This just refers to a file, even text files.

###Tree

Any (sub) directory in the project.

###Upstream Downstream

Upstream is where other features go and will eventually propagate down to your branch when you pull.  The other features flow downstream to you.  Your feature branch is the downstream branch because your changes don't affect anything upstream.


###Squash

Combines (squashes) multiple commits into one.  Very useful when you create temporary commits and commit on top of it and you want to make things cleaner by reducing to a single commit.

###Porcelain and Plumbing

Plumbing refers to the bare pipe.  Porcelain refers to the toilet that is used on top of the bare pipe.  In other words, git plumbing commands are low level commands not meant for most users; in the bathroom nobody uses the bare pipe directly.  Instead, most git users should use porcelain commands meant for normal usage like the toilet instead of the pipe.

####Example plumbing commands

`git hash-object`

`git ls-tree`

`git rev-parse`

`git write-tree`

`git update-index`

###Detached Head

Your branch will be in a detached head if you checkout a reference object that that is not a tag or the HEAD of any branch. `git checkout HEAD^1` will likely put yourself into a detached HEAD state, assuming that your previous commit is not the HEAD of a branch or a tag.

Basics
=======

`git branch -a` lists all branches, remote and local
`git branch -r` lists all branches on the remote

Good Reading
============

[Git content-addressable filesystem](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects)

[Git revision specification](https://www.kernel.org/pub/software/scm/git/docs/gitrevisions.html)

[Git maintenance and data recovery](https://git-scm.com/book/en/v2/Git-Internals-Maintenance-and-Data-Recovery)

[Viewing tree objects](http://alblue.bandlem.com/2011/08/git-tip-of-week-trees.html)

[Really good git internals](https://www.youtube.com/watch?v=ig5E8CcdM9g)

Git Internals
==============

HEAD (typically) points to a branch.  Branches are just pointers to commits.

```
jbu@ubuntu:~/git_jbu/docs$ cat ./.git/HEAD
ref: refs/heads/master

jbu@ubuntu:~/git_jbu/docs$ cat ./.git/refs/heads/master
6b8bbd1a0a7132cb1b24c5d850b43e169e096172

jbu@ubuntu:~/git_jbu/docs$ git checkout -b feature
Switched to a new branch 'feature'

jbu@ubuntu:~/git_jbu/docs$ cat ./.git/HEAD
ref: refs/heads/feature

jbu@ubuntu:~/git_jbu/docs$ cat ./.git/refs/heads/feature
6b8bbd1a0a7132cb1b24c5d850b43e169e096172

jbu@ubuntu:~/git_jbu/docs$ git commit -m "newfile"
[feature 57b35d2] newfile
 1 file changed, 1 insertion(+)
 create mode 100644 newfile.txt

jbu@ubuntu:~/git_jbu/docs$ cat ./.git/refs/heads/feature
57b35d2c3b5b267730a24689253dc12f2f3c4f53
```

What does a commit look like? It references a tree, a parent commit, and has commit details like author, committer, and commit message.  It hashes to a value.  Therefore even the commit message changes, the commit has to rehash.

```
jbu@ubuntu:~/git_jbu/docs$ git cat-file -p  57b35
tree 3eb7b7babbd2ec19a92c3e0578159aac71e7670c
parent 6b8bbd1a0a7132cb1b24c5d850b43e169e096172
author julianbui <julian.bui@ntq-solution.com.vn> 1483922969 +0700
committer julianbui <julian.bui@ntq-solution.com.vn> 1483922969 +0700

newfile
```

###Demo

`watch -n 1 tree -a`

Must default objects to view
A change in a blob will change the hashes.  Hash changes propogate to the top level tree and then to the commit.  
If I share my branch with someone, they ought to have some of the objects already so they don't have to go fetch it again.
You can actually create a file in .git/refs/heads/<some new branch name> and paste a commit hash, and you'll create a new branch

play with `git show --pretty=raw HEAD`

`git reflog` is like a history so you can go back if you screw up your history

branches are nothing more than commits with names

