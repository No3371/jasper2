---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: Git Tips
date: 2020-07-31 18:27:00
tags: [Knowledege]
class: post-template
subclass: 'post'
author: No3371
lang: en
---

Everytime a commit happended, HEAD moves to the commit.

A commit could have more then one parent (e.g. merge).

`HEAD^` is s shorthand for `Head^1` means the parent commit of HEAD commit.

For a commit with only one parent, `rev~` and `rev^` means same thing.

Here is an illustration, by Jon Loeliger. Both commit nodes B and C are parents of commit node A. Parent commits are ordered left-to-right.
~~~
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
C = A^2
D = A^^  = A^1^1   = A~2
E = B^2  = A^^2
F = B^3  = A^^3
G = A^^^ = A^1^1^1 = A~3
H = D^2  = B^^2    = A^^^2  = A~2^2
I = F^   = B^3^    = A^^3^
J = F^2  = B^3^2   = A^^3^2
~~~