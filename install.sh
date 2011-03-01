#!/bin/bash

git submodule update --recursive --init
for file in dot.*; do
    newfile=`echo $file | sed 's/dot//'`
    cp -vri $file ~/$newfile
done
mkdir -p ~/.vim/undo
