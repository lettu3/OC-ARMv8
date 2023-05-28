.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

calcular_pixel:
    //params: x3 = x coord,   x4 = y coord

	mov x0, 640							// x0 = 640.
	mul x0, x0, x4						// x0 = 640 * y.		
	add x0, x0, x3						// x0 = (640 * y) + x.
	lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4.
	add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + framebuffer[0]
ret							


rectangle:
    //Params: (x3, x4 = initial coords) (x1, x2 = width, heigh) (w10 = colour)

	sub SP, SP, 8 						
	stur X30, [SP, 0]					
	bl calcular_pixel 			
	ldr X30, [SP, 0]					 			
	add SP, SP, 8						
	// Usamos los registros temporales: x9, x11, x12, x13
	mov x9, x2		// x9 = contador altura				
	mov x13, x0							
	rectangleLoop:
		mov x11, x1     // x11 = contador de ancho
		mov x12, x13	//x12 va a ser un registro donde guardo el pixel inicial de cada fila, lo necesito tener pq voy a estar haciendo operaciones en x13				
		printRectangle:
			stur w10, [x13]				
			add x13, x13, 4	    //avanzo al siguiente pixel			
			sub x11, x11, 1		//resto el contador de ancho	    	
			cbnz x11, printRectangle    //si no llegue al final de la fila, vuelvo a pintar el siguiente pixel	
			mov x13, x12				//si llegue al final de la fila, me vuelvo a parar en el primer pixel de la fila
			add x13, x13, 2560			//sumo 2560, equivalente a saltar a la fila de debajo
			sub x9, x9, 1				//resto el contador de altura
			cbnz x9, rectangleLoop	    // si no llegue a la ultima fila, vuelvo a pintar
ret


triangulo:
//parametros:(x3,x4  = coords iniciales) (x1, altura) (w10 = color)
    sub sp, sp, 8
    stur x30, [sp, 0]
///????///
    bl calcular_pixel
///
    ldr x30, [sp, 0]
    add sp, sp, 8
//registros a usar ???????  x9 = contador de altura, x11 = contador de ancho de fila,  x12 = contador de nivel
    mov x9, x1
    mov x13, x0

triangleLoop:
    mov x11, x1
    add x11, x11, 1
    sub x11, x11, x9
    mov x12, x13

///
printTriangle:
    stur w10, [x13]     //coloreo el pixel
    add x13, x13, 4     //avanzo al siguiente pixel
    sub x11, x11, 1     //resto el contador de ancho de fila
    cbnz x11, printTriangle //si no llegue al final de la fila, vuelvo a pintar el siguiente pixel
    mov x13, x12            //me vuelvo a parar en el primer pixel de la fila
    add x13, x13, 2559      //salto una linea abajo pero un pixel atras
    sub x9, x9, 1           //resto el contador de altura
    cbnz x9, triangleLoop   //si no llegue a la base, vuelve a pintar



ret




floor:
sub sp, sp, 8
stur x30, [sp, 0]

	movz x10, 0xc6, lsl 16
	movk x10, 0xa664, lsl 00

    mov x1, SCREEN_WIDTH
    mov x2, SCREEN_HEIGH
        lsr x4, x4, 1
        mov x9, SCREEN_HEIGH
        lsr x9, x9, 2
        add x4, x4, x9


    mov x3, 0
    mov x4, SCREEN_HEIGH
        lsr x4, x4, 1
        mov x9, SCREEN_HEIGH
        lsr x9, x9, 2
        add x4, x4, x9

bl rectangle


ldr x30, [sp, 0]
add sp, sp, 8
ret

background:
    sub sp, sp, 8
    stur x30, [sp, 0]

    mov x1, SCREEN_WIDTH     //todo el ancho de la pantalla
    mov x2, SCREEN_HEIGH    //toda la altura de la pantalla
    mov x3, 0               
    mov x4, 0               //coordenada 0,0
    bl rectangle
    ldr x30, [sp, 0]
    add sp, sp, 8
ret



