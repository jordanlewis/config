#!/bin/bash

git submodule update
for file in dot.*; do
    newfile=`echo $file | sed 's/dot//'`
    echo "cp -vri $file ~/$newfile"
done
mkdir -p ~/.vim/undo
