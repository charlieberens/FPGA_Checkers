#!/bin/sh
sed "s/playerb/r24/g" "Test\ Files/Assembly\ Files/$1.s" > "temp_assembly_guy"
sed "s/cpub/r25/g" "temp_assembly_guy" > "temp_assembly_guy"
sed "s/kingb/r26/g" "temp_assembly_guy" > "temp_assembly_guy"
# ../assembler/asm -i instructions.csv -r aliases.csv Test\ Files/Assembly\ Files/$1.s && mv Test\ Files/Assembly\ Files/$1.mem $1.mem
# ../assembler/asm -i instructions.csv -r aliases.csv temp_assembly_guy && mv $1.mem
