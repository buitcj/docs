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

Syntax: git reset [<mode>] [<commit>]

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


Strange Syntax
===============

^ (caret) means the parent/previous revision

`HEAD^1` is the revision prior to HEAD.  It is also the equivalent of HEAD~1.

`HEAD^2` is the first commit of the merged branch, IF HEAD is a merge commit. This is called the **second parent**

~ (tilde) means the parent/previous revision of the commit.  Similar to ^ but it doesn't trace merged branches.

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

Git Vocabulary
==============

###Tree-ish

"Tree-ish" is a term that refers to any identifier (as specified in the Git revisions documentation) that ultimately leads to a (sub)directory tree (Git refers to directories as "trees" and "tree objects").

Basically it can be a file or folder (folders are files in linux) of a particular revision. It can also be a revision because a revision is simply the version of the root directory tree.

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

###Blob

This just refers to a file, even text files.






