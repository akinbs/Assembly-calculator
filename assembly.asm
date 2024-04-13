.data 
string1: .asciiz "Enter the first number: \n"
UserOperator: .asciiz "Choose an operation: \n" 
string2: .asciiz "Enter the second number: \n" 
result: .asciiz "Result: \n" 
newline: .asciiz "\n"
errmsg: .asciiz "ERROR! Wrong operation type. Try: +, -, *, / \n" 
carrymsg: .asciiz "Remainder from division \n" 

operand1: .word 1 
operand2: .word 1 
operator: .word 2 

out_sum: .word 1 
out_sub: .word 1 
out_mul: .word 1 
out_div: .word 1 
carry: .word 1 

.text 

main: 
    # First operand message 
    li $v0, 4  
    la $a0, string1 
    syscall 
    # Input first operand 
    li $v0, 5 
    syscall 

    sw $v0, operand1 

optype: 
    li $v0, 4 
    la $a0, UserOperator
    syscall 
    # Operator selection 
    la $a0, operator
    la $a1, 2 
    li $v0, 8
    syscall 
    lw $t0, 0($a0) 

    # Newline 
    li $v0, 4 
    la $a0, newline 
    syscall  

    # Operation control 
    li $t1, '+' 
    li $t2, '-' 
    li $t3, '*' 
    li $t4, '/'  

    beq $t0, $t1, do_addition 
    beq $t0, $t2, do_subtraction
    beq $t0, $t3, do_multiplication 
    beq $t0, $t4, do_division  
    j err

do_addition:
    li $v0, 4 
    la $a0, string2 
    syscall 

    li $v0, 5 
    syscall 
    sw $v0, operand2

    lw $s1, operand1 
    lw $s2, operand2 
    add $s3, $s1, $s2 

    li $v0, 4 
    la $a0, result
    syscall 
    li $v0, 1
    move $a0, $s3
    syscall  
    li $v0, 4 
    la $a0, newline
    syscall
    j main

do_subtraction:
    li $v0, 4 
    la $a0, string2 
    syscall 

    li $v0, 5 
    syscall 
    sw $v0, operand2

    lw $s1, operand1 
    lw $s2, operand2 
    sub $s3, $s1, $s2 

    li $v0, 4 
    la $a0, result
    syscall 
    li $v0, 1
    move $a0, $s3
    syscall  
    li $v0, 4 
    la $a0, newline
    syscall
    j main

do_multiplication:
    li $v0, 4 
    la $a0, string2 
    syscall 

    li $v0, 5 
    syscall 
    sw $v0, operand2

    lw $s1, operand1 
    lw $s2, operand2 
    mult $s1, $s2 
    mflo $s3 

    li $v0, 4 
    la $a0, result
    syscall 
    li $v0, 1
    move $a0, $s3
    syscall  
    li $v0, 4 
    la $a0, newline
    syscall
    j main

do_division:
    li $v0, 4 
    la $a0, string2 
    syscall 

    li $v0, 5 
    syscall 
    sw $v0, operand2

    lw $s1, operand1 
    lw $s2, operand2 
    div $s1, $s2 
    mflo $s3 
    mfhi $s4 
    sw $s4, carry

    li $v0, 4 
    la $a0, carrymsg
    syscall 
    li $v0, 1
    move $a0, $s3
    syscall  

    li $v0, 4 
    la $a0, result
    syscall 
    li $v0, 1
    move $a0, $s3
    syscall  
    li $v0, 4 
    la $a0, newline
    syscall
    j main

err: 
    li $v0, 4 
    la $a0, errmsg 
    syscall 
    j optype
