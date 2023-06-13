	.include "complex.s"
	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main


///
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

main: 
    // x0 contiene la direccion base del framebuffer
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
    	
		movz x10, 0x75, lsl 16
		movk x10, 0xaadb, lsl 00
	bl background
	
		movz x10, 0xc6, lsl 16
		movk x10, 0xa664, lsl 00   //color arena
	bl floor
	
		movz x10, 0xff, lsl 16
		movk x10, 0xe87c, lsl 00
	bl astro

		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 120
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 20
	bl pyramid

		mov x1, 120
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
	bl pyramid

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200
		movz x10, 0x93, lsl 16
		movk x10, 0x3f94, lsl 00
		mov x4, SCREEN_HEIGH
    		lsr x4, x4, 1
    		sub x4, x4, 20      //coordenada base Y = 220
	bl dinosaurio

			mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 150
			movz x10, 0x27, lsl 16
			movk x10, 0x4739, lsl 00 // color del cactus en w10
	bl cactus

	mov x27, xzr
	
	mov x9, GPIO_BASE
	ldr x12, = 0x800000
	mov x6, 0
	mov x7, 0

/*
subir_velocidad:
	ldr x12, = 0x400000
	b InfLoop

bajar_velocidad:
	ldr x12, = 0xB00000
	b InfLoop
 */

InfLoop:
	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w14, [x9, GPIO_GPLEV0]


	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	
	and w11, w14, 0b00000010 //Mapea la W, bit 2
	//add w21, w11, wzr
	cbnz w11, day_game

	/////////////////////////////////////////////////////////
	
	//and w11, w14, 0b00000100 //Mapea la A
	//cbnz w11, bajar_velocidad //COMPLETAR

	/////////////////////////////////////////////////////////
	and w11, w14, 0b00001000 //Mapea la S
	//add w27,w11,wzr //Guardo en w27 el estado del juego. Lo voy a chquear con un cbnz o con un branch con flag común.
	cbnz w11, night_game

	/////////////////////////////////////////////////////////
	//and w11, w14, 0b00010000 //Mapea la D
	//cbnz w11, background

	/////////////////////////////////////////////////////////
	//and w11, w14, 0b00100000 //Mapea la BARRA
	//cbnz w11, jump
	
	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado
	eor x13, x13, x13
	delay2:
		add x13, x13, #1
		cmp x13, x12
		bne delay2
	b InfLoop



day_game:
	ldr w14, [x9, GPIO_GPLEV0]
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits
	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]
	// Lee el estado de los GPIO 0 - 31
	ldr w14, [x9, GPIO_GPLEV0]
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00010000 //Mapea la D
	bl subir_velocidad
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00100000 //Mapea la BARRA
	bl jump

	and w11, w14, 0b00000100 //Mapea la A
	bl bajar_velocidad
	and w11, w14, 0b00001000 //Mapea la W, bit 2
	//add w21, w11, wzr
	cbnz w11, night_game

	bl status

	add x19, x19, 1   //offset para ir moviendo las cosas en x19
	add x18, x18, 3
		movz x10, 0x75, lsl 16
		movk x10, 0xaadb, lsl 00
	bl background
	
		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 210
			sub x3, x3, x19
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 50
	bl pyramid
	
		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 120
			sub x3, x3, x19
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 30
	bl pyramid

		mov x1, 120
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, x19 //resto el offset, el objeto se mueve hacia la izquierda
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 10

	bl pyramid

		movz x10, 0xc6, lsl 16
		movk x10, 0xa664, lsl 00   //color arena
	bl floor
	
		movz x10, 0xff, lsl 16
		movk x10, 0xe87c, lsl 00
	bl astro
	
	mov x3, SCREEN_WIDTH
			
			lsr x3, x3, 1
			add x3, x3, 150
			sub x3, x3, x18 //resto el offset, el objeto se mueve hacia la izquierda
			movz x10, 0x27, lsl 16
			movk x10, 0x4739, lsl 00 // color del cactus en w10
	bl cactus

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200
			movz x10, 0x93, lsl 16
			movk x10, 0x3f94, lsl 00
			movz x25, 0x93, lsl 16
			movk x25, 0x3f94, lsl 00
		mov x4, SCREEN_HEIGH
    		lsr x4, x4, 1
    		sub x4, x4, 20      //coordenada base Y = 220
			sub x4, x4, x7
	bl dinosaurio
		
	delay1:
		add x13, x13, #1
		cmp x13, x12
		bne delay1
	b day_game

night_game:
	ldr w14, [x9, GPIO_GPLEV0]
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]
	// Lee el estado de los GPIO 0 - 31
	ldr w14, [x9, GPIO_GPLEV0]
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00010000 //Mapea la D
	bl subir_velocidad
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00100000 //Mapea la BARRA
	bl jump
	and w11, w14, 0b00000100 //Mapea la A
	bl bajar_velocidad //COMPLETAR
	and w11, w14, 0b00000010 //Mapea la W, bit 2
	//add w21, w11, wzr
	cbnz w11, day_game

	bl status
	
	add x19, x19, 1   //offset para ir moviendo las cosas en x19
	add x18, x18, 3
		movz x10, 0x29, lsl 16
		movk x10, 0x2936, lsl 00 //color del fondo
	bl background
	
		movz x10, 0xd5, lsl 16
		movk x10, 0xd5ca, lsl 00
	bl astro

		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 210
			sub x3, x3, x19
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 50
	bl pyramidNoc
	
		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 120
			sub x3, x3, x19
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 30
	bl pyramidNoc

		mov x1, 120
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, x19 //resto el offset, el objeto se mueve hacia la izquierda
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 10
	bl pyramidNoc

		movz x10, 0x00, lsl 16
		movk x10, 0x0055, lsl 00
	bl floor
	
		mov x3, SCREEN_WIDTH
			
			lsr x3, x3, 1
			add x3, x3, 150
			sub x3, x3, x18 //resto el offset, el objeto se mueve hacia la izquierda
			movz x10, 0x00, lsl 16
			movk x10, 0x3333, lsl 00 // color del cactus en w10
	bl cactus

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200

			mov x4, SCREEN_HEIGH
    			lsr x4, x4, 1
    			sub x4, x4, 20
				sub x4, x4, x7
			movz x12, 0x00, lsl 16
			movk x12, 0xFFFF, lsl 00
	bl dinosaurioNoc

	delay3:
		add x13, x13, #1
		cmp x13, x12
		bne delay3
	b night_game
