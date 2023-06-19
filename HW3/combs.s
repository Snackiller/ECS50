/*
void generate_combs(int* count, int index, int start, int* data, int** combs, int len, int k, int* items) {
    // recursion termination condition: a combination is ready to be printed
    if (index == k) {
        for (int i=0; i<k; i++) {
            combs[*count][i] = data[i];
        }
        (*count)++;
    } else {
        for (int i=start; i<=len && len-i+1>=k-index; i++) {
            data[index] = items[i];
            generate_combs(count, index+1, i+1, data, combs, len, k, items);
        }
    }
}

int** get_combs(int* items, int k, int len) {
    int num = num_combs(len, k);
    int** combs = (int**)malloc(num * sizeof(int*));
    for (int i=0; i<num; i++) {
        combs[i] = (int*)malloc(k * sizeof(int));
    }
    int* data = (int*)malloc(k * sizeof(int));
    int count = 0;
    generate_combs(&count, 0, 0, data, combs, len-1, k, items);
    free(data);
    return combs;
}
*/

.global get_combs
.equ count, 0

.text
generate_combs:
    push %ebp
    movl %esp, %ebp
    subl $4, %esp
    push %ebx
    push %esi

    .equ index, 8
    .equ start, 12
    .equ data, 16
    .equ combs, 20
    .equ len, 24
    .equ k, 28
    .equ items, 32
    
    # if (index == k)
    movl k(%ebp), %eax # eax=k
    cmpl index(%ebp), %eax
    jnz if_end # index!=k
    xor %esi, %esi # i=0
for_start_one:
    movl k(%ebp), %eax # eax=k
    cmpl %eax, %esi # i<k
    jge for_end_one # i==k

    #combs[*count][i] = data[i]
    movl data(%ebp), %edx # edx=data
    movl (%edx, %esi, 4), %edx # edx=data[i]
    movl combs(%ebp), %eax # eax=combs
    movl (%eax, %edi, 4), %eax # eax=combs[*count]
    movl %edx, (%eax, %esi, 4) # combs[*count][i]=data[i]

    incl %esi #i++
    jmp for_start_one
for_end_one:
    incl %edi #(*count)++;
    jmp recursive_epilogue

if_end:
    xor %esi, %esi # i=0
    movl start(%ebp), %esi # i=start
    movl k(%ebp), %eax # eax=k
for_start_two:
    # i<=len
    movl len(%ebp), %edx # edx=len
    cmpl len(%ebp), %esi
    jg for_end_two # i>len

    # len-i+1>=k-index
    movl k(%ebp), %eax # eax=k
    subl index(%ebp), %eax # k-index
    subl %esi, %edx # len-i
    incl %edx # len-i+1
    cmpl %edx, %eax
    jg for_end_two # len-i+1<k-index

    # data[index] = items[i]
    movl items(%ebp), %ecx # ecx=items
    movl (%ecx, %esi, 4), %ecx # ecx=items[i]
    movl data(%ebp), %eax # eax=data
    movl index(%ebp), %edx # edx=index
    movl %ecx, (%eax, %edx, 4) # data[index]=items[i]

    # get items
    push items(%ebp)

    # get k
    push k(%ebp)

    # get len
    push len(%ebp)

    # get combs
    movl combs(%ebp), %ecx
    push %ecx

    # get data
    push data(%ebp)

    # get i++
    movl %esi, %ecx
    incl %ecx
    push %ecx

    # get index++
    movl index(%ebp), %ecx
    incl %ecx
    push %ecx

    call generate_combs
    addl $28, %esp
    incl %esi # i++
    jmp for_start_two

for_end_two:

recursive_epilogue:
    pop %esi
    pop %ebx
    movl %ebp, %esp
    pop %ebp
    ret

get_combs:
    push %ebp
    movl %esp, %ebp
    subl $16, %esp
    push %edi
    push %esi

    .equ items, 8
    .equ k, 12
    .equ len, 16
    .equ data, -4
    .equ num, -8
    .equ combs, -12

    # num = num_combs(len, k)
    movl k(%ebp), %eax
    push %eax
    movl len(%ebp), %eax
    push %eax
    call num_combs
    addl $8, %esp
    movl %eax, num(%ebp)

    # combs = (int**)malloc(num * sizeof(int*))
    shll $2, %eax
    push %eax
    call malloc
    addl $4, %esp
    movl %eax, combs(%ebp)

    xor %esi, %esi #i=0
        
for_start:
    # i<num
    cmpl num(%ebp), %esi
    jge for_end #i==num

    # combs[i] = (int*)malloc(k * sizeof(int))
    movl k(%ebp), %edx
    shll $2, %edx
    push %edx
    call malloc
    addl $4, %esp
    movl combs(%ebp), %ecx
    movl %eax, (%ecx, %esi, 4)

    incl %esi # i++
    jmp for_start
        
for_end:
    # data = (int*)malloc(k * sizeof(int))
    movl k(%ebp), %eax
    shll $2, %eax
    push %eax
    call malloc
    addl $4, %esp
    movl %eax, data(%ebp)

    # get items
    push items(%ebp)

    # get k
    push k(%ebp)

    # get len++
    movl len(%ebp), %ecx
    decl %ecx
    push %ecx

    # get combs
    movl combs(%ebp), %ecx
    push %ecx

    # get data
    push data(%ebp)

    # get i
    push $0

    # get index
    push $0

    xor %edi, %edi #count=0
    call generate_combs
    addl $28, %esp

    # free(data)
    movl data(%ebp), %ecx
    push %ecx
    call free
    addl $4, %esp

    movl combs(%ebp), %eax # return combs
        
# epilogue
    pop %esi
    pop %edi
    movl %ebp, %esp
    pop %ebp
    ret
