# Author: Tomas Baublys
# function char *substr(char *str, char *substr_keyword) implementation in Risc-V assembly language for Computer Architecture class 

.equ NULL, 0                                                   # define NULL as 0 for code readability
.equ MAX_INPUT, 64                                             # define the max amount of bytes a user can enter

.data
    msg1: .asciz "Welcome to substring demo in Risc-V 32bit assembly, enter a string: "
    msg2: .asciz "Now enter the keyword to look for: "
    result_msg: .asciz "Result: "
    
.global main

.text

main:
    la a0, msg1                                                 # load the address of the first message to a0
    li a7, 4                                                    # load imm 4 to a7 to call print string
    ecall                                                       # make the syscall
    
    addi sp, sp, -MAX_INPUT                                     # move the stack pointer by MAX_INPUT to make space for the str
    mv s1, sp                                                   # save the current stack pointer for the variable str
    
    li a7, 63                                                   # load imm 63 to a7 to make the syscall read(file descriptor, buffer, max character to read)
    li a0, 0                                                    # 0 - stdin
    mv a1, s1                                                   # move s1 to a1 to pass as buffer to read syscall
    li a2, MAX_INPUT                                            # load the maximum characters to read from the console to a2
    ecall                                                       # make the syscall
    
    mv t1, s1                                                   # move the str address to t1
    add t1, t1, a0                                              # add the amount of bytes read to the address at t1, to set it after the last byte
    sb zero, -1(t1)                                             # add a null terminating character instead of '\n'
    
    addi sp, sp -MAX_INPUT                                      # make space on the stack for the next argument (substr_keyword)
    mv s2, sp                                                   # save the current stack pointer to s2 - beginning of substr_keyword
    
    la a0, msg2                                                 # load the address of the first message to a0
    li a7, 4                                                    # load imm 4 to a7 to call print string
    ecall                                                       # make the syscall
    
    li a7, 63                                                   # load imm 63 to a7 to make the syscall read(file descriptor, buffer, max character to read)
    li a0, 0                                                    # 0 - stdin
    mv a1, s2                                                   # move s1 to a1 to pass as buffer to read syscall
    li a2, MAX_INPUT                                            # load the maximum characters to read from the console to a2
    ecall
    
    mv t1, s2                                                   # move the substr_keyword address to t1
    add t1, t1, a0                                              # add the amount of bytes read to the address at t1, to set it after the last byte
    sb zero, -1(t1)                                             # add a null terminating character instead of '\n'
    
    la a0, result_msg
    li a7, 4
    ecall
    
    mv a0, s1                                                   # load str from the data segment to a0 to pass as function argument char *str
    mv a1, s2                                                   # load substr_keyword from the data segment to a1 to pass as function argument char *substr_keyword

    jal ra, substr                                              # call the function void *substr(char *str, char *substr_keyword) as substr(a0, a1)
    
    li t1, NULL                                                 # check if not substrings were found
    beq a0, t1, exit
    
    li a7, 4                                                    # else a7 = 4, to make the system call for print_string();
    ecall                                                       # make the system call

    addi sp, sp, MAX_INPUT                                      # delete substr_keyword from stack
    addi sp, sp, MAX_INPUT                                      # delete str from stack
    
    exit:
    # exit the program with 0
    addi a7, zero, 10                                           # syscall with a7 = 10 => exit(0)
    ecall                                                       # make the syscall
    
# arguments a0 -> string pointer, a1 -> substring pointer !strings must be null terminated!  
# doesn`t preserve a0, a1, and t1-t5
# void *substr(char *str, char *substr_keyword)
substr:
        mv t1, a1                                               # move a1 (substr_keyword) to t1 as we will need a1 later
        lb t3, (0)t1                                            # load the first character of substr_keyword to t3
    
    # loop through the string
    _substr_loop:
        lb t2, (0)a0                                            # load the first character of str to t2
        
        beq t2, t3, _substr_matcher                             # compare if they are equal
        
        _substr_loop_continue:
        addi a0, a0, 1                                          # increment current pointer to str by one to move to the next character
        bne t2, zero, _substr_loop                              # if not the end of the string continue the loop
        
        
        _substr_return_none:
        addi a0, zero, NULL                                     # if substring wasnt found return NULL
        j _substr_return                                        # jump to return
        
    _substr_matcher:
        addi t5, a0, 1                                          # save the pointer to next character of the string if we want to return
                
        _substr_matcher_loop:
            lb t2, (0)a0                                        # load byte from the address of current character in the str t2 = *(a0 + 0)
            lb t3, (0)t1                                        # load byte from the address of current character in the substr_keyword t3 = *(t1 + 0)
            

            beq t3, zero, _substr_matcher_return                # if we reached the end of our keyword return
            beq t2, zero, _substr_return_none                   # if we reached the end of our string return NULL

            bne t2, t3 _substr_matcher_go_back                  # if the characters do not match go back to our original loop
        
            addi a0, a0, 1                                      # move pointer to str by one character
            addi t1, t1, 1                                      # move the pointer to substr_keyword by one character
        
            j _substr_matcher_loop                              # no conditions were met continue the loop
        
        _substr_matcher_go_back:
            mv a0, t5                                           # reset the pointer to our string to next character before this function call
            mv t1, a1                                           # reset the pointer to substr_keyword to the beginning
            j _substr_loop_continue            
        
        _substr_matcher_return:
            addi a0, t5, -1                                     # if the matching was succesful, return the start of the matching that we saved in t3
            
    # return  
    _substr_return:  
    ret                                                         # return
    
    
