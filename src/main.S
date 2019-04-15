.syntax unified
.global main

.type main, %function
main:
  bl init
  ldr r6,=#24000 //set r6 = 12000, 12000 = 48000*0.25

loop:
  bl sequence_do_initial
  bl sound_pause
  bl sequence_fa_initial
  bl sound_pause
  bl sequence_do_initial
  bl sound_pause
  bl sequence_so_initial
  bl sound_pause
  bl sequence_do_initial
  bl sound_pause
  b loop

sequence_do_initial:
  str lr,[sp,#-4]!
  mov r10,#0 
  mov r11,#0 
  b sequence_do

sequence_do:
  bl sequence_do_1 
  bl sequence_do_2
  b sequence_do

sequence_do_1: 
  str lr,[sp,#-4]!
  mov r4,#56 
  mov r5,#6
  b sequence_up_initial

sequence_do_2: 
  str lr,[sp,#-4]!
  mov r4,#55
  mov r5,#5
  b sequence_up_initial

sequence_fa_initial:
  str lr,[sp,#-4]!
  mov r10,#0 
  mov r11,#0 
  b sequence_fa

sequence_fa:
  bl sequence_fa_1 
  bl sequence_fa_2
  b sequence_fa

sequence_fa_1: 
  str lr,[sp,#-4]!
  mov r4,#42 
  mov r5,#760
  b sequence_up_initial

sequence_fa_2: 
  str lr,[sp,#-4]!
  mov r4,#41
  mov r5,#81
  b sequence_up_initial

sequence_so_initial:
  str lr,[sp,#-4]!
  mov r10,#0 
  mov r11,#0 
  b sequence_so

sequence_so:
  bl sequence_so_1 
  bl sequence_so_2
  b sequence_so

sequence_so_1: 
  str lr,[sp,#-4]!
  mov r4,#38 
  mov r5,#396
  b sequence_up_initial

sequence_so_2: 
  str lr,[sp,#-4]!
  mov r4,#37
  mov r5,#593
  b sequence_up_initial

branch_to_sequence:
  ldr lr,[sp],#4
  bx lr
@ for this part, if r11 equals r5 then branch to sequence
branch_to_loop:
  mov r7,#0
  mov r9,#0   //initialize r7,r9
  add sp,#4 //first sp= sp+4 
  ldr lr,[sp],#4 //then get the value lr in the address of sp and sp +4
  bx lr
@ for this part, if r10 counter equals 12000 or 24000 then it will jump back to the loop
sequence_up_initial:
  mov r7, #0 //inital r7 = 0 counter r7 which is how many times bl to the autio
  mov r9, #0 //inital r9 = 0 counter r9 which is how much time to move from up to downside
  b sequence_up

sequence_up:
  ldr r0,=0x5F00
  bl BSP_AUDIO_OUT_Play_Sample
  add r10,#1
  cmp r10,r6
  beq branch_to_loop
  add r7,#1
  cmp r7,r4
  beq sequence_down_initial 
  b sequence_up

sequence_down_initial:
  mov r7, #0
  mov r9, #0 
  b sequence_down

sequence_down:
  ldr r0,=0xA0FF
  bl BSP_AUDIO_OUT_Play_Sample
  add r10,#1
  cmp r10,r6
  beq branch_to_loop
  add r7,#1
  cmp r7,r4
  beq loop_n_times  
  b sequence_down

loop_n_times:
  add r11,#1
  cmp r11,r5 
  beq branch_to_sequence
  b sequence_up_initial

sound_pause:
  str lr,[sp,#-4]!
  b no_music

no_music:
  movs r0,0
  bl BSP_AUDIO_OUT_Play_Sample
  add r9,#1
  cmp r9,r6
  beq branch_to_sequence
  b no_music

.size main, .-main
