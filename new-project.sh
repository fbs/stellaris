#!/bin/bash

DIR=$1
echo "Creating a new project in $1"
mkdir -p $1/src
cp linker.ld .gitignore Makefile  $1 -r
cp src/startup_gcc.c $1/src/
cp src/template.x $1/src/main.c
sed -i s/uartstdio.c// $1/Makefile
