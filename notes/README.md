# Checkers

## Usage

Assemble with the following

```sh
./assembler/asm -o <output> -i instructions.csv -r aliases.csv <input>
```

## Implementation

### Conventions

-   The board state is stored as a bitmap with 1s corresponding to locations with pieces. The 0th bit (the LSB) corresponds to the top left square, the 3rd bit is the top right.

### Algorithm

See `legal_move_algorithm.md`

### Reading Player Moves

We do a little memory mapped IO sort of a thing. Reading from `0x10000000` will give you the current player board state.

### Custom Instructions

| Instruction | Name               | OPCode  | Type | Description                                                              |
| ----------- | ------------------ | ------- | ---- | ------------------------------------------------------------------------ |
| `sur`       | Shift up Right     | `10000` | `I`  | Shifts a board state $rs up and to the right 1. Stores the result in $rd |
| `sul`       | Shift up Left      | `10001` | `I`  | Shifts a board state $rs up and to the left 1. Stores the result in $rd  |
| `sura`      | Shift up Right And | `11000` | `R`  | `$rd = $rs & sur($rt)`                                                   |
| `sula`      | Shift up Left And  | `11001` | `R`  | `$rd = $rs & sul($rt)`                                                   |

### Aliases

| Register | Alias        | Purpose              |
| -------- | ------------ | -------------------- |
| `r24`    | `b_player`   | Player Board State   |
| `r25`    | `b_computer` | Computer Board State |
