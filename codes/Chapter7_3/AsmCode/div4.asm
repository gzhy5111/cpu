.text
	main:
		li	$t0, -10
		li	$t1, 10
		li	$t2, 5
		li	$t3, -5
		
		# -10/5 = -2
		div	$t0, $t2	# ffff fffe�����룩
		# -10/-5 = 2
		div	$t0, $t3	# 0000 0002�����룩
		# 10/5   = 2
		div	$t1, $t2	# 0000 0002�����룩
		# 10/-5 = -2
		div	$t1, $t3	# ffff fffe�����룩