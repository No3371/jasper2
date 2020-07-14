---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: The Evolution Of Value System
date: 2020-07-14 18:07:00
tags: [Getting started]
class: post-template
subclass: 'post'
author: No3371
lang: zh-TW
---

Take a look at this equation: `ATK = STR * 10`. It's simple, isn't it?

`ATK = (STR + DEX) * 5` is also simple, I have no doubt you can tell me the answer in seconds when I tell you the value of STR and DEX.

How about:

> DMG = (((ATK + BASE_ATK_MODIFIER) * ATK_MULTIPLIER + ATK_MODIFIER) * ATK_TO_DMG_RATIO + DMG_MODIFIER) * FINAL_DMG_MULTIPLIER

Looks like something that you need in a RPG game with a complete sets of potions, buffs, debuffs, etc. right? You have to do something like this when you need to calculate how much damage a character can made.
Leme try to convert this to C#:

```CSharp
float newDmg;
newDmg = atk + baseAtkModifier;
newDmg = newDmg * atkMultiplier + atkModifier;
newDmg = newDmg * atkToDmgRatio + dmgModifier;
newDmg *= finalDmgMultiplier; 
```
I have several questions for you:
- If it's a MMO, how much calculation do you need when you have 10000 players?
- When do you run this recalculation? You can cache `DMG` so you will not always recalculate it, but you have to do it when any of [`ATK`, `BASE_ATK_MODIFIER`, `ATK_MULTIPLIER`, `ATK_MODIFIER`, `ATK_TO_DMG_RATIO`, `DMG_MODIFIER`, `FINAL_DMG_MULTIPLIER`] is changed, right? How do you know that, these dependencies are changed so you have to recalculate?
- So to know when you want to push the change to `ATK`, so all values depends on it will recalculate, how do you know what values depends on it? What values to recalcualte?

Do You write:
```CSharp
atk += 10;
RecalculateDMG();
```
or 
```CSharp
atkModifier += 10;
RecalculateDMG();
```
here, there, everywhere? Right, you should improve it a bit:
```CSharp
void SetATK(float value)
{
  atk = value;
  RecalculateDMG();
}

void SetBaseAtkModifier(float value) {...}
void SetAtkMultiplier(float value) {...}
void SetAtkModifier(float value) {...}
void SetAtkToDmgRatio(float value) {...}
void SetDmgModifier(float value) {...}
void SetFinalDmgMultiplier(float value) {...}

void SetDMG(float value)
{
  dmg = value;
  RecalculateOtherStuffDependsOnDMG();
}

void RecalculateDMG()
{
  float newDmg;
  newDmg = atk + baseAtkModifier;
  newDmg = newDmg * atkMultiplier + atkModifier;
  newDmg = newDmg * atkToDmgRatio + dmgModifier;
  newDmg *= finalDmgMultiplier; 
  SetDMG(dmg);
}

void main ()
{
  SetATK(10);
  SetBaseAtkModifier(1); // From a passive skill: Base ATK + 1
  SetAtkMultiplier(2); // From a weapon have 200% power
  SetAtkModifier(10); // From ATK+ potion
  SetAtkToDmgRatio(1); // Default value
  SetDmgModifier(-100); // From a debuff that weakening you
  SetFinalDmgMultiplier(2); // From a game mode that everybody deals double damage
}
```

Some more questions to bother you:
- This is a very simple system, not enough for a RPG, how many codes you'll have to write and keep maintaining for a complex 4X e.g. Stellaris
- The example is a very simple 1 level structure. What if there're other values depends on `DMG`? What if all these values `DMG` depends on depends on somethings else? What if deep inside the `RecalculateOtherStuffDependsOnDMG()` you unintentionally modified `ATK`... you never know before you encounter StackOverflowException.
- `SetAtkToDmgRatio(1); // Default value` does not actually change the value, but the recalculation will occurs if you do not check the equality. Do you want to add a if to before all the Set()?
- All the calculation before the last Set() is wasted, you only needs the latest DMG... Do you want to come back to the old ways so:
    ```CSharp
    atk = 10;
    baseAtkModifier = 1;
    atkMultiplier = 2;
    atkModifier = 10;
    atkToDmgRatio = 1;
    dmgModifier = -100;
    finalDmgMultiplier = 2;
    ```
    whenver any of the lines appears in your codebase you place a `RecalculateDMG();`... Sounds cool.

You may have realized that, in this way, the model of all these values exist in your head, or on some designer documentation, it's all your labor to maintain the implementation of the model, any tiny change you'll have to edit a piece of code.

As a wise man once said:
> Modern problems require modern solutions.

It's time to introduce a automatic system to take over the burden.
