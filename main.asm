            LIST  P=16F84A
            INCLUDE "p16f84a.inc"
            CHAVES      EQU   0x0C
            DADO_2      EQU   0x0D
            DADO_3      EQU   0x0E
            DADO_4      EQU   0x0F
#DEFINE     BANK_0      bcf   STATUS,RP0
#DEFINE     BANK_1      bsf   STATUS,RP0
            ORG         0x00
            goto        SETUP_INIT            ; pula para a linha 12 ; 10 1000 0000 1100
            ORG         0x05

SETUP_INIT  BANK_1                        ; Muda para o banco de memoria zero 
            movlw       0x07
            movwf       TRISA
            clrf        TRISB
INICIO      BANK_0

            movf        PORTA,0
            andlw       b'00000111'
            movwf       CHAVES

            movlw       b'00000000'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
            goto        LED_DESLIGADO

            movlw       b'00000001'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
            goto        EFECT_1

            
            movlw       b'00000010'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
            goto        EFECT_2_1
            
            movlw       b'00000011'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
            goto        EFECT_2_2
            
            movlw       b'00000100'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
            goto        EFECT_3

            movlw       b'00000101'
            subwf       CHAVES,0          ; Subtrai o valor de  
            btfsc       STATUS,2 
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



; simulador

0 LIST P=16F84A
1 INCLUDE "p16f84a.inc"
2 CHAVES EQU 0x0C
3 DADO_2 EQU 0x0D
4 DADO_3 EQU 0x0E
5 DADO_4 EQU 0x0F
6
7 ORG 0x00
8 goto SETUP_INIT ; pula para a linha 12 ; 10 1000 0000 1100
9 ORG 0x05
10
11 SETUP_INIT ; Muda para o banco de memoria zero
12 bsf STATUS,RP0
13 movlw 0x07
14 movwf TRISA
15 clrf TRISB
16 INICIO
17 bcf STATUS,RP0
18 movf PORTA,0
19 andlw b'00000111'
20 movwf CHAVES
21
22 movlw b'00000000'
23 subwf CHAVES,0 ; Subtrai o valor de
24 btfsc STATUS,2
25 goto LED_DESLIGADO
26
27 movlw b'00000001'
28 subwf CHAVES,0 ; Subtrai o valor de
29 btfsc STATUS,2
30 goto EFECT_1
31
32
33 movlw b'00000010'
34 subwf CHAVES,0 ; Subtrai o valor de
35 btfsc STATUS,2
36 goto EFECT_2_1
37
38 movlw b'00000011'
39 subwf CHAVES,0 ; Subtrai o valor de
40 btfsc STATUS,2
41 goto EFECT_2_2
42
43 movlw b'00000100'
44 subwf CHAVES,0 ; Subtrai o valor de
45 btfsc STATUS,2
46 goto EFECT_3
47
48 movlw b'00000101'
49 subwf CHAVES,0 ; Subtrai o valor de
50 btfsc STATUS,2
51 goto LED_LIGADO
52
53 goto INICIO
54
55 EFECT_1
56 clrf PORTB ; Loop acendendo led e movendo para a esquerda
57 LOOP_1
58 rlf PORTB,1
59 bcf PORTB,0
60 rlf PORTB,1
61 bsf PORTB,0
62 btfss PORTB,6 ; Verifica se o ultimo led do efeito esta acesso
63 goto LOOP_1
64 goto INICIO
65
66
67
68 EFECT_2_1
69 clrf PORTB ; Loop acendendo led e movendo para a esquerda
70 LOOP_2
71 rlf PORTB,1
72 bsf PORTB,0
73 btfss PORTB,7
74 goto LOOP_2
75 goto INICIO
76
77 EFECT_2_2
78 movlw 0xff
79 movwf PORTB ; Loop acendendo led e movendo para a esquerda
80 LOOP_3
81 rrf PORTB,1
82 bcf PORTB,7
83 btfsc PORTB,0
84 goto LOOP_3
85 goto INICIO
86
87 EFECT_3
88 movlw 0xff
89 movwf PORTB ; Define todos os bits do PORTB como 1
90 LOOP_4
91 RRF PORTB,1
92 bcf PORTB,7 ; Define o ultimo bit como 0
93 btfsc PORTB,0 ; Termina o loop se o primeiro bit for zero
94 goto LOOP_4
95 goto INICIO
96
97 LED_DESLIGADO
98 LED_LIGADO
99 GOTO INICIO