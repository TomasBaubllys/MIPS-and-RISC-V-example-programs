# struct Node {
# 8 bytes - val
# 8 bytes - next
# 8 bytes - prev
#}

.equ NODE_SIZE 24

.data
head: .word 0
end_of_data_segment: .word 0                    # end of data segment to track were to allocate nodes

.global main

.text

main:
    # load the addr of end_of_data_segment to end_of_data_segment
    la t0, end_of_data_segment
    mv t1, t0
    # make space for the end_of_data_segment itself
    addi t1, t1, 4
    sw t1, 0(t0)
    
    # create a node, and make it our head
    li a0, 82
    jal ra, alloc_node
    la t0, head
    sw a0, 0(t0)
    
    # allocate a node with the value I
    li a0, 73
    jal ra, alloc_node
    
    # move a0, to a1
    mv a1, a0
    la a0, head
    # a0, now cotains the addr of head, 
    # deref it again to contain the start of our first node
    lw a0, 0(a0)
    jal ra add_tail
    
    
    # allocate a node with the value S
    li a0, 83
    jal ra, alloc_node
    
    # move a0, to a1
    mv a1, a0
    la a0, head
    # a0, now cotains the addr of head, 
    # deref it again to contain the start of our first node
    lw a0, 0(a0)
    jal ra add_tail
    
    # allocate a node with the value C
    li a0, 67
    jal ra, alloc_node
    
    # move a0, to a1
    mv a1, a0
    la a0, head
    # a0, now cotains the addr of head, 
    # deref it again to contain the start of our first node
    lw a0, 0(a0)
    jal ra add_tail
    
    
    # allocate a node with the value -
    li a0, 45
    jal ra, alloc_node
    
    # move a0, to a1
    mv a1, a0
    la a0, head
    # a0, now cotains the addr of head, 
    # deref it again to contain the start of our first node
    lw a0, 0(a0)
    jal ra add_tail
    
    
    # allocate a node with the value V
    li a0, 86
    jal ra, alloc_node
    
    # move a0, to a1
    mv a1, a0
    la a0, head
    # a0, now cotains the addr of head, 
    # deref it again to contain the start of our first node
    lw a0, 0(a0)
    jal ra add_tail
    
    
    # print the list
    la a0, head
    lw a0, 0(a0)
    jal ra, print_list
    
    # print a newline
    jal ra print_newline
    
    # delete the node containing I
    la a0, head
    lw a0, 0(a0)
    mv a1, a0
    li a1, 0x10000020
    jal ra del_node
    
    # delete the last node V
    la a0, head
    lw a0, 0(a0)
    mv a1, a0
    li a1, 0x10000080
    jal ra del_node
    
    # print the list again
    jal ra, print_list
    
    # exit with 0
    exit:
    li a7, 10
    ecall
    
    exit_err:
    li a7, 93
    li a0, 1
    ecall        # branch if curr node -> next is not equal to curr node
        bne t0, t2, _print_list_loop


# a0 - value too set the node to
# allocates memory in the data segment for a node, returns its starting addr in a0
alloc_node:
    # move the end of the data segment
    la t0, end_of_data_segment
    lw t1, 0(t0)
    # t2 will now point to our start of the node
    mv t2, t1                
    addi t1, t1, NODE_SIZE
    sw t1, 0(t0)
    
    # move the a0 with 0xA at the beginning to the start of the node
    li t3, 0xA
    slli t3, t3, 28
    # store as MSB in the beginnning of value
    sw t3, 0(t2)     
    
    # store the a0 value
    sw a0, 4(t2)
    
    # point the next to itself 4 bytes - 0, 4 bytes - pointer to node
    sw zero, 8(t2)
    sw t2, 12(t2)
    
    # point the prev to itself 4 bytes - 0, 4 bytes - pointer to node
    sw zero, 16(t2)
    sw t2, 20(t2)
    
    # return the starting addr of the node in a0
    mv a0, t2
    
    ret
    
# beginning of the list in a0, starting of the node addr in a1
add_tail:    
    # traverse a0, till you find a pointer to itself
    mv t0, a0
    mv t2, t0
    _add_tail_loop:
        # move to the next node
        mv t0, t2
        
        # load the address of next to t2
        lw t2, 12(t0)
        
        # branch if curr node -> next is not equal to curr node
        bne t0, t2, _add_tail_loop
    # link the curr node t2->next a1 store at curr node +12 the adrr of a1
    sw a1, 12(t0)
 
    # new node prev -> old node
    sw t0, 20(a1)
    
    ret
    
# a0 - head addr, a1 - node to del addr returns a0 - head of the list
# WILL CAUSE A MEMORY LEAK!!!! since deleted nodes are in the heap
del_node:
    # loop throught until node == addr to delete
    # traverse a0, till you find a pointer to a1
    mv t0, a0
    mv t2, t0
    
    # if head == node to del delete the first node
    beq t0, a1, _del_node_found_start
    
     _del_node_loop:
        # move to the next node
        mv t0, t2
        
        # if null encountered return -1;
        beq t0, zero, _del_node_exit_F
        
        # check if t0 == node to delete
        beq t0, a1, _del_node_found
        
        # load the address of next to t2
        lw t2, 12(t0)
        
        # if we found the node delete it
        beq t0, a1, _del_node_found
        
        # if we encoutered the end and not found return -1
        beq t0, t2, _del_node_exit_F
        
        # no conditions were met return
        j _del_node_loop
    
    
    
    # load next -> next to curr node if (next next is not )
    # deletes t0 node if its not the last node 
    _del_node_found:
        # t1 now contains the prev node
        lw t1, 20(t0)
        # t2 now contains the next node
        lw t2 12(t0)
        
        # if our node is the last node handle the spec case
        beq t0, t2, _del_node_found_end
    
        # link the nodes and return
        sw t2, 12(t1)
        sw t1 20(t2)
        # a0 still is the head of the list
        ret
    
    # deletes the last node 
    _del_node_found_end:
        # t0 points to the nodel to del
        # t1 now contains the addr of the prev node
        lw t1, 20(t0)
    
        # point t1 next to itself and return
        sw t1, 12(t1)
        ret
        
    # deletes the node if its the first node and returns the addr of the new head
    _del_node_found_start:
        # t1 will now contain the next node
        lw t1, 12(t0)
        
        # point t1 prev to itself
        sw t1, 20(t1)
        
        # return the new addr of the head
        mv a0, t1 
        ret
    
    # if node not or null encountered found return -1
    _del_node_exit_F:
        li a0, -1
        ret
    
# beginning of the list in a0
# on return a0 - bytes written if succesfull, -1 if failure
print_list:
    # t1 will be our counter
    addi t1, zero, 0
    mv t0, a0
    mv t2, t0
    _print_list_loop:
        # move to the next node
        mv t0, t2
        
        # check for null if so return -1
        beq t0, zero, _print_list_return_F
        
        # load the address of next to t2
        lw t2, 12(t0)
        lw a0, 4(t0)
        
        li a7, 11
        ecall
        
        # + one byte was written
        addi t1, t1, 1
        
        # branch if curr node -> next is not equal to curr node
        bne t0, t2, _print_list_loop
        
        mv a0, t1
        ret
        
        _print_list_return_F:
            li a0, -1
            ret

# helper func to print a new line
print_newline:
    mv t1, a0
    li a0, 13
    li a7, 11
    ecall
    ret
    
    
    
