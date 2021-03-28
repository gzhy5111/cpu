# Òç³ö
.text
	addi $t1, $zero, 2147483647
	addi $t2, $zero, 1
	add $a0, $t1, $t2
	
	li $v0, 1
	syscall 