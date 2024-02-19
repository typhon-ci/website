#!/usr/bin/env bash

version="v7.0"
rm -rf themes
mkdir themes
cd themes
curl -L "https://github.com/adityatelange/hugo-PaperMod/tarball/$version" | tar -zx
mv "$(ls)" papermod
