;--------------------------------------------------------------
; @author Orozco Mendoza Albert Gabriel
; @date 15/01/2023
; @ide	MPLAB X IDE v6.00
; @file P4-Contador_7SEG_74HC595
; @brief contador de 0 a99 usando 74HC595, si el botón está presionado es descendente, sino ascendente 
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
    CALL Config_OSC,1
    CALL Config_Port,1
    CALL SUBIDA_DE_VALORES
INICIO:
    CALL    Delay_1s
    BTFSC   PORTA,3,0  ;PORTA<3> = 0? - Button press?
    GOTO    INICIO_NO_BOTON ;va al número 0
    GOTO    INICIO_BOTON ;va al número 99
button:
    BTFSC PORTA,3,0  ;PORTA<3> = 0? - Button press?
    GOTO CUAL_SUMA	;sino está presionado el botón suma
    GOTO CUAL_RESTA	;si está presionado el botón resta
CUAL_SUMA:
    MOVF 0x504,0    ;sube el número al w
    CPFSEQ 0x508    ;lo compara con 99
    GOTO NO_99	    ;si no es 99 va al siguiente análisis
    GOTO button	    ;sino espera a que presionen el botón para restar
NO_99:    
    BTFSC 0X504,3
    btfss 0X504,0   ;compara si no es 9
    GOTO S_NORMAL	    ;si no es 9 suma normal
    GOTO S_NO_NORMAL	    ;si es 9 hay una suma distinta  
S_NORMAL:
    MOVLW 0001B
    ADDWF 0x504,0,0 ;suma 1 al número anterior
    movwf 0x504
    andwf 0x518,0 ;mira solo las unidades
    Call VERIFICAR ;sube las unidades
    MOVLW 100B ;bit fantasma
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    movf 0x504,0 ;trae el resultado 0x504
    andwf 0x519,0 ;multiplica con 0x519
    movwf 0x530 ;lo paso a otro registro
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530 ;rota para q quede en unidades
    movf  0x530,0
    Call VERIFICAR ;sube las decenas
    bsf   PORTA,1
    BCF	  PORTA,1
    CALL Delay_1s
    GOTO button
S_NO_NORMAL:
    MOVLW 0x07 ;suma +0x07, para q aumente en uno las decenas y la unidad vaya a 0
    ADDWF 0x504,0,0 ;suma con 0x504+0x07
    MOVWF 0x504 ;guarda la  suma en 0x504
    andwf 0x518,0 ;pone solo las unidades
    Call VERIFICAR ;sube las unidades
    MOVLW 100B ;bit fantasma
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    movf 0x504,0 ;sube el número al w
    andwf 0x519,0 ;mira solo las decenas
    movwf 0x530
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530 ;pone las decenas en las unidades
    RRNCF 0X530
    movf  0x530,0 ;sube el número de las decenas al w
    Call VERIFICAR ;sube las decenas
    bsf   PORTA,1 ;sube todos los datos
    BCF	  PORTA,1
    CALL Delay_1s
    GOTO button
CUAL_RESTA:
    MOVF 0x504,0 ;sube el valor de 504 al w
    MOVWF 0X510	;carga el número a registro 0x510
    TSTFSZ 0X510    ;salta si el resultado es 0
    GOTO NO_0
    GOTO button
NO_0:    
    ANDWF 0X535,0
    MOVWF 0X531
    TSTFSZ 0x531    ;salta si el valor es 0
    GOTO R_NORMAL
    GOTO R_NO_NORMAL
R_NORMAL:
    MOVLW 0001B ;sube 1 al w
    SUBWF 0x504,0,0 ;resta el número con 1
    movwf 0x504 ;el resultado pasa al 0x504
    andwf 0x518,0 ;mira las unidades
    Call VERIFICAR ;sube las unidades
    MOVLW 100B ;bit fantasma
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    movf 0x504,0 ;sube el resultado al w
    andwf 0x519,0 ;mira las decenas
    movwf 0x530 ;pone las decenas 0x530
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530 ;pone las decenas a las unidades
    movf  0x530,0 ;el número de las decenas se pone en el w
    Call VERIFICAR ;sube las decenas
    bsf   PORTA,1 ;latch sube
    BCF	  PORTA,1
    CALL Delay_1s
    GOTO button
R_NO_NORMAL:
    MOVLW 0x07 ;sube el 0x07 al w
    SUBWF 0x504,0,0 ; resta el número anterior con 0x07
    movwf 0x504,0 ; el resultado se pone en 0x504
    andwf 0x518,0 ;se ven las unidades
    Call VERIFICAR ;se suben las unidades
    MOVLW 100B ;bit fantasma
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    movf 0x504,0 ;se sube el resultado al w
    andwf 0x519,0 ;se ven las decenas
    movwf 0x530
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530
    RRNCF 0X530 ;se pasa el número de las decenas a las unidades
    movf  0x530,0 ;se sube el número al w
    Call VERIFICAR ;se suben las decenas
    bsf   PORTA,1 ;se sube el latch
    BCF	  PORTA,1
    call Delay_1s
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
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,1	; PORTA<7:0> = 0
    CLRF    ANSELA,1	; PortA digital
    BSF	    TRISA,3,1	; RA3 como entrada
    BCF	    TRISA,0,1
    BCF	    TRISA,1,1
    BCF	    TRISA,2,1
    BSF	    WPUA,3,1	; Activamos la resistencia Pull-Up del pin RA3
    RETURN 
    
A9:
     MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A8:
    MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A7:
    MOVLW 100B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A6:
    MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A5:
    MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A4:
    MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A3:
    MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A2:
    MOVLW 000B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A1:
    MOVLW 100B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 0x04
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 100B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
A0:
    MOVLW 100B ;sube bit por bit y luego pone el clk
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
     MOVLW 000B
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    RETURN
    INICIO_NO_BOTON:
    CALL A0;sube las unidades
    MOVLW 100B ;bit fantasma
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    CALL A0 ;sube las decenas
    bsf   PORTA,1 ;sube el latch
    BCF	  PORTA,1
    MOVLW 0000B ;pone 0 al 0x504
    movwf 0x504
    CALL Delay_1s
    GOTO button
INICIO_BOTON:
    CALL A9 ;sube las unidades
    MOVLW 100B; bit fantasma
    MOVWF PORTA
    bsf	  PORTA,0
    bcf	  PORTA,0
    CALL A9 ;sube las decenas
    bsf   PORTA,1 ;sube el latch
    BCF	  PORTA,1
    MOVLW 0x99
    movwf 0x504 ;pone el 99 en 0x504
    CALL Delay_1s
    GOTO button
VERIFICAR:
    igual0:
    CPFSEQ 0x520 ;mira si es 0, si es cero sube el cero sino sigue buscando
    goto igual1
    call A0
    return
    igual1:
    CPFSEQ 0x521 ;mira si es 1, si es 1 sube el 1 sino sigue buscando
    goto igual2
    call A1
    return
    igual2:
    CPFSEQ 0x522  ;mira si es 2, si es 2 sube el 2 sino sigue buscando
    goto igual3
    call A2
    return
    igual3:
    CPFSEQ 0x523 ;mira si es 3, si es 3 sube el 3 sino sigue buscando
    goto igual4
    call A3
    return
    igual4:
    CPFSEQ 0x524 ;mira si es 4, si es 4 sube el 4 sino sigue buscando
    goto igual5
    call A4
    return
    igual5:
    CPFSEQ 0x525 ;mira si es 5, si es 5 sube el 5 sino sigue buscando
    goto igual6
    call A5
    return
    igual6:
    CPFSEQ 0x526 ;mira si es 6, si es 6 sube el 6 sino sigue buscando
    goto igual7
    call A6
    return
    igual7:
    CPFSEQ 0x527 ;mira si es 7, si es 7 sube el 7 sino sigue buscando
    goto igual8
    call A7
    return
    igual8:
    CPFSEQ 0x528 ;mira si es 8, si es 8 sube el 8 sino sigue buscando
    goto igual9
    call A8
    return
    igual9:
    CPFSEQ 0x529 ;mira si es 9, si es 9 sube el 9 sino nop
    nop
    call A9
    return
SUBIDA_DE_VALORES:
    MOVlw 10011001B ;sube el valor de 99 al 508
    MOVWF 0X508
    movlw 00001111B ;sube el valor de 00001111 al 518
    movwf 0x518
     movlw 11110000B ;sube el valor 0xF0 al registro 0x519
    movwf 0x519
    movlw 0x00 ;sube el valor de 0 a 0x520
    movwf 0x520
    movlw 0x01 ;sube el valor de 1 a 0x521
    movwf 0x521
    movlw 0x02 ;sube el valor de 2 a 0x522
    movwf 0x522
    movlw 0x03 ;sube el valor de 3 a 0x523
    movwf 0x523
    movlw 0x04 ;sube el valor de 4 a 0x524
    movwf 0x524
    movlw 0x05 ;sube el valor de 5 a 0x525
    movwf 0x525
    movlw 0x06 ;;sube el valor de 6 a 0x526
    movwf 0x526
    movlw 0x07 ;;sube el valor de 7 a 0x527
    movwf 0x527
    movlw 0x08; ;sube el valor de 8 a 0x528
    movwf 0x528
    movlw 0x09; ;sube el valor de 9 a 0x529
    movwf 0x529
    MOVLW 0X0F
    MOVWF 0X535
    RETURN
END resetVect







