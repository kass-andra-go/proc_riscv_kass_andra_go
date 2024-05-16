#test program
addi t0, zero, 9
addi t1, zero, 3
m1:
sub t0, t0, t1
beq t0, zero, m2
jal zero, m1
m2:
addi zero, zero, 0
