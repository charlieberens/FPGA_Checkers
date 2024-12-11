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

| Instruction | Name             | ALU OPCode | Type | Description                                                              |
| ----------- | ---------------- | ---------- | ---- | ------------------------------------------------------------------------ |
| `not`       | Bitwise Not      | `01000`    | `R`  | $rd = ~rs                                                                |
| `sur`       | Shift up Right   | `01110`    | `R`  | Shifts a board state $rs up and to the right 1. Stores the result in $rd |
| `sul`       | Shift up Left    | `01111`    | `R`  | Shifts a board state $rs up and to the left 1. Stores the result in $rd  |
| `sdr`       | Shift down Right | `11110`    | `R`  |                                                                          |
| `sdl`       | Shift Down Left  | `11111`    | `R`  |                                                                          |

### Aliases

| Register | Alias     | Purpose              |
| -------- | --------- | -------------------- |
| `r24`    | `playerb` | Player Board State   |
| `r25`    | `cpub`    | Computer Board State |
| `r26`    | `kingb`   | King Board State     |

### Fake Memory Locations

| Location | Function                                           | Usage     |
| -------- | -------------------------------------------------- | --------- |
| `0x1000` | Status Register. 0 for all good.                   | R/W       |
| `0x1001` | Latest Sensor Reading                              | Read Only |
| `0x1002` | Connects to the LED Player piece Location Register | R/W       |
| `0x1003` | Connects to the LED CPU piece Location Register    | R/W       |
| `0x1004` | Connects to the LED king Location Register         | R/W       |
| `0x1005` | Value of the button register                       | R         |
