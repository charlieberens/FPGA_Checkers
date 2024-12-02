# Processor
## NAME (NETID)
Arnav Ajay (aa695)

## Description of Design
This fully pipelined processor (that also deals with hazards and bypassing) incorporates all components from previous checkpoints (ALU, regfile, and multdiv) within 5 stages to break down and process each instruction (each stage has latches in between them to pass instructions sequentially through the stages, triggered by negative clock cycles since parts such as data memory are not instantaneous and thus need to be on a separate clock cycle in order for each stage to execute correctly without stage delays). 

The first stage is 'fetch' which simply increments the program counter (or changes the program counter if we jump or branch to a different instruction in the code) and extracts the instruction for that specific program count. The next stage is the decode stage, which takes the instruction (which we got from the previous stage) and extracts the register data (from our regfile) that is specified by the instruction (if required, since some instructions do not require register data). The next stage is the execute stage, which houses our ALU and multdiv modules. This stage takes our register data (or sign extended immediate if that is what the instruction specifies) and performs arithmetic and logical operations on this data. Branching and jumping is also handled in this stage (both change the PC, branch uses logic from the ALU to determine when to do so) and the addresses with offset (for lw and sw) are also calculated at this stage. 

The next stage is the memory stage, which is where any memory interactions take place. For instance, for storing something from a register to memory and vice versa, this memory data is taken from here. The final stage is the writeback stage, which is where data from the execude and memory stages are 'written back' to the regfile. Within these stages, there is logic for bypassing (to allow results from the execute, memory, and decode stages to reach their destinations faster without having to go through extra stages unnecessarily, thus avoiding some dependacy issues / hazards in our code) and stalling (in order to avoid hazards), which will be discussed breifly in the next sections.

## Bypassing

Bypassing essentially lets the results from the execute, memory, and decode stages reach their 'destinations' faster and prevents us trying to read from sources that haven't been updated by these stages. This essentially involves results (usually to be written to the destination register later on) being directly passed to either the execute or memory stages if one of their input registers is the same as that destination register (in a later stage). This is done via three main MUXs, one for each of the ALU inputs and one for the input into data memory. 

## Stalling

Stalling aims to avoid hazards that are not taken care of by bypassing by temporarily suspending the program counter and required latches. This is when there is a load instruction followed by another instruction whose input register is the destination register of the load operation. The one case where this is voided is if the second instruction is a store operation, since store is taken care of instantly in the memory stage (no 'delay' in memory stage). The other case of stalling is when a multdiv operation is taking place, in which case the program counter and all program latches not related to the multdiv operation itself are temporarily halted until the result from the multdiv operation is produced.

## Optimizations

This might not be considered an optimization, but I slighly modified the stall logic for multdiv (compared to what is on the slides) to stall all latches when a multdiv operation is taking place. This way, I do not need to extend the MUX in the writeback stage to account for a multdiv result, and I simply say that my multdiv result replaces where my ALU result typically goes during a multdiv instruction.


## Bugs

