
; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = INTOSC_HS      ; Oscillator Selection bits (Internal oscillator, HS oscillator used by USB (INTHS))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = ON              ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = OFF          ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will not cause Reset)
  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)


;****************Variables Definition*********************************
    TEMP		EQU	0x50			;Reservamos espacio para un registro temporal 
    TEMP2		EQU	0x51			;Reservamos mas espacio para otro registro temporal
    CONSTANT		MASKa =	0xF0			;Mascara que delimitara los bits mas significativos
    CONSTANT		MASKb =	0x0F			;Mascara que delimitara los bits menos significativos
;****************Main code*****************************
			ORG     0x000             	;reset vector
  			GOTO    MAIN              	;go to the main routine
INITIALIZE:
			CLRF	TRISD			;Puerto D como salidas
			ADPCFG = 0x01FF			;Puerto B trabaje como entradas digitales
			SETF	TRISB			;Todo puerto B como entrada
			
			RETURN				;end of initialization subroutine

MAIN:
			CALL 	INITIALIZE

BASE:	

			MOVF	PORTB, 0		;PORTB es movido a WREG para nuestro dato 1
			ANDLW	MASKa			;Aplicamos mascara para los bits mas significativos
			MOVWF	TEMP			;Actualizamos el valor ya delimitado en temporal
			RRNCF	TEMP,W	   		;Corremos un bit de dicho valor
			MOVWF	TEMP			;Nueva actualizacion
			RRNCF	TEMP,W	   		;Nuevo Corrimiento
			MOVWF	TEMP			;Nueva actualizacion
			RRNCF	TEMP,W	   		;Ultimo corrimiento
			MOVWF	TEMP			;Ultima actualizacion
			MOVF	PORTB,0			;PORRTB es leido nuevamente para nuestro dato2
			ANDLW	MASKb			;Aplicamos mascara para los bits mas significativos
			MOVWF	TEMP2			;Actualizamos el valor del temporal 2
			RLNCF	TEMP2,W			;Hacemos un corrimiento a la izquierda (desconozco por que esta corrido a la derecha una vez)
			MOVWF	TEMP2			;Actualizo el dato
			MOVF	TEMP2,W			;Muevo el temporal 2 a WREG
			ADDWF	TEMP,0			;Sumo lo que haya en WREG con temporal 1
			BC	CARRY_EVENT		;Si hay carry llama al evento para mostrarlo
			CALL	DECODE			;Llamamos la función de decodificación
			MOVWF	PORTD			;Muestra el resultado codificado
			GOTO 	BASE			;infinite loop

DECODE:
			ADDWF	PCL,1			;
			RETLW	b'01111110'		;//0
			RETLW	b'00110000'		;//1
			RETLW	b'01101101'		;//2
			RETLW	b'01111001'		;//3
			RETLW	b'00110011'		;//4
			RETLW	b'01011011'		;//5
			RETLW	b'01011111'		;//6
			RETLW	b'01110000'		;//7
			RETLW	b'01111111'		;//8
			RETLW	b'01110011'		;//9
			RETLW	b'01110111'		;//A
			RETLW	b'00011111'		;//B
			RETLW	b'01001110'		;//C
			RETLW	b'00111101'		;//D
			RETLW	b'01001111'		;//E
			RETLW	b'01000111'		;//F
			
CARRY_EVENT:
			RETLW  b'10000000'		;
			
			END                       	;end of the main program
