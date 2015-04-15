---
layout: post
title: Edge Connectivity, Quickly
date: 2015-04-13
---

Today we'll talk about another randomized algorithm: this time to find the edge connectivity of a graph. We'll present a naive solution first and then discuss a dramatic improvement. This should serve as a nice introduction to Monte Carlo randomized algorithms :)

If you've seen the naive solution before, feel free to skip down the "An Improvement" section, where we discuss the Karger-Stein algorithm.

### Some Definitions

The *edge-connectivity* of a graph is the largest number $k$ such that upon removal of any subset of edges of $E$ of size less than $k$, $G$ remains connected. So a tree has edge-connectivity 1. A graph that is a cycle has edge-connectivity 2.

We also define the *min-cut problem*: given a graph $G = (V, E)$, find a nonempty subset $S \subset V$ such that the number of edges from $S$ to $V-S$ is minimized.

So then we have the min-cut problem solves the edge-connectivity question. Presenting a smallest cut means that, for any set of edges smaller than our cut, removal of that subset from $G$ preserves $G$ connectednss. Which is precisely edge-connectivity!

### Our Algorithm
Some quick python-esque pseudocode:
{% highlight python %}
def mincut(G):
    while vertex_set(G) >= 2:
        e = random_edge(G)
        G = contract(G, e) # delete self loops
    return edges_remaining(G)
{% endhighlight %}
Let's do some analysis on this algorithm's probability of correctness.

Suppose we have some graph $G = (V, E)$ be a graph with $n$ vertices. Let $F$ be some min cut of $G$. Then we claim that the probability that $\texttt{mincut}$ outputs $F$ is at least $\frac{2}{n(n-1)}$.

To show this, we'll lower bound the probability that $\texttt{mincut}$ is wrong.

Let's define some variables: let $\mid F\mid = k$, $\mid V\mid = n$ and $\mid E \mid = m$.

We make the following observation: if our contraction algorithm ever contracts something in $F$, then we won't choose $F$ as a cut. Conversely, if our algorithm never picks something in $F$, then certainly, the cut we're left with will be $F$.

So Pr(We pick $F$ as our min cut) = Pr(We never contract an edge in $F$).

Let's define $E_i$ to the event that our algo contracts an edge in $F$ in iteration $i$. So we're considering

$$\Pr(\bar{E_1} \cap \ldots \cap \bar{E_{n-2}})$$

(Note the $n-2$. We only go until we have two vertices left).
Using the definition of conditional probability, we can see that the above is the same as

$$\Pr(\bar{E_1}) \cdot \Pr(\bar{E_2}|\bar{E_1}) \cdots \Pr(\bar{E_{n-2}}|\bar{E_1} \cap \bar{E_2} \cdots \cap \bar{E_{n-3}})$$

Though this looks gross, we'll be able to establish lower bounds on each of the terms individually. Let's start with the first term.

We started with the assumption that we had a min cut $F$ and it was of size $k$. So then every vertex in $G$ must have degree at least $k$, as otherwise, we could pick the edges to which it's incident and have a smaller cut. So this means that $2m = \sum_{v \in V} deg(v) \geq kn$. Or in other words, $\frac{k}{m} \leq \frac{2}{n}$.

But we have that $\Pr(E_1)$ (the prob that we pick a guy in $F$ in our first run) is $\frac{k}{n} \leq \frac{2}{n}$. So then $\Pr(\bar{E_1}) \geq (1 - \frac{2}{n})$.

So that's not so bad. We then have a bound on the first term in that ugly product we had. Let's keep going.

Let's consider the $i$th iteration. Let's suppose that up until now, we've been kosher. Which is to say, we haven't picked anything in $F$ yet. Things are going great. What's the probability we keep it going?

Well, we have $k$ edges in our min cut and some number of remaining edges $m'$. So then the probability we don't mess up is $1 - \frac{k}{m'}$. But we want some bound of this in terms of $n$...

Well, let's think. Here's an observation: at *every* point in the algorithm, every vertex must have degree at least $k$. To see this, remember that each vertex now represents some clump of vertices. If some vertex had degree less than $k$, then there would be some clump of vertices that could be seperated by removing less than $k$ vertices. But that would contradict our assumption that $F$ is a min cut!

So after $i$ contractions, by the handshaking lemma, we have that $m' \geq \frac{k(n-i)}{2}$, where $m'$ is the number of remaining edges.

So then the probability that we screw up in the $i$th iteration, given that we'd been fine so far is at least

$$ 1 - \frac{k}{m'} \geq 1 - \frac{k}{k(n-i)/2} = 1 - \frac{2}{n-i}$$

 So then, the big probability mess we had above is at least
  $$
  \left(1 - \frac{2}{n}\right)
  \left(1 - \frac{2}{n-2}\right)\cdots \left(1 - \frac{2}{n-(n-3)}\right)
  =
  \left(\frac{n-2}{n}\right)
  \left(\frac{n-3}{n-1}\right)\cdots
  \left(\frac{2}{4}\right)
  \left(\frac{1}{3}\right)
$$
But cancelling terms, we get that this is

$$\frac{2}{n(n-1)}$$

As claimed. But wait a second. That probability is the probability of correctness. Which is $\Omega(n^{-2})$.

I'm not sure we should be impressed.

Sure, this algorithm is polytime, but it's probability of correctness is abyssmal! Luckily, we're about to see a really useful tool in randomized algorithms. It's called *amplification*.

### Amplification

*Amplification* - running an randomized algorithm a lot of times to decrease its probability of error.

So instead, let's try running the new randomized algorithm lots of times (say, $t$ times) and choose the smallest of the cuts we get. So then

$$\Pr(\text{Missing our min cut}) = \Pr(\text{original algo missing min cut})^t$$

Then
$$\left(1 - \frac{2}{n(n-1)}\right)^t \leq \left(1 - \frac{1}{n^2}\right)^t.$$

Note than when $t = n^2$, this goes to $\frac{1}{e}$. When $t = n^3$, this goes to $\frac{1}{e^n}$, which is tiny! Note that this is running the original algorithm $n^3$ times. We contracted order $n^2$ edges, so to get this probability bound, our overall big oh cost is $O(n^5)$. So if we're willing to wait around for a while, then we can be *almost guaranteed* that our algorithm is correct! And all in polytime :)

### An Improvement

The probability we had originally was a product of things. And at the very end, those things got pretty small. Three quarters? A third? These terms our killing our probability of correctness!

Which sparks a new idea. Maybe we should use the original contracting idea for a while, but once $G$ starts to get pretty small, switch to something a bit slower. It'll be a small sacrifice in time, but perhaps we'll save on the number of times we need to repeat the algorithm.

So let's try it! We'll to establish a cutoff point - any probability higher than this will be considered "bad." For our purposes, a half should be fine. So when do we need to stop contracting? It turns out that if we contract the graph until it has $\frac{n}{\sqrt{2}}$ remaining vertices (starting with $n$), then any contraction after that has more than a 50/50 chance of ruining our min cut.

Check it out:

$$\prod_{i=n/\sqrt{2}}^n \frac{i-2}{i} = \frac{n/\sqrt{2}(n/\sqrt{2} - 1)}{n(n-1)} \approx \frac{(n/\sqrt{2})^2}{n^2} \approx \frac{1}{2}$$

(If that looks like a giant mess, don't worry about it. The terms in the product cancel out as they did before).

So we first contract down to $n/\sqrt{2}$ vertices. Now what? Well now we need to tread carefully, because we have at least a half chance to mess up our min cut. So we make a couple of tries. We'll pick two different edges and continue onward from there, taking the minimum of the two min cuts provided to us. Not only that, we'll use this strategy multiple times, recursively. When we get to some small number of vertices, we can use a slower algorithm to give us the best min-cut on some small graph.

So we have
{% highlight python %}
def contract_to(G, t):
    while vertex_set(G) >= t:
        e = random_edge(G)
        G = contract(G, e)
    return G

def faster_mincut(G):
    if vertex_set(G) < 6:
        return careful_mincut(G)
    t = int(round(vertex_set(G) / 2 ** 0.5))
    G1 = contract_to(G, t)
    G2 = contract_to(G, t)
    return min(faster_mincut(G1), faster_mincut(G2))
{% endhighlight %}

### Analysis - Correctness

So what has this gained us? Quite a bit, actually. Let's call $P(n)$ the probability of picking a fixed mincut on $n$ vertices. Let's consider the probability that one of the recursive calls picks a particular mincut. Call this probability $P_{X1}$.So then

$$P_{X1} = P_{X2} \leq \frac{1}{2} \cdot P\left(\frac{n}{\sqrt{2}}\right)$$

Our overall algorithm will return the proper mincut if it doesn't select any edge in the recursive calls. So then

$$P(n) = 1 - (1 - P_{X1})(1 - P_{X2})$$

Which together yield

$$P(n) \geq P\left(\frac{n}{\sqrt{2}}\right) + \frac{1}{4}P\left(\frac{n}{\sqrt{2}}\right)^2$$

This has solution $O(\frac{1}{lg(n)})$ (proof by induction).

### Analysis - Runtime

Each call of $\texttt{faster_mincut}$ makes two recursive calls and contracts some edges. The number of edge contractions is a constant multiple of the number of edges, so is $O(n^2)$. So our recurrence for work is

$$T(n) = 2T\left(\frac{n}{\sqrt{2}}\right) + O(n^2)$$

By the master theorem, this is $O(n^2lg(n))$.

### More Amplification

So what does it take to get our same $1 - \frac{1}{e^n}$ bound of correctness? It turns out to be $nlg(n)$. Our probability of success works out to be

$$1 - \left(1 - \frac{1}{lg(n)}\right)^{nlg(n)} = 1 - \frac{1}{e^n}$$

So overall, we run a $O(n^2lg(n))$ algorithm $nlg(n)$ times, yielding an overall big oh of $O(n^3(lg(n))^2)$. Contrast this with the $O(n^5)$ algorithm we had originally!

### Reflections

Hopefully this was enlightening. It's a bit nice to see a nontrivial randomized algorithm, isn't it?
