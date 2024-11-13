# Author: Tomas Baublys
# Sample program for Computer Architecture class
# Implements and demo`s a substring function void *substr(char *str, char *substr_keyword)
# Values are defined in the data segment

.eqv NULL 0

.data
	str: .asciiz "I calculated Pi and it`s s`ti dna iP detaluclac I" 
	substr_keyword: .asciiz "Pi"
	
.globl main

.text

main:
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
	la $t1, 0($a0)					# load the address of str to t1 (temporary register)	 
	la $t2, 0($a1)					# load the address of substr_keyword to t2 (temporary register)
	
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
	j _substr_loop					# move back to the initial loop
	 
	_substr_matcher_return:
	addi $v0, $t5, -1				# load the start of the substring to v0 
	jr $ra						# return
	 
	  
	
