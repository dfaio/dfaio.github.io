---
layout: post
title: Some Primality Tests
permalink: isprime
date: 2015-05-18
comments: True
---

Today we'll discuss a variety of primality tests - each an improvement of the last, working up to the well-known and very important **Miller-Rabin test**.

### A Naive Solution
Naively checking primality in python is straightforward - check all possible factors!
{% highlight python %}
def isPrime(n):
    if n < 2: return False
    if n == 2: return True
    for possibleFactor in xrange(3, n):
        if x % possibleFactor == 0:
            return False
    return True
{% endhighlight %}
This runs in $O(n)$ time, where $n$ the *value* of the input.

We can do a bit better by noticing that if $p \mid n$, then $n = pq$ and so $q \mid n$. Which is to say: factors come in pairs. So we only need to check half of the factors of $n$. If we always take $p \leq q$, then $p$ is maximized at $\sqrt{n}$. So we obtain the following $O(\sqrt{n})$ solution:
{% highlight python %}
def fasterIsPrime(n):
    if n < 2: return False
    if n == 2: return True
    maxFactor = int(round(n ** 0.5))
    for possibleFactor in xrange(3, maxFactor + 1):
        if n % possibleFactor == 0:
            return False
    return True
{% endhighlight %}

### This is Slower than you think
We might be tempted to look at this analysis and say: "awesome - a sublinear solution! Good job, everyone!" But a more careful look suggests we should be more cautious.

This analysis is parameterized on the *value* of the input, rather than the *length* of the input.

What's the difference? Think of this way: in the RAM model of computation (our default model), all the inputs are strings. We don't really know how this number is encoded, all we know it that it's a string. If we can give a $log(n)$-length string encoding $n$ (and we can - binary is one such encoding), then now, when we talk about runtime, we parameterize on the length of the input.

Moreover, since real computers use binary for everything, we should we reassured that this reparameterization is not some math-voodoo-magic but instead, a more realistic representation of the computation.

If it helps, you can imagine we're taking $k := len(n)$ and then working in $O(k)$ world.

So, with our revised analysis, $k = lg(n)$, or equivalently, $2^k = n$.  So our previous $O(n)$ solution becomes $O(2^{k})$, which is exponential!

So how can we do better?

The answer? A couple number theory tricks and some random bits!

### The Fermat Primality Test

If you recall, Fermat's little theorem says, if $p$ is prime, then $a^p \equiv_p 1$ for all $a$. The contrapositive of this statement is: if $a^p \not\equiv_p 1$ for some $a$, then $p$ is not prime.

The Fermat primality test relies on this simple fact - we simply grab a bunch of $a$'s at random from $\mathbb{Z}_p$ and test them. If one $a$ fails the test, we know for sure that $p$ is not prime. Once we've checked enough $a$'s and we're feeling good, we output "probably prime."

In python,
{% highlight python %}
import random
def fermatIsPrime(n, trials):
    for trial in xrange(trials):
        a = random.randint(1, n-1)
        if pow(a, n-1, n) != 1:
            return False
    return True
{% endhighlight %}
Line 5 uses python's builtin $\texttt{pow}$ function, which will compute a\*\*(n-1) % n using modular exponentiation, which is polynomial time. If we decided to first compute a\*\*(n-1) and then mod by n, we'd be exponential, as

$$len(a^{n-1}) = lg(a^{n-1}) = (n-1)lg(a)$$

This is exponential in terms of the input length. So even recording the value in memory would take exponential time!

So then as long as $\texttt{trials}$ is polynomial in terms of the length of $n$, $\texttt{fermatIsPrime}$ runs in poly time, which is great news!

Sure, there's some probability of error. Maybe we didn't check enough $a$'s and we just happened to miss some witness to that fact that $n$ is composite. But if $\texttt{trials}$ is really big (and polynomials can get quite big), we can be *almost assured* that "probably prime" means "is prime."

With one large, unfortunate exception.

### Carmichael Numbers

Sadly, the converse of Fermat's little theorem does not hold. Carmichael numbers are defined as composite numbers $n$ which, for all $b \in Z_n$, $b^{n-1} \equiv_n 1$.

Which is to say, they're precisely the numbers that'll slip past the Fermat test.

Not only that, there are infinitely many Carmichael numbers! (If you're interested, 561 is the first Carmichael number). No matter how many times you run $\texttt{fermatIsPrime(561)}$, it will always incorrectly report that 561 is prime.

The fix? More number theory tricks!

### Square Roots of Unity

Suppose $p$ is prime. We define a *square root of unity* to be some $x \in Z_p$ such that $x^2 \equiv_p 1$.

Certainly, $1$ and $-1$ are square roots of unity. Call these the trivial square roots of unity. We claim that there are no nontrivial square roots of unity in $Z_p$.

If we define $x^2 - 1$ to be a polynomial over $Z_p$, then we get for free that $1$ and $-1$ are the only square roots of unity in $Z_p$. This is as a degree $d$ polynomial has at most $d$ roots.

### Fermat + Roots of Unity

Here, we'll get a stronger claim by combining the two number-theoretic facts we have so far. This will be the basis of the Miller-Rabin primality test.

By Fermat's little theorem, we know that if $p$ is prime, then $a^{p-1}$ is equivalent to $1$ mod $p$. Which means that (loose notation alert) $\sqrt{a^{p-1}}$ better be equivalent to $1$ or $-1$.

More formally, $\sqrt{a^{p-1}} = a^{(p-1)/2}$, and since we're assuming $p$ is a prime bigger than 2, $p-1$ is even. So $\frac{p-1}{2}$ makes sense.

Further, since $p-1$ is even, we can express $p-1$ as $2^s \cdot d$ for some $s$ and $d$. So then combining Fermat's little theorem with our square roots of unity claim gives us that either

$$a^{d} \equiv_n 1$$

or

$$a^{2^r \cdot d} \equiv_n -1$$

for some $0 \leq r \leq s-1$.

To see this - start with $a^{2^s \cdot d} = a^{p-1} \equiv_p 1$. Take a square root. Either we hit $-1$ and we stop (as we've satisfied the second equality), or we're still equivalent to $1$ mod $n$. So we square root again. And so on. If we never get to $-1$, then at the end, we've taken out all the powers of two and we're left with the first equality. Otherwise, we're left with the second.

### The Miller-Rabin Test

Similar to how the Fermat test was based on the contrapositive of Fermat's little theorem, the Miller-Rabin test is based on the contrapositive of the claim above. Which is to say, if there exists an $a \in Z_n^*$ such that

$$a^d \not\equiv_n 1 \text{ and } a^{2^r \cdot d} \not\equiv_n -1$$

for all $0 \leq r \leq s - 1$, then $n$ is not prime.

So, given an input $n$ to check, we write $n-1$ as $2^s\cdot d$. And we check our two equalities. For random $a$, if $a^d \not\equiv_n 1$, return False. Then, check the second equality: loop for all $i$ and check that $a^{2^i\cdot d} \equiv -1$.

In python: (woohoo!)
{% highlight python %}
import random

def powersOfTwo(n):
    powers = 0
    while n % 2 == 0:
        powers += 1
        n /= 2
    return (powers, n)

def millerRabin(n, trials):
    # Where trials is some polynomial of n
    if n == 2 or n == 3: return True
    (s, d) = powersOfTwo(n - 1)
    for trial in xrange(trials):
        # Trying to find an a that breaks our equalities
        a = random.randint(2, n - 2)
        x = pow(a, d, n)
        secondEquality = False
        if x == 1:
            # First equality holds, try again
            continue
        if x == (n-1):
            # Second equality holds when r == 0
            continue
        for i in xrange(s-1):
            x = pow(x, 2, n)
            if x == 1:
                # Found a nontrivial square root of unity
                return False
            if x == (n - 1):
                # Second equality holds, try again
                secondEquality = True
                break
        # If we got to the end and second equality
        # didn't hold for any of them
        if not secondEquality: return False
    return True


{% endhighlight %}

If $k$ is the number of $a$'s we try, then $\texttt{millerRabin(n, k)}$ runs in $O(k(logn)^3)$ where $n$ is the *value* of the input. Equivalently, if $n$ is the *length* of the input, then we have that $\texttt{millerRabin(n, k)}$ runs in $O(kn^3)$. Not bad! And definitely polynomial time :)
