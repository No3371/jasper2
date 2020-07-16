---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: 初見 Ruby
date: 2020-07-16 18:39:00
tags: [Coding]
class: post-template
subclass: 'post'
author: No3371
lang: zh_TW
---

在建立這個 Blog 的過程中，先是第一次使用 Jekyll, Travis，接著就是第一次摸到 Ruby 這個語言。 

個人習慣在任何程式相關的情境使用英文，例如寫文章、寫註解，這就導致了一個小麻煩，當我要分享我的文章面相台灣社群公開時，總覺得要寫個中文版才行。因此，在摸索了一下 Jekyll，找到喜歡的主題後，我就開始琢磨怎麼讓這個 Blog 能夠提供多個語言的內容。

我試了 [jekyll-multilanguage-plugin]()，後來發現怎麼樣都搞不定，又轉向 [polylgot]()，東摸西摸浪費了不少時間後還算順利，但遇上了一個不滿意的點：我想要在每篇文章中顯示「這篇文章提供什麼語言」，但沒找到自然又簡單的方法。

古人有云：
> Coder 遇到問題怎麼辦？當然是自己寫！
於是我開始動歪腦筋，看看能不能自己實現這個需求......首先我要搞懂 polyglot 是怎麼運作的。

Jekyll 是一個 ruby 專案，polyglot 作為一個 Jekyll 插件也是以 ruby 編寫，為了