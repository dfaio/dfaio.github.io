---
layout: post
title: Phone-a-Friend and SUPERHALTS
date: 2015-04-07
---

Deciding things is hard. There are countably many Turing machines, but an uncountable number of decision problems! Sometimes, maybe asking our TM M for a decision is unreasonable - maybe sometimes we should let him phone-a-friend. A reason question to ask is: if our friend always gives us the right answer, is this enough?

We define the phone-a-friend mechanism as follows: our TM M is given access to an *oracle*. The TM may ask the oracle a membership question: is this string \\(w\\) in some set \\(S\\)? The oracle is all-knowing and will return a yes or no answer immediately. The oracle will always answer correctly. We call a Turing machine with access to an oracle an *oracle Turing machine*.

So certainly, all of a sudden, life gets a lot easier! For example, solving HALTS is trivial! Just ask the oracle. But a worthy question is: does there exist a decision problem that an oracle Turing machine can't solve?
