.global _start
.data
dividend:
	.long 19
divisor:
	.long 6
.text
_start:
	movl $0, %edx #r
	movl $0, %eax #q
	movl $31, %ecx #i
for_start:
	shll $1, %edx
	movl dividend, %ebx
	shrl %cl, %ebx
	andl $1, %ebx
	orl %ebx, %edx
	cmpl divisor, %edx
	jl _continue
	subl divisor, %edx
	movl $1, %ebx
	shll %cl, %ebx
	orl %ebx, %eax
_continue:
	decl %ecx
	jge for_start
done:
	nop
