.include "memorymap.inc"
.include "monitor.inc"

.stringmaptable russian "russian.tbl"
.stringmaptable pseudo_g "pseudo_g.tbl"

.def BL_CHAR_1 0x00       ; Пробельные символы
.def BL_CHAR_2 0x20
.def LIVE_CHAR 0x17       ; Символ живой клетки. 0x17 - закрашенный квадрат
.def KEY_PRESSED 0xff
.def GEN_CONTROL_ON  0x01 ; Контроль количества выводимых поколений
.def GEN_CONTROL_OFF 0x00
.def CRT_8075_CFG    0xc002
.def TIM_8053_CAN2   0xd802

.SECTION "LIFE" FREE

   .byte 0x60             ; #5ffc 60
   .byte 0x00             ; #5ffd 00
   .byte 0x6f             ; #5ffe 6f
   .byte 0x60             ; #5fff 60

START:
   call @_CLS             ; #6000 cd 93 63
   mvi a,LIVE_CHAR        ; #6003 3e 17
   sta @LIVE_SYM          ; #6005 32 14 63
   call @PRINT_SPLASH     ; #6008 cd 15 63
   call @BEEP3            ; #600b cd d3 63
   mvi a,GEN_CONTROL_ON   ; #600e 3e 01
   sta @GEN_CONTROL       ; #6010 32 12 63
   mvi a,10               ; #6013 3e 0a
   sta @GEN_CONTROL_COUNT ; #6015 32 13 63
   jmp @CMD_VK            ; #6018 c3 3d 61

@CMD_K: ; Перезапуск программы
   mvi a,GEN_CONTROL_OFF  ; #601b 3e 00
   call @BEEP1            ; #601d cd 9d 63
   sta @GEN_CONTROL       ; #6020 32 12 63
   call @_CLS             ; #6023 cd 93 63
   call @PRINT_SPLASH     ; #6026 cd 15 63
   lxi h,@INPUT_LIVE_SYM  ; #6029 21 69 63
   call PRINT_STRING      ; #602c cd 18 f8
   call INPUT_KEY         ; #602f cd 03 f8
   call @BEEP1            ; #6032 cd 9d 63
   mov c,a                ; #6035 4f
   call PRINT_CHAR        ; #6036 cd 09 f8
   call @DELAY            ; #6039 cd 77 62
   call @DELAY            ; #603c cd 77 62
   call @DELAY            ; #603f cd 77 62
   call @DELAY            ; #6042 cd 77 62
   call @DELAY            ; #6045 cd 77 62
   call @BEEP2            ; #6048 cd b8 63
   call @BEEP4            ; #604b cd fa 63
   sta @LIVE_SYM          ; #604e 32 14 63
   call @_CLS             ; #6051 cd 93 63
   call @PRINT_SPLASH     ; #6054 cd 15 63
   lxi h,@NEED_INSTR      ; #6057 21 4f 63
   call PRINT_STRING      ; #605a cd 18 f8
   call INPUT_KEY         ; #605d cd 03 f8
   call @BEEP4            ; #6060 cd fa 63
   cpi 'd'                ; d = Д
   jz @6073               ; #6065 ca 73 60
   cpi 'D'                ; #6068 fe 44
   jz @6073               ; #606a ca 73 60
   call @BEEP1            ; #606d cd 9d 63
   jmp @CMD_STR           ; #6070 c3 91 60
@6073:
   call @_CLS             ; #6073 cd 93 63
   call @BEEP1            ; #6076 cd 9d 63
   lxi h,@HELP_TEXT       ; #6079 21 0a 64
   call PRINT_STRING      ; #607c cd 18 f8
   call INPUT_KEY         ; #607f cd 03 f8
   call @BEEP4            ; #6082 cd fa 63
   call @BEEP1            ; #6085 cd 9d 63
   call @DELAY            ; #6088 cd 77 62
   call @DELAY            ; #608b cd 77 62
   jmp @CMD_STR           ; #608e c3 91 60

@CMD_STR: ; Очистка поля
   call @_CLS             ; #6091 cd 93 63
   mvi a,'r'              ; #6094 3e 72
   sta @MODE_PLACEHOLDER  ; #6096 32 07 63
   mvi a,'0'              ; #6099 3e 30
   sta @GEN4_PLACEHOLDER  ; #609b 32 10 63
   sta @GEN3_PLACEHOLDER  ; #609e 32 0f 63
   sta @GEN2_PLACEHOLDER  ; #60a1 32 0e 63
   sta @GEN1_PLACEHOLDER  ; #60a4 32 0d 63
   lxi h,0x77c2           ; #60a7 21 c2 77
   push h                 ; #60aa e5
   lxi b,0x0001           ; #60ab 01 01 00
   mvi e,58               ; #60ae 1e 3a
   call @_LINE            ; #60b0 cd d3 60
   push h                 ; #60b3 e5
   lxi h,0x7f12           ; #60b4 21 12 7f
   mvi e,58               ; #60b7 1e 3a
   call @_LINE            ; #60b9 cd d3 60
   pop h                  ; #60bc e1
   mvi c,78               ; #60bd 0e 4e
   mvi e,25               ; #60bf 1e 19
   call @_LINE            ; #60c1 cd d3 60
   pop h                  ; #60c4 e1
   mvi e,25               ; #60c5 1e 19
   call @_LINE            ; #60c7 cd d3 60
   call @INC_GEN          ; #60ca cd a4 62
   call @PRINT_MODE       ; #60cd cd 8e 62
   jmp @MAIN_LOOP         ; #60d0 c3 db 60

@_LINE:
   mvi m,LIVE_CHAR        ; #60d3 36 17
   dad b                  ; #60d5 09
   dcr e                  ; #60d6 1d
   jnz @_LINE             ; #60d7 c2 d3 60
   ret                    ; #60da c9

@MAIN_LOOP:
   call INPUT_KEY         ; #60db cd 03 f8
   call @BEEP4            ; #60de cd fa 63
   cpi 'a'                ; #60e1 fe 61
   jz @CMD_A              ; #60e3 ca 10 61
   cpi 'A'                ; #60e6 fe 41
   jz @CMD_A              ; #60e8 ca 10 61
   cpi 'r'                ; #60eb fe 72
   jz @CMD_R              ; #60ed ca 1e 61
   cpi 'R'                ; #60f0 fe 52
   jz @CMD_R              ; #60f2 ca 1e 61
   cpi 0x0d               ; #60f5 fe 0d
   jz @CMD_VK             ; #60f7 ca 3d 61
   cpi 0x1f               ; #60fa fe 1f
   jz @CMD_STR            ; #60fc ca 91 60
   cpi 'k'                ; #60ff fe 6b
   jz @CMD_K              ; #6101 ca 1b 60
   cpi 'K'                ; #6104 fe 4b
   jz @CMD_K              ; #6106 ca 1b 60
   mov c,a                ; #6109 4f
   call PRINT_CHAR        ; #610a cd 09 f8
   jmp @MAIN_LOOP         ; #610d c3 db 60

@CMD_A: ; Автоматический режим
   mvi a,'a'              ; #6110 3e 61
   sta @MODE_PLACEHOLDER  ; #6112 32 07 63
   call @BEEP1            ; #6115 cd 9d 63
   call @PRINT_MODE       ; #6118 cd 8e 62
   jmp @MAIN_LOOP         ; #611b c3 db 60

@CMD_R: ; Ручной режим
   mvi a,'r'              ; #611e 3e 72
   sta @MODE_PLACEHOLDER  ; #6120 32 07 63
   call @BEEP2            ; #6123 cd b8 63
   call @PRINT_MODE       ; #6126 cd 8e 62
   jmp @MAIN_LOOP         ; #6129 c3 db 60

@CHECK_KEY_STATUS:
   call @DELAY            ; #612c cd 77 62
   call KEY_STATUS        ; #612f cd 12 f8
   cpi KEY_PRESSED        ; #6132 fe ff
   call @DELAY            ; #6134 cd 77 62
   jz @MAIN_LOOP          ; #6137 ca db 60
   jmp @CMD_VK            ; #613a c3 3d 61

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@CMD_VK: ; Пуск
   lxi d,0x0000           ; #613d 11 00 00
   lxi h,0x7860           ; #6140 21 60 78
   mvi b,0x37             ; #6143 06 37
   mvi c,0x15             ; #6145 0e 15
   call @BEEP1            ; #6147 cd 9d 63
@614a:
   push b                 ; #614a c5
   call @CALC_NEIGHBOURS  ; #614b cd f1 61
   xchg                   ; #614e eb
   cpi 0x03               ; #614f fe 03
   jz @NEW_LIVE           ; #6151 ca 67 61
   jp @NEW_DEAD           ; #6154 f2 62 61
   cpi 0x02               ; #6157 fe 02
   jm @NEW_DEAD           ; #6159 fa 62 61
   mov a,b                ; #615c 78
   cpi 0x00               ; #615d fe 00
   jnz @NEW_LIVE          ; #615f c2 67 61
@NEW_DEAD:
   mvi m,0x00             ; #6162 36 00
   jmp @616b              ; #6164 c3 6b 61
@NEW_LIVE:
   lda @LIVE_SYM          ; #6167 3a 14 63
   mov m,a                ; #616a 77
@616b:
   pop b                  ; #616b c1      
   dcr b                  ; #616c 05      
   mvi a,0x00             ; #616d 3e 00   
   cmp b                  ; #616f b8      
   jp @6179               ; #6170 f2 79 61
   inx h                  ; #6173 23      
   xchg                   ; #6174 eb      
   inx h                  ; #6175 23      
   jmp @614a              ; #6176 c3 4a 61
@6179:
   dcr c                  ; #6179 0d      
   cmp c                  ; #617a b9      
   jp @6192               ; #617b f2 92 61
   mvi b,0x37             ; #617e 06 37   
   push h                 ; #6180 e5      
   xchg                   ; #6181 eb      
   lxi d,0x0018           ; #6182 11 18 00
   dad d                  ; #6185 19      
   xchg                   ; #6186 eb      
   pop h                  ; #6187 e1      
   push d                 ; #6188 d5      
   lxi d,0x0018           ; #6189 11 18 00
   dad d                  ; #618c 19      
   pop d                  ; #618d d1      
   xchg                   ; #618e eb      
   jmp @614a              ; #618f c3 4a 61
@6192:
   call @BUFFER_TO_SCREEN ; #6192 cd c0 61
   call @BEEP2            ; #6195 cd b8 63
   lda @GEN_CONTROL       ; #6198 3a 12 63
   cpi GEN_CONTROL_ON     ; #619b fe 01   
   jnz @61b2              ; #619d c2 b2 61
   lda @GEN_CONTROL_COUNT ; #61a0 3a 13 63
   dcr a                  ; #61a3 3d      
   sta @GEN_CONTROL_COUNT ; #61a4 32 13 63
   cpi 0x00               ; #61a7 fe 00   
   jz @CMD_K              ; #61a9 ca 1b 60
   call @DELAY            ; #61ac cd 77 62
   jmp @CMD_VK            ; #61af c3 3d 61
@61b2:
   call @INC_GEN          ; #61b2 cd a4 62
   lda @MODE_PLACEHOLDER  ; #61b5 3a 07 63
   cpi 'a'                ; #61b8 fe 61   
   jz @CHECK_KEY_STATUS   ; #61ba ca 2c 61
   jmp @MAIN_LOOP         ; #61bd c3 db 60

@BUFFER_TO_SCREEN:
   lxi d,0x7860           ; #61c0 11 60 78
   lxi h,0x0000           ; #61c3 21 00 00
   mvi b,0x37             ; #61c6 06 37   
   mvi c,0x15             ; #61c8 0e 15   
@61ca:
   mov a,m                ; #61ca 7e      
   xchg                   ; #61cb eb      
   mov m,a                ; #61cc 77      
   dcr b                  ; #61cd 05      
   mvi a,0x00             ; #61ce 3e 00   
   cmp b                  ; #61d0 b8      
   jp @61da               ; #61d1 f2 da 61
   inx h                  ; #61d4 23      
   xchg                   ; #61d5 eb      
   inx h                  ; #61d6 23      
   jmp @61ca              ; #61d7 c3 ca 61
@61da:
   dcr c                  ; #61da 0d      
   cmp c                  ; #61db b9      
   rp                     ; #61dc f0      
   mvi b,0x37             ; #61dd 06 37   
   push h                 ; #61df e5      
   xchg                   ; #61e0 eb      
   lxi d,0x0018           ; #61e1 11 18 00
   dad d                  ; #61e4 19      
   xchg                   ; #61e5 eb      
   pop h                  ; #61e6 e1      
   push d                 ; #61e7 d5      
   lxi d,0x0018           ; #61e8 11 18 00
   dad d                  ; #61eb 19      
   pop d                  ; #61ec d1      
   xchg                   ; #61ed eb      
   jmp @61ca              ; #61ee c3 ca 61

@CALC_NEIGHBOURS:
   push d                 ; #61f1 d5      
   push h                 ; #61f2 e5      
   mvi c,0x00             ; #61f3 0e 00   
   mov a,m                ; #61f5 7e      
   mvi b,0x00             ; #61f6 06 00   
   cpi 0x00               ; #61f8 fe 00   
   jz @6204               ; #61fa ca 04 62
   cpi 0x20               ; #61fd fe 20   
   jz @6204               ; #61ff ca 04 62
   mvi b,0x01             ; #6202 06 01   
@6204:
   lxi d,0xffb1           ; #6204 11 b1 ff
   dad d                  ; #6207 19      
   mov a,m                ; #6208 7e      
   cpi BL_CHAR_1          ; #6209 fe 00   
   jz @6214               ; #620b ca 14 62
   cpi BL_CHAR_2          ; #620e fe 20   
   jz @6214               ; #6210 ca 14 62
   inr c                  ; #6213 0c      
@6214:
   inx h                  ; #6214 23      
   mov a,m                ; #6215 7e      
   cpi BL_CHAR_1          ; #6216 fe 00   
   jz @6221               ; #6218 ca 21 62
   cpi BL_CHAR_2          ; #621b fe 20   
   jz @6221               ; #621d ca 21 62
   inr c                  ; #6220 0c      
@6221:
   inx h                  ; #6221 23      
   mov a,m                ; #6222 7e      
   cpi BL_CHAR_1          ; #6223 fe 00   
   jz @622e               ; #6225 ca 2e 62
   cpi BL_CHAR_2          ; #6228 fe 20   
   jz @622e               ; #622a ca 2e 62
   inr c                  ; #622d 0c      
@622e:
   lxi d,0x004c           ; #622e 11 4c 00
   dad d                  ; #6231 19      
   mov a,m                ; #6232 7e      
   cpi BL_CHAR_1          ; #6233 fe 00   
   jz @623e               ; #6235 ca 3e 62
   cpi BL_CHAR_2          ; #6238 fe 20   
   jz @623e               ; #623a ca 3e 62
   inr c                  ; #623d 0c      
@623e:
   inx h                  ; #623e 23      
   inx h                  ; #623f 23      
   mov a,m                ; #6240 7e      
   cpi BL_CHAR_1          ; #6241 fe 00   
   jz @624c               ; #6243 ca 4c 62
   cpi BL_CHAR_2          ; #6246 fe 20   
   jz @624c               ; #6248 ca 4c 62
   inr c                  ; #624b 0c      
@624c:
   dad d                  ; #624c 19      
   mov a,m                ; #624d 7e      
   cpi BL_CHAR_1          ; #624e fe 00   
   jz @6259               ; #6250 ca 59 62
   cpi BL_CHAR_2          ; #6253 fe 20   
   jz @6259               ; #6255 ca 59 62
   inr c                  ; #6258 0c      
@6259:
   inx h                  ; #6259 23      
   mov a,m                ; #625a 7e      
   cpi BL_CHAR_1          ; #625b fe 00   
   jz @6266               ; #625d ca 66 62
   cpi BL_CHAR_2          ; #6260 fe 20   
   jz @6266               ; #6262 ca 66 62
   inr c                  ; #6265 0c      
@6266:
   inx h                  ; #6266 23      
   mov a,m                ; #6267 7e      
   cpi BL_CHAR_1          ; #6268 fe 00   
   jz @6273               ; #626a ca 73 62
   cpi BL_CHAR_2          ; #626d fe 20   
   jz @6273               ; #626f ca 73 62
   inr c                  ; #6272 0c      
@6273:
   mov a,c                ; #6273 79      
   pop h                  ; #6274 e1      
   pop d                  ; #6275 d1      
   ret                    ; #6276 c9      

@DELAY:
   push h                 ; #6277 e5      
   push psw               ; #6278 f5      
   lxi h,0x1388           ; #6279 21 88 13
   mvi a,0x00             ; #627c 3e 00   
@627e:
   dcx h                  ; #627e 2b      
   nop                    ; #627f 00      
   nop                    ; #6280 00      
   nop                    ; #6281 00      
   nop                    ; #6282 00      
   cmp h                  ; #6283 bc      
   jnz @627e              ; #6284 c2 7e 62
   cmp l                  ; #6287 bd      
   jnz @627e              ; #6288 c2 7e 62
   pop psw                ; #628b f1      
   pop h                  ; #628c e1      
   ret                    ; #628d c9      

@PRINT_MODE:
   push h                 ; #628e e5      
   push psw               ; #628f f5      
   lxi h,@MODE_TEXT       ; #6290 21 03 63
   call PRINT_STRING      ; #6293 cd 18 f8
   pop psw                ; #6296 f1      
   pop h                  ; #6297 e1      
   ret                    ; #6298 c9

@PRINT_GEN:
   push h                 ; #6299 e5      
   push psw               ; #629a f5      
   lxi h,@GEN_TEXT        ; #629b 21 09 63
   call PRINT_STRING      ; #629e cd 18 f8
   pop psw                ; #62a1 f1      
   pop h                  ; #62a2 e1      
   ret                    ; #62a3 c9      

@INC_GEN:
   push psw               ; #62a4 f5      
   lda @GEN4_PLACEHOLDER  ; #62a5 3a 10 63
   cpi '9'                ; #62a8 fe 39   
   jz @62b4               ; #62aa ca b4 62
   inr a                  ; #62ad 3c      
   sta @GEN4_PLACEHOLDER  ; #62ae 32 10 63
   jmp @62fe              ; #62b1 c3 fe 62
@62b4:
   mvi a,'0'              ; #62b4 3e 30   
   sta @GEN4_PLACEHOLDER  ; #62b6 32 10 63
   lda @GEN3_PLACEHOLDER  ; #62b9 3a 0f 63
   cpi '9'                ; #62bc fe 39   
   jz @62c8               ; #62be ca c8 62
   inr a                  ; #62c1 3c      
   sta @GEN3_PLACEHOLDER  ; #62c2 32 0f 63
   jmp @62fe              ; #62c5 c3 fe 62
@62c8:
   mvi a,'0'              ; #62c8 3e 30   
   sta @GEN3_PLACEHOLDER  ; #62ca 32 0f 63
   lda @GEN2_PLACEHOLDER  ; #62cd 3a 0e 63
   cpi '9'                ; #62d0 fe 39   
   jz @62dc               ; #62d2 ca dc 62
   inr a                  ; #62d5 3c      
   sta @GEN2_PLACEHOLDER  ; #62d6 32 0e 63
   jmp @62fe              ; #62d9 c3 fe 62
@62dc:
   mvi a,'0'              ; #62dc 3e 30   
   sta @GEN2_PLACEHOLDER  ; #62de 32 0e 63
   lda @GEN1_PLACEHOLDER  ; #62e1 3a 0d 63
   cpi '9'                ; #62e4 fe 39   
   jz @62f0               ; #62e6 ca f0 62
   inr a                  ; #62e9 3c      
   sta @GEN1_PLACEHOLDER  ; #62ea 32 0d 63
   jmp @62fe              ; #62ed c3 fe 62
@62f0:
   mvi a,'0'              ; #62f0 3e 30   
   sta @GEN4_PLACEHOLDER  ; #62f2 32 10 63
   sta @GEN3_PLACEHOLDER  ; #62f5 32 0f 63
   sta @GEN2_PLACEHOLDER  ; #62f8 32 0e 63
   sta @GEN1_PLACEHOLDER  ; #62fb 32 0d 63
@62fe:
   call @PRINT_GEN        ; #62fe cd 99 62
   pop psw                ; #6301 f1      
   ret                    ; #6302 c9      

@MODE_TEXT:
   .byte 0x1b,0x59,0x20,0x25 ; Y %
@MODE_PLACEHOLDER:
   .byte 'a'
   .byte 0x00

@GEN_TEXT:
   .byte 0x1b,0x59,0x20,0x27 ; Y '
@GEN1_PLACEHOLDER:
   .byte '0'
@GEN2_PLACEHOLDER:
   .byte '0'
@GEN3_PLACEHOLDER:
   .byte '4'
@GEN4_PLACEHOLDER:
   .byte '9'
   .byte 0x00

@GEN_CONTROL:
   .byte 0x00
@GEN_CONTROL_COUNT:
   .byte 0x00
@LIVE_SYM:
   .byte LIVE_CHAR        ; Символ живой клетки. 0x17 - закрашенный квадрат

@PRINT_SPLASH:
   lxi h,@SPLASH_SCREEN   ; #6315 21 72 67
   shld @SOURCE           ; #6318 22 49 63
   lxi h,0x771e           ; #631b 21 1e 77
   shld @DESTINATION      ; #631e 22 4b 63
   lxi h,0x0832           ; #6321 21 32 08
   shld @COUNT            ; #6324 22 4d 63
@6327:
   lhld @SOURCE           ; #6327 2a 49 63
   mov a,m                ; #632a 7e      
   inx h                  ; #632b 23      
   shld @SOURCE           ; #632c 22 49 63
   lhld @DESTINATION      ; #632f 2a 4b 63
   mov m,a                ; #6332 77      
   inx h                  ; #6333 23      
   shld @DESTINATION      ; #6334 22 4b 63
   lhld @COUNT            ; #6337 2a 4d 63
   dcx h                  ; #633a 2b      
   shld @COUNT            ; #633b 22 4d 63
   mvi a,0x00             ; #633e 3e 00   
   cmp h                  ; #6340 bc      
   jnz @6327              ; #6341 c2 27 63
   cmp l                  ; #6344 bd      
   jnz @6327              ; #6345 c2 27 63
   ret                    ; #6348 c9      

@SOURCE:
   .word 0x6fa4
@DESTINATION:
   .word 0x7f50
@COUNT:
   .word 0x0000

@NEED_INSTR:
   .byte 0x1B,0x59,0x37,0x2A ; Y7*
   ;.byte "instrukcii nuvny? d/n"
   .stringmap russian,"ИНСТРУКЦИИ НУЖНЫ? Д/Н"
   .byte 0x00

@INPUT_LIVE_SYM:
   .byte 0x1B,0x59,0x37,0x25 ; Y7%
   ;.byte "navmite klawi{u simwola kletki vizni:"
   .stringmap russian,"НАЖМИТЕ КЛАВИШУ СИМВОЛА КЛЕТКИ ЖИЗНИ:"
   .byte 0x00

@_CLS:
   push b                 ; #6393 c5
   push psw               ; #6394 f5
   mvi c,0x1f             ; #6395 0e 1f
   call PRINT_CHAR        ; #6397 cd 09 f8
   pop psw                ; #639a f1      
   pop b                  ; #639b c1      
   ret                    ; #639c c9      

@BEEP1:
   push psw               ; #639d f5      
   mvi a,0x06             ; #639e 3e 06   
   sta CRT_8075_CFG       ; #63a0 32 02 c0
   mvi a,0x0f             ; #63a3 3e 0f   
   sta TIM_8053_CAN2      ; #63a5 32 02 d8
   sta TIM_8053_CAN2      ; #63a8 32 02 d8
   call @DELAY            ; #63ab cd 77 62
   mvi a,0xf0             ; #63ae 3e f0   
   sta CRT_8075_CFG       ; #63b0 32 02 c0
   call @BEEP5            ; #63b3 cd 01 64
   pop psw                ; #63b6 f1      
   ret                    ; #63b7 c9      

@BEEP2:
   push psw               ; #63b8 f5      
   mvi a,0x06             ; #63b9 3e 06   
   sta CRT_8075_CFG       ; #63bb 32 02 c0
   mvi a,0x28             ; #63be 3e 28   
   sta TIM_8053_CAN2      ; #63c0 32 02 d8
   sta TIM_8053_CAN2      ; #63c3 32 02 d8
   call @DELAY            ; #63c6 cd 77 62
   mvi a,0xf0             ; #63c9 3e f0   
   sta CRT_8075_CFG       ; #63cb 32 02 c0
   call @BEEP5            ; #63ce cd 01 64
   pop psw                ; #63d1 f1      
   ret                    ; #63d2 c9      

@BEEP3:
   push psw               ; #63d3 f5      
   mvi b,0x36             ; #63d4 06 36   
   mvi a,0x37             ; #63d6 3e 37   
   sta TIM_8053_CAN2      ; #63d8 32 02 d8
   sta TIM_8053_CAN2      ; #63db 32 02 d8
   mvi a,0x06             ; #63de 3e 06   
   sta CRT_8075_CFG       ; #63e0 32 02 c0
@63e3:
   call @DELAY            ; #63e3 cd 77 62
   mov a,b                ; #63e6 78      
   sta TIM_8053_CAN2      ; #63e7 32 02 d8
   sta TIM_8053_CAN2      ; #63ea 32 02 d8
   dcr b                  ; #63ed 05      
   jnz @63e3              ; #63ee c2 e3 63
   xra a                  ; #63f1 af      
   sta CRT_8075_CFG       ; #63f2 32 02 c0
   call @BEEP5            ; #63f5 cd 01 64
   pop psw                ; #63f8 f1      
   ret                    ; #63f9 c9      

@BEEP4:
   push psw               ; #63fa f5      
   xra a                  ; #63fb af      
   sta CRT_8075_CFG       ; #63fc 32 02 c0
   pop psw                ; #63ff f1      
   ret                    ; #6400 c9      

@BEEP5:
   mvi a,0x05             ; #6401 3e 05   
   sta TIM_8053_CAN2      ; #6403 32 02 d8
   sta TIM_8053_CAN2      ; #6406 32 02 d8
   ret                    ; #6409 c9      

@HELP_TEXT:
   .byte 0x0c,0x0a ; CLS, LF
   ;.byte " 1. sosedqmi kletki s~ita`tsq kletki, nahodq}iesq w"
   .stringmap russian," 1. СОСЕДЯМИ КЛЕТКИ СЧИТАЮТСЯ КЛЕТКИ, НАХОДЯЩИЕСЯ В"
   .byte 0x0a,0x0d
   ;.byte "    wosxmi q~ejkah, raspolovennyh rqdom s dannoj"
   .stringmap russian,"    ВОСЬМИ ЯЧЕЙКАХ, РАСПОЛОЖЕННЫХ РЯДОМ С ДАННОЙ"
   .byte 0x0a,0x0d
   ;.byte "    po gorizontali, wertikali ili diagonali."
   .stringmap russian,"    ПО ГОРИЗОНТАЛИ, ВЕРТИКАЛИ ИЛИ ДИАГОНАЛИ."
   .byte 0x0a,0x0d
   ;.byte " 2. esli u nekotoroj kletki menx{e dwuh sosedej,"
   .stringmap russian," 2. ЕСЛИ У НЕКОТОРОЙ КЛЕТКИ МЕНЬШЕ ДВУХ СОСЕДЕЙ,"
   .byte 0x0a,0x0d
   ;.byte "    ona pogibaet ot odino~estwa. esli kletka imeet bolx{e"
   .stringmap russian,"    ОНА ПОГИБАЕТ ОТ ОДИНОЧЕСТВА. ЕСЛИ КЛЕТКА ИМЕЕТ БОЛЬШЕ"
   .byte 0x0a,0x0d
   ;.byte "    treh sosedej, ona pogibaet ot tesnoty. esli rqdom s"
   .stringmap russian,"    ТРЕХ СОСЕДЕЙ, ОНА ПОГИБАЕТ ОТ ТЕСНОТЫ. ЕСЛИ РЯДОМ С"
   .byte 0x0a,0x0d
   ;.byte "    pustoj q~ejkoj okavetsq rowno tri sosednie kletki"
   .stringmap russian,"    ПУСТОЙ ЯЧЕЙКОЙ ОКАЖЕТСЯ РОВНО ТРИ СОСЕДНИЕ КЛЕТКИ"
   .byte 0x0a,0x0d
   ;.byte "    vizni, to w |toj q~ejke rovdaetsq nowaq kletka"
   .stringmap russian,"    ЖИЗНИ, ТО В ЭТОЙ ЯЧЕЙКЕ РОЖДАЕТСЯ НОВАЯ КЛЕТКА"
   .byte 0x0a,0x0d
   ;.byte "           ***rabota s programmoj***"
   .stringmap russian,"           ***РАБОТА С ПРОГРАММОЙ***"
   .byte 0x0a,0x0d
   ;.byte " r-ru~noj revim;"
   .stringmap russian," Р-РУЧНОЙ РЕЖИМ;"
   .byte 0x0a,0x0d
   ;.byte " a-awtomati~eskij revim;"
   .stringmap russian," А-АВТОМАТИЧЕСКИЙ РЕЖИМ;"
   .byte 0x0a,0x0d
   ;.byte " wk-pusk;"
   .stringmap russian," ВК-ПУСК;"
   .byte 0x0a,0x0d
   ;.byte " str-o~istka polq;"
   .stringmap russian," СТР-ОЧИСТКА ПОЛЯ;"
   .byte 0x0a,0x0d
   ;.byte " k-perezapusk programmy;"
   .stringmap russian," К-ПЕРЕЗАПУСК ПРОГРАММЫ;"
   .byte 0x0a,0x0d
   ;.byte " -dlq ostanowki programmy w awtomati~eskom revime"
   .stringmap russian," -ДЛЯ ОСТАНОВКИ ПРОГРАММЫ В АВТОМАТИЧЕСКОМ РЕЖИМЕ"
   .byte 0x0a,0x0d
   ;.byte "  nado navatx l`bu` klawi{u uprawleniq kursorom;"
   .stringmap russian,"  НАДО НАЖАТЬ ЛЮБУЮ КЛАВИШУ УПРАВЛЕНИЯ КУРСОРОМ;"
   .byte 0x0a,0x0d
   ;.byte " -konfiguraci` kletok movno nabiratx l`bymi simwolami;"
   .stringmap russian," -КОНФИГУРАЦИЮ КЛЕТОК МОЖНО НАБИРАТЬ ЛЮБЫМИ СИМВОЛАМИ;"
   .byte 0x0a,0x0d
   ;.byte " -w hode raboty programmy movno wru~nu` menqtx kartinku;"
   .stringmap russian," -В ХОДЕ РАБОТЫ ПРОГРАММЫ МОЖНО ВРУЧНУЮ МЕНЯТЬ КАРТИНКУ;"
   .byte 0x0a,0x0d
   ;.byte " -revim i nomer pokoleniq indiciru`tsq wwerhu |krana."
   .stringmap russian," -РЕЖИМ И НОМЕР ПОКОЛЕНИЯ ИНДИЦИРУЮТСЯ ВВЕРХУ ЭКРАНА."
   .byte 0x0a,0x0d
   ;.byte "            ***navmite l`bu` klawi{u***"
   .stringmap russian,"            ***НАЖМИТЕ ЛЮБУЮ КЛАВИШУ***"
@SPLASH_SCREEN:        ;123456789012345678901234567890123456789012345678901234567890123456789012345678
   .stringmap pseudo_g,".............................................................................."
   .stringmap pseudo_g,".........,________________________________________________________............"
   .stringmap pseudo_g,".........|...................,__________.........................|............"
   .stringmap pseudo_g,".........|..................,`..........\........................|............"
   .stringmap pseudo_g,".........|.........,..,..,.,`.[.[,^\.Г^a.\..a..a..a..............|............"
   .stringmap pseudo_g,".........|........'J/'J/'J/L_[\,`|...[.[L_L\L`\L`\L`.............|............"
   .stringmap pseudo_g,".........|........'|''|''|'\.`||.|...Г^.`,``[``[``[`.............|............"
   .stringmap pseudo_g,".........|..................\..[.'_/.[..,`.......................|............"
   .stringmap pseudo_g,".........|...................\.........,`........................|............"
   .stringmap pseudo_g,".........|....................^^^^^^^^^`.........................|............"
   .stringmap pseudo_g,".........|.......|^-|^\|^^./[,^\'-^./a|^\.,-,^-|^^'-^._..........|............"
   .stringmap pseudo_g,".........|.......|.||.||_a.[[|...|.|.||_/.[||.||_a.|..^..........|............"
   .stringmap pseudo_g,".........|.......|.||^`|...[[|...|.|^-|.|.[|.--|...|.._..........|............"
   .stringmap pseudo_g,".........|.......|.||..|__|^-'_/.|.|.||_/,`|,`||__.|..^..........|............"
   .stringmap pseudo_g,".........|.............,__,_a._a,__,_a.,.,.,,.,.,................|............"
   .stringmap pseudo_g,".........|.............|.||.||.||.'|.|,`\|\-|\-,`\...............|............"
   .stringmap pseudo_g,".........|.............|.||_/|.||..|_/|_J|'||'||_J...............|............"
   .stringmap pseudo_g,".........|.............|.||..|.||..|..|.||.||.||.|...............|............"
   .stringmap pseudo_g,".........|.............'.''...^`'..'..'.''.''.''.'...............|............"
   .stringmap pseudo_g,".........|...................[...-`.Г^`|^^.......................|............"
   .stringmap pseudo_g,".........|.........,|,,|,,|,.[...|..[..|_a.a[aa[aa[a.............|............"
   .stringmap pseudo_g,".........|.........,-\,-\,-\.[...|..Г^.|.../Гa/Гa/Гa.............|............"
   .stringmap pseudo_g,".........|..........'..'..'..L_[.Ja.[..|__..`..`..`..............|............"
   .stringmap pseudo_g,".........|.......................................................|............"
   .stringmap pseudo_g,".........|.......................................................|............"
   .stringmap pseudo_g,".........|.......................................................|............"
   .stringmap pseudo_g,"....."
_SYNCHRO:
   .byte 0xe6
_CHECKSUM:
   .byte 0xbf,0xbd

.ENDS
