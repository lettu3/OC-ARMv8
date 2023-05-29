.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO CALCULAR PIXEL--//
calcular_pixel:
    //params: x3 = x coord,   x4 = y coord

	mov x0, 640							// x0 = 640.
	mul x0, x0, x4						// x0 = 640 * y.		
	add x0, x0, x3						// x0 = (640 * y) + x.
	lsl x0, x0, 2						// x0 = ((640 * y) + x) * 4.
	add x0, x0, x20						// x0 = ((640 * y) + x) * 4 + framebuffer[0]
ret							
//--FIN DE CALCULAR PIXEL--//

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

//--INICIO DEL TRIANGULO--//
triangle:
//parametros: x1 = TAmaño del triangulo, x3 y x4 = coordenadas (x, y) del vertice superior del triangulo
//            w10 = color del triangulo

    sub sp, sp, 8
    stur x30, [sp, 0]

    bl calcular_pixel

    ldr x30, [sp, 0]
    add sp, sp, 8

    mov x13, x0          //x13 = pixel de inicio           
    mov x9, x1          //x9 = altura del triangulo, lo uso como contador

    triangleLoop:
        mov x12, x13                //me traigo a x12 el primer pixel de la fila
        mov x11, x1                 //me traigo a x11 el ancho maximo de fila
        add x11, x11, 1             //le sumo 1
        sub x11, x11, x9            //le resto la altura parcial, de esta manera con cada iteracion del loop, x11 va a ser cada vez mas grande

        printTriangle:
            stur w10, [x13]         //pinto el pixel
            add x13, x13, 4         //apunto al siguiente
            sub x11, x11, 1         // resto el contador de ancho de fila
            cbnz x11, printTriangle //si no llegue al final, vuelvo y pinto el siguiente pixel
            mov x13, x12            //si llegue al final de la fila, me vuelvo a parar en el primer pixel de esta
            add x13, x13, 2559      //hago un salto de linea, pero un pixel atras
            sub x9, x9, 1           //resto el contador de altura
            cbnz x9, triangleLoop   //si no es la ultima fila, repito

ret
//--FIN DEL TRIANGULO--//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL DINOSAURIO--//

//--FIN DEL DINOSAURIO--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL CACTUS--//
cactus:
//parametros: x3= coordenada x donde se empieza a pintar el cactus, la coordenada y es estatica
//el tamaño es siempre el mismo
sub sp, sp, 8
stur x30, [sp, 0]

mov x23, x3  //guardo x3 en x23 para restaurarlo cuando lo necesite

mov x4, SCREEN_HEIGH
    lsr x4, x4, 1
    add x4, x4, 40  //esta sera la coordenada base de Y
mov x24, x4 // la guardo en x24 para restaurarla cuando lo necesite


movz x10, 0x27, lsl 16
movk x10, 0x4739, lsl 00 // color del cactus en w10
    //\\\\\\\\\\\\\\\\\\\
    //tronco del cactus//
    mov x1, 20
    mov x2, 80

    mov x3, x23
        add x3, x3, 20
    mov x4, x24
    // 20x80  (X+20, Y)
    bl rectangle

    //fin tronco del cactus//
    //\\\\\\\\\\\\\\\\\\\\\\
    //brazo izquierdo//
    mov x1, 10 
    mov x2, 30

    mov x3, x23
    mov x4, x24
        add x4, x4, 20
    // 10x30 (X, Y+20)
    bl rectangle

    mov x1, 10
    mov x2, 10

    mov x3, x23
        add x3, x3, 10
    add x4, x4, 20
    // 10x10 (X, Y+40)
    bl rectangle
    //fin brazo izquierdo//
    //\\\\\\\\\\\\\\\\\\\\\
    //brazo derecho//
    mov x1, 10
    mov x2, 10

    mov x3, x23
        add x3, x3, 40
    mov x4, x24
        add x4, x4, 50
    // 10x10 (X+40, Y+40)
    bl rectangle

    mov x1, 10
    mov x2, 50

    add x3, x3, 10
    mov x4, x24
        add x4, x4, 10
    bl rectangle

    //fin brazo derecho//
ldr x30, [sp, 0]
add sp, sp, 8
ret
//--FIN DEL CACTUS--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL SUELO--//
floor:
//parametros:
sub sp, sp, 8
stur x30, [sp, 0]

	movz x10, 0xc6, lsl 16
	movk x10, 0xa664, lsl 00   //color arena

    mov x1, SCREEN_WIDTH
    mov x2, 120


    mov x3, 0
    mov x4, SCREEN_HEIGH
        lsr x4, x4, 1
        mov x9, SCREEN_HEIGH                
        lsr x9, x9, 2
        add x4, x4, x9                  

bl rectangle // 640 x 120  (0, 360)

ldr x30, [sp, 0]
add sp, sp, 8
ret
//--FIN DEL SUELO--//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//--INICIO DEL FONDO--//
background:
//parametros: w10 = color del fondo
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
//--FIN DEL FONDO--//

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
