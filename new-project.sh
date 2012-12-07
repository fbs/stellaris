#!/bin/bash

DIR=$1
echo "Copying into $1"
mkdir -p $1/src
cp linker.ld .gitignore Makefile  $1 -r
cp src/startup_gcc.c $1/src/
