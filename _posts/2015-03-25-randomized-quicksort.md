---
layout: post
title: Randomized Quicksort
permalink: quicksort
date: 2015-03-25
---

As a nice first randomized algorithm, we'll present a randomized version of quicksort and do some analysis on its runtime. This post assumes familiarity with basic probability concepts (mainly expectation).

This algorithm will be an example of Las Vegas algorithm - a randomized algorithm whose runtime is variable, not its probability of correctness. Interestingly, Las Vegas algorithms were first coined in 1979 by a professor at University of Chicago named Laszlo Babai. In fact, Babai's doctoral advisor was Turan! (Of Turan's theorem in graph theory).

Las Vegas algorithms are in contrast the other main type of randomized algorithm, Monte Carlo algorithms. Monte Carlo algorithms' probability of correctness is variable, not their runtime.

But first, a lightning fast review of deterministic quicksort. In deterministic quicksort, we have some list that we want to sort. We pick a pivot point and then break our list up into two parts: those elements of the list smaller than the pivot and those greater. We then recurse on these smaller lists.

A quick python implementation is as follows:

{% highlight python %}
def quicksort(L):
    if len(L) == 1 or len(L) == 0:
        return L
    pivot = L[0]
    smaller = [elt for elt in L if elt < pivot]
    larger = [elt for elt in L if elt >= pivot]
    return quicksort(smaller) + [pivot] + quicksort(larger)
{% endhighlight %}

On average, this will run in \\(O(nlgn)\\), but our worst-case runtime is \\(O(n^2)\\). That is, if our choice of pivot happens to be the smallest or biggest of the list, we're kinda screwed.

So account for this issue, we can instead just choose a pivot at random. This can make it difficult for an adversary to feed us a worst case input. In python, this would amount to:

{% highlight python %}
import random
def randomized_quicksort(L):
    if len(L) == 1 or len(L) == 0:
        return L
    # randint upper bound is inclusive
    i = random.randint(len(L) - 1)
    pivot = L[i]
    smaller = [elt for elt in L if elt < pivot]
    larger = [elt for elt in L if elt >= pivot]
    return quicksort(smaller) + [pivot] + quicksort(larger)
{% endhighlight %}

Quick and easy! Let's do some analysis on the expected runtime. When we say expected runtime, we're taking the expectation over all choices of random pivots for some fixed input.

We let \\(a_1, a_1, \ldots a_n\\) be some input to \\(\texttt{randomized_quicksort}\\) and let \\(s_1, s_2, \ldots, s_n\\) be the sorted version of this input. We define indicator random variables \\(X_{i,j}\\) which are 1 if \\(a_i\\), \\(a_j\\) are ever compared during our given run of quicksort and 0 otherwise. By linearity:

$$\mathbb{E}[X] = \sum_{i=1}^{n-1}\sum_{j = i+1}^n \mathbb{E}[X_{i, j}]$$

Since \\(X_{i,j}\\) is an indicator random variable, its expectation is just the probability that \\(a_i\\) and \\(a_j\\) are compared. So what is this probability? Let's call the \\(i\\)th element of the (sorted) array \\(e_i\\) and the \\(j\\)th element of the array \\(e_j\\). Certainly, if we pick either one of those elements as a pivot, we'll compare one to the other.

We're picking pivots at random, so we might as well think of picking pivots in the following way: take the final sorted array and throw darts randomly at it. If the dart lands on the \\(k\\)th spot, use \\(e_k\\) as the pivot point. Somewhere in the sorted array, we have the sequence
$$e_i, e_{i+1}, \ldots e_{j-1}, e_j$$
If we pick a pivot outside of this chunk of the sorted array, we just throw another dart. If throw a pivot inside this chunk and it hits \\(e_i\\) or \\(e_j\\), the two get compared. But if we pick somewhere in the middle, \\(e_i\\) and \\(e_j\\) will get moved to seperate sublists and never be compared. So the probability that \\(X_{i,j}\\) is 1 is
$$\frac{2}{j-i+1}$$
So then we have that

$$ \mathbb{E}[X] = \sum_{i=1}^{n-1}\sum_{j = i+1}^n \mathbb{E}[X_{i, j}] = \sum_{i=1}^{n-1}\sum_{j = i+1}^n \frac{2}{j - i + 1} $$

Substituting in, we see this is equal to

$$2\sum_{i=1}^{n-1}\sum_{k=2}^{n-i+1} \frac{1}{k}
\leq 2\sum_{i=1}^{n}\sum_{k=2}^{n} \frac{1}{k} $$

Then, we have that the inside sum is less than \\(lnn\\). This can be seen by examining the integral of \\(lnn\\) and the viewing the sum as a Riemann sum underneath the curve. So then we have

$$ 2\sum_{i=1}^{n}\sum_{k=2}^{n} \frac{1}{k} \leq 2\sum_{i=1}^{n} ln(n) \leq 2nln(n) $$

So then we have that our randomized quicksort algorithm runs in $O(nlgn)$ as desired. :)
