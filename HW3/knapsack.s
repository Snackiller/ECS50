.global knapsack

.section .data
.equ weights, 1
.equ values, 1
.equ num_items, 1
.equ capacity, 1
.equ cur_value, 1
.equ best_value, 1
.equ var_a, 1
.equ var_b, 1

.section .text
.global max
max:
    movl var_b, %edx
    cmpl var_a, %edx
    jg end_max 
    movl var_a, %edx
end_max:
    ret

knapsack:
    pushl %ebp
    movl %esp, %ebp

    pushl %esi
    pushl %ebx
    movl $0, %esi

    movl cur_value, %eax
    movl %eax, best_value 

    for_start:
        cmpl num_items, %esi 
        jae for_end

        movl weights, %ecx		
	    movl capacity, %edx
        cmpl (%ecx, %esi, 4), %edx 
        jb inner_if_end

        movl cur_value, %ecx
		addl (%ecx, %esi, 4), %ecx
		pushl %ecx

		movl capacity, %ecx
		subl (%ecx, %esi, 4), %ecx
		pushl %ecx

		movl num_items, %ecx
		subl %esi, %ecx
		decl %ecx
		pushl %ecx

        movl values, %ecx
		addl %esi, %ecx
		leal (%ecx, %esi, 4), %ecx
		pushl %ecx

        movl weights, %ecx
		addl %esi, %ecx
		leal (%ecx, %esi, 4), %ecx
		pushl %ecx

        call knapsack

        addl $20, %esp
        movl best_value, %ecx

        call max

        movl %eax, best_value

        inner_if_end:
            incl %esi 
            jmp for_start

    for_end:
        movl best_value, %eax 

    popl %ebx
    popl %esi
    movl %ebp, %esp
    popl %ebp
    ret

done:
    nop
