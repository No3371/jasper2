---
layout: post
title: "如何優化複雜的編輯器介面"
tags: unity optimization
published: true
language: tw
other_language_versions: en/2021-04-28-optimize-drawing-lots-of-control-in-unity-editor
---

## IMGUI 立刻繪製

I've personally not yet tried the new UI System (UIElement), still sticking with the old IMGUI. Immediate Mode GUI, as its name implies, means the GUI get drawn immediately by CPU along with the GUI code statements get executed.

This means if you have a loop that loops through and draw 1000 items, it draws all 1000 items every frame, synchronously.

Things like this happens: You are checking out a project that worked by others, you opened some random foldout, and boom! It turns out 200 references fields are packed into that tiny foldout! It's a trap! Unity start freezing every seconds because it's trying to draw all the GUI controls every frame, and you start trying hard to click that damn foldout again so you can hide all those GUI controls to stop Unity from freezing.

Take a tool I found on Github today as example. It's a logcat viewer that help us read adb logcat output easily. While any program can easily accept and store thousands of log strings, the author decided that it can only show 200 items at once. And I have a simple explanation for that: It can't, without being painful to use.

## 可見元件

When creating editor tools we often need to display a lot of GUI controls, for example, a complex panel composed of a lot of functional components, or simply a selection panel that shows a lot of options.

It's important to have this in mind at the early design phase: It's not all controls always needs to be drawn.

In this post I'll take a simple scrollview as example.

![](..\assets\2021-04-28-optimize-drawing-lots-of-control-in-unity-editor\visibility.png)

The above figure shows 3 types of blocks in the content block, which filled with different colors. Green means it's a control that is fully visible, Yellow means it's partially visible, Red means it's totally invisble.

Scrollview is like a window, and the actual content *slides* through the window. We can very easily predict if a control is visible if we know the size&position of the scrollview rect and all the controls.