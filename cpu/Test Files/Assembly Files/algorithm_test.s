nop
nop
nop
nop

# Load 0x10000000 into $s0 
addi $s0, $0, 1
sll $s0, $s0, 7

##########################################
# Initialize CPU Pieces, and King
##########################################

initialize_cpu_pieces:
    # Initialize CPU pieces
    addi $cpub, $0, 255
    sll $cpub, $cpub, 24

    # Write these to the opponent led register
    sw $cpub, 2($s0)

    # Write the blank king bitmap to the LED king register
    addi $kingb, $0, 0
    sw $kingb, 3($s0) 

    ##########################################
    # while(it is time for the player_to move)
    #   check is it time for the computer to move
    ##########################################

waiting_for_move_loop:

    # Store "whether it's time for the computer to move" into $t0
    lw $t0, 1($s0)

    # If it is 1, exit the loop. Otherwise, loop again.
    bne $t0, $0, do_move
    j waiting_for_move_loop

##########################################
# Find pieces that could theoretically move down left
##########################################

do_move:
    # Load player pieces in to $r24
    lw $playerb, 0($s0)

    ### Find and make any left moves
    ## Set Arguments
    # $a0 = sur(cpub)
    # $a1 = sur(playerb)
    sur $a0, $cpub, $0
    sur $a1, $playerb, $0
    jal find_and_make_moves

    ### Find and make any right moves
    ## Set Arguments
    # $a0 = sul(cpub)
    # $a1 = sul(playerb)
    sul $a0, $cpub, $0
    sul $a1, $playerb, $0
    jal find_and_make_moves

 # find_moves(shifted_cpub, shifted_playerb, shifted_cpub_2x, shifted_playerb_2x)
find_and_make_moves:
    # $t0 = ~shifted_cpub
    # $t1 = ~shifted_playerb
    not $t0, $a0, $0
    not $t1, $a1, $0

    # my_free_pieces ($t2) = $cpub & ~shifted_cpub
    and $t2, $cpub, $t0

    # my_fully_free_pieces ($t3) = my_free_pieces ($t2) & ~shifted_playerb ($t1)
    and $t3, $t2, $t1

    # my_semi_obstruct_pieces ($t4) = my_free_pieces ($t2) & shifted_playerb ($a1)
    and $t4, $t2, $a1

    # TODO - Implement Jumping

    # Set it_is_time_for_the_computer_to_move to 0
    lw $0, 1($s0)


