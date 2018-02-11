; main.s
; Runs on any Cortex M processor
; A very simple first project implementing a random number generator
; Daniel Valvano
; May 12, 2015

;  This example accompanies the book
;  "Embedded Systems: Introduction to Arm Cortex M Microcontrollers",
;  ISBN: 978-1469998749, Jonathan Valvano, copyright (c) 2015
;  Section 3.3.10, Program 3.12
;
;Copyright 2015 by Jonathan W. Valvano, valvano@mail.utexas.edu
;   You may use, edit, run or distribute this file
;   as long as the above copyright notice remains
;THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
;OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
;MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
;VALVANO SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL,
;OR CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
;For more information about my classes, my research, and my books, see
;http://users.ece.utexas.edu/~valvano/


; we align 32 bit variables to 32-bits
; we align op codes to 16 bits
       THUMB
	   IMPORT Random	; C function, returns a random number into r0
       AREA    |.text|, CODE, READONLY, ALIGN=2
       EXPORT  Start		   
Start  	   
	   BL  add64
	   BL  sub64
	   BL  endian

add64  
	   ADD r12, LR	; store the return address of the line "BL add64"
	   BL  Random	; first random number
	   MOV r3, r0	; r3 = Random Value
	   BL  Random	; second random number
	   ADDS r4, r3, r0	; Adds 2 random numbers, r4 = sum 
	   MOVCS r5, #1	; carry flag saved
	   BCC	ok		; if C == 0, no error
	   BL	unsadd	; saturation subroutine for unsigned addition
	   BVC	ok		; if V == 0, no error
	   BL	sign	; saturation subroutine for signed, V == 1
	   
ok	   
	   BX  r12		; branch link to the address after add64


unsadd
	   MOV r4, #0xFFFFFFFF	; unsigned - ceiling, saturation
	   BX  r14	;return

sign
	   MOV r4, #0x7FFFFFFF	; signed - ceiling(2,147,483,647), saturation
	   BMI ok	; if N == 1, it was overflow
	   MOV r4, #0x80000000	; singed - floor(-2,147,483,647), saturation
	   BX  r14  ; return
	   
sub64
	   ADD r11, LR	; store the return address of the line "BL sub64"
	   BL  Random	; first random number
	   MOV r3, r0	; r3 = Random Value
	   BL  Random	; second random number
	   SUBS r4, r3, r0	; Subtracts 2 random numbers, r4 = subtraction
	   MOVCS r5, #1 ; carry flag saved
	   BCS	ok2		; if C == 1, no error
	   BL	unsub	; saturation subroutine for unsigned subtraction
	   BVC	ok2		; if V == 0, no error
	   BL	sign	; saturation subroutine for signed, v == 1
	   
ok2
	   BX  r11		; branch link to the address after sub64
	   
unsub
	   MOV r4, #0	; floor, r4 = 0
	   BX  r14		; return

endian
	   ADD r3, LR	; store the return address
	   BL  Random
	   REV r4, r0	; Litte endian to Big Endiand, Vise Versa
	   BL  Random
	   REV r5, r0	   
	   BL  Random
	   REV r6, r0
	   BL  Random
	   REV r7, r0
	   BL  Random
	   REV r8, r0	   
	   BL  Random
	   REV r9, r0	   
	   BL  Random
	   REV r10, r0
	   BL  Random
	   REV r11, r0
	   BL  Random
	   REV r4, r0
	   BL  Random
	   REV r5, r0
	   BX  r3		; brank link to the address after endian
	   
       ALIGN      
       END  
           