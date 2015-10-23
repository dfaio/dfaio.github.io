---
layout: post
title: Defining Variables Inside Expressions in Python
permalink: vars
date: 2015-03-09
---

Of course I should start with the disclaimer that this is a complete hack. But it's a fun one.

There's been a bit of a competition among my friends and me recently as to who can write the best one-liners in python. While I'm by no means in the lead (one of my friends wrote an entire tetris implementation in one line!), I did discover this fun little hack:

{% highlight python %}
__import__("sys")._getframe(1).f_locals.update({"foo":42})
{% endhighlight %}

This is gross for a number of reasons. Firstly, the sys.getframe method returns a frame object from the call stack, but this is implementation defined and not guaranteed to work in all versions of python.

Then, the f_locals field of the frame object is a dictionary of all the local variables in our current stack frame. But since we're arbitrarily constraining ourselves to expressions (one-liners are cooler this way), we can't write a line like:

{% highlight python %}
thisFrame.f_locals["foo"] = 42
{% endhighlight %}

So we hack it with a builtin destructive dictionary method, update. Since this is ultimately a destructive function call, while this is technically an expression, it evaluates to None.
