---
layout: post
title: MPD Recently Added Playlists
date: 2015-05-26
---

mpd (which stands for Music Player Daemon) is a commonly-used backend for playing music on Linux systems. I've been using it in conjunction with the ncmpcpp (ncurses-music-player-client-plus-plus) frontend for a while. It's great for a number of reasons.

I've been looking for a way to emulate iTunes's Recently Added playlists for a while and finally sat down to solve the problem.

mpd stores playlists as plain text, stored (on my system) in ~/.config/mpd/playlists as .m3u files. Since it's plain text, we can simply redirect the output of some bash command to a new playlist file.

The command

{% highlight bash %}
find ~/Music -name "*.mp3" -mtime -30 | sort
{% endhighlight %}

does a nice approximation of the functionality for me. The -name flag followed by *.mp3 looks for mp3 files. The -mtime flag followed by -30 asks for files that have been modified in the last 30 days (note this can also mean getting added to the directory).

I chose to pipe this to sort, as I listen to music by album, and all my mp3 files start with their track number. So piping to sort sorts each album internally.

Feels like scratching a long-lasting itch :) This opens up a whole new world of "smart playlists!" You could write some giant, complicated python script, throw it on a cron job, and you have yourself a smart playlist :P

This is why I love mpd + ncmpcpp :)
