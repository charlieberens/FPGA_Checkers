#!/bin/sh
sed "s/playerb/r24/g" Test\ Files/Assembly\ Files/$1.s > temp_assembly_guy
sed "s/cpub/r25/g" temp_assembly_guy > temp_assembly_guy_1
sed "s/kingb/r26/g" temp_assembly_guy_1 > temp_assembly_guy_2
../assembler/asm -i instructions.csv temp_assembly_guy_2 && mv temp_assembly_guy_2.mem $1.mem
rm temp_assembly_guy
rm temp_assembly_guy_1
rm temp_assembly_guy_2
