#!/bin/bash

for file in dot.*; do
    newfile=`echo $file | sed 's/dot//'`
    echo "cp -vri $file ~/$newfile"
done
