;--------------------------------------------------------------
; @author Orozco Mendoza Albert Gabriel
; @date 30/01/2023
; @ide	MPLAB X IDE v6.00
; @file Parcial2_ejercicio2
; @brief secuencia de encendido de leds siempre y cuando se presione el botón de la placa, otros botones hacen q se pare y se reinicie (cada uno una acción distinta) y cuando no se realizan interrupciones se da un toggle
;------------------------------------------------------------------
PROCESSOR 18F57Q84
#include "Bit_Config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVectLowPriority:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    NOP			;como solo se activa cuando el botón está presionado, esta instrucción nunca se realizará		;
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO    Recarga	;inicia la secuencia de leds
PSECT ISRVectHighPriority,class=CODE,reloc=2
ISRVectHighPriority:
    BTFSS   PIR10,0,0	; ¿Se ha producido la INT1?
    RETFIE		;Sino se ha producido se regresa a donde se llamo, pero con los flags sin limpiar, de esa manera la interrupcion queda encendida y los leds no continuan
    GOTO    FIN		;si se ha presionado el botón reinicia el código
PSECT udata_acs
contador1:  DS 1	    
contador2:  DS 1
only_five:   DS 1 
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1_INT2,1
    GOTO    Toggle
Toggle:
   BTG	   LATF,3	    ;Se prende el led RF3
   CALL    Delay_500ms,1    ;Delay
   BTG	   LATF,3	    ;Se apaga el led RF3
   CALL    Delay_500ms,1    ;Delay
   goto	   Toggle
 Corrimiento1:		    ;hace la secuencia
    MOVLW	10000001B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	01000010B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	00100100B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	00011000B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	00000000B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	00011000B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	00100100B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	01000010B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	10000001B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    MOVLW	00000000B
    MOVWF	LATC,0
    CALL	Delay_250ms,1
    DECFSZ	only_five,1,0
    GOTO	Corrimiento1	;repite la secuencia
    GOTO	FIN		;cuando se reproduzca 5 veces, reinicia el código
Recarga:
    MOVLW   0x05	
    MOVWF   only_five,0		;Solo se puede reproducir el código 5 veces
    GOTO    Corrimiento1	;Va a la secuencia de leds
 Config_OSC:
    ;Configuracion del oscilador interno a una frecuencia de 4MHz
    BANKSEL OSCCON1 
    MOVLW   0x60        ;Seleccionamos el bloque del osc con un div:1
    MOVWF   OSCCON1
    MOVLW   0x02        ; Seleccionamos una frecuencia de 4MHz
    MOVWF   OSCFRQ 
    RETURN

Config_Port:	
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    BSF	    LATF,2,1
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1
    BCF	    TRISF,2,1
    ;Config User Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    ;Config portb
    BANKSEL PORTB
    CLRF    PORTB,1	
    CLRF    ANSELB,1	
    BSF	    TRISB,4,1	
    BSF	    WPUB,4,1
    ;Config portf
    BANKSEL PORTF
    CLRF    PORTF,1	
    CLRF    ANSELF,1	
    BSF	    TRISF,2,1	
    BSF	    WPUB,2,1
    ;Config portc
    BANKSEL PORTC
    CLRF    PORTC,1	
    CLRF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	; INT1 --> RB4
    ;Config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	; INT2 --> RF2
    RETURN
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
Config_INT0_INT1_INT2:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 1 -- INT1 de alta prioridad
    BSF	IPR10,0,1    ; IPR1<INT2IP> = 1 -- INT2 de alta prioridad
    
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR10,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
    
Delay_250ms:		    ;2Tcy -- Call
    MOVLW   250		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy
Ext_Loop_250ms:
    MOVLW   248		    ;n*TcyTcy
    MOVWF   contador1,0	    ;n*Tcy
Int_Loop_250ms:
    NOP				    ;k*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_250ms	    ;(k-1)*2*n*Tcy
    NOP				    ;n*Tcy
    NOP				    ;n*Tcy
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_250ms	    ;(n-1)*2Tcy
    RETURN	
Delay_500ms:
   CALL Delay_250ms,1
   CALL Delay_250ms,1
   RETURN
FIN:	    ;acaba el programa y lo reinicia
End resetVect


