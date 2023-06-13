jump:
sub SP, SP, 8 						
stur X30, [SP, 0]
	cmp wzr, w11
		b.lt setregister
	b endverify

	setregister:
		mov x6, 1
	endverify:

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret

status:
sub SP, SP, 8 						
stur X30, [SP, 0]
	mov x9, 1
	mov x10, 2

	cmp x6, x9
		b.eq jumping
	cmp x6, x10
		b.eq falling
	
	b endstatus

	jumping:
		add x7, x7, 2

		cmp x7, 130
			b.eq switch
		b endstatus

		switch:
			mov x6, 2
		b endstatus

	falling:
		sub x7, x7, 2

		cmp x7, 0
			b.eq finishjump
		b endstatus

		finishjump:
			mov x6, 0

	endstatus:
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret


///


bajar_velocidad:
sub SP, SP, 8 						
stur X30, [SP, 0]

	cmp wzr, w11
		b.lt sub_speed
	b end_down_speed

	sub_speed:
	ldr x12, =0xB00000

	end_down_speed:

	ldr X30, [SP, 0]					 			
	add SP, SP, 8	
ret
 
subir_velocidad:
sub SP, SP, 8 						
stur X30, [SP, 0]

	cmp wzr, w11
		b.lt add_speed
	b end_up_speed	
		
	add_speed:	
	ldr x12, =0x001000

	end_up_speed:

ldr X30, [SP, 0]					 			
add SP, SP, 8
ret
