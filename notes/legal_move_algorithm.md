We assume the player is moving down the board. Why? This is how it's in my head for whatever reason.

A:

-   `while wait, wait`

Find pieces that could theoretically move down left:

-   Find pieces that are not obstructed by their own color: `my_free_pieces = my_pieces & !my_pieces_shift_up_right`
-   Find pieces that are fully unobstructed: `my_fully_free_pieces = my_free_pieces & !their_pieces_shift_up_right`
-   Find pieces that are only obstructed by the oponent: `my_semi_opp_obstruct_pieces = my_free_pieces & their_pieces_shift_up_right`
    -   Find which of these are fully obstructed: `my_fully_opp_obstruct_pieces = my_semi_opp_obstruct_pieces & their_pieces_shift_up_right_2x`
    -   Find takes: `my_take_pieces = my_semi_opp_obstruct_pieces - my_fully_opp_obstruct_pieces`
    -   `if my_take_pieces != 0`
        -   Set `only_takes = 1`
        -   Choose First Legal Move from my_take_pieces: `j choose_first_legal_move(my_semi_opp_obstruct_pieces, 0)`
    -   `set wait = 1`
    -   `if only_takes: j A`
    -   Set `only_takes = 0`
    -   `if my_fully_free_pieces != 0`
        -   Choose first legal move from my_fully_free_pieces: `j choose_first_legal_move(my_fully_free_pieces, 0)`

B:
Find pieces that could theoretically move down right:
(Do the same as above, but right)

C:
Declare defeat

choose_first_legal_move(candidates, direction, is_a_jump):

```
i = 0
mask = 1
while candidates & mask == 0:
    mask << 1
    i += 1

move_offset = 3 + direction
full_offset = move_offset + move_offset & is_a_jump

add_to_move_array({from=i,to=i+full_offset})
show_from_move_array()
jump A
```
