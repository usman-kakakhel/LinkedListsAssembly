#	prog.asm - Multiplies and divides recursively
#

#	Text Segment
	.text
main:
	menuL:	la $a0, msg3		#Output message
		li $v0, 4
		syscall
	
		li $v0, 5		#Input the menu choice
		syscall
		move $s0, $v0
		
	m1:	bne $s0, 1, m2
		la $a0, msg4		#Output message to enter number for multiply
		li $v0, 4
		syscall
		
		li $v0, 5		#Input the first number
		syscall
		move $s1, $v0
		
		
		addi $a0, $0, 1
		move $a1, $s1
		jal multi		#call multiply function
		move $s2, $a0
		
		la $a0, msg9		
		li $v0, 4
		syscall			#print the answer of multiplication
		move $a0, $s2
		li $v0, 1		
		syscall
		
		
	m2:	bne $s0, 2, m3
		la $a0, msg5		#Output message
		li $v0, 4
		syscall
		
		li $v0, 5		#Input divident
		syscall
		move $s1, $v0
		
		la $a0, msg6		#Output divisor message
		li $v0, 4
		syscall
		
		li $v0, 5		#Input divisor
		syscall
		move $s2, $v0
		
		move $a0, $s1		#a0 has the remainder
		move $a1, $0		#a1 has the quotient
		move $a2, $s2		#s2 has the divisor
		jal divid
		move $s3, $a0
		move $s4, $a1
		
		la $a0, msg8	
		li $v0, 4
		syscall			#print remainder
		move $a0, $s3
		li $v0, 1
		syscall			
		
		
		la $a0, msg7		
		li $v0, 4
		syscall			#print quotient
		move $a0, $s4
		li $v0, 1		
		syscall
			
		
	m3:	beq $s0, 3, mDone
		j menuL
		
mDone:	li $v0, 10		#Exit program
	syscall


#	Methods
divid:
	blt $a0, $a2, recEnd	#if divisor is less than divident, end recursive calls
	sub $a0, $a0, $a2	#subtratact divisor from divident
	addi $a1, $a1, 1	#add 1 in quotient
	
	
recur:	addi $sp, $sp, -4	#save ra to stack
	sw $ra, 0($sp)
	jal divid		#call recursive
	lw $ra, 0($sp)
	addi $sp, $sp, 4	#load ra
recEnd:

		
divE:	
	jr $ra


multi:
	addi $t1, $0, 10		#find last digit of number
	div $t0, $a1, $t1		#by finding modulus of number
	mul $t2, $t0, $t1
	sub $t3, $a1, $t2
	beqz $t0, recEnd1		#if one number left in integer, exit recursive calls
	
	sub $a1, $a1, $t3		#truncate the last digit from the number
	div $a1, $a1, $t1
	
recur1:	addi $sp, $sp, -8		#save ra to stack
	sw $ra, 0($sp)			#save $t3 to stack for further use
	sw $t3, 4($sp)
	jal multi			#call recursive
	lw $t3, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8		#load ra
recEnd1:

	mul $a0, $a0, $t3		#multiply $t3 with answer

mulEnd:
	jr $ra

	#addi $sp, $sp, -8	#save only s0 and s1 to stack
	#sw $s0, 0($sp)
	#sw $s1, 4($sp)
	
	#lw $s0, 0($sp)		#load s0 and s1 from stack
	#lw $s1, 4($sp)
	#addi $sp, $sp, 8

#	Data Segment
	.data
newL:	.asciiz "\n"
msg3:	.asciiz	"\n\nMenu:\n1- Multiply.\n2- Divide.\n3- Exit.\nEnter your choice:\n"
msg4:	.asciiz	"\nEnter Number to Multiply.\n"
msg5:	.asciiz	"\nEnter Divident.\n"
msg6:	.asciiz	"\nEnter Divisor.\n"
msg7:	.asciiz	"\nThe Quotient is: "
msg8:	.asciiz	"\nThe remainder is: "
msg9:	.asciiz	"\nThe multiple is: "
# 	End Of Prelim.asm