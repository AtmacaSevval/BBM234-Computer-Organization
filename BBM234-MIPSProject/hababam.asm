
addi $s2, $0, 0 # i = 0 : i value that for first function 

#s0 : 6(size)
.data
A: .word 720, 480, 80, 3, 1, 0 #input array
str1 : .asciiz "The average similarity score is: " #The string is average value to print to the console
	.text
	.globl main
	
	
main:	la $t1, A  # Load the address of A[0] to register t1
	jal loop
	#finish first function
	
	
	#second function
	la $a0, A # Load the address of A[0] to register a0
	move $a1, $s0 # save the size of array to a1
	jal average # call average
	
	li $v0, 4 # to print string
	la $a0, str1 # print str1 to the console 
	syscall
	
	move $a0, $v1 # save the average value and print to the console
	li $v0, 1
	syscall
	
	li $v0, 10 # exit
  	syscall

# $s0 = ial ntDatasize;
# $s2 = i	

loop:
	slt $t0, $s2, $s0 #compare i and datasize. If i < datasize then 1. Otherwise 0.
	beq $t0, $0, done #if i>= datasize then break the loop
	
	sll $t0, $s2, 2 #4i
	add $t0, $t0, $t1 # the adress of i = 4i + adress of data [0]
	lw $t3, 0($t0) # t3 = data[i] 
	
	rem $t4, $t3, 2 # t4 = data[i] % 2
	bne $t4,0, loop_else  # if data[i] % 2 != 0 then go to else block
	sra $t3, $t3, 3 # otherwise t3 = data[i] * 8 

L1:
	sw $t3, 0($t0) # data[i] = t3
	addi $s2 $s2 1 # increase the "i"
	j loop # go back the loop the calculate other index
	
loop_else:
	sll $t5, $t3, 2 # t5 = t3 * 4
	sll $t6, $t3, 0 # t6 = t3 * 1
	addu $t3, $t5, $t6 # t3 = t5 + t6 = 5 * t3
	j L1
	
	
done:
	jr $ra
	 # return main and execute orher function



# $a0 : int[] data
# $a1 : n
# $s0 : sum
# $s2: average

  	
average:

	addi $sp, $sp, -12 #make space on stack
	sw $s3, 0($sp) # save s3(data[n-1]) on stack because overwrite
	sw $a1, 8($sp) # save a1(n) on stack
	sw $ra, 4($sp) # save $ra on stack
	
	bne $a1, 1, else_average # if n != 1 go to else
	lw $s0, 0($a0) # sum = data[0]
	jal L2 
	
	
else_average:

	addi $t0, $a1, -1 # t0 = n - 1
	
	sll $t0, $t0, 2
	addu $t0, $t0, $a0
	lw $s3 0($t0) # s3 = data[n-1]
	
	addi $a1, $a1, -1 # n = n - 1
	
	jal average # call recursive as a average_recursive(data, n - 1)
	
	lw $a1, 8($sp) # save n to calculate sum
	
	addi $t3, $a1, -1 # t3 = n - 1
	mul $t5, $t3, $v0 #  t3 * v0 = (n - 1)* average_recursive(data, n - 1)
	addu $s0, $s3, $t5 # data[n - 1] + (n - 1)* average_recursive(data, n - 1)
	

	
L2:
	div $s2, $s0, $a1 # average = sum / n;
	move $v0, $s2 # save as a return
	move $v1, $s2 #save v1
	
	lw $s3, 0($sp) # restore on stack 
	lw $a1, 8($sp)
	lw $ra, 4($sp) 
	addi $sp, $sp, 12 #deallocate stack space
	jr $ra # return to caller
