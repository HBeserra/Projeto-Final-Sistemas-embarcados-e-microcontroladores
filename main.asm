            LIST  P=16F84A
            INCLUDE "p16f84a.inc"
            CHAVES      EQU   0x0C
            CONT_TMR0   EQU   0x0D
            MSK_EFEITO  EQU   0x0E
            DADO_4      EQU   0x0F

#DEFINE     BANK_0      bcf   STATUS,RP0
#DEFINE     BANK_1      bsf   STATUS,RP0
            
            ORG         0x00
            goto        SETUP_INIT   
			ORG			0x04
			retfie
            ORG         0x05

SETUP_INIT  
            BANK_1                        ; Muda para o banco de memoria zero 
            movlw       b'00000111'
            movwf       TRISA
            clrf        TRISB

            movlw       0x07              ; Configuração do timer 0 
            movwf       OPTION_REG 


INICIO      
            BANK_0

            movf        PORTA,0
            andlw       b'00000111'
            movwf       CHAVES

            movlw       b'00000000'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
            goto        LED_OFF

            movlw       b'00000001'
            subwf       CHAVES,0   
            btfsc       STATUS,2 
            goto        EFECT_1

            movlw       b'00000010'
            subwf       CHAVES,0   
            btfsc       STATUS,2 
            goto        EFECT_2_1
            
            movlw       b'00000011'
            subwf       CHAVES,0   
            btfsc       STATUS,2 
            goto        EFECT_2_2
            
            movlw       b'00000100'
            subwf       CHAVES,0   
            btfsc       STATUS,2 
            goto        EFECT_3

            movlw       b'00000101'
            subwf       CHAVES,0   
            btfsc       STATUS,2 
            goto        LED_ON
            
            goto INICIO

EFECT_1     
            clrf        PORTB             ; Loop acendendo led e movendo para a esquerda
            bcf         STATUS,0
LOOP_1      
            rlf         PORTB,1
   			btfss		MSK_EFEITO,0		; bit mascara do efeito alternancia entre os leds
            bsf         PORTB,0
			movlw		0x01
			xorwf		MSK_EFEITO,F
            call        DELAY_1S
            btfss       PORTB,7           ; Verifica se o ultimo led do efeito esta acesso
            goto        LOOP_1
            goto        INICIO



EFECT_2_1   
                      ; Acendendo led e movendo para a esquerda      
            call        DELAY_1S
			rlf         PORTB,1
            bsf         PORTB,0

            goto        INICIO

EFECT_2_2   
        ; Apagando led e movendo para a direita
            bcf         STATUS,0
LOOP_3      
            call        DELAY_1S
			rrf         PORTB,1
            bcf         PORTB,7 
            
            goto        INICIO

EFECT_3     
            movlw       0xff
            movwf       PORTB             ; Define todos os bits do PORTB como 1
            bcf         STATUS,0
LOOP_4      
			call        DELAY_1S 
            RRF         PORTB
            bcf         PORTB,7           ; Define o ultimo bit como 0 
            btfsc       PORTB,0           ; Termina o loop se o primeiro bit for zero
            goto        LOOP_4
            goto        INICIO

LED_OFF     
            clrf        PORTB
            goto        INICIO
LED_ON      
            movlw       0xff
            movwf       PORTB
            goto        INICIO

                                          ; 196*(1/(1000000/256)) = 0,501s  OBS: frequencia FOSC/4
DELAY_1S                                  ; Timer0 Prescaler 256 Preset 60 = Periodo 0.0501s com loop de 10 vezes = 0.50s  
            movlw       d'10'
            movwf       CONT_TMR0
LOOP_5
            bcf         INTCON,2          ; Reset da flag de interupção do Timer0
            movlw       d'60'             ; Inicia a contagem em 60       
            movwf       TMR0
AWAIT_TMR0  
            btfss       INTCON,T0IF       ; Loop ate o timer emitir uma interupção
            goto        AWAIT_TMR0
            decfsz      CONT_TMR0         ; Continua no loop ate o contador do timer chegar a zero        
            goto        LOOP_5
            return
			END
