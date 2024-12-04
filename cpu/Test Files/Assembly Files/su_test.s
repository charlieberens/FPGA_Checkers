nop
nop
nop
nop

# Intialize the board state
# 1-1-1-1-
# -1-1-1-1
# 0-0-0-0-
# -0-0-0-0
# 0-0-0-0-
# -0-0-0-0
# 1-1-1-1-
# -1-1-1-1
# 11111111000000000000000111111111
# Initialize the registers
addi  $r1, $r0, 255
sll   $r1, $r1, 24
addi  $r1, $r1, 255


sur   $r2, $r1, $r0
sul   $r3, $r1, $r0

not   $r4, $r2, $r0 
not   $r5, $r3, $r0 

and   $r6, $r1, $r4
and   $r7, $r1, $r5