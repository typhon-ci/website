#!/usr/bin/env bash

rm -rf themes
mkdir themes
cd themes
curl -L "https://github.com/adityatelange/hugo-PaperMod/tarball/master" | tar -zx
mv "$(ls)" papermod
