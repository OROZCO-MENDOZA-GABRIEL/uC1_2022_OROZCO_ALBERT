PSECT udata_acs
contador1: DS	1		;reserva un bit en acces ram
contador2: DS	1		;reserva un bit en acces ram
PSECT code
;Retardo=10us,T = 6 + 4k
Delay_10us:		    ;2Tcy -- Call
    MOVLW   1		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy

Delay_Loop_10us:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_10us ;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=25us,T = 7 + 3k
Delay_25us:		    ;2Tcy -- Call
    MOVLW   6		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy
    NOP			    ;1Tcy

Delay_Loop_25us:	    
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_25us ;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=50us,T = 6 + 4k
Delay_50us:		    ;2Tcy -- Call
    MOVLW   11		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy

Delay_Loop_50us:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_50us ;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=100us,T = 8 + 4k
Delay_100us:		    ;2Tcy -- Call
    MOVLW   23		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy
    NOP			    ;1Tcy
    NOP			    ;1Tcy

Delay_Loop_100us:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_100us;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=200us,T = 8 + 3k
Delay_200us:		    ;2Tcy -- Call
    MOVLW   64		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy
    NOP			    ;1Tcy
    NOP			    ;1Tcy

Delay_Loop_200us:
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_200us;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=250us,T = 6 + 4k
Delay_250us:		    ;2Tcy -- Call
    MOVLW   61		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy

Delay_Loop_250us:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_250us;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=500us,T = 8 + 4k
Delay_500us:		    ;2Tcy -- Call
    MOVLW   123		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy
    NOP			    ;1Tcy
    NOP			    ;1Tcy

Delay_Loop_500us:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_500us;(k-1)*2Tcy
    RETURN		    ;2Tcy
    
;Retardo=1ms,T = 8 + 4k
Delay_1ms:		    ;2Tcy -- Call
    MOVLW   248		    ;1Tcy
    MOVWF   contador1,0	    ;1Tcy
    NOP			    ;1Tcy
    NOP			    ;1Tcy

Delay_Loop_1ms:
    NOP			    ;k*Tcy
    DECFSZ  contador1,1,0   ;(k-1) + 3Tcy
    GOTO    Delay_Loop_1ms  ;(k-1)*2Tcy
    RETURN		    ;2Tcy
;Retardo=5ms,T = (4k)n+6n+10
Delay_5ms:		    ;2Tcy -- Call
    MOVLW   5		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy
    NOP			    ;1Tcy
    NOP			    ;1Tcy

Ext_Loop_5ms:
    MOVLW   248		    ;n*Tcy
    MOVWF   contador1,0	    ;n*Tcy
    
Int_Loop_5ms:
    NOP				    ;k*n*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_5ms	    ;(k-1)*2*n*Tcy
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_5ms	    ;(n-1)*2Tcy
    NOP				    ;1Tcy
    NOP				    ;1Tcy
    RETURN			    ;2Tcy       
;Retardo=10ms,T = (4k)n+7n+10
Delay_10ms:		    ;2Tcy -- Call
    MOVLW   10		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy
    NOP			    ;1Tcy
    NOP			    ;1Tcy

Ext_Loop_10ms:
    MOVLW   248		    ;n*Tcy
    MOVWF   contador1,0	    ;n*Tcy
    
Int_Loop_10ms:
    NOP				    ;k*n*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_10ms	    ;(k-1)*2*n*Tcy
    NOP				    ;n*Tcy
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_10ms	    ;(n-1) *2Tcy
    NOP				    ;1Tcy
    NOP				    ;1Tcy
    RETURN			    ;2Tcy
    
;Retardo=25ms,T = (4k)n+8n+6
Delay_25ms:		    ;2Tcy -- Call
    MOVLW   25		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy

Ext_Loop_25ms:
    MOVLW   248		    ;n*Tcy
    MOVWF   contador1,0	    ;n*Tcy
    NOP			    ;n*Tcy
Int_Loop_25ms:
    NOP				    ;k*n*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_25ms	    ;(k-1)* 2*n*Tcy
    NOP				    ;n*Tcy
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_25ms	    ;(n-1) *2Tcy
    RETURN			    ;2Tcy
;Retardo=50ms,T = (4k)n+8n+6
Delay_50ms:		    ;2Tcy -- Call
    MOVLW   50		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy

Ext_Loop_50ms:
    MOVLW   248		    ;n*Tcy
    MOVWF   contador1,0	    ;n*Tcy
    NOP			    ;n*Tcy
Int_Loop_50ms:
    NOP				    ;k*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_50ms	    ;((k-1)* 2)*n*Tcy
    NOP				    ;n*Tcy 
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_50ms	    ;(n-1) *2Tcy
    RETURN			    ;2Tcy
;Retardo=100ms,T = (4k)n+8n+6
Delay_100ms:		    ;2Tcy -- Call
    MOVLW   100		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy

Ext_Loop_100ms:
    MOVLW   248		    ;n*Tcy
    MOVWF   contador1,0	    ;n*Tcy
    NOP			    ;n*Tcy
Int_Loop_100ms:
    NOP				    ;k*n*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_100ms	    ;(k-1)* 2*n*Tcy
    NOP				    ;n*Tcy 
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_100ms	    ;(n-1) *2Tcy
    RETURN			    ;2Tcy
;Retardo=200ms,T = (4k)n+8n+6
Delay_200ms:		    ;2Tcy -- Call
    MOVLW   200		    ;1Tcy
    MOVWF   contador2,0	    ;1Tcy

Ext_Loop_200ms:
    MOVLW   248		    ;n*Tcy
    MOVWF   contador1,0	    ;n*Tcy
    NOP			    ;n*Tcy
Int_Loop_200ms:
    NOP				    ;k*n*Tcy
    DECFSZ  contador1,1,0	    ;((k-1) + 3)*n*Tcy
    GOTO    Int_Loop_200ms	    ;((k-1)* 2)*nTcy
    NOP				    ;n*Tcy 
    NOP				    ;n*Tcy
    DECFSZ  contador2,1,0	    ;(n-1) + 3Tcy
    GOTO    Ext_Loop_200ms	    ;(n-1) *2Tcy
    RETURN			    ;2Tcy

;Retardo=250ms,T = (4k)n+8n+6
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
        








