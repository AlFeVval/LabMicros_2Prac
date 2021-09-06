
; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC =  INTOSC_HS	; Oscillator Selection bits (Internal oscillator, XT used by USB (INTXT))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOR = ON              ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = ON           ; USB Voltage Regulator Enable bit (USB voltage regulator enabled)

; CONFIG2H
  CONFIG  WDT = ON              ; Watchdog Timer Enable bit (WDT enabled)
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = OFF          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RB3)
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
    TM1			EQU	0x60			;	
    TM2			EQU	0x70			;	
    TM3			EQU	0x80			;
    IDX			EQU	0x90			;
    IMP			EQU	0xA0			;
;****************Main code*****************************
			ORG     0x000             	;reset vector
  			GOTO    MAIN              	;go to the main routine
INITIALIZE:
			CLRF	TRISD			;Puerto D como salidas
			CLRF	TRISC			;
			BSF	TRISB, RB7		;Boton de subida
			BSF	TRISB, RB6		;Boton de bajada		
			
			RETURN				;end of initialization subroutine

MAIN:
			CALL 	INITIALIZE

BASE:
			MOVF	TEMP,W			;
			BZ	TURN_NINE 		;
			DECF	TEMP			;
			BTFSC	PORTB,RB7
			CALL	DEC_VEL			
			BTFSC	PORTB,RB6
			CALL	INC_VEL
			CALL	VEL_TABLE		
			CALL	DECODE			;
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
			BZ	D_EIGHT			;.
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

DELAY_10S:
			MOVLW	b'10000000'
			MOVWF	PORTC			
    			MOVLW	d'60'			;
			MOVWF	TM1			;
			MOVLW	D'236'			;
		T310:	MOVWF	TM2			;
		T210:	MOVWF	TM3			;
		T110:	DECFSZ	TM3			;
			GOTO	T110		        ;
			DECFSZ	TM2			;
			GOTO	T210			;
			DECFSZ	TM1			;
			GOTO	T310			;
			RETURN				;
			
DELAY_5S:
			MOVLW	b'01000000'
			MOVWF	PORTC			
    			MOVLW	d'30'			;
			MOVWF	TM1			;
			MOVLW	D'236'			;
		T35:	MOVWF	TM2			;
		T25:	MOVWF	TM3			;
		T15:	DECFSZ	TM3			;
			GOTO	T15		        ;
			DECFSZ	TM2			;
			GOTO	T25			;
			DECFSZ	TM1			;
			GOTO	T35			;
			MOVLW	b'00000000'
			MOVWF	PORTC			
			RETURN				;
			
DELAY_1S:
			MOVLW	b'00000100'
			MOVWF	PORTC			
    			MOVLW	d'6'			;
			MOVWF	TM1			;
			MOVLW	D'236'			;
		T3:	MOVWF	TM2			;
		T2:	MOVWF	TM3			;
		T1:	DECFSZ	TM3			;
			GOTO	T1		        ;
			DECFSZ	TM2			;
			GOTO	T2			;
			DECFSZ	TM1			;
			GOTO	T3			;
			MOVLW	b'00000000'
			MOVWF	PORTC			
			RETURN				;
			
DELAY_500mS:
			MOVLW	b'00000010'
			MOVWF	PORTC			
    			MOVLW	d'3'			;
			MOVWF	TM1			;
			MOVLW	D'236'			;
		T305:	MOVWF	TM2			;
		T205:	MOVWF	TM3			;
		T105:	DECFSZ	TM3			;
			GOTO	T105		        ;
			DECFSZ	TM2	    		;
			GOTO	T205			;
			DECFSZ	TM1			;
			GOTO	T305			;
			RETURN				;
			
DELAY_100mS:
			MOVLW	b'00000001'
			MOVWF	PORTC			
    			MOVLW	d'6'			;
			MOVWF	TM1			;
			MOVLW	D'75'			;
		T301:	MOVWF	TM2			;
		T201:	MOVWF	TM3			;
		T101:	DECFSZ	TM3			;
			GOTO	T101		        ;
			DECFSZ	TM2			;
			GOTO	T201			;
			DECFSZ	TM1			;
			GOTO	T301			;
			RETURN				;
			
			
			
DEC_VEL:
			MOVLW	0x04
			SUBWF	IDX,0
			BZ	INC_VEL
			BTFSC	PORTB,RB7
			INCF	IDX
			RETURN
			
INC_VEL:
			MOVLW	0x00
			SUBWF	IDX,0
			BZ	DEC_VEL
			BTFSC	PORTB,RB6
			DECF	IDX
			RETURN
			
VEL_TABLE:
			MOVLW	0x00
			SUBWF	IDX,0
			BZ	DELAY_100mS
			MOVLW	0x01
			SUBWF	IDX,0
			BZ	DELAY_500mS
			MOVLW	0x02
			SUBWF	IDX,0
			BZ	DELAY_1S
			MOVLW	0x03
			SUBWF	IDX,0
			BZ	DELAY_5S
			MOVLW	0x04
			SUBWF	IDX,0
			BZ	DELAY_10S
			RETURN
			
			END                       	;end of the main program


