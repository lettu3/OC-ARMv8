.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CHECK_RANGE--//
checkRange:
//params: x3 = x coord,  x4= y coord
sub SP, SP, 8 						
stur X30, [SP, 0]	

    mov x25, SCREEN_WIDTH
    mov x26, SCREEN_HEIGH       //me traigo los valores a compararar para el rango

    cmp x3, xzr
        b.lt addWidth
    cmp x25, x3
        b.lt subWidth
    cmp x4, xzr
        b.lt addHeigh
    cmp x26, x4
        b.lt subHeigh

    b endrange

    addWidth:
        add x3, x3, SCREEN_WIDTH
        cmp x3, xzr
            b.lt addWidth
    
    subWidth:
        sub x3, x3, SCREEN_WIDTH
        cmp x25, x3
            b.lt subWidth
    
    addHeigh:
        add x4, x4, SCREEN_HEIGH
        cmp x4, xzr
            b.lt addHeigh
    
    subHeigh:
        sub x4, x4, SCREEN_HEIGH
        cmp x26, x4
            b.lt subHeigh
    
    endrange:


ldr X30, [SP, 0]				 			
add SP, SP, 8	
ret
//--FIN CHECK_RANGE--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CALCULAR_PIXEL--//
calcular_pixel: 
//params: x3 = coord x, x4 = coord y, returns the pointer to the framebuffer in that coord in x0
sub SP, SP, 8 						
stur X30, [SP, 0]	

    bl checkRange  //chequea si las coordenadas estan dentro del rango posible para el framebuffer, si no, las corrige

    mov x0, 640							// x0 = 640.
	mul x0, x0, x4						// x0 = 640 * y.		
	add x0, x0, x3						// x0 = (640 * y) + x.
	lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4.
	add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + framebuffer[0]

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN CALCULAR_PIXEL--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO PAINT_PIXEL--//
paint_pixel:
//parametros, x3 = x coord, x4 = y coord, w10 = colour;
sub SP, SP, 8 						
stur X30, [SP, 0]

    bl calcular_pixel
    stur w10,[x0]  // Colorear el pixel N

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN PAINT_PIXEL--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL RECTANGULO--//
rectangle:
//parametros: x1 = Width, x2 = Heigh, x3= initial x, x4 = initial y, w10 = color
sub SP, SP, 8 						
stur X30, [SP, 0]

    mov x13, x3     //me guardo en x13, la coordenada x inicial de cada fila
    mov x9, x2      //contador de altura
    rectangleLoop:
        mov x3, x13 //restauro la coordenada x
        mov x11, x1 //contador de ancho
        rectanglePaint:
            bl paint_pixel //pinto el pixel
            add x3, x3, 1   //avanzo al de la derecha
            sub x11, x11, 1 //resto el contador de anchos
            cbnz x11, rectanglePaint //si no llegue al final, vuelvo a pintar
            add x4, x4, 1      //bajo al pixel de abajo
            sub x9, x9, 1    //resto el contador de altura
            cbnz x9, rectangleLoop  //si no llegue al final, vuelvo a empezar
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret

//--FIN DEL RECTANGULO--//

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DE PAINT_PIXEL_COND--//
paint_pixel_cond:
//parametros, x3 = x coord, x4 = y coord, w10 = colour;
sub SP, SP, 8 						
stur X30, [SP, 0]

    bl calcular_pixel

	ldur w14, [x0]   //guardo el color previo de ese pixel en w14

	cmp w14, w21    //si ese pixel es del color que no quiero tocar...
		b.eq endgame
	//si no son iguales...
	colour_pixel:
    stur w10,[x0]  // Colorear el pixel N

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN DE PAINT_PIXEL_COND--//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DE RECTANGLE_COND--//
rectangle_cond:
//parametros: x1 = Width, x2 = Heigh, x3= initial x, x4 = initial y, w10 = color
sub SP, SP, 8 						
stur X30, [SP, 0]

    mov x13, x3     //me guardo en x13, la coordenada x inicial de cada fila
    mov x9, x2      //contador de altura
    rectangleLoop_cond:
        mov x3, x13 //restauro la coordenada x
        mov x11, x1 //contador de ancho
        rectanglePaint_cond:
            bl paint_pixel_cond //pinto el pixel
            add x3, x3, 1   //avanzo al de la derecha
            sub x11, x11, 1 //resto el contador de anchos
            cbnz x11, rectanglePaint_cond //si no llegue al final, vuelvo a pintar
            add x4, x4, 1      //bajo al pixel de abajo
            sub x9, x9, 1    //resto el contador de altura
            cbnz x9, rectangleLoop_cond  //si no llegue al final, vuelvo a empezar
ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN DE RECTANGLE_COND--//
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
	
	movz x10, 0xad, lsl 16
	movk x10, 0x9b80, lsl 00
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--PIRAMIDE NOCTURNA--//
pyramidNoc:
//parametros x1 = alto de la piramide, x3= coordenada x de la punta, x4= coordenada y de la punta
sub SP, SP, 8 						
stur X30, [SP, 0]

mov x23, x3
mov x24, x4
	
	movz x10, 0x00, lsl 16
	movk x10, 0x0011, lsl 00
	mov x3, x23
	mov x4, x24
bl triangle1

	movz x10, 0x00, lsl 16
	movk x10, 0x0033, lsl 00
	mov x3, x23
	mov x4, x24
bl triangle2

ldr X30, [SP, 0]					 			
add SP, SP, 8	
ret
//--FIN DE LA PIRAMIDE NOCTURNA--//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CIRCUNFERENCIA--//
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
	cmp x15, xzr
	b.lt true
// else ...
	sub x14, x14, 1  // y = y-1
		add x16, x13, x13	//x16 = (2 * x)
		add x17, x14, x14  // x17 = (2 * y)
		add x15, x15, x16  // x15 = error + (2 * x)
		sub x15, x15, x17	// x15 = error + (2 * x) - (2 * y)
		add x15, x15, 1		//x15 = error + (2 * x) - (2 * y) + 1
	b end

true: add x16, x13, x13  // x16 = (2 * x)
	add x15, x15, x16  // x15 = error + (2 * x)
	add x15, x15, 1   // x15 = error + (2 * x) + 1
	//... fuera de las guardas

end:add x13, x13, 1
//checkear x<y y volver a circunference loop
	subs x9, x13, x14
	b.lt circunference_loop
ldr x30, [sp, 0]
add sp, sp, 8
ret	
//--FIN DE LA CIRCUNFERENCIA--//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL CIRCULO--//
circle:
//parametros x3= coordenada x del centro, x4 = coordenada y del centro,  x5 = radio, w10 = color
sub sp, sp, 8
stur x30, [sp, 0]
mov x23, x3
mov x24, x4
	circleloop:
		bl circunference
		mov x3, x23
		mov x4, x24
		sub x5, x5, 1
		cbnz x5, circleloop					//basicamente vamos haciendo circunferencias de radio n a 1 hasta rellenar
ldr x30, [sp, 0]
add sp, sp, 8
ret
//--FIN DEL CIRCULO--//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--ENDGAME--//
endgame:
