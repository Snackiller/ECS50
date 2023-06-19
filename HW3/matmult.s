/*
int** matMult(int **a, int num_rows_a, int num_cols_a, int** b, int num_rows_b, int num_cols_b){
	int** c = (int**)malloc(num_rows_a * sizeof(int*));
	for(int rowa = 0; rowa < num_rows_a; rowa++){
		c[rowa] = (int*)malloc(num_cols_b * sizeof(int));
		for(int colb = 0; colb < num_cols_b; colb++){
			c[rowa][cola] = 0;
			for(int cola = 0; cola < num_cols_a; cola++){
				c[rowa][cola] += a[rowa][cola] * b[cola][colb];
			}
		}
	}
	return c;
}
*/

.global matMult
.equ ws, 4

.text

matMult:
	# prologue:
	.equ num_locals, 4
	.equ num_saved_registers, 3
	push %ebp
	movl %esp, %ebp
	subl $((num_locals + num_saved_registers) * ws), %esp # make space

	# stack
	# ebp + 7: num_cols_b
	# ebp + 6: num_rows_b
	# ebp + 5: b
	# ebp + 4: num_cols_a
	# ebp + 3: num_rows_a
	# ebp + 2: a
	# ebp + 1: return address
	# ebp    : saved ebp
	# ebp - 1: c
	# ebp - 2: rowa
	# ebp - 3: colb
	# ebp - 4: cola/rowb

	.equ a, (2 * ws) # %ebp
	.equ num_rows_a, (3 * ws) # %ebp
	.equ num_cols_a, (4 * ws) # %ebp
	.equ b, (5 * ws) # %ebp
	.equ num_rows_b, (6 * ws) # %ebp
	.equ num_cols_b, (7 * ws) # %ebp
	
	.equ c, (-1 * ws) # %ebp
	.equ rowa, (-2 * ws) # %ebp
	.equ colb, (-3 * ws) # %ebp
	.equ cola, (-4 * ws) # %ebp

	push %esi
	push %edi
	push %ebx
	
	# int** c = (int**)malloc(num_rows_a * sizeof(int*));
	movl num_rows_a(%ebp), %eax # eax = num_rows_a
	shll $2, %eax # eax = num_rows * sizeof(int*)
	push %eax
	call malloc # return value will be in EAX
	addl $1*ws, %esp # remove the arg to malloc from stack
	movl %eax, c(%ebp) # int** c = (int**)malloc(num_rows_a * sizeof(int*));
	# ECX : rowa
	# EDX : colb
	# ESI : cola

	# for(int rowa = 0; rowa < num_rows_a; rowa++){
	movl $0, rowa(%ebp) # rowa = 0
	rowa_for_start:
		# rowa < num_rows_a == rowa - num_rows_a < 0
		# negation: rowa - num_rows_a >= 0
		movl rowa(%ebp), %ecx
		cmpl num_rows_a(%ebp), %ecx # rowa - num_rows_a
		jge rowa_for_end # >= 0
	
		# c[rowa] = (int*)malloc(num_cols_b * sizeof(int));
		movl %ecx, rowa(%ebp) # save rowa
		movl num_cols_b(%ebp), %edx # edx = num_cols_b
		shll $2, %edx # edx = num_cols_b * sizeof(int)
		push %edx
		call malloc # return value in EAX
		addl $1*ws, %esp # clear the arg to malloc from stack
		movl rowa(%ebp), %ecx # restore ECX back to rowa
		movl c(%ebp), %edx # edx = c
		movl %eax, (%edx, %ecx, ws) # c[rowa] = (int*)malloc(num_cols_b * sizeof(int))
		# for(int colb = 0; colb < num_cols_b; colb++){
		movl $0, colb(%ebp) # colb = 0
		colb_for_start:
			movl colb(%ebp), %edx # edx = colb
			# colb < num_cols_b == colb - num_cols_b < 0
			# negation: colb - num_cols_b >= 0
			cmpl num_cols_b(%ebp), %edx
			jge colb_for_end
			# movl c(%ebp), %ebx # ebx = c
			# movl (%ebx, %ecx, ws), %ebx # ebx = c[rowa]
			# movl (%ebx, %edx, ws), %ebx  # ebx = c[rowa][colb]
			# for(int cola = 0; cola < num_cols_a; cola++){
			movl rowa(%ebp), %edi # edi = rowa
			movl c(%ebp), %ecx # ecx = c
			movl (%ecx, %edi, ws), %ecx # ecx = c[rowa]
			movl colb(%ebp), %edi # edi = colb
			movl $0, (%ecx, %edi, ws) # c[rowa][colb] = 0
			movl $0, cola(%ebp) # cola/rowb = 0
			cola_for_start:
				movl cola(%ebp), %esi # esi = cola
				# cola < num_cols_a == cola - num_cols_a < 0
				# negation: cola - num_cols_a >= 0
				cmpl num_cols_a(%ebp), %esi
				jge cola_for_end
				
				# a[rowa][cola]
				# b[cola][colb]
				# c[rowa][colb]

				# c[rowa][colb] += a[rowa][cola] * b[cola][colb];
				# c[rowa][colb] = c[rowa][colb] + a[rowa][cola] * b[cola][colb];
				# eax = a[rowa][cola]
				movl rowa(%ebp), %edi # edi = rowa
				movl a(%ebp), %eax # eax = a
				movl (%eax, %edi, ws), %eax # eax = a[rowa]
				movl cola(%ebp), %edi # edi = cola
				movl (%eax, %edi, ws), %eax # eax = a[rowa][cola]

				# ebx =  b[cola][colb]
				movl cola(%ebp), %edi # edi = cola
				movl b(%ebp), %ebx # ebx = b
				movl (%ebx, %edi, ws), %ebx # edi = b[cola]
				movl colb(%ebp), %edi # edi = colb
				movl (%ebx, %edi, ws), %ebx # edi = b[cola][colb]

				# eax = a[rowa][cola] * b[cola][colb]	
				imull %ebx # eax = eax * ebx

				# ecx = c[rowa][colb]
				movl rowa(%ebp), %edi # edi = rowa
				movl c(%ebp), %ecx # ecx = c
				movl (%ecx, %edi, ws), %ecx # ecx = c[rowa]
				movl colb(%ebp), %edi # edi = colb
				# c[rowa][colb] = eax = a[rowa][cola] * b[cola][colb]
				addl %eax, (%ecx, %edi, ws) 

				incl cola(%ebp) # cola++
				jmp cola_for_start
			cola_for_end:
			incl colb(%ebp) # colb++
			jmp colb_for_start
		colb_for_end:
		incl rowa(%ebp) # rowa++
		jmp rowa_for_start
	rowa_for_end:
	# return c
	movl c(%ebp), %eax
	# epilogue:
	pop %ebx
	pop %edi
	pop %esi
	movl %ebp, %esp
	pop %ebp
	ret

