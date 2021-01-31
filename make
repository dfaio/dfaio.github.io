#!/bin/sh
emacsclient -e "(progn (find-file \"index.org\") (org-html-export-to-html) (kill-buffer))" 
emacsclient -e "(progn (find-file \"keys.org\") (org-html-export-to-html) (kill-buffer))" 

