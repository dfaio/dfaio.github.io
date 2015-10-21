---
layout: post
title: Counting Necklaces
date: 2015-05-13
---

Today we'll discuss a cute proof of  Fermat's little theorem. If you recall, Fermat's little theorem states that if $p$ is a prime, then

$$a^p \equiv a \mod{p}$$

This is equivalent to saying $a^{p}  - a \equiv 0 \mod{p}$ or that $p \mid a^{p} -a$. This last statement is the one that we'll latch onto.

Suppose we had a collection of $a$ differently colored beads and we want to make necklaces of length $p$. (Maybe you have weird friends who will only wear prime-length necklaces, I don't know. They're your friends.)

So we start by choosing a color for the first bead, then a color for the second and so on. We have $a^p$ different ways to do this. Let's say that we go ahead and make all $a^p$ possible necklaces.  Once we're done, we connect the ends together.

We can divide the necklaces into two different groups: some of the necklaces use only one color, some use more than one. Since there are only $a$ colors, we have $a$ necklaces of one color and $a^p - a$ necklaces of more than one color.

Now that we've connected the ends together, some necklaces that were previously different are now the same, as they're simply rotations of each other. These form little equivalence classes.

So how big are these equivalence classes? Here's a claim:

If we have a string $S$ that is composed of repetitions of some smaller string $T$, then the size of $S$'s equivalence class is the length of $T$.

Here's an example - suppose $S$ is the string AABAABAAB (composed of three AAB's). Then the first three rotations

{% highlight python %}
AABAABAAB -> BAABAABAA -> AABAABAAB
{% endhighlight %}

get us back to where we started.

But... (and this is my favorite part) the necklaces we made are of prime length! So there can't possibly be any shorter substring repetition, as otherwise, the length of the substring $T$ would divide the length of our necklaces.  So then each equivalence class has size $p$.

Since each multicolored necklace is in exactly one equivalence class (and they're all of size $p$), if there are $k$ equivalence classes, then the number of multicolored necklaces is $kp$. Or equivalently, $p \mid a^p - a$.

Cute, right? I really like  how succinctly you can summarize the proof: "count necklaces." So if you're ever put on the spot being asked to prove Fermat's little theorem, just recall that phrase and you should be able to work it out from there :)