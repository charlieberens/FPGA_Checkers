nop
nop
nop
nop

# Load 0x10000000 into $s0 
addi $s0, $0, 1
sll $s0, $s0, 12

j initialize_cpu_pieces

##########################################
# Initialize CPU Pieces, and King
##########################################
sleep:    
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    addi $t0, $0, 1
    sub $a0, $a0, $t0

    blt $a0, $0, sleep

    j ra

check_non_zero:
    j $ra

initialize_cpu_pieces:
    # Initialize CPU pieces
    addi $cpub, $0, 4095
    sll $cpub, $cpub, 24

    # Write these to the CPU led register
    sw $cpub, 3($s0)

    # Initialize Player pieces
    addi $playerb, $0, 4095

    # Write these to the player led register
    sw $playerb, 2($s0)

    # Write the blank king bitmap to the LED king register
    sw $kingb, 4($s0)

preparing_for_player_move:
    # Ensure that sensor readings == $playerb | $cpub
    # That is (sensor readings) & ($playerb | $cpub)  == 0
    # Store the sensor readings into $t0
    lw $t0, 1($s0)
    or $t1, $playerb, $cpub
    bne $t0, $t1, set_error

    # Clear the initialization error
    sw $0, 0($s0)

    # Wait for move
    j waiting_for_move_loop

set_board_state_error:
    addi $t0, $0, 1
    sw $t0, 0($s0)
    j preparing_for_player_move

##########################################
# while(it is time for the player_to move)
#   check is it time for the computer to move
##########################################
waiting_for_move_loop:
    # Store the old board state in $s1
    lw $s1, 1($s0)

    addi $a0, $0, 100000
    j sleep

    # Store the new board state in $s2
    lw $s2, 1($s0)

    bne $s1, $t0, waiting_for_move_loop_continuing
    j waiting_for_move_loop

    waiting_for_move_loop_continuing:
        addi $a0, $0, 100000
        j sleep

        # Store the old board state in $s1
        add $s1, $s2, $0

        # Store the new board state in $s2
        lw $s2, 1($s0

        # If the state has changed, we check again
        bne $s1, $s2, waiting_for_move_loop_continuing

        # If the state hasn't changed, the move has been made
        j update_board_from_player_move

##########################################
# Using the new sensor readings, update the board according to the players move
##########################################
update_board_from_player_move:
    # Store sensor_reading in $s1, $cpub (old) in $s2, $playerb (old) in $s3
    lw $s1, 1($s0)
    add $s2, $cpub, $0
    add $s3, $playerb, $0

    # Moved player piece = sensor_reading & ~(old_player_board | old_cpu_board)
    or $t0, $s2, $s3
    not $t0, $t0, $0
    and $t0, $s1, $t0
    # Add this to the player board
    or $playerb, $s3, $ t0

    # Moved player piece gap = ~sensor_reading & old_player_board
    not $t0, $s1, $0
    and $t1, $t0, $s3
    # Remove this from the player board
    not $t1, $t1, $0
    and $playerb, $t1, $0

    # Opponent Taken Pieces = ~sensor_reading & old_cpu_board
    not $t0, $s1, $0
    and $t1, $t0, $s2
    # Remove this from the cpu board
    not $t1, $t1, $0
    and $cpub, $t1, $0

##########################################
# Find pieces that could theoretically move down left
##########################################
do_move:
    # Load player pieces in to $r24
    lw $playerb, 2($s0)

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

    # If there are moves, continue, else return
    bne $t3, $0, find_and_make_moves_cont 
    jr $ra

    find_and_make_moves_cont:
        # mask ($t5) = 0000...1
        # for i < 32:
        #   piece ($a0) = free_pieces($t2) & mask
        #   if piece:
        #       return piece
        #   mask = mask<<1
        #   i -= 1
        addi $t5, $0, 1
        addi $t6, $0, 32

        find_piece_loop:
            and $a0, $t2, $t5
            bne $a0, $0, piece_found
        
            sll $t5, $t5, 1
            addi $t6, $t6, -1

            bne $t6, $0, find_piece_loop
        


    # Set it_is_time_for_the_computer_to_move to 0
    lw $0, 1($s0)

piece_found:


