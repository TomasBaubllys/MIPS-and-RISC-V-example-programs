# Author: Tomas Baublys
# Sample program for Computer Architecture class
# Implements and demo`s a substring function void *substr(char *str, char *substr_keyword)
# Values are read from the console

.eqv NULL 0						# define custom NULL for readability 
.eqv MAX_INPUT 64					# define the maximum amount of characters to read from the user

.data
	msg1: .asciiz "Welcome to substring demo in MIPS32 assembly, enter a string: "
	msg2: .asciiz "Now enter the keyword to look for: "
	result_msg: .asciiz "Result: "
	
	str: .space MAX_INPUT   			# space for the main string
	substr_keyword: .space MAX_INPUT		# space for the substring keyword
	
.globl main

.text

main:
	la $a0, msg1					# load the address of the first message to a0
	li $v0, 4					# load imm 4 to v0 to make the syscall print string
	syscall						# make the syscall
	
	la $a0, str					# load the address of the string to a0
	li $a1, MAX_INPUT				# load the maximum amount of characters we want to read from the console
	li $v0, 8					# load imm 8 to v0 to make the syscall read string
	syscall						# make the syscall
	
	jal remove_first_newline			# remove the newline added to the string when reading it from the terminal
	
	la $a0, msg2					# load the address of the second message to a0
	li $v0, 4					# load imm 4 to v0 to make the syscall print string
	syscall						# make the syscall
	
	la $a0, substr_keyword				# load the address of the string to a0
	li $a1, MAX_INPUT				# load the maximum amount of characters we want to read from the console
	li $v0, 8					# load imm 8 to v0 to make the syscall read string
	syscall						# make the syscall
	
	jal remove_first_newline			# remove the newline added to the string when reading it from the terminal
	
	
	la $a0, result_msg				# load the address of the result message message to a0
	li $v0, 4					# load imm 4 to v0 to make the syscall print string
	syscall						# make the syscall

	la $a0, str					# load the address of str to a0
	la $a1, substr_keyword				# load the address of substr_keyword to a1
	jal substr					# call the substring function
	
	beqz $v0, exit					# if null was returned terminate the prgram 
	move $a0, $v0					# move the address returned by the substr to a0
	li $v0, 4					# load the 4 (syscall for print to v0)
	syscall						# make the syscall
	
	exit:
	li $v0, 10					# 10 - syscall to terminate the program
	syscall
	

# void* substr(char *str, char* substr_keyword) 
# strings must be null terminated!
# returns a the pointer to the beginning of the string in the original string, does not make a copy
substr:
	move $t1, $a0					# load the address of str to t1 (temporary register)	 
	move $t2, $a1					# load the address of substr_keyword to t2 (temporary register)
	
	_substr_loop:					# label for the main loop
	lb $t3, 0($t1)					# load the values stored in addresses t1 and t2 (*str and *substr_keyword)
	lb $t4, 0($t2)
	
	beq $t3, $t4, _substr_matcher			# compare the characters *(str + current_offset) *substr_keyword
	
	_substr_loop_continue:
	addi $t1, $t1, 1				# increment the pointer of str by one
	bnez $t3, _substr_loop				# if its not the end of the string continue the loop (branch if *(str + current_offset) != 0)
	
	_substr_return_none:
	li $v0, NULL					# return NULL if the substring wasn`t found
	jr $ra						# return to the address saved in ra
		
	_substr_matcher:				# used for matching the substr_keyword to str
	addi $t5, $t1, 1				# save the address of the next character in string
	move $t6, $t2					# save the start of substr_keyword
	
	_substr_matcher_loop:				# loop label for matching str to substr_keyword
	lb $t3, 0($t1)					# load the current character of str to t3
	lb $t4, 0($t2)					# load the current character of substr_keyword to t4
	  
	beqz $t4, _substr_matcher_return		# if null terminating character is reached in substr_keyword return the start of the substring
	beqz $t3, _substr_return_none			# if we reached the end of str and a matching substring was not found return NULL  
	 
	bne $t3, $t4, _substr_matcher_go_back		# if the characters don`t match return to the orginial loop and continue the search
	 
	addi $t1, $t1, 1				# increment str to move to the next character 
	addi $t2, $t2, 1				# increment substr_keyword to move to the next character
	 
	j _substr_matcher_loop				# no conditions were met, continue the matching
	 
	 _substr_matcher_go_back:
	move $t1, $t5					# move the saved value in t5 (next character of str after starting the matching) to t1 
	move $t2, $t6					# move the beginning of substr_keyword to t2
	j _substr_loop					# move back to the initial loop
	 
	_substr_matcher_return:
	addi $v0, $t5, -1				# load the start of the substring to v0 
	jr $ra	
	

# function that replaces first new line character found with 0
# helps with syscall 8, which adds the newline to our inputed string
# void remove_first_newline(char *str) or remove_frist_newline(a0)
remove_first_newline:
	beq $a0, NULL, _remove_first_newline_return	# if char *str was NULL return
	move $t0, $a0					# move a0 value to t0 to preserve it
	
	_remove_first_newline_loop:
	lb $t1, 0($t0)					# load the character at the address t0 to t1
	beq $t1, '\n', _remove_first_newline_replace	# if the new line was found replace it with 0
	
	beq $t1, 0, _remove_first_newline_return	# if the reached the null terminated character return
	
	addi $t0, $t0, 1				# increment t0 by 1 to move to the next character
	j _remove_first_newline_loop			# no conditions where met continue the loop
				
	_remove_first_newline_replace:
	li $t2, 0					# load 0 to t2
	sb $t2, 0($t0)					# store the newline character at the address pointed by t0	
	
	_remove_first_newline_return:
	jr $ra						# return 
	