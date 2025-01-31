# RISC-V simple counter program
#
# Stanislav Zhelnio, 2020
#

.text

start:      li a0, 1                   # t0 = 1

push_full:  li a0, 1               # t0 = 1
            sw a0, 0(a0)             # push t0
            li a0, 2                      # t0 = 2
            sw a0, 0(a0)             # push t0
            li a0, 3                      # t0 = 3
            sw a0, 0(a0)             # push t0
            li a0, 4                     # t0 = 4
            sw a0, 0(a0)             # push t0
            li a0, 5                     # t0 = 5
            sw a0, 0(a0)             # push t0

pop_empty: lw a0, 0(a0)      # pop t0
            lw a0, 0(a0)             # pop t0
            lw a0, 0(a0)             # pop t0
            lw a0, 0(a0)             # pop t0

alternating: li a0, 6              # t0 = 6
             sw a0, 0(a0)            # push t0
             lw a0, 0(a0)            # pop t0
             li a0, 7                    # t0 = 7
             sw a0, 0(a0)           # push t0
             lw a0, 0(a0)            # pop t0
             li a0, 8                    # t0 = 8
             sw a0, 0(a0)           # push t0
             lw a0, 0(a0)            # pop t0

loop_test:   beq zero, zero, push_full