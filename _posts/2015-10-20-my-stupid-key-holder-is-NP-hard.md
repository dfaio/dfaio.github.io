---
layout: post
title: Arranging keys on my key holder is NP-hard
date: 2015-10-20
---

This past summer, I bought [this](http://www.amazon.com/KeySmart-Compact-Holder-Black-Organizer/dp/B00KYTWL5E) key-holding gadget. I'm a little paranoia about losing my keys, so I figured it'd be a good way to make sure I don't lose any of them.


But god forbid you ever have to change what keys you carry with you.

I just bought a USB drive to put on it (I recently had a snafu with arch and had to chroot in. But I had to go a couple hours without my laptop because I didn't have a boot USB on me. Never again).

Anyway.

30 minutes into the process of rearranging my keys so that the USB drive would fit on it, I thought to myself: "this has to be NP-hard."

And indeed it is.

We reduce from [PARTITION](https://en.wikipedia.org/wiki/Partition_problem). (Really, they're nearly the same problem). Take a second and gaze at the key holder on the linked amazon page to get a sense for the problem. We want to arrange the keys so that all keys fit on the keyring and there's no "tangling" of keys in the middle.

Call the length of the key holder $l$.

Suppose I give you a bunch of keys to put on the key holder. Each key is very short - maybe $\frac{l}{3}$. So the length of the keys won't be an issue - it's mostly an issue of getting the heights to match. The keys are of varying heights.

Certainly, the key holder needs to have equal height on each end. Additionally, every key must be present (like, why would you even buy one of these things if you're still going to have keys jangling around)?

So then, if the sum of the heights of the keys is $S$, each side of the key holder must have height $\frac{S}{2}$.

But this is just exactly PARTITION, which we know to be NP-complete.

Sigh. Wikipedia says that there's a pseudo-poly time dynamic programming solution for PARTITION, which has led PARTITION to be called "The Easiest Hard Problem".

Though to be frank, I don't know if I consider that to be much condolence.