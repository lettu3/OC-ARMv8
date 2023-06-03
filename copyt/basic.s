.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CALCULAR PIXEL--//
calcular_pixel:
    //params: x3 = x coord,   x4 = y coord

	//QUE PASA SI (X3>640 o X3 < 0) O (X4 > 480 o X4 < 0)????
	//NECESARIO PARA EJERCICIO 2 ARREGLAR ESTO 

	mov x0, 640							// x0 = 640.
	mul x0, x0, x4						// x0 = 640 * y.		
	add x0, x0, x3						// x0 = (640 * y) + x.
	lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4.
	add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + framebuffer[0]
ret							
//--FIN DE CALCULAR PIXEL--//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO PINTAR PIXEL--//

paint_pixel:
//params x3 = x coord, x4 = y coord  w10 = colour
sub SP, SP, 8 						
stur X30, [SP, 0]		

	bl calcular_pixel
	stur w10, [x0]

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret

//--FIN DE PINTAR PIXEL--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL RECTANGULO--//
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
//--FIN DEL RECTANGULO--//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL TRIANGULO1--//
triangle1:
//parametros: x1 = TAmaño del triangulo, x3 y x4 = coordenadas (x, y) del vertice superior del triangulo
//            w10 = color del triangulo
sub SP, SP, 8 						
stur X30, [SP, 0]

	mov x9, x1
	mov x13, x3
	triangleLoop1:
		mov x3, x13				//guardo en x13 la coordenada x del primer pixel de la fila
		mov x11, x1
			add x11, x11, 1
		sub x11, x11, x9

		printTriangle1:
			bl paint_pixel
			add x3, x3, 1			//sumo 1 a la coord x
			sub x11, x11, 1			//resto el contador de largo de fila
			cbnz x11, printTriangle1 // si no llegue al final de la fila, pinto otro pixel
			sub x13, x13, 1         // le resto 1 a la coordenada x del primer pixel de la fila almacenada en x13
			add x4, x4, 1			//sumo 1 a la coord y
			sub x9, x9, 1           //resto el contador de altura
			cbnz x9, triangleLoop1 // si no llegue a la ultima fila, repito
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN DEL TRIANGULO1--//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL TRIANGULO2--//
triangle2:
//parametros: x1 = TAmaño del triangulo, x3 y x4 = coordenadas (x, y) del vertice superior del triangulo
//            w10 = color del triangulo
sub SP, SP, 8 						
stur X30, [SP, 0]

	mov x9, x1
	mov x13, x3
	triangleLoop2:
		mov x3, x13				//guardo en x13 la coordenada x del primer pixel de la fila
		mov x11, x1
			add x11, x11, 1
		sub x11, x11, x9

		printTriangle2:
			bl paint_pixel
			add x3, x3, 1			//sumo 1 a la coord x
			sub x11, x11, 1			//resto el contador de largo de fila
			cbnz x11, printTriangle2 // si no llegue al final de la fila, pinto otro pixel
			add x4, x4, 1			//sumo 1 a la coord y
			sub x9, x9, 1           //resto el contador de altura
			cbnz x9, triangleLoop2 // si no llegue a la ultima fila, repito
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN DEL TRIANGULO2--//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DE LA PIRAMIDE--//
pyramid:
//parametros x1 = alto de la piramide, x3= coordenada x de la punta, x4= coordenada y de la punta
sub SP, SP, 8 						
stur X30, [SP, 0]

mov x23, x3
mov x24, x4

	mov x3, x23
	mov x4, x24
bl triangle1

	movz x10, 0x92, lsl 16
	movk x10, 0x7e5e, lsl 00
	mov x3, x23
	mov x4, x24
bl triangle2

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN DE LA PIRAMIDE--//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CIRCUNFERENCIA--//
//COMPLETAR//COMPLETAR//COMPLETAR//COMPLETAR//COMPLETAR//COMPLETAR//COMPLETAR//COMPLETAR//
circunference:
//parametros: x3 = coordenada x del centro, x4 = coordenada y del centro, x5 = radio,  w10 = color
sub sp, sp, 8
stur x30, [sp, 0]

mov x23, x3
mov x24, x4     //me guardo en x23 y x24 las coordenadas del centro para poder restaurarlas

mov x13, xzr			//x13 va a representar mi offset de x, inicialmente 0
mov x14, x5				//x14 va a representar mi offset de y, inicialmente r
mov x15, 1				//x15 va a representar el error
	sub x15, x15, x5

circunference_loop:  //while ....
	mov x3, x23					
		add x3, x3, x13			// x_mid + x
	mov x4, x24
		add x4, x4, x14			// y_mid + y
	bl paint_pixel

	mov x3, x23
		add x3, x3, x14      // x_mid + y
	mov x4, x24
		add x4, x4, x13      // y_mid + x				
	bl paint_pixel

	mov x3, x23
		sub x3, x3, x14    // x_mid - y
	mov x4, x24
		add x4, x4, x13    // y_mid + x
	bl paint_pixel

	mov x3, x23
		sub x3, x3, x13   // x_mid - x
	mov x4, x24
		add x4, x4, x14   // y_mid + y
	bl paint_pixel

	mov x3, x23
		sub x3, x3, x13  // x_mid - x
	mov x4, x24
		sub x4, x4, x14  // y_mid - y
	bl paint_pixel

	mov x3, x23
		sub x3, x3, x14  // x_mid - y
	mov x4, x24
		sub x4, x4, x13  // y_mid - x
	bl paint_pixel

	mov x3, x23
		add x3, x3, x14  // x_mid + y
	mov x4, x24
		sub x4, x4, x13  // y_mid - x
	bl paint_pixel

	mov x3, x23
		add x3, x3, x13		// x_mid + x
	mov x4, x24
		sub x4, x4, x14  // y_mid - y
	bl paint_pixel


// if x15 < 0....
		add x16, x13, x13  // x16 = (2 * x)
		add x15, x15, x16  // x15 = error + (2 * x)
	add x15, x15, 1   // x15 = error + (2 * x) + 1

// else ...
	sub x14, x14, 1  // y = y-1
		add x16, x13, x13	//x16 = (2 * x)
		add x17, x14, x14  // x17 = (2 * y)
		add x15, x15, x16  // x15 = error + (2 * x)
		sub x15, x15, x17	// x15 = error + (2 * x) - (2 * 16)
		add x15, x15, 1		//x15 = error + (2 * x) - (2 * 16) + 1

//... fuera de las guardas

	add x13, x13, 1
//checkear x<y y volver a circunference loop

ldr x30, [sp, 0]
add sp, sp, 8
ret


circle:
//parametros x3= coordenada x del centro, x4 = coordenada y del centro,  x5 = radio, w10 = color
	circleloop:
		bl circunference
		sub x5, x5, 1
		cbnz x5, circleloop					//basicamente vamos haciendo circunferencias de radio n a 1 hasta rellenar
ret
