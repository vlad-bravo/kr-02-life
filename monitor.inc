; Точки вызова монитора

; ---------------------------------------------------------------------------
; OF800h - Entry point after reset                
.def     COLD_INIT             0xf800
; ---------------------------------------------------------------------------
; OF803h - Keyboard input 
;   Input : None
;   Output: A - character code read from keyboard
.def     INPUT_KEY             0xf803
; ---------------------------------------------------------------------------
; 0F806Н - Read a byte from a tape 
;   Input : A=0FFh - with sync; A=08h - no sync
;   Output: A - data read from cassette
.def     TAPE_READ_BYTE        0xf806
; ---------------------------------------------------------------------------
; 0F809h - Print character to screen 
;   Input : C - character to print
;   Output: None
.def     PRINT_CHAR            0xf809
; ---------------------------------------------------------------------------
; 0F80Ch - Write a byte onto a tape 
;   Input : C - data to write
;   Output: None
.def     TAPE_WRITE_BYTE       0xf80c
; ---------------------------------------------------------------------------
; 0F812h - Query keyboard 
;   Input : None
;   Output: A=00h - key not pressed; A=0FFh - key pressed
.def     KEY_STATUS            0xf812
; ---------------------------------------------------------------------------
; 0F15h - Print to screen in hex 
;   Input: A - data to print
;   Output: None
.def     PRINT_HEX             0xf815
; ---------------------------------------------------------------------------
; 0F18h - Print string 
;   Input: HL - string address
;   Output: None
.def     PRINT_STRING          0xf818
; ---------------------------------------------------------------------------
; 0F1Bh - Get key
;   Input : None
;   Output: A=0FFh - key not pressed; A=0FEh - Rus/Lat; otherwise A - key code
.def     GET_KEY               0xf81b
; ---------------------------------------------------------------------------
; 0F81Eh - Get cursor position
;   Input : None
;   Output: H - row, L - column
.def     GET_CURSOR_POSITION   0xf81e
; ---------------------------------------------------------------------------
; 0F821h - Read character from screen at current cursor position
;   Input : None
;   Output: A - char read from screen
.def     READ_VIDEO_RAM        0xf821
; ---------------------------------------------------------------------------
; 0F824h - Read from a tape
;   Input: HL - offset of memory buffer to store data to
;   Output: HL - start, DE - end, BC - checksum
.def     TAPE_READ_BLOCK       0xf824
; ---------------------------------------------------------------------------
; 0F27h - Write block to a tape
;   Input: HL - start, DE - end of memory block
;   Output:  BC - checksum
.def     TAPE_WRITE_BLOCK      0xf827
; ---------------------------------------------------------------------------
; 0F82Ah - Calculate Check Summ
;   Input: HL - start; DE - end;
;   Output: BC - checksum
.def     CALC_CHECK_SUMM       0xf82a
; ---------------------------------------------------------------------------
; 0F82Dh - Init Display
; Input: None
; Output: None
.def     INIT_DISPLAY_REFRESH  0xf82d
; ---------------------------------------------------------------------------
; 0F830h - Get memory heap
;   Input: None
;   Output: HL - Address of highest address of memory, avalable for a user's programm
.def     GET_FREE_MEM_ADDR     0xf830
; ---------------------------------------------------------------------------
; 0F833h - Set memory heap
;   Input: HL - Address of highest address of memory, avalable for a user's programm
;   Output:  None
.def     SET_FREE_MEM_ADDR     0xf833
