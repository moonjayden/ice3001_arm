
	.cdecls C, LIST, "Compiler.h"
;------------------------------------------------
;		.data
;------------------------------------------------
GPIO_BASE			.equ	0x40000000
NVIC_BASE			.equ	0xe0000000
RCGCGPIO			.equ	0x608
GPIOHBCTL			.equ	0x06C
GPIODIR				.equ	0x400
GPIOAFSEL			.equ	0x420
GPIOPUR				.equ	0x510
GPIODEN				.equ	0x51C
GPIOAMSEL			.equ	0x528
GPIOPCTL			.equ	0x52C
GPIOLOCK			.equ	0x520
GPIOCR				.equ	0x524
RCGC2				.equ	0x108
GPIODR8R			.equ	0x508

GPIODATA			.equ	0x000
EN3					.equ	0x10C
GPIOIM				.equ	0x410
GPIOICR				.equ	0x41C
RCGCUART			.equ	0x618

UARTCTL				.equ	0x030
UARTIBRD			.equ	0x024
UARTFBRD			.equ	0x028
UARTLCRH			.equ	0x02C
UARTFR				.equ	0x018
UARTDR				.equ	0x000

SW_ON				.equ	0x1E ;11110
SW_OFF				.equ	0x1D ;11101
SW_SLOW				.equ	0x1B ;11011
SW_FAST				.equ	0x17 ;10111
;--------------------------------------------------
             .text                           ; Program Start
             .global RESET                   ; Define entry point
             .align	4
			 .sect ".text"

             .global Switch_Init
             .global Switch_Input
			 .global num_1
			 .global num_3

			 .global LED_Init
			 .global LED_On
			 .global LED_Off

			 .global Blink_slow
			 .global Blink_fast

			 .global UART_Init
;------------------------------------------------
;			switch initializition
;------------------------------------------------
Switch_Init:
		mov r0, #GPIO_BASE	;RCGC : General-Purpose Input/Output Run Mode Clock Gating Control
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #RCGCGPIO
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x800 ;Enable GPIO M port
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE	;HBCTL : High-Performance Bus Control
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #GPIOHBCTL
		add r1, r1, r0

		mov r0, #0x800
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE	;DIR
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIODIR
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x1f
		str r0, [r1]

		mov r0, #GPIO_BASE	;AFSEL : Alternate Function Select
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOAFSEL
		add r1, r1, r0

		ldr r0, [r1]
		bic r0, r0, #0x1f
		str r0, [r1]

		mov r0, #GPIO_BASE	;PUR
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOPUR
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1f
		str r0, [r1]

		mov r0, #GPIO_BASE	;DEN
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIODEN
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1f
		str r0, [r1]

		mov r0, #GPIO_BASE	;AMSEL : Analog Mode Select
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOAMSEL
		add r1, r1, r0

		mov r0, #0
		str r0, [r1]

		mov r0, #GPIO_BASE	;PCTL : Port Control
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOPCTL
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x1f;#0x000f000f
		str r0, [r1]

		mov r0, #GPIO_BASE	;LOCK
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOLOCK
		add r1, r1, r0

		mov r0, #GPIO_BASE
		mov r2, #0xc400000
		add r2, r2, r0
		mov r0, #0xf4000
		add r2, r2, r0
		mov r0, #0x34b
		add r2, r2, r0

		ldr r0, [r1]
		orr r0, r0, r2
		str r0, [r1]

		mov r0, #GPIO_BASE	;CR
		mov r1, #0x63000
		add r1, r1, r0
		mov r0, #GPIOCR
		add r1, r1, r0

		ldr r0, [r1]
		mov r2, #0x00000000
		bic r0, r0, r2
		str r0, [r1]

		b _EXIT
;------------------------------------------------
;			LED initializition
;------------------------------------------------
LED_Init:
		mov r0, #GPIO_BASE	;RCGC2
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #RCGC2
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x40  ; enable read port G pin2
		str r0, [r1]

		mov r0, #GPIO_BASE		;GPIODIR
		mov r1, #0x26000
		add r1, r1, r0
		mov r2, #GPIODIR
		add r1, r1, r2

		ldr r0, [r1]
		orr r0, r0, #0x04	;Port G pin2 set as output
		str r0, [r1]

		mov r0, #GPIO_BASE		;GPIOAFSEL GPIO
		mov r1, #0x26000
		add r1, r1, r0
		mov r2, #GPIOAFSEL
		add r1, r1, r2

		ldr r0, [r1]
		mov r0, #0				;associated pin controlled by GPIO register
		str r0, [r1]

		mov r0, #GPIO_BASE		;GPIODR8R
		mov r1, #0x26000
		add r1, r1, r0
		mov r2, #GPIODR8R
		add r1, r1, r2

		ldr r0, [r1]
		orr r0, r0, #0x04		;port G pin2 controlled by 8mA Drive
		str r0, [r1]

		mov r0, #GPIO_BASE		;GPIODEN
		mov r1, #0x26000
		add r1, r1, r0
		mov r2, #GPIODEN
		add r1, r1, r2

		ldr r0, [r1]
		orr r0, r0, #0x04		;Digital functions for the port G pin2 enable
		str r0, [r1]

		b _EXIT
;------------------------------------------------
;			Uart initializition
;------------------------------------------------
UART_Init:
;System Control
		mov r0, #GPIO_BASE	;RCGCUART : Provides software the capabiltiy to enable and disable the UART modules in Run Mode
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #RCGCUART
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x01	;Enable UART Module 0 in Run Mode
		str r0, [r1]
		nop
		nop

		mov r0, #GPIO_BASE	;RCGCGPIO : General-Purpose Input/Output Run Mode Clock Gating Control
		mov r1, #0xFE000
		add r1, r1, r0
		mov r0, #RCGCGPIO
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x01 	;Enable GPIO A port
		str r0, [r1]
		nop
		nop
;UART
		mov r0, #GPIO_BASE		;UARTCTL
		mov r1, #0xc000
		add r1, r1, r0
		mov r2, #UARTCTL
		add r1, r1, r2

		ldr r0, [r1]
		bic r0, r0, #0x01		;Disable UART
		str r0, [r1]

		mov r0, #GPIO_BASE		;UARTIBRD : Integer part of the baud rate divisor value
		mov r1, #0xc000
		add r1, r1, r0
		mov r2, #UARTIBRD
		add r1, r1, r2

		ldr r0, [r1]
		mov r0, #0x08		; 16000000/(16*115200)=8.6805 -> 0x08
		str r0, [r1]

		mov r0, #GPIO_BASE		;UARTFBRD : Fractional Part of the baud rate divisor value
		mov r1, #0xc000
		add r1, r1, r0
		mov r2, #UARTFBRD
		add r1, r1, r2

		ldr r0, [r1]
		mov r0, #0x2C		; integer((0.6805)*64+0.5)=44 -> 0x2c
		str r0, [r1]

		mov r0, #GPIO_BASE		;UARTLCRH : line control register
		mov r1, #0xc000
		add r1, r1, r0
		mov r2, #UARTLCRH
		add r1, r1, r2

		ldr r0, [r1]
		mov r0, #0x60		; 8bit/No parity/1stop bit
		str r0, [r1]

		mov r0, #GPIO_BASE		;UARTCTL
		mov r1, #0xc000
		add r1, r1, r0
		mov r2, #UARTCTL
		add r1, r1, r2

		ldr r0, [r1]
		orr r0, r0, #0x01		;Enable UART
		str r0, [r1]

;GPIO Port A
		mov r0, #GPIO_BASE		;GPIOAFSEL : Mode Control Select Register
		mov r1, #0x4000
		add r1, r1, r0
		mov r2, #GPIOAFSEL
		add r1, r1, r2

		ldr r0, [r1]
		orr r0, r0, #0x03		;Associated pin controlled by Peripheral (PA0,PA1)
		str r0, [r1]

		mov r0, #GPIO_BASE		;GPIOPCTL : Port Control
		mov r1, #0x4000
		add r1, r1, r0
		mov r0, #GPIOPCTL
		add r1, r1, r0

		ldr r0, [r1]
		orr r0, r0, #0x11;		;Use U0Rx(PA0), U0Tx(PA1)
		str r0, [r1]

		mov r0, #GPIO_BASE		;GPIODEN
		mov r1, #0x4000
		add r1, r1, r0
		mov r2, #GPIODEN
		add r1, r1, r2

		ldr r0, [r1]
		orr r0, r0, #0x03		;Digital functions for the port A Enable
		str r0, [r1]

		mov r0, #GPIO_BASE		;AMSEL : Analog Mode Select
		mov r1, #0x4000
		add r1, r1, r0
		mov r0, #GPIOAMSEL
		add r1, r1, r0

		mov r0, #0				;Disable
		str r0, [r1]

;////////////Initial Display///////////////////////////////
_Print_LEDMODE:
_check_FIFO:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTFR
		add r2, r1, r2

		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20	;compare if TXFF bit is 1
		BEQ _Print_LEDMODE	;Go back to Label Print_LEDMODE if the transmitter is full (TXFF bit = 1)
_data_write:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTDR
		add r2, r1, r2

_print_L:
		mov r1, #0x4c	;'L'
		str r1, [r2]
_p_Delay_L:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_L:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_E	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_L			;else branch
_print_E:
		mov r1, #0x45	;'E'
		str r1, [r2]
_p_Delay_E:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_E:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_D	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_E			;else branch
_print_D:
		mov r1, #0x44	;'D'
		str r1, [r2]
_p_Delay_D:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_D:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_sp	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_D			;else branch
_print_sp:
		mov r1, #0x20	;' '
		str r1, [r2]
_p_Delay_sp:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_sp:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_M	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_sp			;else branch
_print_M:
		mov r1, #0x4D	;'M'
		str r1, [r2]
_p_Delay_M:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_M:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_O	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_M			;else branch
_print_O:
		mov r1, #0x4F	;'O'
		str r1, [r2]
_p_Delay_O:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_O:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_D2	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_O			;else branch
_print_D2:
		mov r1, #0x44	;'D'
		str r1, [r2]
_p_Delay_D2:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_D2:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_E2	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_D2			;else branch
_print_E2:
		mov r1, #0x45	;'E'
		str r1, [r2]
_p_Delay_E2:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_E2:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_enter	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_E2			;else branch
_print_enter:
		mov r1, #0x0D	;'enter'
		str r1, [r2]
		mov r1, #0x0A	;'enter'
		str r1, [r2]
		b _EXIT

;////////////Switch Input///////////////////////////////
Switch_Input:

		mov r5, #GPIO_BASE
		mov r1, #0x63000
		add r1, r1, r5
		mov r5, #0x7c
		add r1, r1, r5

		ldr r5, [r1]

DELAY:	MOVW r3,#0xffff

_DELAY_LOOP:
		CBZ r3,_DELAY_EXIT		;Compare and Branch on Zero
		sub r3,r3,#1
		B _DELAY_LOOP
_DELAY_EXIT:

		cmp r5, #SW_ON
		BEQ _on

		cmp r5, #SW_OFF
		BEQ _off

		cmp r5, #SW_SLOW
		BEQ _slow

		cmp r5, #SW_FAST
		BEQ _fast

		mov r1, #'A'
		b _EXIT			;If nothing was pressed


_on:
		mov r1, #'B'
		b _EXIT

_off:
		mov r1, #'C'
		b _EXIT
_slow:
		mov r1, #'D'
		b _EXIT

_fast:
		mov r1, #'E'
		b _EXIT

num_1:
		mov r0, r1
		bx lr		;go back to C code


;////////////LED On///////////////////////////////
LED_On:
		mov r0, #GPIO_BASE
		mov r1, #0x26000
		add r1, r1, r0
		mov r0, #0x10  ;masking for Port G pin2
		add r1, r1, r0
		mov r5, #0x04 ;write tp port G to turn on LED
		str r5, [r1]
		b _Print_SW_A

;////////////LED Off///////////////////////////////
LED_Off:
		mov r0, #GPIO_BASE
		mov r1, #0x26000
		add r1, r1, r0
		mov r0, #0x10 	;masking for Port G pin2 addr[9:2]
		add r1, r1, r0
		mov r5, #0x00 ; wrote to port G to turn off LED
		str r5, [r1]

		b _Print_SW_B

;////////////Blink slow///////////////////////////////
;////////////blink slowly///////////////////////////////

Blink_slow:
		mov r0, #GPIO_BASE
		mov r1, #0x26000
		add r1, r1, r0		; to LED's address
		mov r0, #0x10
		add r1, r1, r0

		mov r6, #5			;blink 5 times

s_on:
		mov r5, #0x04 		;write tp port G to turn on LED
		str r5, [r1]

s_Delay_i:
		MOVW r3,#0xffff; set register value large number
		mov r3, r3, LSL#5	;long delay blink slowly
s_Delay_Loop_i:
		sub r3,r3,#1			; subtract 1
		CBZ r3, s_off	;Compare and Branch on Zero (if r3 becomes 0)
		b s_Delay_Loop_i			;else branch

s_off:
		mov r5, #0x00 ; wrote to port G to turn off LED
		str r5, [r1];Turn off LED

		sub r6, #1
		CMP r6, #0
		beq _Print_SW_C		;when it completes blinking 5 times, exit
		;CBZ r6, _Print_SW_C		;when it completes blinking 5 times, exit
s_Delay_i_:
		MOVW r3,#0xffff; set register value large number
		mov r3, r3, LSL#5

s_Delay_Loop_i_:
		sub r3, r3, #1			; subtract 1
		CMP r3, #0
		BEQ s_on	;Compare and Branch on Zero (if r3 becomes 0)
		b s_Delay_Loop_i_			;else branch
;////////////Blink fast/////////////////////////////////
Blink_fast:
		mov r0, #GPIO_BASE
		mov r1, #0x26000
		add r1, r1, r0		; to LED's address
		mov r0, #0x10
		add r1, r1, r0

		mov r6, #5			;blink 5 times


f_on:
		mov r5, #0x04 		;write tp port G to turn on LED
		str r5, [r1]

f_Delay_i:
		MOVW r3,#0xffff  ; set register value large number
		mov r3, r3, LSL#3  ;short delay blink fast

f_Delay_Loop_i:
		sub r3,r3,#1			; subtract 1
		CBZ r3, f_off	;Compare and Branch on Zero (if r3 becomes 0)
		b f_Delay_Loop_i			;else branch

f_off:
		mov r5, #0x00 ; wrote to port G to turn off LED
		str r5, [r1];Turn off LED

		sub r6, #1
		CMP r6, #0
		beq _Print_SW_D		;when it completes blinking 5 times, exit


f_Delay_i_:
		MOVW r3,#0xffff; set register value large number
		mov r3, r3, LSL#3

f_Delay_Loop_i_:
		sub r3,r3,#1			; subtract 1
		CMP r3, #0
		BEQ f_on	;Compare and Branch on Zero (if r3 becomes 0)
		b f_Delay_Loop_i_			;else branch
;////////////////////////////////////////////////
;////////////Print UART///////////////////////////////
;Print -SW A
_Print_SW_A:
_check_FIFO_SW_A:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTFR
		add r2, r1, r2

		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20	;compare if TXFF bit is 1
		BEQ _Print_SW_A	;Go back to Label Print_LEDMODE if the transmitter is full (TXFF bit = 1)
_data_write_SW_A:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTDR
		add r2, r1, r2

_print_SW_A_h:
		mov r1, #0x2D	;'-'
		str r1, [r2]
_p_Delay_SW_A_h:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_A_h:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_A_S	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_A_h			;else branch
_print_SW_A_S:
		mov r1, #0x53	;'S'
		str r1, [r2]
_p_Delay_SW_A_S:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_A_S:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_A_W	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_A_S			;else branch
_print_SW_A_W:
		mov r1, #0x57	;'W'
		str r1, [r2]
_p_Delay_SW_A_W:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_A_W:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_sp_SW_A	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_A_W		;else branch
_print_sp_SW_A:
		mov r1, #0x20	;' '
		str r1, [r2]
_p_Delay_sp_SW_A:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_sp_SW_A:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_A	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_sp_SW_A			;else branch
_print_SW_A:
		mov r1, #0x41	;'A'
		str r1, [r2]
_p_Delay_SW_A:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_A:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_enter_SW_A	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_A			;else branch
_print_enter_SW_A:
		mov r1, #0x0D	;'enter'
		str r1, [r2]
		mov r1, #0x0A	;'enter'
		str r1, [r2]
		b _EXIT


;Print -SW B
_Print_SW_B:
_check_FIFO_SW_B:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTFR
		add r2, r1, r2

		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20	;compare if TXFF bit is 1
		BEQ _Print_SW_B	;Go back to Label Print_LEDMODE if the transmitter is full (TXFF bit = 1)
_data_write_SW_B:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTDR
		add r2, r1, r2

_print_SW_B_h:
		mov r1, #0x2D	;'-'
		str r1, [r2]
_p_Delay_SW_B_h:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_B_h:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_B_S	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_B_h			;else branch
_print_SW_B_S:
		mov r1, #0x53	;'S'
		str r1, [r2]
_p_Delay_SW_B_S:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_B_S:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_B_W	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_B_S			;else branch
_print_SW_B_W:
		mov r1, #0x57	;'W'
		str r1, [r2]
_p_Delay_SW_B_W:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_B_W:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_sp_SW_B	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_B_W		;else branch
_print_sp_SW_B:
		mov r1, #0x20	;' '
		str r1, [r2]
_p_Delay_sp_SW_B:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_sp_SW_B:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_B	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_sp_SW_B			;else branch
_print_SW_B:
		mov r1, #0x42	;'B'
		str r1, [r2]
_p_Delay_SW_B:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_B:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_enter_SW_B	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_B			;else branch
_print_enter_SW_B:
		mov r1, #0x0D	;'enter'
		str r1, [r2]
		mov r1, #0x0A	;'enter'
		str r1, [r2]
		b _EXIT


;Print -SW C
_Print_SW_C:
_check_FIFO_SW_C:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTFR
		add r2, r1, r2

		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20	;compare if TXFF bit is 1
		BEQ _Print_SW_C	;Go back to Label Print_LEDMODE if the transmitter is full (TXFF bit = 1)
_data_write_SW_C:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTDR
		add r2, r1, r2

_print_C_h:
		mov r1, #0x2D	;'-'
		str r1, [r2]
_p_Delay_C_h:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_C_h:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_C_S	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_C_h			;else branch
_print_C_S:
		mov r1, #0x53	;'S'
		str r1, [r2]
_p_Delay_C_S:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_C_S:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_C_W	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_C_S			;else branch
_print_C_W:
		mov r1, #0x57	;'W'
		str r1, [r2]
_p_Delay_C_W:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_C_W:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_sp_C	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_C_W		;else branch
_print_sp_C:
		mov r1, #0x20	;' '
		str r1, [r2]
_p_Delay_sp_C:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_sp_C:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_C	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_sp_C			;else branch
_print_C:
		mov r1, #0x43	;'C'
		str r1, [r2]
_p_Delay_C:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_C:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_enter_C	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_C			;else branch
_print_enter_C:
		mov r1, #0x0D	;'enter'
		str r1, [r2]
		mov r1, #0x0A	;'enter'
		str r1, [r2]
		b _EXIT

;Print -SW D
_Print_SW_D:
_check_FIFO_SW_D:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTFR
		add r2, r1, r2

		ldr r1, [r2]
		and r1, r1, #0x20
		cmp r1, #0x20	;compare if TXFF bit is 1
		BEQ _Print_SW_D	;Go back to Label Print_LEDMODE if the transmitter is full (TXFF bit = 1)
_data_write_SW_D:
		mov r1, #GPIO_BASE
		mov r2, #0xc000
		add r2, r1, r2
		mov r1, #UARTDR
		add r2, r1, r2

_print_SW_D_h:
		mov r1, #0x2D	;'-'
		str r1, [r2]
_p_Delay_SW_D_h:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_D_h:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_D_S	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_D_h			;else branch
_print_SW_D_S:
		mov r1, #0x53	;'S'
		str r1, [r2]
_p_Delay_SW_D_S:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_D_S:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_D_W	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_D_S			;else branch
_print_SW_D_W:
		mov r1, #0x57	;'W'
		str r1, [r2]
_p_Delay_SW_D_W:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_D_W:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_sp_SW_D	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_D_W		;else branch
_print_sp_SW_D:
		mov r1, #0x20	;' '
		str r1, [r2]
_p_Delay_sp_SW_D:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_sp_SW_D:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_SW_D	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_sp_SW_D			;else branch
_print_SW_D:
		mov r1, #0x44	;'D'
		str r1, [r2]
_p_Delay_SW_D:
		MOVW r3,#0xffff; set register value large number
_p_Delay_Loop_SW_D:
		sub r3,r3,#1			; subtract 1
		CBZ r3, _print_enter_SW_D	;Compare and Branch on Zero (if r3 becomes 0)
		b _p_Delay_Loop_SW_D			;else branch
_print_enter_SW_D:
		mov r1, #0x0D	;'enter'
		str r1, [r2]
		mov r1, #0x0A	;'enter'
		str r1, [r2]
		b _EXIT


;///////////////////////////////////////////////
_EXIT:
		bx lr		;go back to C code


			.retain
			.retainrefs
