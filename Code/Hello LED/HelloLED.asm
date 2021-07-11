; ***********************************
; * (Testing uC capabilities)       *
; * (ATtiny85 v 1.0)                *
; * (C)2021 by Paweł Standowicz     *
; ***********************************
;
.nolist
.include "tn85def.inc" ; Define device ATtiny85
.list
;
; **********************************
;        H A R D W A R E
; **********************************
;
; (F2 adds ASCII pin-out for device here)
; Device: ATtiny85, Package: 8-pin-PDIP_SOIC
;
;           _________
;        1 /         |8
;      o--|RESET  VCC|--o
;      o--|PB3    PB2|--o
;      o--|PB4    PB1|--o
;      o--|GND    PB0|--o
;       4 |__________|5
;
;
; **********************************
;  P O R T S   A N D   P I N S
; **********************************
;
; (Add symbols for all ports and port pins with ".equ" here)
; (e.g. .equ pDirD = DDRB ; Define a direction port
;  or
;  .equ bMyPinO = PORTB0 ; Define an output pin)
;
; **********************************
;   A D J U S T A B L E   C O N S T
; **********************************
;
; (Add all user adjustable constants here, e.g.)
;.equ CLOCK = 1000000 ; Define the clock frequency
;.equ TIMER0_PRESCALER = 1024;
.equ TICKS_PER_SECOND = 976 ; Clock 1MHz and 1024 prescaler
.equ TIMER_INTS_PER_HALF_SECOND = 2

.equ GREEN_LED = PORTB3 ; should source current to light
.equ FREE_LEG0 = PORTB0
.equ FREE_LEG1 = PORTB1
.equ FREE_LEG2 = PORTB2
.equ FREE_LEG3 = PORTB4
.equ FREE_LEG4 = PORTB5
;
; **********************************
;  F I X  &  D E R I V.  C O N S T
; **********************************
;
; (Add symbols for fixed and derived constants here)
.equ TICKS_PER_HALF_SECOND = TICKS_PER_SECOND / 2 ;(488) Clock 1MHz and 1024 prescaler
.equ TIMER_MAX_VALUE = TICKS_PER_HALF_SECOND / 2 ; (244)
;
; **********************************
;       R E G I S T E R S
; **********************************
;
; free: R0 to R14
.def rSreg = R15 ; Save/Restore status port
.def rmp = R16 ; Define multipurpose register
.def rTimer0Ints = R17 ; Timer0 interrupts counter
; free: R17 to R29
; used: R31:R30 = Z for ...
;
; **********************************
;           S R A M
; **********************************
;
.dseg
.org SRAM_START
; (Add labels for SRAM locations here, e.g.
;sLabel1:
;  .byte 16 ; Reserve 16 bytes)
;
; **********************************
;         M A C R O S
; **********************************
.macro EnableLED
    sbi PORTB, GREEN_LED
.endmacro

.macro DisableLED
    cbi PORTB, GREEN_LED
.endmacro
; **********************************
;         C O D E
; **********************************
;
.cseg
.org 0
;
; **********************************
; R E S E T  &  I N T - V E C T O R S
; **********************************
    rjmp Main ; Reset vector
    reti ; INT0 - External Interrupt Request 0
    reti ; PCI0 - Pin Change Interrupt Request 0
    reti ; OC1A - Timer/Counter 1 Compare Match A
    reti ; OVF1 - Timer/Counter 1 Overflow
    reti ; OVF0 - Timer/Counter 0 Overflow
    reti ; ERDY - EEPROM Ready
    reti ; ACI - Analog Comparator
    reti ; ADCC - ADC Conversion Complete
    reti ; OC1B - Timer/Counter 1 Compare Match B
    rjmp Timer0_MatchA ; OC0A - Timer/Counter 0 Compare Match A
    reti ; OC0B - Timer/Counter 0 Compare Match B
    reti ; WDT - Watchdog Time-out
    reti ; USI_START - USI Start
    reti ; USI_OVF - USI Overflow
;
; **********************************
;  I N T - S E R V I C E   R O U T .
; **********************************
;
; (Add all interrupt service routines here)
Timer0_MatchA:
    inc rTimer0Ints ; Increase timer interrupts counter by 1
    cpi rTimer0Ints, TIMER_INTS_PER_HALF_SECOND ; Compare it to expected interrupts number in 0.5 sec.
    brne ToggleLED ; Jump if not equal
    clr rTimer0Ints ; Clear timer interrupts counter to 0

    ToggleLED:
        sbic PORTB, GREEN_LED ; if LED is off skip next instruction
        rjmp Disable_LED
        EnableLED
        rjmp Timer0_MatchA_End

    Disable_LED:
        DisableLED

    Timer0_MatchA_End:
    reti
;
; **********************************
;  M A I N   P R O G R A M   I N I T
; **********************************
;
Main:
.ifdef SPH ; if SPH is defined
    ldi rmp, High(RAMEND)
    out SPH, rmp ; Init MSB stack pointer
.endif
    ldi rmp, Low(RAMEND)
    out SPL, rmp ; Init LSB stack pointer

    ldi rmp, (1 << SE) ; Set Sleep Enable bit
    out MCUCR, rmp ; Enable MCU sleep mode (Idle by default)

    ldi rmp, (1 << FREE_LEG0) | (1 << FREE_LEG1) | (1 << FREE_LEG2) | (1 << FREE_LEG3) | (1 << FREE_LEG4)
    out PORTB, rmp ; Enable pull-up resistors on unsued chip legs as recommended in documentation
    sbi DDRB, GREEN_LED ; Set LED pin as output

    ; Prepare Timer0
    ldi rmp, (1 << CS02) | (1 << CS00)
    out TCCR0B, rmp ; Set clock prescaler to 1024
    ldi rmp, (1 << WGM01)
    out TCCR0A, rmp ; Set Clear Timer on Compare Match (CTC) Mode
    ldi rmp, TIMER_MAX_VALUE
    out OCR0A, rmp ; Set Output Compare Register A
    ldi rmp, (1 << OCIE0A)
    out TIMSK, rmp ; Enable Timer/Counter 0 Compare Match A Interrupt

    sei ; Enable interrupts
;
; **********************************
;    P R O G R A M   L O O P
; **********************************
;
Main_Loop:
    sleep
    rjmp Main_Loop
;
; **********************************
; P R O G R A M   F U N C T I O N S
; **********************************
;
; End of source code
;
; (Add Copyright information here, e.g.
Author:
    .db "(C)2021 by Pawel Standowicz " ; Source code readable
; .db "C(2)20 0ybG reahdrS hcimtd  " ; Machine code format
