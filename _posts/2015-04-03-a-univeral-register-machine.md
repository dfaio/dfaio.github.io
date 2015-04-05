---
layout: post
title: A Universal Register Machine
date: 2015-04-03
---

Register machines are yet another abstract model of computation. They're actually quite interesting for a number of reasons and oftentimes they prove to be a prettier model than Turing Machines.

So what is a register machine, you ask? A register machine is a finite collection of registers and a control unit. Each register holds a natural number and the control unit executes commands that modify the contents of the registers. We write \\(R_i\\) for the \\(i\\)th register. Our instruction set is super simple:

{% highlight asm %}
inc r k
dec r k l
halt
{% endhighlight %}

\\(\texttt{inc}\\) increments register \\(r\\) and then goes to line \\(k\\) in the program. \\(\texttt{dec}\\) checks to see if register \\(r\\) is zero. If it's not, \\(\texttt{dec}\\) decrements the register by 1 and then goes to line \\(k\\). Otherwise, it doesn't decrement and instead just moves to line \\(l\\) in the program. \\(\texttt{halt}\\) is pretty self-explanatory.

To make things nicer, we'll often label our registers. (X, Y, and so on).

As a first example, here we define an addition function that takes two registers X and Y and places X + Y in Z.

{% highlight asm linenos %}
# addition: X + Y -> Z
dec X 3 4 # while X != 0: X--, Z++
inc Z 2
dec Y 5 6 # while Y != 0: Y--, Z++
inc Z 4
halt
{% endhighlight %}

Similarly, we could define a multiplication algorithm as follows:

{% highlight asm linenos %}
# multiplication: X * Y -> Z
dec X 3 8
dec Y 4 6
inc U 5
inc Z 3
dec U 7 2
inc Y 6
halt
{% endhighlight %}

If we recall from a couple posts back, we showed that, without loss, a Turing machine can have access to its own source code. There's a similar trick we can play with register machines, though it's far less involved. It involves something called Godel numberings, which we'll discuss in a moment. It's one of the features of register machines I like.

Spoiler alert: register machines are numbers. Let's examine this idea.

Essentially, we're going to building a toolbox of functions to help us swap between register machines and numbers. We'll need a coding function, which will turn a sequence of numbers into a single number, a length function, which will give us the length of our sequence number, and decoding function that extracts out elements from our sequence.

Essentially, we're encoding a list of numbers as a single (quite large) number.

We define a class of functions called *coding functions*. Coding functions turn a sequence of numbers into a single number. More formally, it's a "polyadic map" of the form

\\[f : \mathbb{N}^\* \rightarrow \mathbb{N}\\]

Polyadic just means that it takes multiple arguments. To build such a function, we first define a pairing function of the form

\\[\pi : \mathbb{N}^2 \rightarrow \mathbb{N}\\]

There's a number of different ways we could go about defining such a pairing function. Here's one idea: take two numbers \\(x\\) and \\(y\\). Turn them into unary (that is, two strings of length \\(x\\) and \\(y\\), respectively), then concatenate these strings together with some sort of delimiter. For example,

\\[\pi(3, 5) = 10000010001_2 = 1041\\]

There's a number of other various ways to go about this, but let's stick with this as a proof of concept. Then we can define our polyadic coding function as such:

\\[ f \text{ (nil)} = 0, f (a_1, \ldots a_n) = f(a_1, f(a_2, \ldots a_n))\\]

Where nil is the empty list. If you're familiar with functional programming, this is essentially just

{% highlight haskell %}
foldl pi 0 [a1, a2..an]
{% endhighlight %}

We can define similar length and decoding functions. A length function could perhaps be the binary digit sum of the sequence number (minus 1).

Then, note that we can encode register machine instructions as numbers as well: \\(\texttt{halt}\\) can be \\(0\\), \\(\texttt{inc r k}\\) can be \\(f(r, k)\\), and \\(\texttt{dec r k l}\\) can be \\(f(r, k, l)\\). From here, we can encode entire programs as a sequence of such instructions.

So register machines are numbers. With that in mind, let's get working on our original task - to define a univeral register machine.

A *univeral register machine* is a register machine that takes another register machine as input and simulates that register machine. This is an important concept. The notion of self-reference has been show to be extraordinarily powerful. It provides a natural definition of recursion, for instance.

To implement such a register machine, we'll want a couple of macros:

{% highlight asm %}
copy r s k      # Copy r to s, goto k
zero r k l      # If r is 0, goto k, else goto l
pop r s k       # s = r[0]; r = r[1:], goto k
read r i s k    # s = r[i]; goto k, halt if out of bounds
write r i s k   # r[i] = s; goto k, halt if out of bounds
{% endhighlight %}

Or here, we define a copy macro:

{% highlight asm linenos %}
# copy r s k
dec s 2 3 # set s = 0
dec r 4 6 # move r to u and s
inc u 5
inc s 3
dec u 7 9 # move u back to r
inc s 6
dec u 8 k
{% endhighlight %}

The zero macro is straightforward:

{% highlight asm linenos %}
# zero r k l
dec r 3 k
inc r l
{% endhighlight %}

For pop, given our specific encoding, it happens to be useful to define a div macro that has conditional branches, depending on the value of the bit we just removed.
