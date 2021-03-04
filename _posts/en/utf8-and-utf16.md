---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: UTF-8 And UTF-16
date: 2020-07-31 18:27:00
tags: [Knowledege]
class: post-template
subclass: 'post'
author: No3371
lang: en
---

## UTF-8 (RFC3629)
- The first 128 characters (US-ASCII) need one byte.
- The next 1,920 characters need two bytes to encode, which covers the remainder of almost all Latin-script alphabets, and also Greek, Cyrillic, Coptic, Armenian, Hebrew, Arabic, Syriac, Thaana and N'Ko alphabets, as well as Combining Diacritical Marks.
- Three bytes are needed for characters in the rest of the Basic Multilingual Plane, which contains virtually all characters in common use,[19] including most Chinese, Japanese and Korean characters.
- Four bytes are needed for characters in the other planes of Unicode, which include less common CJK characters, various historic scripts, mathematical symbols, and emoji (pictographic symbols). 

## UTF-16
- Could be LE or BE.
- U+0000~U+FFFF: Basic Multilingual Plane. (2 bytes)
- U+10000~U+10FFFF: Supplementary Planes. (4 bytes)

## BOM
Endian info placed ahead of a byte stream to indicate the endian of this stream.