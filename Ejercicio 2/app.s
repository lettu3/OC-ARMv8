	.include "complex.s"
	.include "actions.s"
	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32
	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34
	.globl main

main: 
    
	mov x20, x0 // Guarda la dirección base del framebuffer en x20
    	
		movz x10, 0x75, lsl 16
		movk x10, 0xaadb, lsl 00
	bl background
		
		movz x10, 0xff, lsl 16
		movk x10, 0xe87c, lsl 00
	bl astro

		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 210
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 50
	bl pyramid
	
		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 120
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 30
	bl pyramid

		mov x1, 120
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 10

	bl pyramid

		movz x10, 0xc6, lsl 16
		movk x10, 0xa664, lsl 00   //color arena
	bl floor

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

			mov w21, w10			//guardo el color del cactus (el dino no lo puede tocar)
	bl cactus

	
	mov x9, GPIO_BASE				
	ldr x12, = 0x800000				//velocidad inicial
	mov x6, 0						//Jump_status
	mov x7, 0						//Jump offset


InfLoop:
	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w14, [x9, GPIO_GPLEV0]


	
	and w11, w14, 0b00000010 //Mapea la W, bit 2
	//add w21, w11, wzr
	cbnz w11, day_game
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00001000 //Mapea la S
	//add w27,w11,wzr //Guardo en w27 el estado del juego. Lo voy a chquear con un cbnz o con un branch con flag común.
	cbnz w11, night_game

	eor x13, x13, x13
	delay2:
		add x13, x13, #1
		cmp x13, x12
		bne delay2
	b InfLoop


day_game:
	ldr w14, [x9, GPIO_GPLEV0]
	mov x9, GPIO_BASE

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

	bl status		//checkea el estado del salto

	add x19, x19, 1   //offset para ir moviendo las cosas en el eje x en x19

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
				mov w21, w10		//guardo el color del cactus en w21 para checkear colision
	bl cactus

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200
			movz x10, 0x93, lsl 16
			movk x10, 0x3f94, lsl 00
		mov x4, SCREEN_HEIGH
    		lsr x4, x4, 1
    		sub x4, x4, 20      //coordenada base Y = 220
			sub x4, x4, x7      //resto el offset de salto, mientras mas grande mas alto estara el dino
	bl dinosaurio
		
	delay1:						//delay loop
		add x13, x13, #1
		cmp x13, x12
		bne delay1
	b day_game

night_game:
	ldr w14, [x9, GPIO_GPLEV0]
	mov x9, GPIO_BASE
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

	bl status		//checkea el estado del salto
	
	add x19, x19, 1   //offset para ir moviendo las cosas en el eje x en x19

	add x18, x18, 3
		movz x10, 0x29, lsl 16
		movk x10, 0x2936, lsl 00 //color del fondo
	bl background
	
	mov x3, 30
	mov x4, 30 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	
	mov x3, 70
	mov x4, 50 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 100
	mov x4, 200 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 421
	mov x4, 250 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 570
	mov x4, 280
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 500
	mov x4, 20
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 200
	mov x4, 300
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 350
	mov x4, 100
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 600
	mov x4, 150 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 550
	mov x4, 105 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 320
	mov x4, 220 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle

	mov x3, 400
	mov x4, 270 
	mov x5, 2
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	bl circle
	
	mov x3, SCREEN_WIDTH
    lsr x9, x3, 2
    lsr x3, x3, 1
    add x3, x3, x9

	movz x10, 0x3B, lsl 16
	movk x10, 0x3A47, lsl 00
	mov x4, SCREEN_WIDTH
    lsr x4, x4, 3
	mov x5, 50
	bl circle
	
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
				mov w21, w10		//guardo el color del cactus en w21 para checkear colision
	bl cactus

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200
			mov x4, SCREEN_HEIGH
    			lsr x4, x4, 1
    			sub x4, x4, 20
				sub x4, x4, x7		//offset de salto
	bl dinosaurioNoc

	delay3:
		add x13, x13, #1
		cmp x13, x12
		bne delay3
	b night_game
