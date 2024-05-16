proc_riscv_kass_andra_go

My implementation of RISC-V processor. ISA RV32I. No traps and exceptions.

Моя реализация простейшей однотактоной версии процессора архитектуры RISC-V, соответствующей большей части спецификации ISA RV32I ver. 2.1 (нет поддержки системных команд и обработки исключений).


Процессор поддерживает 37 команд: 

тип R – add, sub, sll, slt, sltu, xor, srl, sra, or, and

тип I – addi, slli, slti, sltui, xori, srli, srai, ori, andi

lw, lh, lb, lhu, lbu

jalr

тип B – beq, bne, blt, bge, bltu, bgeu

тип S – sw, sh, sb

тип J – jal

тип U – lui, auipc
