---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: The Evolution Of Variables
date: 2020-07-14 18:07:00
tags: [Unity, Coding]
class: post-template
subclass: 'post'
author: No3371
lang: zh_TW
---

看看這個算式：`ATK = STR * 10`，是不是很簡單？

`ATK = (STR + DEX) * 5` 也很簡單，我相信你可以在得到 STR 跟 DEX 的值之後飛快地告訴我答案。

再來看看......

> DMG = (((ATK + BASE_ATK_MODIFIER) * ATK_MULTIPLIER + ATK_MODIFIER) * ATK_TO_DMG_RATIO + DMG_MODIFIER) * FINAL_DMG_MULTIPLIER

這看起來像是一個完整的 RPG ——有豐富的藥水效果、技能增減益的那種遊戲可以用上的計算流程，對吧？當我們需要計算一個角色可以造成多少傷害的時候，就需要像這樣計算出傷害值。

```CSharp
float newDmg;
newDmg = atk + baseAtkModifier;
newDmg = newDmg * atkMultiplier + atkModifier;
newDmg = newDmg * atkToDmgRatio + dmgModifier;
newDmg *= finalDmgMultiplier; 
```

看看這段程式碼，我想問幾個問題：
- 假如這段程式碼屬於一個大型多人線上遊戲（MMO），而我們有 10000 個玩家，它會消耗掉多少 CPU 算力？
- 你覺得這段程式碼應該在什麼時候執行？如果我們不想要一直不斷重新計算，可以選擇把 DMG 的結果暫存起來，但每當 [`ATK`, `BASE_ATK_MODIFIER`, `ATK_MULTIPLIER`, `ATK_MODIFIER`, `ATK_TO_DMG_RATIO`, `DMG_MODIFIER`, `FINAL_DMG_MULTIPLIER`] 其中之一改變了，就得重算，對吧？問題來了，要怎麼知道什麼時候這些來源數值改變了、該重算了？
- 程式碼是我們自己寫的，當然不會不知道在哪裡寫了更改 `ATK` 的段落（就算不知道，Bug 出現之後也知道了）。所以當更改一個數值的時候，我們就要求重新計算所有依賴於它的其他數值，合理吧？問題來了，要怎麼知道什麼數值依賴於 `ATK`？

你可能會把
```CSharp
atk += 10;
RecalculateDMG();
```
或者：
```CSharp
atkModifier += 10;
RecalculateDMG();
```
類似的片段在你的 codebase 裡面到處都是。

我們試著做點改進：
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
  SetBaseAtkModifier(1); // 來自被動技能加成：攻擊力+1
  SetAtkMultiplier(2); // 來自一把威力 200% 的武器
  SetAtkModifier(10); // 來自攻擊力藥水
  SetAtkToDmgRatio(1); // 預設的攻擊力-傷害轉化比 1:1
  SetDmgModifier(-100); // 一個弱化 DEBUFF
  SetFinalDmgMultiplier(2); // 一個特殊遊戲模式，所有人造成傷害加倍
}
```
看似行數較多，其實都是重複的東西，請你花一點時間看一看，然後試著回答這些問題：
- 上面這一段程式碼只描述了一個很簡單的計算傷害輸出的系統，假如今天你要做的是一款 4X 策略遊戲例如 Stellaris，你要寫多少程式碼？
- 此外，它只是一個單層的系統。假如有其他的數值依賴於 `DMG` 呢？假如這些會影響 `DMG` 的數值本身也依賴於其他數值呢？會不會在你搭建起整個系統的過程中，`RecalculateOtherStuffDependsOnDMG()` 其中某個依賴於 `DMG` 的數值又反過來影響了 `ATK`，導致程式陷入了無限迴圈產生了 StackOverflowException......
- `SetAtkToDmgRatio(1); // Default value` 當這個值本來就是 1，並不需要觸發任何重算。假如今天不是常數 1，而是某個變數，而你不想浪費 CPU 算力，你就得要確認數值是否變化決定是否重算。你想要在每個數值的每個 Set() 前面都判斷新舊值是否相等嗎？
- 上述範例中，除了最後一次 Set()，其他的 Set() 導致的所有的重算都是不必要的，你只需要最後一次重算的最新 `DMG`，這下怎麼辦呢？難道我們只能使用老方法：
    ```CSharp
    atk = 10;
    baseAtkModifier = 1;
    atkMultiplier = 2;
    atkModifier = 10;
    atkToDmgRatio = 1;
    dmgModifier = -100;
    finalDmgMultiplier = 2;
    RecalculateDMG();
    ```
    在任何改變數值的地方最後才加一行 `RecalculateDMG();` 來確保既不浪費又能得到最新的 `DMG`嗎......聽起來超棒der......

You may have realized that, in this way, the model of all these values exist in your head, or on some designer documentation, it's all your labor to maintain the implementation of the model, any tiny change you'll have to edit a piece of code.

As a wise man once said:
> Modern problems require modern solutions.

It's time to introduce a automatic system to take over the burden.
