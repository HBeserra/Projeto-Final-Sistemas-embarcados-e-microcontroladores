            LIST  P=16F84A
            INCLUDE "p16f84a.inc"
            CHAVES      EQU   0x0C
            DADO_2      EQU   0x0D
            DADO_3      EQU   0x0E
            DADO_4      EQU   0x0F
#DEFINE     BANK_0      bcf   STATUS,RP0
#DEFINE     BANK_1      bsf   STATUS,RP0
            ORG         0x00
            goto        INICIO            ; pula para a linha 12 ; 10 1000 0000 1100
            ORG         0x05



INICIO      BANK_0                        ; Muda para o banco de memoria zero ; 01 0010 1000 0011
            movf        PORTB,0
            andlw       b'00000111',0
            movwf       CHAVES

            movlw       b'00000000'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,z 
            goto        LED_DESLIGADO

            movlw       b'00000001'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,z 
            goto        EFECT_1

            
            movlw       b'00000010'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,z 
            goto        EFECT_2_1
            
            movlw       b'00000011'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,z 
            goto        EFECT_2_2
            
            movlw       b'00000100'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,z 
            goto        EFECT_3

            movlw       b'00000101'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,z 
            goto        LED_LIGADO
            
            goto INICIO

EFECT_1     clrf        PORTB             ; Loop acendendo led e movendo para a esquerda
LOOP_1      rlf         PORTB,1
            rlf         PORTB,1
            bsf         PORTB,0
            btfss       PORTB,6           ; Verifica se o ultimo led do efeito esta acesso
            goto        LOOP_1
            goto        INICIO



EFECT_2_1   clrf        PORTB             ; Loop acendendo led e movendo para a esquerda
LOOP_2      rlf         PORTB,1
            bsf         PORTB,0
            btfss       PORTB,7           
            goto        LOOP_2
            goto        INICIO

EFECT_2_2   movlw       0xff
            movwf       PORTB             ; Loop acendendo led e movendo para a esquerda
LOOP_3      rrf         PORTB,1
            bcf         PORTB,7
            btfsc       PORTB,0           
            goto        LOOP_3
            goto        INICIO

EFECT_3     movlw       0xff
            movwf       PORTB             ; Define todos os bits do PORTB como 1
LOOP_4      RRF         PORTB
            bcf         PORTB,7           ; Define o ultimo bit como 0
            btfsc       PORTB,0           ; Termina o loop se o primeiro bit for zero
            goto        LOOP_4
            goto        INICIO

