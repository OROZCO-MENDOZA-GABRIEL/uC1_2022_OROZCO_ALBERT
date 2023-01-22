;--------------------------------------------------------------
; @author Orozco Mendoza Albert Gabriel
; @date 15/01/2023
; @ide	MPLAB X IDE v6.00
; @file P2-Display_7SEG
; @brief Programa que muestra números o letras dependiendo de lo que decida el usuario
;------------------------------------------------------------------
PROCESSOR 18F57Q84
#include "Bit_config.inc"	// config statements should precede project file includes.
#include "Retardos.inc"
#include <xc.inc>
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1  
N0:
    MOVLW	11000000B   ;Sube el 1 al puerto D
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N1	;si el botón no está presionado va al 1
    GOTO	axd ;si el botón  está presionado va al a
N1:
    MOVLW	11111001B   ;Sube el 1 al puerto D
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N2	;si el botón no está presionado va al 2
    GOTO	axd ;si el botón  está presionado va al a
N2:
    MOVLW	10100100B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N3 ;si el botón no está presionado va al 3
    GOTO	axd;si el botón  está presionado va al a
N3:
    MOVLW	10110000B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N4 ;si el botón no está presionado va al 4
    GOTO	axd ;si el botón  está presionado va al a   
N4:
    MOVLW	10011001B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N5 ;si el botón no está presionado va al 5
   GOTO 	axd ;si el botón  está presionado va al a
N5:
    MOVLW	10010010B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N6 ;si el botón no está presionado va al 6
    GOTO	axd ;si el botón  está presionado va al a
N6:
    MOVLW	10000010B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N7 ;si el botón no está presionado va al 7
    GOTO	axd ;si el botón  está presionado va al a  
N7:
    MOVLW	11111000B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N8 ;si el botón no está presionado va al 8
    GOTO	axd ;si el botón  está presionado va al a
N8:
    MOVLW	10000000B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N9 ;si el botón no está presionado va al 9
    GOTO	axd ;si el botón  está presionado va al a
N9:
    MOVLW	10010000B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0 ;si el botón no está presionado va al 0
    GOTO	axd ;si el botón  está presionado va al a
axd:
    MOVLW	10001000B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0 ;si el botón no está presionado va al 1
    GOTO	bxd  ;si el botón  está presionado va al b 
bxd:
    MOVLW	10000011B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0  ;si el botón no está presionado va al 1
    GOTO	cxd ;si el botón  está presionado va al c
cxd:
    MOVLW	11000110B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0 ;si el botón no está presionado va al 1
    GOTO	dxd ;si el botón  está presionado va al d 
dxd:
    MOVLW	10100001B
    MOVWF	PORTD
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0 ;si el botón no está presionado va al 1
    GOTO	exd ;si el botón  está presionado va al e 
exd:
    MOVLW	10000110B
    MOVWF	PORTD,1
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0 ;si el botón no está presionado va al 1
    GOTO	fxd ;si el botón  está presionado va al f 
fxd:
    BANKSEL	PORTD
    SETF	LATD,1
    MOVLW	10001110B
    MOVWF	PORTD,1
    CALL	Delay_1s
    BTFSC	PORTA,3,0   ;PORTA <3> = 0  -  BUTTON PRESS
    GOTO	N0 ;si el botón no está presionado va al 1
    GOTO	axd ;si el botón  está presionado va al a
Config_OSC:
    ;configuración del oscilador interno a una frecuencia de 8MHz
    BANKSEL	OSCCON1
    MOVLW	0x60	    ;seleccionamos el bloque del oscilador interno con un div:1
    MOVWF	OSCCON1,1
    MOVLW	0x02	    ;seleccionamos una frecuencia de 8MHz
    MOVWF	OSCFRQ,1 
    RETURN
Config_Port:		    
    ;config PORTD
    BANKSEL	PORTD
    CLRF	PORTD,1	    ;PORTF = 0 
    bsf		LATD,7,1	    ;LATF = 1
    CLRF	ANSELD,1    ;ANSELF<7:F> = 0 - PORT D DIGITAL    
    MOVLW 00000000B	
    MOVWF TRISD	;se pone el puerto d como salida
    ;config Button
    BANKSEL PORTA
    CLRF    PORTA,1	    ;PORTA<7:0> = 0 
    CLRF    ANSELA,1	    ;PORTA digital
    BSF	    TRISA,3,1	    ;RA3 como entrada
    BSF	    WPUA,3,1	    ;Activamos la resistencia pull-up del pin RA3
    RETURN
			    
END resetVect



