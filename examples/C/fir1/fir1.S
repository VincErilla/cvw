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


j_loop:
    bge a2, t0, donej
    sw zero, 0(a2) # y{j} = 0
    mv t4, a1 # t4 = a1
    li t3, 0 # t3 = 0
    add t5, a0, t2  # t5 = a0
i_loop:
    bge t4, t1, donei
    lw t6, 0(t4)
    lw a5, 0(t5)
    mul s2, t6, a5
    srai s2, s2, 31
    add t3, t3, s2
    addi t4, t4, 4 # i++
    j i_loop
donei:
    sw t3, 0(a2)
    addi a2, a2, 4 # j++
    j j_loop

donej:
    ret                 # all done; return
