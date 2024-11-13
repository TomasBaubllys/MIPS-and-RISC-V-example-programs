# Author: Tomas Baublys
# function char *substr(char *str, char *substr_keyword) implementation in Risc-V assembly language for Computer Architecture class 

.equ NULL, 0                                                   # define NULL as 0 for code readability

.data
    str: .asciz "I calculated Pi and it`s s`ti dna iP detaluclac I"
    substr_keyword: .asciz "Pi"
    
.global main

.text

main:
    la a0, str                                                  # load str from the data segment to a0 to pass as function argument char *str
    la a1, substr_keyword                                       # load substr_keyword from the data segment to a1 to pass as function argument char *substr_keyword

    jal ra, substr                                              # call the function void *substr(char *str, char *substr_keyword) as substr(a0, a1)
    
    li t1, NULL                                                 # check if not substrings were found
    beq a0, t1, exit
    
    li a7, 4                                                    # else a7 = 4, to make the system call for print_string();
    ecall                                                       # make the system call
    
    exit:
    # exit the program with 0
    addi a7, zero, 10
    ecall
    
# arguments a0 -> string pointer, a1 -> substring pointer !strings must be null terminated!  
# doesn`t preserve a0, a1, and t1-t5
# void *substr(char *str, char *substr_keyword)
substr:
        lb t1, (0)a1                                              # load word[0] to t1
    
    # loop through the string
    _substr_loop:
        lb t0, (0)a0                                              # load str[a0] to t0
        beq t0, t1, _substr_matcher                               # compare if they are equal
        
        _substr_loop_continue:
        addi a0, a0, 1                                            # increment current pointer to str by one to move to the next character
        bne t0, zero, _substr_loop                                # if not the end of the string continue the loop
        
        
        _substr_return_none:
        addi a0, zero, NULL                                       # if substring wasnt found return -1
        j _substr_return
        
    _substr_matcher:
        addi t3, a0, 1                                            # save the pointer to next character of the string if we want to return
        mv t4, a1                                                 # save the pointer to the beginning of substr_keyword if we need to reset it later 
        
        _substr_matcher_loop:
            lb t0, (0)a0                                          # load byte from the address of current character in the str t0 = *(a0 + 0)
            lb t1, (0)a1                                          # load byte from the address of current character in the substr_keyword t1 = *(a1 + 0)
        
            beq t1, zero, _substr_matcher_return                  # if we reached the end of our keyword return
            beq t0, zero, _substr_return_none                     # if we reached the end of our string return -1
        
            bne t1, t0 _substr_matcher_go_back                    # if the characters do not match go back to our original loop
        
            addi a0, a0, 1                                        # else move pointer by one character
            addi a1, a1, 1
        
            j _substr_matcher_loop                                # no conditions were met continue the loop
        
        _substr_matcher_go_back:
            la a1, substr_keyword                                 # if characters didnt match go back
            mv a0, t3                                             # reset the pointer to our string to next character before this function call
            mv a1, t4                                             # reset the pointer to substr_keyword to the beginning
            j _substr_loop_continue            
        
        _substr_matcher_return:
            addi a0, t3, -1                                       # if the matching was succesful, return the start of the matching that we saved in t3
            
    # return  
    _substr_return:  
    ret
    
    
