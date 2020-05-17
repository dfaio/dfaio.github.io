# Traversing the Infinite Complete $\omega$-nary Tree

2016-03-03

The infinite complete $\omega$-nary tree is one where every node has $\mathbb{N}$-many children. There are no leaves; the tree just extends downward infinitely. Call this graph $\mathfrak{G}$.

We can't BFS or DFS over $\mathfrak{G}$. A DFS would simply get stuck on the leftmost branch forever and a BFS would never reach depth 2. How then are we to traverse it?

In the infinite complete *binary* tree, nodes are uniquely indentified by a finite length binary string. In $\mathfrak{G}$, nodes are uniquely indentified by a finite sequence of natural numbers. Let $s(v)$ be $v$'s corresponding sequence. In $\mathfrak{G}$, $u$ is the parent of $v$ iff $s(u)$'s length is one less than $s(v)$'s' and $s(u)$ is a prefix of $s(v)$.

Any tree traversal produces a well order on the tree's vertices. BFS on the complete infinite binary tree is the shortlex ordering (sort first by length, then lexographically). In fact, on level $i$, the set of corresponding binary strings is the set of all $i$-bit natural numbers, and the nodes are visited in increasing order.

Further, any tree tree traversal has order type $\omega$.

A traversal of $\mathfrak{G}$ is a well order on the nodes of $\mathfrak{G}$. What does this order look like? Here's the idea (nodes are represented as int tuples):

{% highlight python %}
def traverse():
    visitedNextChild = {() : 0}
    while True:
        currentlyVisited = visitedNextChild.keys()
        for v in currentlyVisited:
            nextChild = v + (visitedNextChild[v],)
            visit(nextChild)
            visitedNextChild[v] += 1
            visitedNextChild[nextChild] = 0
{% endhighlight %}
Here, We start with the root node, which we can represent as the empty tuple. We maintain a mapping from visited nodes to the next child of theirs to visit. At each iteration, we visit each of the prescribed next children, and update the mapping.

The fact that this visits every node in $\mathfrak{G}$ follows easily by induction.

In math symbols, if $S_i$ is the set of visited nodes at iteration $i$, then

$$
\begin{align*}
S_{i+1} = S_i &\cup \{s + 0 \mid s \in S_i \} \\
&\cup \{s_1s_2\ldots (s_n+1)\mid s_1s_2\ldots s_n \in S_i \}
\end{align*}
$$

(there are totally duplicates being added here, but that's the beauty of sets).

Fix the nodes $u = s_1\ldots s_{n-1}$ and $v = s_1\ldots s_{n-1}s_n$. Define $t(x)$ to be the iteration at which $x$ is visited. Then $t(v) = t(u) + s_n + 1$. This leads to this gorgeous fact:

$s_1\ldots s_n$ is visited at iteration $\sum_{i=1}^n (s_i + 1) = n + \sum_{i=1}^n s_i$.

This means that our tree traversal has a pretty interesting sub-relation: namely that $u < v$ if $u$'s length + $u$'s digit sum is less than $v$'s length + $v$'s digit sum. Or, (if we one-index), just the digit sums.

From here on out, we'll one-index for simplicity's sake. (That is, assume $\mathbb{N}$ starts at 1).

Let's see if we can characterize the entire ordering. (That is, instead of building a relation based on iteration, build a relation built on precise ordering of traversal).

It's exactly the same relation, but if they tied, you recurse on the largest proper prefix of each.

{% highlight python %}
def lessThan(u, v):
  # u < v
  return digitSum(u) < digitSum(v) or lessThan(u[::-1], v[::-1])
{% endhighlight %}

So the empty sequence is the least element (as we visit the root of $\mathfrak{G}$ first). I'm fairly certain that if you create the corresponding $\leq$ relation, this becomes a total order.

Here's the cool thing: we've produced an order on $\mathbb{N}^*$ that has order type $\omega$! (The normal shortlex trick doesn't work when our alphabet is countably infinite).

In general, if we want to produce an ordering of order type $\omega$ on $$\mathbb{N}^*$$, it suffices to partition $\mathbb{N}^*$ into countably many partitions, each of finite size. Then the "concatentation" of these partitions yields order type $\omega$.

Just some fun observations :)
