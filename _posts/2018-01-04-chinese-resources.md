---
layout: post
title: Chinese Learning Resources
permalink: chinese-resources
date: 2018-01-04
---

I've spent many hours honing my learning-Chinese setup, and this page is intended to share some of the resources I've found.

## Define-on-highlight in Kindle (with pinyin)

I consider highlight-on-lookup an essential feature for reading 'real' Chinese long-form material. I don't have the patience to handwrite characters into Pleco every time I don't understand what's going on. This problem is solved with the following (very-very-very-critical-to-my-life) file [here]. It's mobi file for the English-Chinese dictionary CC-CEDICT.

I put this file in the documents/dictionaries directory on my Kindle; it might be different for your e-reader. If your e-reader doesn't support mobi, I suggest the wonderful tool ebook-convert as a means to convert it to epub.

This isn't a perfect solution; CC-CEDICT is probably my least favorite English-Chinese dictionary around, but I have been unable to find any other dictionaries in electronic form. The Kindle has a English-Chinese dictionary by default, but for baffling reasons, it does not include pinyin.

Another good approach could be add pinyin to the builtin Kindle dictionary, but the file format might be obsfucated.

## Programmatically collecting vocab words from books

ChineseTextAnalyzer is the best program of this type I've seen so far (shout out to the incredible 书博 for telling me about this one). It does a lot of stuff, but I'll just outline my favorite part here.

You feed it a text file and it splits the file up into words (presumably with longest-match against CC-CEDICT). Based on a set of 'known words,' ChineseTextAnalyzer can give you a list of unknown words from the corpus, sorted by frequency of appearance in the text. It's then super easy to export these words into a CSV file and import into Anki.

I find this method of gathering vocab to be much more motivating that studying lists of words from a textbook. This way, I get longer-form reading with content I'm interested in, and a vocab list custom-tailored to the content I want to consume.