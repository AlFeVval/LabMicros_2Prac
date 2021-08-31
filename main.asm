
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
    TIMER		EQU	0x60			;	
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
			MOVF	TEMP,W			;
			BZ	TURN_NINE 		;
			DECF	TEMP			;
			CALL	DECODE			;
			;CALL	DELAY			;
			GOTO 	BASE			;infinite loop

DECODE:
			MOVLW	0x00			;
			SUBWF	TEMP,0			;
			BZ	D_ZERO			;
			MOVLW	0x01			;
			SUBWF	TEMP,0			;
			BZ	D_ONE			;
			MOVLW	0x02			;
			SUBWF	TEMP,0		;
			BZ	D_TWO			;
			MOVLW	0x03			;
			SUBWF	TEMP,0			;
			BZ	D_THREE			;
			MOVLW	0x04			;
			SUBWF	TEMP,0			;
			BZ	D_FOUR			;
			MOVLW	0x05			;
			SUBWF	TEMP,0			;
			BZ	D_FIVE			;
			MOVLW	0x06			;
			SUBWF	TEMP,0			;
			BZ	D_SIX			;
			MOVLW	0x07			;
			SUBWF	TEMP,0			;
			BZ	D_SEVEN			;
			MOVLW	0x08			;
			SUBWF	TEMP,0			;
			BZ	D_EIGHT			;
			MOVLW	0x09			;
			SUBWF	TEMP,0			;
			BZ	D_NINE			;	
			RETURN;
			
D_ZERO:
			MOVLW	b'01111110'		;//0
			MOVWF	PORTD			;
			RETURN;
D_ONE:
			MOVLW	b'00110000'		;//1
			MOVWF	PORTD			;
			RETURN			;
D_TWO:
			MOVLW	b'01101101'		;//2
			MOVWF	PORTD			;
			RETURN		;
D_THREE:
			MOVLW	b'01111001'		;//3
			MOVWF	PORTD			;
			RETURN			;
D_FOUR:
			MOVLW	b'00110011'		;//4
			MOVWF	PORTD			;
			RETURN			;
D_FIVE:
			MOVLW	b'01011011'		;//5
			MOVWF	PORTD			;
			RETURN;
D_SIX:
			MOVLW	b'01011111'		;//6
			MOVWF	PORTD			;
			RETURN			;
D_SEVEN:
			MOVLW	b'01110000'		;//7
			MOVWF	PORTD			;
			RETURN			;
D_EIGHT:
			MOVLW	b'01111111'		;//8
			MOVWF	PORTD			;
			RETURN;
D_NINE:
			MOVLW	b'01111011'		;//9
			MOVWF	PORTD			;
			RETURN		;
			
TURN_NINE:
			MOVLW	d'10'			;
			MOVWF	TEMP			;
			GOTO	BASE			;
DELAY:
			MOVLW	d'255'			;
			MOVWF	TIMER			;
			DECFSZ	TIMER			;
			GOTO	DELAY			;
			GOTO	BASE			;
			
			END                       	;end of the main program


