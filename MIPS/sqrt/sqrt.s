# Author: Tomas Baublys
# Newtons square root approximation in MIPS assembly language

.eqv ITERATIONS 50			# define the number of iterations for sqrt

.data
	input_msg: .asciiz "Enter a number to calculate the square root of:\n"
	output_msg: .asciiz "Result: "	
	one_half: .float 0.5		# constant used for calculations
	initial_guess: .float 1		# initial guess is set to 1 also used for approximating
.globl main

.text

main:
	la $a0, input_msg			# load the address of our messege to a0
	li $v0, 4			# load imm 4 to v0 to make the syscall print string
	syscall				# make the syscall
	
	li $v0, 6			# load imm 6 to v0 to make the syscall read float
	syscall 			# make the syscall 	

	mov.s $f12, $f0			# move our the read number from f0 to f12 to pass it as an argument 	
	jal sqrt			# call the function with the argument in f12
	
	la $a0, output_msg		# load the address of output message to a0
	li $v0, 4			# load imm 4 to v0 to make the syscall print string
	syscall				# make the syscall  
	
	mov.s $f12, $f0			# move the result of the function to f12
	li $v0, 2			# syscall print float
	syscall 			# make the call
	
	#exit
	li $v0, 10
	syscall
	
	
# expects argument to be in f12 register
sqrt:
	li $t0, ITERATIONS		# load the number of iterations for calculating sqrt to t0	
	l.s $f4, initial_guess
	l.s $f10, one_half		# load 1/2 to f10, that will be used for calculations
	
	_sqrt_loop:
	div.s $f5, $f12, $f4		# divided the number by our current iterations x
	add.s $f5, $f4, $f5		# add x to the result of division
	mul.s $f4, $f10, $f5		# multiply the result by 0.5 and set the result to our next generation of x to f4 register
	
	sub $t0, $t0, 1			# subtract one from the counter
	bnez $t0, _sqrt_loop		# if counter is not zero, continue calculating
	
	mov.s $f0, $f4			# move the result to the register f0 (tipically used for returning)
	
	jr $ra				# return to the main function
