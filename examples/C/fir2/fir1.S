# fir.S
# assembly language of Finite Impulse Response (FIR)

// a0: base address of x
// a1: base address of c
// a2: base address of y, later used as pointer to y[j] in j loop
// a3: n
// a4: m

// t0: &y[n-m+1] to check termination of j loop
// t1: &c[m] to check termination of i loop
// t2: &x[j+m-1]
// t3: sum
// t4: pointer to c[i] in i loop
// t5: pointer to x[j-i+(m-1)]
// t6: value of c[i]
// a5: value of x[j-i+(m-1)]

.global fir


fir:
    sub t0, a3, a4 # t0 = n-m
    addi t0, t0, 1 # t0 = t0+1
    slli t0, t0, 2
    add t0, a2, t0
    slli t1, a4, 2 # t1 = a4*4
    add t1, a1, t1 # t1 = a1+t1
    mv t2, a2


j_loop:
    bge a2, t0, donej
    li t3, 0
    mv t4, a1 # t4 = a1
    sub t6, a2, t2
    add t5, a0, t6
    addi t6, a4, -1
    slli t6, t6, 2
    add t5, t5, t6

i_loop:
    bge t4, t1, donei
    lw t6, 0(t4)
    lw a5, 0(t5)
    mul a6, t6, a5
    srai a6, a6, 31
    add t3, t3, a6
    addi t4, t4, 4 # i++
    addi t5, t5, -4
    j i_loop

donei:
    sw t3, 0(a2)
    addi a2, a2, 4 # j++
    j j_loop

donej:
    ret                 # all done; return
