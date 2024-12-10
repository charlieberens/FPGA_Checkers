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
    #00000000000000000010110111111111 11775
    #11111111110000110000000000000000 65475 << 16
    addi $playerb, $0, 65475
    sll $playerb, $playerb, 16
    # addi $playerb, $0, 4095
    # sll $playerb, $playerb, 20
    
    addi $cpub, $0, 11775
    
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

    # Get updated pieces
    jal get_updated_board_from_sensor_reading
    
    # Update the leds
    add $a0, $v0, $0
    add $a1, $v1, $0
    add $a2, $0, $0
    jal update_leds_w_args

    # Check if the button is pressed
    lw $t0, 5($s0)
    bne $t0, $0, waiting_for_move_loop_button_has_been_pressed
    j waiting_for_move_loop

    waiting_for_move_loop_button_has_been_pressed:
        # Update the board state
        add $playerb, $v0, $0
        add $cpub, $v1, $0
        add $kingb, $0, $0 # TODO - Implement kings

        j do_move

# This will find cpub_new and playerb_new based on a sensor reading returns (playerb_new, cpub_new)
get_updated_board_from_sensor_reading:
    # Player pieces = sensor_reading & ~cpub
    lw $t0, 1($s0)
    add $t1, $playerb, $0 
    add $t2, $cpub, $0

    not $t3, $cpub, $0
    and $v0, $t0, $t3

    # Remove all places with no pieces
    and $v0, $v0, $t0 
    and $v1, $playerb, $t0 

    jr $ra

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
    # s4 - Double Shifted playerb

    bne $a0, $0, find_and_make_moves_right
    find_and_make_moves_left:
        sur $s2, $cpub, $0
        sur $s3, $playerb, $0
        
        sur $s4, $s3, $0

        j find_and_make_moves_post_side
    find_and_make_moves_right:
        sul $s2, $cpub, $0
        sul $s3, $playerb, $0

        sul $s4, $playerb, $0
        sul $s4, $s4, $0
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

    # my_fully_obstructed_pieces ($t5) = my_semi_obstruct_pieces & shifted_playerb_2x ($s4)
    and $t5, $t4, $s4

    # my_take_pieces ($t5) = my_semi_opp_obstruct_pieces ($t4) & ~my_fully_opp_obstruct_pieces ($t5)
    not $t5, $t5, $0
    and $t5, $t5, $t4

    bne $t5, $0, handle_jump_moves

    # If there are fully free moves, continue, else return
    bne $t3, $0, handle_not_jump_moves 
    jr $ra


update_leds_and_return:
    jal update_leds
    j waiting_for_move_loop

find_piece_loop:
    # mask ($t5) = 0000...1
    # for i < 32:
    #   piece ($v0) = candidates($a0) & mask
    #   if piece:
    #       return piece
    #   mask = mask<<1
    #   i -= 1
    addi $t5, $0, 1
    addi $t6, $0, 32

    find_piece_loop_inner:
        and $v0, $a0, $t5
        bne $v0, $0, piece_found

        sll $t5, $t5, 1
        addi $t6, $t6, -1

        bne $t6, $0, find_piece_loop_inner
    piece_found: jr $ra

handle_not_jump_moves:
    # my fully free pieces ($t3)
    add $a0, $t3, $0

    # addi $sp, $sp, -1
    # sw $ra, 0($sp)
    jal find_piece_loop
    # lw $ra, 0($sp)
    # addi $sp, $sp, 1

    # Remove the piece from the cpu board
    not $t5, $v0, $0
    and $cpub, $cpub, $t5

    # Add the moved piece to the cpu board
    bne $a0, $0, is_right 
    is_left:
        sdr $t5, $v0, $0
        j piece_found_post_side
    is_right:
        sdl $t5, $v0, $0
    piece_found_post_side:
    or $cpub, $cpub, $t5

    j update_leds_and_return

handle_jump_moves:
    # my take pieces ($t5)
    add $a0, $t5, $0

    # addi $sp, $sp, -1
    # sw $ra, 0($sp)
    jal find_piece_loop
    # lw $ra, 0($sp)
    # addi $sp, $sp, 1

    # Remove the piece from the cpu board
    not $t5, $v0, $0
    and $cpub, $cpub, $t5

    # Add the moved piece to the cpu board, remove the taken piece from the player's board
    bne $a0, $0, is_right 
    is_left:
        sdr $t5, $v0, $0
        sdr $t6, $t5, $0

        j piece_found_post_side
    is_right:
        sdl $t5, $v0, $0
        sdl $t6, $t5, $0
    piece_found_post_side:

    not $t5, $t5, $0
    and $playerb, $playerb, $t5
    or $cpub, $cpub, $t6

    j update_leds_and_return

update_leds:
    # Write these to the CPU led register
    sw $playerb, 2($s0)
    sw $cpub, 3($s0)
    sw $kingb, 4($s0)

    jr $ra

# Same as update_leds but uses arguments
update_leds_w_args:
    sw $a0, 2($s0)
    sw $a1, 3($s0)
    sw $a2, 4($s0)

    jr $ra
