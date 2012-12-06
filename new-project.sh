#!/bin/bash

DIR=$1
echo "Copying into $1"
mkdir -p $1
cp linker.ld Makefile startup_gcc.c main.c $1 -r
