---
layout: post
current: post
cover:  assets/images/welcome.jpg
navigation: True
title: Create Custom World in Unity ECS
date: 2020-07-14 18:07:00
tags: [Unity, Coding]
class: post-template
subclass: 'post'
author: No3371
lang: en
---
> This article assumes you Unity ECS knowledge mentioned in the article (:door:[link](https://gametorrahod.com/world-system-groups-update-order-and-the-player-loop/)) (some part of it is deprecated).

```CSharp
using Unity.Entities;
using UnityEngine;
using UnityEngine.LowLevel;

public class Bootstrap
{
    // It's just i want to create the world so early, it's up to you when to create the world
    [RuntimeInitializeOnLoadMethod(UnityEngine.RuntimeInitializeLoadType.BeforeSceneLoad)]
    static void CreateWorld ()
    {
        World w = new World("BootWorld");
        ScriptBehaviourUpdateOrder.UpdatePlayerLoop(w, PlayerLoop.GetCurrentPlayerLoop()); // You have to hook the world into player loop
        w.GetOrCreateSystem<InitializationSystemGroup>(); // Player loop only update these group
        w.GetOrCreateSystem<SimulationSystemGroup>();     // Player loop only update these group
        w.GetOrCreateSystem<PresentationSystemGroup>();   // Player loop only update these group
        w.GetOrCreateSystem<YourSystem>(); // Create the sytem in the world
        // We have to add the system to any of the 3 group.
        // Otherwise the system idly exist in the world, but won't do anything and won't show up in the debugger
        w.GetExistingSystem<InitializationSystemGroup>().AddSystemToUpdateList(w.GetExistingSystem<YourSystem>());
        // Now the system should be working and can query for interesting entites
    }
}

```
