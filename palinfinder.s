// palinfinder.s, provided with Lab1 in TDT4258 autumn 2026
.global _start

// r0 = input address, r1 = index / eventually string length, r2 = left index, r3 = right index,
// r4 = temp char, r5 = temp char

_start:
	ldr r0, =input  		// r0 = address of input
	mov r1, #0				// r1 = index, starting at 0

check_input:
	// Check input length
	ldrb r4, [r0, r1]		// r4 = input[r1]
	cmp r4, #0				// have we reached '\0'?
	beq length_found		// if yes -> length is found

	add r1, r1, #1			// r1++
	b check_input			// check next character

length_found:
	// r1 is now the length, check if < 4 characters and set
	// left and right index
	cmp r1, #4				
	blt is_no_palindrom		// if length < 4 -> not a palindrome

	mov r2, #0				// left = 0
	sub r3, r1, #1			// right = length - 1

skip_left_spaces:
	cmp r2, r3				// have left and right met or crossed?
	bge is_palindrom 		// if left >= right, all chars matched -> palindrom

	ldrb r4, [r0, r2]		// r4 = input[left]
	cmp r4, #' '
	bne skip_right_spaces	// if input[left] != space, check right side

	add r2, r2, #1			// left++
	b skip_left_spaces		// check for more spaces

skip_right_spaces:
	cmp r2, r3				// have left and right met or crossed?
	bge is_palindrom 		// if left >= right, all chars matched -> palindrom

	ldrb r5, [r0, r3]		// r5 = input[right]
	cmp r5, #' '
	bne check_wildcards		// if input[right] != space, check for wildcard

	sub r3, r3, #1			// right--
	b skip_right_spaces		// check for more spaces

check_wildcards:
	cmp r4, #'?'
	beq chars_match			// if left char == ?, wildcard match

	cmp r4, #'%'
	beq chars_match			// if left char == %, wildcard match

	cmp r5, #'?'
	beq chars_match			// if rigt char == ?, wildcard match

	cmp r5, #'%'
	beq chars_match			// if right char == %, wildcard match

check_left_case:
	// (capital letters have smaller ASCII values than lowercase)
	cmp r4, #'A'
	blt check_right_case	// if r4 < 'A'? -> don't convert (number)

	cmp r4, #'Z'
	bgt check_right_case	// if r4 > 'Z' -> don't convert (lowercase)

	add r4, r4, #32			// uppercase -> lowercase

check_right_case:
	// (capital letters have smaller ASCII values than lowercase)
	cmp r5, #'A'			
	blt compare_chars		// if r5 < 'A'? -> don't convert (number)

	cmp r5, #'Z'
	bgt compare_chars		// if r5 > 'Z' -> don't convert (lowercase)

	add r5, r5, #32			// uppercase -> lowercase

compare_chars:
	cmp r4, r5				// input[left] == input[right]?
	bne is_no_palindrom		// if no -> not a palindrome

chars_match:
	add r2, r2, #1			// left++
	sub r3, r3, #1			// right--
	b skip_left_spaces		// check next pair
	
// From manual:
// LED:     9 8 7 6 5 4 3 2 1 0
// bit:     9 8 7 6 5 4 3 2 1 0

is_palindrom:
	// Switch on only the 5 rightmost LEDs
	ldr r6, =0xFF200000		// r6 = address of red LED data reg.

	// 5 rightmost LEDs: 0000011111_2 = 0x1F_16
	mov r7, #0x1F			// turn on LED 4-0
	str r7, [r6]			// write LED pattern to data reg.

	// Write 'Palindrom detected' to UART
	ldr r6, =0xFF201000		// r6 = address of JTAG UART data reg.
	ldr r7, =palindrome_msg	// r7 = address of palindrome msg
	b print_uart				// print msg
	
	
is_no_palindrom:
	// Switch on only the 5 leftmost LEDs
	ldr r6, =0xFF200000		// r6 = address of red LED data reg.

	// 5 leftmost LEDs: 1111100000_2 = 0x3E0
	mov r7, #0x3E0			// turn on LED 9-5
	str r7, [r6]			// write LED pattern to data reg.

	// Write 'Not a palindrom' to UART
	ldr r6, =0xFF201000		// r6 = address of JTAG UART data reg.
	ldr r7, =not_palindrome_msg	// r7 = address of palindrome msg
	b print_uart			// print msg
	
print_uart:
    ldrb r8, [r7]           // r8 = current character
    cmp r8, #0              // end of string?
    beq _exit               // yes -> finished printing

    str r8, [r6]            // write character to JTAG UART
    add r7, r7, #1          // move to next character
    b print_uart            // print next character

_exit:
	// Branch here for exit
	b .
	
.data
.align
	// This is the input you are supposed to check for a palindrom
	input: .asciz "Grav ned den varg"
	
	// Final messages after check
	palindrome_msg: .asciz "Palindrome detected"
	not_palindrome_msg: .asciz "Not a palindrome"
.end
