.include "basic.s"
.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480	

//--INICIO DEL DINOSAURIO--//
//Parametros: x3 = coordenada X de inicio, el tamaño y la coordenada Y (de momento) son estaticos
dinosaurio:
sub sp, sp, 8
stur x30, [sp, 0]

movz x10, 0x93, lsl 16
movk x10, 0x3f94, lsl 00 // color del dino en w10

mov x23, x3  //me guardo x3 en x23 para recuperarlo cuando lo necesite

mov x4, SCREEN_HEIGH
    lsr x4, x4, 1
    sub x4, x4, 20      //coordenada base Y = 220
mov x24, x4  //me guardo x4 en x24 para recupearlo cuando lo necesite
    //\\\\\\\\\\\\\\\\\\\
    //Cabeza del dino//
        mov x1, 50
        mov x2, 25
    
        mov x3, x23
        mov x4, x24
    // 50 x 25 (X, Y)
    bl rectangle

        mov x1, 30
        mov x2, 15

        mov x3, x23
        add x4, x4, 25
    // 30 x 15  (X, Y+25)
    bl rectangle

        mov x1, 40
        mov x2, 10

        mov x3, x23
        add x4, x4, 5
    // 40 x 5 (X, Y+35)
    bl rectangle
    
    movz x10, 0xff, lsl 16
    movk x10, 0xffff, lsl 00 
        mov x1, 5
        mov x2, 5

        mov x3, x23
            add x3, x3, 10
        mov x4, x24
            add x4, x4, 5
    // ojo : 5x5 (X+10, Y+5)
    bl rectangle
    //Fin cabeza del dino//
    //\\\\\\\\\\\\\\\\\\\\\
movz x10, 0x93, lsl 16
movk x10, 0x3f94, lsl 00 // color del dino en w10
    //\\\\\\\\\\\\\\\\\\\\\
    //TORSO DEL DINO

        mov x1, 25
        mov x2, 80

        mov x3, x23
        mov x4, x24
            add x4, x4, 40
    // 25 x 80 (X, Y+40)
    bl rectangle
        mov x1, 18
        mov x2, 10

        mov x3, x23
            add x3, x3, 25
        add x4, x4, 20
    // 18 x 10  (X+25, Y+60)
    bl rectangle
    //fin torso del dino
    //\\\\\\\\\\\\\\\\\\\\\
    //cola y patas del dino
        mov x1,70
        mov x2,30
        
        mov x3,x23
            sub x3, x3, 50
        mov x4, x24
            add x4, x4, 100
        // 70 x 30  (X-50, Y+100)
        bl rectangle

            mov x1, 25
            mov x2, 30

            mov x4, x24
                add x4, x4, 80
        // 25 x 30 (X-50, Y+180)
        bl rectangle

            mov x1, 10
            mov x2, 20

            mov x3, x23
            add x4, x4, 50
        //10 x 20 (X, Y+230)
        bl rectangle

            sub x3, x3, 20
        // 10 x 20  (X-20, Y+230)
        bl rectangle




movz x10, 0x73, lsl 16
movk x10, 0xa16c, lsl 00 // color del dino en w10


ldr x30, [sp, 0]
add sp, sp, 8
ret
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
    add x4, x4, 45  //esta sera la coordenada base de Y
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

//--INICIO DEL SOL/LUNA--//
astro:
//parametros: w10 = color
sub sp, sp, 8
stur x30, [sp, 0]

mov x3, SCREEN_WIDTH
    lsr x9, x3, 2
    lsr x3, x3, 1
    add x3, x3, x9

mov x4, SCREEN_WIDTH
    lsr x4, x4, 3
mov x5, 30
bl circle


mov x1, 40
mov x2, 40
mov x3, SCREEN_WIDTH
    lsr x9, x3, 2
    lsr x3, x3, 1
    add x3, x3, x9
    sub x3, x3, 20
mov x4, SCREEN_HEIGH
    lsr x4, x4, 3
bl rectangle


ldr x30, [sp, 0]
add sp, sp, 8
ret
//--FIN DEL SOL/LUNA--//

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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
