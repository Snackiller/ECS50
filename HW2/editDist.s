.global _start

.data

string1:
    .space 100

string2:		
	.space 100

strlen1:
    .long 0

strlen2:
    .long 0
	
strlen_ret:
    .long 0

oldDist:
	.space 400

curDist:
	.space 400

var_a:
	.long 0

var_b:
	.long 0
	
strlen_str:
    .long 0

.text

# int min(int a, int b)
# {
#   return a < b ? a : b;
# }
# if(a<b){
#     return a
# }else{
#     return b
# }

min:
    movl var_a, %edx # %edx = var_a
    # a < b == a - b < 0
    cmpl var_b, %edx # a-b
    jl end_min
    movl var_b, %edx
    end_min:
    ret

swap:
    push %ecx
	movl $0, %ecx # init i = 0
	swap_for_start:
        # i -100 >= 0
        cmpl $100, %ecx
        jge swap_for_end 
        # LIFO
		push oldDist(, %ecx, 4)
		push curDist(, %ecx, 4)
		pop oldDist(, %ecx, 4)
		pop curDist(, %ecx, 4)
		incl %ecx # i++
		jmp swap_for_start
	swap_for_end:
    pop %ecx
	ret

strlen: # copy from lecture
	push %ebx
    push %ecx
    movl $0, %ecx
    movl strlen_str, %ebx
    strlen_for_start:
        cmpb $0,(%ebx,%ecx,1)
        jz strlen_for_end
        incl %ecx
        jmp strlen_for_start
	strlen_for_end:
    movl %ecx, strlen_ret
    pop %ecx
    pop %ebx
	ret

_start:
	movl $string1, strlen_str
	call strlen
    push %ebx
	movl strlen_ret, %ebx
    movl %ebx,strlen1
    pop %ebx
	movl $string2, strlen_str
	call strlen
    push %ebx
    movl strlen_ret, %ebx
    movl %ebx,strlen2
    pop %ebx

    # int i, j, dist;
    movl $0, %esi # i = esi = 0

	movl $0, %eax # dist = eax = 0

    # for (i = 0; i < word2_len + 1; i++)
    # {
    #     oldDist[i] = i;
    #     curDist[i] = i;
    # }
    // intialize distances to length of the substrings
    init_dist_for_start:
        # i >= word2_len+1 == i - word2_len -1 >= 0 == i - word2_len > 0
        cmpl strlen2, %esi
        jg init_dist_for_end
        movl %esi, oldDist(, %esi, 4) # oldDist[i] = i
		movl %esi, curDist(, %esi, 4) # curDist[i] = i
        incl %esi # i++
        jmp init_dist_for_start
    init_dist_for_end:
    movl $1, %esi # i = 1
    # for(i = 1; i < word1_len + 1; i++)
    outer_for_start:
        # i >= word1_len + 1 == i - str1_len -1 >= 0
        cmpl strlen1, %esi
        jg outer_for_end
        # curDist[0] = i;
        movl %esi, curDist
        movl $1, %edi # j = 1
        # for(j = 1; j < word2_len + 1; j++)
        inner_for_start:
            # j >= word2_len + 1 == j - str2_len -1 >= 0
            cmpl strlen2, %edi
            jg inner_for_end
#       if (word1[i - 1] == word2[j - 1])
#       {
#         curDist[j] = oldDist[j - 1];
#       } // the characters in the words are the same
            if_start: # str1[i -1] != str2[j -1]
                push %ecx
				movb string1-1(, %esi, 1), %cl
				cmpb string2-1(, %edi, 1), %cl
                pop %ecx
                jnz else_start
                # ecx = oldDist[j - 1] 
                movl oldDist-4(,%edi,4), %ecx
                movl %ecx, curDist(,%edi,4) # curDist[j] = oldDist[j - 1];
                jmp end_if
#       else
#       {
#         curDist[j] = min(min(oldDist[j],      // deletion
#                              curDist[j - 1]), // insertion
#                          oldDist[j - 1]) + 1; // subtitution
#       }
            else_start:
                # min(oldDist[j], curDist[j - 1])
                movl oldDist(,%edi,4), %ecx
                movl %ecx, var_a
                movl curDist-4(,%edi,4), %ecx
                movl %ecx, var_b
                call min
                # min(min(oldDist[j],curDist[j - 1]), oldDist[j - 1])
                movl %edx, var_a
                movl oldDist-4(,%edi,4), %ecx
                movl %ecx, var_b
                call min
				movl %edx, curDist(, %edi, 4)
				incl curDist(, %edi, 4)
            end_else:
            end_if:
                incl %edi # j++
                jmp inner_for_start
        inner_for_end:
            call swap
            incl %esi # i++
            jmp outer_for_start        
    outer_for_end:
        movl strlen2, %ebx
        movl oldDist(,%ebx,4), %eax

done:
    nop
