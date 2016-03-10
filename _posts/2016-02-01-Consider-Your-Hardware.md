---
layout: post
title: Consider Your Hardware
permalink: hardware
date: 2016-02-01
---

This is a story about a compiler optimization that didn't optimize.

My compilers class last semester had a lab focused on optimizations. Our compiler targeted x86_64 assembly and the optimization in question removed register-register moves. That is, if you have an instruction of the form

{% highlight asm %}
mov %rax, %rbx
{% endhighlight %}

the compiler will modify the generated code, renaming occurrences of rbx after this instruction to rax. This is called *register coalescing*.

We had a good bit of trouble implementing it (mostly because of a poorly-thought-out interference graph implementation). After a couple frustrating days, we got it working.

The result? No statistically significant improvement. Dang.

At first glance, maybe this isn't all that surprising. Movs are supposed to be cheap, right?

But there's a little bit more to the story. Turns out (I didn't know this at the time), modern Intel processors have way more 16 registers. They often have over a 100. There's something called a register file, and the processor maintains a mapping from x86_64 registers to physical registers. In fact, register-register movs really become nothing more than a pointer-renaming.

So the optimization that we spent a couple days implementing was already taken care of for us at the hardware level.

Being the impetuous 20-year-old I am, I quickly developed the opinion that register coalescing is dumb. An antiquated optimization, made obsolete by modern hardware.

But a conversation with the OS professor here changed my mind.

In general, (he says), simply because you **can** do something at the hardware level doesn't mean you **should**. With the rise of mobile devices and the #internetOfThings, a lot of widely-used processors don't have a lot of power. If you can compile a binary once and take care of all register-register moves once and for all, sometimes that's worthwhile.

It's an interesting topic - very cool to think of the compiler as just a small part of a larger whole. The compiler and the hardware together share the responsibility of making code run efficiently - how the work is divided is a complex question.

And more generally, it's a reminder to think critically about the hardware your code is running on prior to jumping into a nontrivial task. Premature optimization strikes again!