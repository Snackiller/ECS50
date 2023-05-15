.global _start
.data
num1:
	.long 10
	.long 20
num2:
	.long 30
	.long 40
.text
_start:
    movl num1, %edx
    movl num1+4, %eax
    addl num2+4, %eax
    adcl num2, %edx
done:
	nop
