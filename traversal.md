---
css: 'mnml.css'
generator: pandoc
...

Traversing the Infinite Complete <span class="math inline">*ω*</span>-nary Tree {#traversing-the-infinite-complete-omega-nary-tree}
===============================================================================

2016-03-03

The infinite complete <span class="math inline">*ω*</span>-nary tree is
one where every node has <span class="math inline">ℕ</span>-many
children. There are no leaves; the tree just extends downward
infinitely. Call this graph <span class="math inline">𝔊</span>.

We can't BFS or DFS over <span class="math inline">𝔊</span>. A DFS would
simply get stuck on the leftmost branch forever and a BFS would never
reach depth 2. How then are we to traverse it?

In the infinite complete *binary* tree, nodes are uniquely indentified
by a finite length binary string. In <span class="math inline">𝔊</span>,
nodes are uniquely indentified by a finite sequence of natural numbers.
Let <span class="math inline">*s*(*v*)</span> be <span
class="math inline">*v*</span>'s corresponding sequence. In <span
class="math inline">𝔊</span>, <span class="math inline">*u*</span> is
the parent of <span class="math inline">*v*</span> iff <span
class="math inline">*s*(*u*)</span>'s length is one less than <span
class="math inline">*s*(*v*)</span>'s' and <span
class="math inline">*s*(*u*)</span> is a prefix of <span
class="math inline">*s*(*v*)</span>.

Any tree traversal produces a well order on the tree's vertices. BFS on
the complete infinite binary tree is the shortlex ordering (sort first
by length, then lexographically). In fact, on level <span
class="math inline">*i*</span>, the set of corresponding binary strings
is the set of all <span class="math inline">*i*</span>-bit natural
numbers, and the nodes are visited in increasing order.

Further, any tree tree traversal has order type <span
class="math inline">*ω*</span>.

A traversal of <span class="math inline">𝔊</span> is a well order on the
nodes of <span class="math inline">𝔊</span>. What does this order look
like? Here's the idea (nodes are represented as int tuples):

{% highlight python %} def traverse(): visitedNextChild = {() : 0} while
True: currentlyVisited = visitedNextChild.keys() for v in
currentlyVisited: nextChild = v + (visitedNextChild\[v\],)
visit(nextChild) visitedNextChild\[v\] += 1
visitedNextChild\[nextChild\] = 0 {% endhighlight %} Here, We start with
the root node, which we can represent as the empty tuple. We maintain a
mapping from visited nodes to the next child of theirs to visit. At each
iteration, we visit each of the prescribed next children, and update the
mapping.

The fact that this visits every node in <span
class="math inline">𝔊</span> follows easily by induction.

In math symbols, if <span class="math inline">*S*~*i*~</span> is the set
of visited nodes at iteration <span class="math inline">*i*</span>, then

\
<span class="math display">\$\$ \\begin{align\*} S\_{i+1} = S\_i &\\cup
\\{s + 0 \\mid s \\in S\_i \\} \\\\ &\\cup \\{s\_1s\_2\\ldots
(s\_n+1)\\mid s\_1s\_2\\ldots s\_n \\in S\_i \\} \\end{align\*}
\$\$</span>\

(there are totally duplicates being added here, but that's the beauty of
sets).

Fix the nodes <span class="math inline">*u* = *s*~1~…*s*~*n* − 1~</span>
and <span class="math inline">*v* = *s*~1~…*s*~*n* − 1~*s*~*n*~</span>.
Define <span class="math inline">*t*(*x*)</span> to be the iteration at
which <span class="math inline">*x*</span> is visited. Then <span
class="math inline">*t*(*v*)=*t*(*u*)+*s*~*n*~ + 1</span>. This leads to
this gorgeous fact:

<span class="math inline">*s*~1~…*s*~*n*~</span> is visited at iteration
<span class="math inline">\$\\sum\_{i=1}\^n (s\_i + 1) = n +
\\sum\_{i=1}\^n s\_i\$</span>.

This means that our tree traversal has a pretty interesting
sub-relation: namely that <span class="math inline">*u* &lt; *v*</span>
if <span class="math inline">*u*</span>'s length + <span
class="math inline">*u*</span>'s digit sum is less than <span
class="math inline">*v*</span>'s length + <span
class="math inline">*v*</span>'s digit sum. Or, (if we one-index), just
the digit sums.

From here on out, we'll one-index for simplicity's sake. (That is,
assume <span class="math inline">ℕ</span> starts at 1).

Let's see if we can characterize the entire ordering. (That is, instead
of building a relation based on iteration, build a relation built on
precise ordering of traversal).

It's exactly the same relation, but if they tied, you recurse on the
largest proper prefix of each.

{% highlight python %} def lessThan(u, v): \# u &lt; v return
digitSum(u) &lt; digitSum(v) or lessThan(u\[::-1\], v\[::-1\]) {%
endhighlight %}

So the empty sequence is the least element (as we visit the root of
<span class="math inline">𝔊</span> first). I'm fairly certain that if
you create the corresponding <span class="math inline">≤</span>
relation, this becomes a total order.

Here's the cool thing: we've produced an order on <span
class="math inline">ℕ^\*^</span> that has order type <span
class="math inline">*ω*</span>! (The normal shortlex trick doesn't work
when our alphabet is countably infinite).

In general, if we want to produce an ordering of order type <span
class="math inline">*ω*</span> on\
<span class="math display">ℕ^\*^</span>\
, it suffices to partition <span class="math inline">ℕ^\*^</span> into
countably many partitions, each of finite size. Then the
"concatentation" of these partitions yields order type <span
class="math inline">*ω*</span>.

Just some fun observations :)
