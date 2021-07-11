EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Hello LED"
Date "2021-07-10"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Microchip_ATtiny:ATtiny85-20PU U?
U 1 1 60E9ECB7
P 2600 2050
F 0 "U?" H 2071 2096 50  0000 R CNN
F 1 "ATtiny85-20PU" H 2071 2005 50  0000 R CNN
F 2 "Package_DIP:DIP-8_W7.62mm" H 2600 2050 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/atmel-2586-avr-8-bit-microcontroller-attiny25-attiny45-attiny85_datasheet.pdf" H 2600 2050 50  0001 C CNN
	1    2600 2050
	1    0    0    -1  
$EndComp
$Comp
L Device:LED D?
U 1 1 60E9F3DF
P 3800 3000
F 0 "D?" V 3839 2882 50  0000 R CNN
F 1 "GREEN LED" V 3748 2882 50  0000 R CNN
F 2 "" H 3800 3000 50  0001 C CNN
F 3 "~" H 3800 3000 50  0001 C CNN
	1    3800 3000
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 60EA0262
P 3800 2500
F 0 "R?" H 3870 2546 50  0000 L CNN
F 1 "220R" H 3870 2455 50  0000 L CNN
F 2 "" V 3730 2500 50  0001 C CNN
F 3 "~" H 3800 2500 50  0001 C CNN
	1    3800 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 2050 3800 2050
Wire Wire Line
	3800 2050 3800 2350
Wire Wire Line
	3800 2650 3800 2850
$Comp
L power:+5V #PWR?
U 1 1 60EA10EB
P 2600 1050
F 0 "#PWR?" H 2600 900 50  0001 C CNN
F 1 "+5V" H 2615 1223 50  0000 C CNN
F 2 "" H 2600 1050 50  0001 C CNN
F 3 "" H 2600 1050 50  0001 C CNN
	1    2600 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 1050 2600 1450
$Comp
L power:GND #PWR?
U 1 1 60EA1706
P 3800 3400
F 0 "#PWR?" H 3800 3150 50  0001 C CNN
F 1 "GND" H 3805 3227 50  0000 C CNN
F 2 "" H 3800 3400 50  0001 C CNN
F 3 "" H 3800 3400 50  0001 C CNN
	1    3800 3400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60EA1A0E
P 2600 3400
F 0 "#PWR?" H 2600 3150 50  0001 C CNN
F 1 "GND" H 2605 3227 50  0000 C CNN
F 2 "" H 2600 3400 50  0001 C CNN
F 3 "" H 2600 3400 50  0001 C CNN
	1    2600 3400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2600 3400 2600 2650
Wire Wire Line
	3800 3150 3800 3400
$EndSCHEMATC
