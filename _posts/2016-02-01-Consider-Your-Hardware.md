---
layout: post
title: Consider Your Hardware
permalink: hardware
date: 2016-02-01
---

One of the labs in compilers last semester dealt with optimizations. In this post, I'm going to discuss one of the optimizations, why it didn't optimize, and why that's ok.

Our compiler generated x86_64 assembly. The optimization in question is register coalescing. Register coalescing removes register-register moves. That is, if you have an instruction of the form

{% highlight asm %}
mov %rax, %rbx
{% endhighlight %}

the compiler will modify the generated code, renaming occurrences of rbx after this instruction to rax. We had a good bit of trouble implementing the optimization (mostly because of a poorly-thought-out interference graph implementation).

After a couple days of work, we finally got it working. The result? No statistically significant improvement.

Which, sure. Maybe not all that surprising. Movs are supposed to be cheap, right?

But there's a little bit more to the story. Turns out (I didn't know this at the time), modern Intel processors have way more 16 registers. They often have over a 100. There's something called a register file, and the processor maintains a mapping from x86_64 registers to physical registers. In fact, register-register movs really become nothing more than a pointer-renaming.

So the optimization that we spent a couple days implementing was already taken care of for us at the hardware level.

Initially after finding this out, I developed the opinion that this means that register coalescing is a dumb optimization, antiquated by modern hardware. But a conversation with the OS professor here changed my mind.

In general, (he says), simply because you **can** do something at the hardware level doesn't mean you **should**. With the rise of mobile devices and the #internetOfThings, a lot of widely-used processors don't have a lot of power. If you can compile a binary once and take care of all register-register moves once and for all, sometimes that's worthwhile.

It's an interesting topic - very cool to think of the compiler as just a small part of a larger whole. The compiler and the hardware together share the responsibility of making code run efficiently - how the work is divided is a complex question.
