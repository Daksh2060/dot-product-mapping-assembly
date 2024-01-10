    .section .note.GNU-stack,"" 
    .global dot_double, map_poly_double, dot_single, map_poly_single, sin_x87
    .text


dot_double:

    mov $0, %r10             #set index counter to 0       
    pxor %xmm0, %xmm0        #set return register to 0           

dot_double_loop:    

    cmp %r10, %rdx           #check to see if array end is reached         
    je end_dot_double                            

    movq (%rdi), %xmm1       #move values from arrays into registers             
    movq (%rsi), %xmm2                     

    mulsd %xmm1, %xmm2       #multiply the two values and add them to the total              
    addsd %xmm2, %xmm0                   

    add $8, %rdi             #increment arrays to next index and increment counter             
    add $8, %rsi
    inc %r10                            

    jmp dot_double_loop                        

end_dot_double:

    ret





dot_single:

    mov $0, %r10              
    pxor %xmm0, %xmm0                     

dot_single_loop:    

    cmp %r10, %rdx                     
    je end_dot_single                            

    movd (%rdi), %xmm1      #changed movq to movd               
    movd (%rsi), %xmm2                     

    mulss %xmm1, %xmm2      #changed mulsd to mulss                     
    addss %xmm2, %xmm0      #changed addsd to addss            

    add $4, %rdi            #increment array pointers by 4 bytes instead of 8            
    add $4, %rsi
    inc %r10                            

    jmp dot_single_loop                        

end_dot_single:

    ret





map_poly_double:

    mov $0, %r9                 #set index counter to 0

poly_loop_double:

    cmp %r9, %rdx               #check if end of array reached
    je end_poly_double

    movq (%rdi), %xmm8          #move double value of x from array to fp register

    mulsd %xmm0, %xmm8          #multiply x by a
    addsd %xmm1, %xmm8          #add b to product

    mulsd (%rdi), %xmm8         #multiply total by x
    addsd %xmm2, %xmm8          #add c to product

    mulsd (%rdi), %xmm8         #mutiply total by x
    addsd %xmm3, %xmm8          #add d to product

    movq %xmm8, (%rsi)          #move total result into output array

    add $8, %rdi                #incrment both arrays and index counter
    add $8, %rsi
    add $1, %r9

    jmp poly_loop_double

end_poly_double:

    ret





map_poly_single:

    mov $0, %r9 

poly_loop_single:

    cmp %r9, %rdx
    je end_poly_single

    movd (%rdi), %xmm8          #changed all movq to movd

    mulss %xmm0, %xmm8          #changed all mulsd to mulss
    addss %xmm1, %xmm8          #changed all addsd to addss

    mulss (%rdi), %xmm8
    addss %xmm2, %xmm8

    mulss (%rdi), %xmm8
    addss %xmm3, %xmm8

    movd %xmm8, (%rsi)

    add $4, %rdi                #add 4 bytes to array pointers instead of 8 to increment
    add $4, %rsi
    add $1, %r9

    jmp poly_loop_single

end_poly_single:

    ret





sin_x87:
    mov $0, %rcx
s87_loop:
    cmp %rdx, %rcx
    jae s87_ret
    fldl (%rdi, %rcx, 8)
    fsin
    fstpl (%rsi, %rcx, 8)
    inc %rcx
    jmp s87_loop
s87_ret:
    ret