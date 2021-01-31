#!/bin/sh
emacsclient -e "(progn (find-file \"index.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"thon.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"keys.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"rpg.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"superhalts.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"quine.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"tree.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"readchinese.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"books.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"cooking.org\") (org-html-export-to-html) (kill-buffer))" 

