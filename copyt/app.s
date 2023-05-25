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


	movz x10, 0x00, lsl 16
	movk x10, 0x9846, lsl 00 //color del pasto en x10

    mov x2, SCREEN_HEIGH         // x2 = Y Size

loop1:
	mov x1, SCREEN_WIDTH         // X Size
	
printGround:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,printGround  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop1  // Si no es la última fila, salto

sky:
	mov x0, x20      //restauro la direccion base del framebuffer...
	movz x10, 0x75, lsl 16
	movk x10, 0xaadb, lsl 00 //color del cielo en x10

	mov x2, SCREEN_HEIGH         // x2 = Y Size
	lsr x2, x2, 1 				 // x2 = (Y Size / 2)

	//me gustaria que el cielo sea 1/4 mas grande que el suelo
	mov x9, x2					// guardo en x9 mi Ysz/2
	lsr x2, x2, 1				// x2 = Ysz/4
	add x2, x2, x9				// x2 = Ysz/2 + Ysz/4

loop2:
	mov x1, SCREEN_WIDTH

printSky:
	stur w10,[x0]  // Colorear el pixel N
	add x0,x0,4    // Siguiente pixel
	sub x1,x1,1    // Decrementar contador X
	cbnz x1,printSky  // Si no terminó la fila, salto
	sub x2,x2,1    // Decrementar contador Y
	cbnz x2,loop2  // Si no es la última fila, salto

Sun:
	mov x0, x20 // restauro la direccion base del framebuffer...
	movz x10, 0xfc, lsl 16
	movk x10, 0xbf49, lsl 00 //color del sol en x10

	mov x2, SCREEN_HEIGH  // en este caso, N Size 
	lsr x2, x2, 2         // N Size := N Size / 4
	mov x3, x2
	lsr x3, x3, 1       // en x3 voy a guardar el radio de mi circulo




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
	cbnz w11, InfLoop

	// si w11 es 0 entonces el GPIO 1 estaba liberado
	// de lo contrario será distinto de 0, (en este caso particular 2)
	// significando que el GPIO 1 fue presionado

	//---------------------------------------------------------------
	// Infinite Loop


InfLoop:
	b InfLoop


