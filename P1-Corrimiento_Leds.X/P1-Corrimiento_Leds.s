;--------------------------------------------------------------
; @author Orozco Mendoza Albert Gabriel
; @date 15/01/2023
; @ide	MPLAB X IDE v6.00
; @file P1-Corrimiento_Leds
; @brief Corrimiento de leds pares e impares, uso de botón para detener o iniciar el corrimiento
;------------------------------------------------------------------
PROCESSOR 18F57Q84
#include "Bit_config.inc"  /config statements should precede project file includes./
#include "Retardos.inc"
#include <xc.inc>
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main 
PSECT CODE 
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
w_presion:
    CLRF    LATC	    ;Se apagan los leds en C
    CLRF    LATE	    ;Se apagan los leds en E
    BTFSC   PORTA,3,0	    ;PORTA<3> = 0? - BUTTON PRESS?
    GOTO    w_presion	    ;No funciona sino está presionado el botón
    GOTO    CORRIMIENTO       
button:
    BTFSC   PORTA,3,0	    ;Ver si el botón está presionado
    RETURN
    CALL    Delay_50ms	    ;darle al usuario tiempo para dejar de presionar
    CALL    Delay_50ms
    GOTO    button2    
button2:
    BTFSC   PORTA,3,0	    ;Ver si el botón está presionado
    goto    button2	    ;Regresa al 0
    RETURN
CORRIMIENTO:
    COR_1_ES_IMPAR:
    MOVLW   00000001B	    ; Solo se prende el primer diodo
    MOVWF   LATC	    ; Se pone el dato en el C
    MOVLW   00000001B	    ; 
    MOVWF   LATE,1	    ; prende r0	
    CALL    button
    CALL    Delay_250ms,1
    COR_2_ES_PAR:
    CALL    button
    MOVLW   00000010B	    
    MOVWF   LATC	    ;Se prende el segundo diodo 
    MOVLW   00000010B	    ; w = 00000010
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    CALL    button
    CALL    Delay_250ms,1
    COR_3_ES_IMPAR:
    CALL    button
    MOVLW   00000100B	    ; w = 00000100
    MOVWF   LATC	    ; LED ON
    MOVLW   00000001B	    ; w = 00000001
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    COR_4_ES_PAR:
    CALL    button
    MOVLW   00001000B	    ; w = 00001000
    MOVWF   LATC	    ; LED ON
    MOVLW   00000010B	    ; w = 00000010
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    CALL    button
    CALL    Delay_250ms,1
    COR_5_ES_IMPAR:
    CALL    button
    MOVLW   00010000B	    ; w = 00010000
    MOVWF   LATC	    ; LED ON
    MOVLW   00000001B	    ; w = 00000001
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    COR_6_ES_PAR:
    CALL    button
    MOVLW   00100000B	    ; w = 00100000
    MOVWF   LATC	    ; LED ON
    MOVLW   00000010B	    ; w = 00000010
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    CALL    button
    CALL    Delay_250ms,1
    COR_7_ES_IMPAR:
    CALL    button
    MOVLW   01000000B	    ; w = 01000000
    MOVWF   LATC	    ; LED ON
    MOVLW   00000001B	    ; w = 00000001
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    COR_8_ES_PAR:
    CALL    button
    MOVLW   10000000B	    ; w = 10000000
    MOVWF   LATC	    ; LED ON
    MOVLW   00000010B	    ; w = 00000010
    MOVWF   LATE,1	    ; LED ON
    CALL    button
    CALL    Delay_250ms,1
    CALL    button
    CALL    Delay_250ms,1
    goto    COR_1_ES_IMPAR
 Config_OSC:
    ;Configuracion del oscilador interno a una frecuencia de 4MHz
    BANKSEL OSCCON1 
    MOVLW   0x60        ;Seleccionamos el bloque del osc con un div:1
    MOVWF   OSCCON1
    MOVLW   0x02        ; Seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ 
    RETURN
   
 Config_Port:  ;PORT-LAT-ANSEL-TRIS	    LED:RF3	BUTTON:RA3
    ;Config Led
    BANKSEL PORTC
    CLRF    PORTC,1	; PORTC = 0 
    CLRF    ANSELC,1	; ANSELF<7:0> = 0 -PORT F DIGITAL
    CLRF    TRISC
    
    ;Config Led
    BANKSEL PORTE
    CLRF    PORTE,1	; PORTF = 0 
    CLRF    ANSELE,1	; ANSELF<7:0> = 0 -PORT F DIGITAL
    CLRF    TRISE
    
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,1	; PORTA<7:0> = 0
    CLRF    ANSELA,1	; PortA digital
    BSF	    TRISA,3,1	; RA3 como entrada
    BSF	    WPUA,3,1	; Activamos la resistencia Pull-Up del pin RA3
    RETURN
	
END resetVect


