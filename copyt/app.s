	.include "complex.s"
	.equ SCREEN_WIDTH,   640
	.equ SCREEN_HEIGH,   480
	.equ BITS_PER_PIXEL, 32

	.equ GPIO_BASE,    0x3f200000
	.equ GPIO_GPFSEL0, 0x00
	.equ GPIO_GPLEV0,  0x34

	.globl main

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
			add x3, x3, 150
			movz x10, 0x27, lsl 16
			movk x10, 0x4739, lsl 00 // color del cactus en w10
	bl cactus

			mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 300
			movz x10, 0x93, lsl 16
			movk x10, 0x3f94, lsl 00
	bl dinosaurio
	
	mov x9, GPIO_BASE
	ldr x12, = 0x800000

/* 
userInput:
	// Ejemplo de uso de gpios
	mov x9, GPIO_BASE

	// Atención: se utilizan registros w porque la documentación de broadcom
	// indica que los registros que estamos leyendo y escribiendo son de 32 bits

	// Setea gpios 0 - 9 como lectura
	str wzr, [x9, GPIO_GPFSEL0]

	// Lee el estado de los GPIO 0 - 31
	ldr w10, [x9, GPIO_GPLEV0]

	// And bit a bit mantiene el resultado del bit 2 en w10 (notar 0b... es binario)
	// al inmediato se lo refiere como "máscara" en este caso:
	// - Al hacer AND revela el estado del bit 2
	// - Al hacer OR "setea" el bit 2 en 1
	// - Al hacer AND con el complemento "limpia" el bit 2 (setea el bit 2 en 0)
	and w11, w10, 0b00000010
	cbnz w11, night

	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado

	//---------------------------------------------------------------
	// Infinite Loop
	b userInput*/


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
	
	//mov x20, x0 // Guarda la dirección base del framebuffer en x20
    movz x10, 0x00, lsl 16
	movk x10, 0x0000, lsl 00 //color del fondo
	and w11, w14, 0b00000010 //Mapea la W, bit 2
	cbnz w11, night

	//////CAMBIOS ANTES DE LLAMAR A LA FUNCION CON LA A//////
	movz x10, 0xFF, lsl 16
	movk x10, 0xFFFF, lsl 00
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00000100 //Mapea la A
	cbnz w11, background

	//////CAMBIOS ANTES DE LLAMAR A LA FUNCION CON LA S//////
	movz x10, 0xFF, lsl 16
	movk x10, 0x0066, lsl 00
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00001000 //Mapea la S
	add w27,w11,wzr //Guardo en w27 el estado del juego. Lo voy a chquear con un cbnz o con un branch con flag común.
	cbnz w11, background

	//////CAMBIOS ANTES DE LLAMAR A LA FUNCION CON LA D//////
	movz x10, 0x66, lsl 16
	movk x10, 0xFFCC, lsl 00
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00010000 //Mapea la D
	cbnz w11, background

	//////CAMBIOS ANTES DE LLAMAR A LA FUNCION CON LA BARRA//////
	movz x10, 0x66, lsl 16
	movk x10, 0xFF00, lsl 00
	/////////////////////////////////////////////////////////
	and w11, w14, 0b00100000 //Mapea la BARRA
	cbnz w11, background
	


	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado
	eor x13, x13, x13
	delay2:
		add x13, x13, #1
		cmp x13, x12
		bne delay2
	b InfLoop

night:
	
	mov x0, x20

	    movz x10, 0x29, lsl 16
		movk x10, 0x2936, lsl 00 //color del fondo
	bl background
	
	movz x10, 0x00, lsl 16
	movk x10, 0x0055, lsl 00
	bl floor
	
		movz x10, 0xd5, lsl 16
		movk x10, 0xd5ca, lsl 00
	bl astro

		
		mov x1, 100
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 120
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
			add x4, x4, 20
	bl pyramidNoc

		mov x1, 120
		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
	bl pyramidNoc


		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 150
			movz x10, 0x00, lsl 16
			movk x10, 0x3333, lsl 00 // color del cactus en w10
	bl cactus

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200
			 // color del cactus en w10
	bl dinosaurioNoc
	b InfLoop



day_game:
	add x19, x19, 1   //offset para ir moviendo las cosas en x19

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
			sub x3, x3, x19 //resto el offset, el objeto se mueve hacia la izquierda
		mov x4, SCREEN_HEIGH
			lsr x4, x4, 1
	bl pyramid

		mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			add x3, x3, 150
			sub x3, x3, x19 //resto el offset, el objeto se mueve hacia la izquierda
			movz x10, 0x27, lsl 16
			movk x10, 0x4739, lsl 00 // color del cactus en w10
	bl cactus

			mov x3, SCREEN_WIDTH
			lsr x3, x3, 1
			sub x3, x3, 200
			movz x10, 0x93, lsl 16
			movk x10, 0x3f94, lsl 00
	bl dinosaurio

/*Lo siguiente es un intento de hacer brillar al dinosaurio dibujando un circulo en el piso abajo de él
Deberia ser del mismo celeste pero mas oscuro para dar la ilusión de que alumbra el piso*/

