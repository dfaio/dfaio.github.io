---
layout: post
title: A Universal Register Machine
date: 2015-04-06
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

If we recall from a couple posts back, we showed that, without loss, a Turing machine can have access to its own source code. There's a similar trick we can play with register machines, though it's far less involved. It involves something called *Godel numberings*. It's one of the features of register machines I quite like.

In essence, Godel numbering is a hack that turns anything into a number. Then, we can encode a register machine program as a number and feed that as input to another register machine. Self-reference!

We're going to building a toolbox of functions to help us swap between register machines and numbers. We'll need a couple of things: a coding function, a length function, and decoding function. The coding function will turn a sequence of numbers into a single number. The length function will give us the length of our sequence number. Our decoding function decodes (or extracts) out elements from our sequence.

Essentially, we're encoding a list of numbers as a single (quite large) number.

### Coding Functions

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

### Univeral Register Machine

A *univeral register machine* is a register machine that takes another register machine as input and simulates that register machine. This is an important concept. The notion of self-reference has been show to be extraordinarily powerful. It provides a natural definition of recursion, for instance.

To implement such a register machine, we'll want a couple of macros:

{% highlight asm %}
copy r s k      # Copy r to s, goto k
zero r k l      # If r is 0, goto k, else goto l
pop r s k       # s = r[0]; r = r[1:], goto k
read r t s k    # s = r[t]; goto k, halt if out of bounds
write r t s k   # r[t] = s; goto k, halt if out of bounds
{% endhighlight %}

### Some Macros

What follows are implementations for each of the above macros. Copy is fairly straightforward:

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

The zero macro is straightforward as well:

{% highlight asm linenos %}
# zero r k l
dec r 3 k
inc r l
{% endhighlight %}

For pop, given our specific encoding, it happens to be useful to define a div macro that has conditional branches, depending on the value of the bit we just removed.

{% highlight asm linenos %}
# div2 r k l
dec u 2 3 # zero-out register u
dec r 4 5 # u = r; r = 0
inc u 3
dec u 6 k # if u is zero, r was even
dec u 7 l # if u is zero, r was odd
inc r 5
{% endhighlight %}

This is a bit more subtle. We first zero out some dummy register u, and then move r's contents into u. Then, we decrement u twice and increment r once. If, in the first dec instruction, we find that we've hit zero, then u was originally even, as an even number of dec instructions preceded it. Similarly, if we hit zero before the second dec instruction, there was an odd number of decrements prior to us, so r must have been odd.

With this macro, pop becomes fairly straightforward:

{% highlight asm linenos %}
# pop r s k
div2 r 3 - # get rid of leading 1
div2 r 4 5 # eat up all zeroes, add to s
inc s 3
add r r 6  # We also ate the next 1, so fix that
dec u 6 7
inc u 8
add r u k
{% endhighlight %}

Where \\(\texttt{add}\\) is some destructive add macro. Note that there is no third argument to the first \\(\texttt{div2}\\) instruction, as our precondition is that r holds a valid sequence number, whose least significant bit is guaranteed to be 1. So we leave this behavior undefined.

{% highlight asm linenos %}
# read r t s k
copy r u 2   # u = r (non-destructive copy)
dec t 4 5
pop u s 3
pop u s k
{% endhighlight %}

To define write, we'll want a push macro:

{% highlight asm linenos %}
# push r s k - push s onto r, goto k
dec s 3 4 # push all the zeros onto r
add r r 2
dec u 4 5 # push the one onto r
inc u 6
add u r k
{% endhighlight %}

With this in hand, we can implement write as if r was a stack: popping off t elements, pushing them onto another stack, push our new value onto r, throwing away the top value from our helper stack, and then replacing the values.

{% highlight asm linenos %}
# write r t s k # r[t] = s; goto k, halt if out of bounds
dec  u 2 3      # initialize - u is our dummy int
dec  v 3 4      # v is our dummy stack
copy t t' 5
dec  t' 6 9     # while t > 0
pop  r u 7      # pop from r onto u
push v u 8
dec  u 8 5      # clean up u, go again
pop  r u 10     # once more, when t == 0
push v u 11
dec  u 11 12
push r s 14     # push s onto r
pop  v u 14     # throw away top value on v
dec  u 14 15    # (this is what we're overwriting)
dec  t 16 k     # while t != 0:
pop  v u 17     # pop from v, push onto u
push r u 18
dec  u 18 15
{% endhighlight %}

### A URMP

With these macros in hand, we can write the man himself: a universal register machine program! Here are the registers we use for our program:

{% highlight c %}
p - our simulated program
c - the code number of P
x - input to P
r - simulates registers of P
i - instructions of P
p - program counter
{% endhighlight %}

{% highlight asm linenos %}
copy  c r 2
write r p x 3
read  c p i 4
pop   i r 5
zero  i 14 6
pop   i p 7
read  r r x 8
zero  i 9 10
inc   x 13
zero  x 11 12
pop   i p 3
dec   x 13 13
write r r x 3
halt
{% endhighlight %}
