.global _start
.equ GPIO_BASE, 0x3f200000
.equ GPFSEL2, 0x08
.equ GPIO_21_OUTPUT, 0x8 ;//# 1 << 3
.equ GPFSET0, 0x1c
.equ GPFCLR0, 0x28
.equ GPIOVAL, 0x200000 ;//# 1 << 21

/*
A grandes razgos, el codigo setea el pin 21 a alto durante un tiempo r2, y lo setea a bajo un tiempo r2 de nuevo.
Vemos acá como se maneja un pin, como se accede a su dirección de memoria, como controlo su estado, como implementar
un temporizador que despues vamos a usar para los puntos y para cambiar el fondo y colores con cada ciclo de luz
diurna. Las direcciones de cada uno están en la datasheet, tambien el manejo de pines.
*/

_start:

	//Cargo en r0 la dirección base del GPIO. 0x3F200000
	ldr r0, =GPIO_BASE
	//El acceso a las direcciones de los otros pines se realiza mediante un offset de esta dirección base.

	/*
	Seteo la función del pin 21 como output. Significa que dado un cambio en el registro
	el pin se pone en alto (1) y da una señal que podemos ver como un true.
	*/
	ldr r1, =GPIO_21_OUTPUT
	str r1, [r0, #GPFSEL2]

	//Cargo en r2 el contador.
	ldr r2, =0x800000 //(Tambien anda 0x8)

//Loop que se corre por siempre para probarlo el tiempo que haga falta, y testear diferentes retardos de pulso.
loop: 
	//Pongo el pin 21 en alto.
	ldr r1, =GPIOVAL //Escribo el valor en el pin. Lo fuerzo a alto con la instruccion #GPFSET0.
	str r1, [r0, #GPFSET0] //Cargo #GPFSET0 en el registro.

	//Una vez que lo "presioné", espero hasta r2 con el contador que hice antes. Esto mantiene el pulso alto.
	eor r10, r10, r10
	delay1:
		add r10, r10, #1
		cmp r10, r2
		bne delay1

	//Seteo el pin en bajo, pero guardando #GPFCLR0, que lo setea a 0 (bajo).
	ldr r1, =GPIOVAL //No se muy bien que hace esto.
	str r1, [r0, #GPFCLR0]

	//Otro delay que determina cuanto tiempo pasa en estado bajo.
	eor r10, r10, r10 //Or exclusiva entre r10 y si mismo.
	delay2:
		add r10, r10, #1
		cmp r10, r2
		bne delay2

	b loop



