;--------------------------------------------------------------
; @author Orozco Mendoza Albert Gabriel
; @date 15/01/2023
; @ide	MPLAB X IDE v6.00
; @file P3-Contador_7SEG_7447
; @brief contador de 0 a99 usando 7447, si el botón está presionado es descendente, sino ascendente 
;------------------------------------------------------------------
PROCESSOR 18F57Q84
#include "Bit_config.inc"  /config statements should precede project file includes./
#include <xc.inc>
PSECT udata_acs
contador1: DS	1		;reserva un bit en acces ram
contador2: DS	1		;reserva un bit en acces ram
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main 
PSECT CODE 
Main:
    CALL Config_OSC,1
    CALL Config_Port,1
INICIO:
    CALL  Delay_1s
    BTFSC   PORTA,3,0  ;PORTA<3> = 0? - Button press?
    GOTO Inicio_no_boton;pondrá un cero en las salidas
    GOTO Inicio_boton	;pondrá un 99 en las salidas
button:
    BTFSC PORTA,3,0  ;PORTA<3> = 0? - Button press?
    GOTO CUAL_SUMA	;sino está presionado el botón suma
    GOTO CUAL_RESTA	;si está presionado el botón resta
CUAL_SUMA:
    MOVF 0x504,0    ;sube el número al w
    CPFSEQ 0x503    ;lo compara con 99
    GOTO NO_99	    ;si no es 99 va al siguiente análisis
    GOTO button	    ;sino espera a que presionen el botón para restar
NO_99:    
    BTFSC 0X504,3
    btfss 0X504,0   ;compara si no es 9
    GOTO S_NORMAL	    ;si no es 9 suma normal
    GOTO S_NO_NORMAL	    ;si es 9 hay una suma distinta    
S_NORMAL:
    MOVLW 0001B
    ADDWF 0x504,0,0 ;suma 1 al número
    BANKSEL PORTB
    MOVWF PORTB,1   ;sube el resultado al puerto B
    MOVWF 0x504	    ; el nuevo número es guardado en el registro 0x504
    CALL Delay_1s,0
    GOTO button
S_NO_NORMAL:
    MOVLW 0x07	;9+7 sale 10 en suma hexadecima
    ADDWF 0x504,0,0 ;suma al número anterior
    MOVWF PORTB	;sube el resultado al puerto B
    MOVWF 0x504	; el nuevo número es guardado en el registro 0x504
    CALL Delay_1s,0
    GOTO button    
CUAL_RESTA:
    MOVF 0x504,0 ;sube el valor de 504 al w
    MOVWF 0X510	;carga el número a registro 0x510
    TSTFSZ 0X510    ;salta si el resultado es 0
    GOTO NO_0
    GOTO button
NO_0:    
    ANDWF 0X530,0
    MOVWF 0X531
    TSTFSZ 0x531    ;salta si el valor es 0
    GOTO R_NORMAL
    GOTO R_NO_NORMAL
R_NORMAL:
    MOVLW 0001B	    ;resta 1 al valor
    SUBWF 0x504,0,0 ;resta el valor de f con w 
    MOVWF PORTB	    ;carga el valor al portb
    MOVWF 0x504	    ;pone el resultado en 0x504
    CALL Delay_1s,0
    GOTO button
R_NO_NORMAL:
    MOVLW 0x07	;resta 7 al valor
    SUBWF 0x504,0,0 ;resta el valor de f con w 
    MOVWF PORTB  ;carga el valor al portb
    MOVWF 0x504	;pone el resultado en 0x504
    CALL Delay_1s,0
    GOTO button    
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
    BANKSEL PORTB
    CLRF    PORTB,1	; PORTF = 0 
    CLRF    ANSELB,1	; ANSELF<7:0> = 0 -PORT F DIGITAL
    MOVLW 00000000B
    MOVWF TRISB
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,1	; PORTA<7:0> = 0
    CLRF    ANSELA,1	; PortA digital
    BSF	    TRISA,3,1	; RA3 como entrada
    BSF	    WPUA,3,1	; Activamos la resistencia Pull-Up del pin RA3
    MOVLW 0x99
    MOVWF 0X503
    MOVLW 0X0F
    MOVWF 0X530
    RETURN 
Inicio_no_boton:
    MOVLW 0x00
    MOVWF PORTB	;ponemos 0 en el puerto B
    MOVWF 0x504	;guardamos el cero en el registro 0x504
    CALL Delay_1s,0
    GOTO button; va al botón
Inicio_boton:
    MOVLW 0x99	;ponemos 99 en el puerto D
    MOVWF PORTB
    movwf 0x504	;guardamos el 99 en el registro 0x504
    CALL Delay_1s,0
    GOTO button
Delay_1s:
    Call Delay_250ms
    Call Delay_250ms
    Call Delay_250ms
    Call Delay_250ms
    Return
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
    RETURN			    ;2Tcy
END resetVect


