;
; ***********************************
; * (Driver for PCF8574 expander)   *
; * (ATtiny85)                      *
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
; (F2 adds ASCII pin-out for device here);
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
.equ SDA = PORTB0
.equ SCL = PORTB2
.equ EXPANDER_INT = PORTB1
.equ ERROR_LED = PORTB4

.equ FREE_LEGS = (1 << PORTB3) | (1 << PORTB5)
;
; **********************************
;   A D J U S T A B L E   C O N S T
; **********************************
;
; (Add all user adjustable constants here, e.g.)
; .equ clock=1000000 ; Define the clock frequency
;
; **********************************
;  F I X  &  D E R I V.  C O N S T
; **********************************
;
; (Add symbols for fixed and derived constants here)
;
; **********************************
;       R E G I S T E R S
; **********************************
;
; free: R0 to R14
.def rSreg = R15 ; Save/Restore status port
.def rmp = R16 ; Define multipurpose register
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
; sLabel1:
;   .byte 16 ; Reserve 16 bytes)
;
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
    rjmp PinChangeInt ; PCI0 - Pin Change Interrupt Request 0
    reti ; OC1A - Timer/Counter 1 Compare Match A
    reti ; OVF1 - Timer/Counter 1 Overflow
    reti ; OVF0 - Timer/Counter 0 Overflow
    reti ; ERDY - EEPROM Ready
    reti ; ACI - Analog Comparator
    reti ; ADCC - ADC Conversion Complete
    reti ; OC1B - Timer/Counter 1 Compare Match B
    reti ; OC0A - Timer/Counter 0 Compare Match A
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
PinChangeInt:
    reti
;
; **********************************
;  M A I N   P R O G R A M   I N I T
; **********************************
;
Main:
.ifdef SPH ; if SPH is defined
    ldi rmp,High(RAMEND)
    out SPH,rmp ; Init MSB stack pointer
.endif
    ldi rmp,Low(RAMEND)
    out SPL,rmp ; Init LSB stack pointer

    ldi rmp, (1 << SE) ; Set Sleep Enable bit
    out MCUCR, rmp ; Enable MCU sleep mode (Idle by default)
    
    ldi rmp, FREE_LEGS
    out PORTB, rmp ; Enable pull-up resistors on unsued chip legs as recommended in documentation

    sbi PCMSK, EXPANDER_INT ; Enable PCINT only on expander pin
    ldi rmp, (1 << PCIE)
    out GIMSK, rmp ; Enable Pin Change Interrupts PCINT
    
    sbi DDRB, ERROR_LED ; Set LED pin as output
    
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
; End of source code
;
; (Add Copyright information here, e.g.
; .db "(C)2020 by Gerhard Schmidt  " ; Source code readable
; .db "C(2)20 0ybG reahdrS hcimtd  " ; Machine code format
;
