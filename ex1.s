.data
matrice: .space 1600
matrice_aux: .space 1600
m: .space 4
n: .space 4
p: .space 4
k: .space 4
newLine: .asciz "\n"
formatInt: .asciz "%d "
formatString: .asciz "%s"

.text

.global main
main:
lea matrice, %edi

pushl $m
pushl $formatInt
call scanf

pushl $n
pushl $formatInt
call scanf

pushl $p
pushl $formatInt
call scanf

addl $24, %esp
addl $2, m
addl $2, n

movl p, %ecx

citire_celule:
	cmpl $0, %ecx
	je evolutie
	
	pushl %ecx
	pushl $p
	pushl $formatInt
	call scanf
	pushl $k
	pushl $formatInt
	call scanf
	addl $16, %esp
	
	incl p
	incl k
	movl p, %eax
	mull n
	addl k, %eax
	movl $1, (%edi, %eax, 4)
	
	popl %ecx
	decl %ecx
	jmp citire_celule
	
evolutie:
pushl $k
pushl $formatInt
call scanf
addl $8, %esp

k_iteratii:
	cmpl $0, k
	je afisare_matrice
	
	movl $1, %ecx
	k_iteratii_linii:
		cmpl %ecx, m
		je cont_k_iteratii
		
		movl $1, %edx
		k_iteratii_col:
			cmpl %edx, n
			je cont_k_iteratii_col
			
			movl %edx, %ebx
			pushl %edx
			movl %ecx, %eax
			mull n
			addl %ebx, %eax
			
			#pushl %edi
			#pushl %eax
			#call celula
			#addl $4, %esp
			#popl %edi
			
			popl %edx
			incl %edx
			jmp k_iteratii_col
			cont_k_iteratii_col:
				incl %ecx
				jmp k_iteratii_linii
	cont_k_iteratii:
		decl k
		jmp k_iteratii
	
celula:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %edi
	movl 12(%ebp), %ecx
	
	xorl %edx, %edx
	addl 4(%edi, %ecx, 4), %edx
	addl -4(%edi, %ecx, 4), %edx
	subl n, %ecx
	addl (%edi, %ecx, 4), %edx
	addl 4(%edi, %ecx, 4), %edx
	addl -4(%edi, %ecx, 4), %edx
	addl n, %ecx
	addl n, %ecx
	addl (%edi, %ecx, 4), %edx
	addl 4(%edi, %ecx, 4), %edx
	addl -4(%edi, %ecx, 4), %edx
	
	popl %ebp
	ret
	
afisare_matrice:
xorl %ecx, %ecx
afisare_linii:
	cmpl %ecx, m
	je exit
	
	xorl %edx, %edx
	afisare_coloane:
		cmpl %edx, n
		je cont_afisare_coloane
		
		movl %edx, %ebx
		pushl %edx
		movl %ecx, %eax
		mull n
		addl %ebx, %eax
		
		movl (%edi, %eax, 4), %ebx
		pushl %ecx
		pushl %ebx
		pushl $formatInt
		call printf
		pushl $0
		call fflush
		addl $12, %esp
		popl %ecx
		popl %edx
		
		incl %edx
		jmp afisare_coloane
		cont_afisare_coloane:
			pushl %ecx
			pushl %edx
			pushl $newLine
			pushl $formatString
			call printf
			pushl $0
			call fflush
			addl $12, %esp
			popl %edx
			popl %ecx
			
			incl %ecx
			jmp afisare_linii
	
exit:
movl $1, %eax
xorl %ebx, %ebx
int $0x80
