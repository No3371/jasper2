---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: UTF-8 And UTF-16
date: 2020-07-31 18:27:00
tags: [Idea]
class: post-template
subclass: 'post'
author: No3371
lang: en
---

## Role
A identity with predefind set of permissions.

## Permission
One has to have corresponding permission to perform an action.

## Role x permission
`role:edit:[role]` x `perm:assign:[perm]`.

Master
- perms
    - role:edit:any
- perms_control
    - message:send (can give/takeaway message:send to role it can edit)
    - message:attachment

Default
- perms
    - message:send

When Master wants to give `message:attachment` to Default, he needs control over `message:attachment`.
This also applies to perm removal, the Master needs control over `message:send` to remove `message:send` from other roles.

By default, `master` has "*" perms and the system will not allow modifying perms of `master`.