	.file	"hello.c"
	.text
	.globl	hello
	.data
	.align 4
	.type	hello, @object
	.size	hello, 16
hello:
	.string	"Hello World!!!\n"
	.globl	buf
	.bss
	.align 32
	.type	buf, @object
	.size	buf, 1024
buf:
	.zero	1024
	.section	.rodata
.LC0:
	.string	"%s"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	$hello
	pushl	$.LC0
	call	printf
	addl	$8, %esp
	movl	$0, %eax
	leave
	ret
	.size	main, .-main
	.section	.note.GNU-stack,"",@progbits
