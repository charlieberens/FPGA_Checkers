#!/bin/sh
../assembler/asm -i instructions.csv -r aliases.csv Test\ Files/Assembly\ Files/$1.s && mv Test\ Files/Assembly\ Files/$1.mem $1.mem
