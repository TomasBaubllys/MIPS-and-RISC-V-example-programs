.eqv ITERATIONS 50			# define the number of iterations for sqrt

.data
	number: .float 13.13
	one_half: .float 0.5
	initial_guess: .float 3.7
.globl main

.text

main:
	la $t0, number			# load the address of the number in the data segment to t0
	l.s $f12, number		# load the floating point value to f12 register to pass to the sqrt functiom	
	jal sqrt			# call the function with the argument in f12
	
	mov.s $f12, $f0			# move the result of the function to f12
	li $v0, 2			# syscall print float
	syscall 			# make the call
	
	#exit
	li $v0, 10
	syscall
	
	sq
	
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