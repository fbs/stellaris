#!/bin/bash

DIR=$1
echo "Creating a new project in $1"
mkdir -p $1
git init $1
cp linker.ld .gitignore Makefile startup_gcc.c  $1 -r
cp template.x $1/main.c
sed -i s/uartstdio.c// $1/Makefile
