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

    jr $ra

initialize_cpu_pieces:
    addi $playerb, $0, 4095
    sll $playerb, $playerb, 20
    
    addi $cpub, $0, 4095
    
    addi $kingb, $0, 0

    jal update_leds

preparing_for_player_move:
    # Ensure that sensor readings == $playerb | $cpub
    # That is (sensor readings) & ($playerb | $cpub)  == 0
    # Store the sensor readings into $t0
    lw $t0, 1($s0)
    or $t1, $playerb, $cpub

    # TODO - UNCOMMENT
    # bne $t0, $t1, set_board_state_error

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
    j do_move
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
    or $playerb, $s3, $t0

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
    addi $a0, $0, 0
    sw $cpub, 0($s0)

    jal find_and_make_moves

    ### Find and make any right moves
    ## Set Arguments
    addi $a0, $0, 1
    jal find_and_make_moves


 # find_moves(dir (0 left, 1 right))
find_and_make_moves:
    # s2 - Shifted Cpub
    # s3 - Shifted Playerb
    # t0 - ~Shifted Cpub
    # t1 - ~Shifted Playerb

    bne $a0, $0, find_and_make_moves_right
    find_and_make_moves_left:
        sur $s2, $cpub, $0
        sur $s3, $playerb, $0
        j find_and_make_moves_post_side
    find_and_make_moves_right:
        sul $s2, $cpub, $0
        sul $s3, $playerb, $0
    find_and_make_moves_post_side:

    # $t0 = ~shifted_cpub
    # $t1 = ~shifted_playerb
    not $t0, $s2, $0
    not $t1, $s3, $0

    # my_free_pieces ($t2) = $cpub & ~shifted_cpub
    and $t2, $cpub, $t0

    # my_fully_free_pieces ($t3) = my_free_pieces ($t2) & ~shifted_playerb ($t1)
    and $t3, $t2, $t1

    # my_semi_obstruct_pieces ($t4) = my_free_pieces ($t2) & shifted_playerb ($s3)
    and $t4, $t2, $s3

    # TODO - Implement Jumping

    # If there are moves, continue, else return
    bne $t3, $0, find_and_make_moves_cont 
    jr $ra

    find_and_make_moves_cont:
        # mask ($t5) = 0000...1
        # for i < 32:
        #   piece ($a0) = free_pieces($t3) & mask
        #   if piece:
        #       return piece
        #   mask = mask<<1
        #   i -= 1
        addi $t5, $0, 1
        addi $t6, $0, 32

        find_piece_loop:
            and $s1, $t3, $t5
            bne $s1, $0, piece_found

            sll $t5, $t5, 1
            addi $t6, $t6, -1

            bne $t6, $0, find_piece_loop
    
    piece_found:
    # Remove the piece from the cpu board
    not $t5, $s1, $0
    and $cpub, $cpub, $t5

    # Add the moved piece to the cpu board
    bne $a0, $0, is_right 
    is_left:
        sdl $t5, $s1, $0
        j piece_found_post_side
    is_right:
        sdr $t5, $s1, $0
    piece_found_post_side:
    or $cpub, $cpub, $t5

    jal update_leds
    j waiting_for_move_loop

update_leds:
    # Write these to the CPU led register
    sw $playerb, 2($s0)
    sw $cpub, 3($s0)
    sw $kingb, 4($s0)

    jr $ra