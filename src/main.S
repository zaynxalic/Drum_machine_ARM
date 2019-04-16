.syntax unified
.global main

.type main, %function
main:
  bl init
  ldr r7,=#24000
  mov r0,r7
  str r0,[sp,#-4]!

loop:
  ldr r7,=#24000
  bl node_do
  bl sound_pause
  ldr r7,=#12000
  bl node_fa_change_initial
  bl sound_pause
  bl change_time
  bl node_do
  bl sound_pause
  ldr r7,=#24000
  bl node_so
  bl sound_pause
  b loop

change_time://change the r0
  ldr r0,[sp],#4
  subs r0,#1000
  beq initial_time
  movs r7,r0
  str r0,[sp,#-4]!
  bx lr

initial_time:
  mov r0,r7
  str r0,[sp,#-4]!
  bx lr

node_do:
  str lr,[sp,#-4]!
  mov r6,#55  //set the frequency 48000/440/2 hz
  b sequence_up_initial

node_fa_change_initial:
  str lr,[sp,#-4]!

node_fa_initial:
  mov r6,#40 //set the frequency 48000/587.33/2 hz
  b node_fa_change

node_fa_change:
  add r6,#1
  cmp r6,#55
  beq node_fa_initial
  b sequence_up_initial

node_so:
  str lr,[sp,#-4]!
  mov r6,#36 //set the frequency 48000/659.33/2 hz
  b sequence_up_initial

branch_to_loop:
  mov r5,#0
  ldr lr,[sp],#4
  bx lr

sequence_up_initial:
  mov r4,#0
  b sequence_up

sequence_up:
  ldr r0,=0x5F00
  bl BSP_AUDIO_OUT_Play_Sample
  add r5,#1
  cmp r5,r7
  beq branch_to_loop
  add r4,#1
  cmp r4,r6
  beq sequence_down_initial
  b sequence_up

sequence_down_initial:
  mov r4,#0
  b sequence_down

sequence_down:
  ldr r0,=0xA0FF
  bl BSP_AUDIO_OUT_Play_Sample
  add r5,#1
  cmp r5,r7
  beq branch_to_loop
  add r4,#1
  cmp r4,r6
  beq sequence_up_initial
  b sequence_down

sound_pause:
  str lr,[sp,#-4]!
  b no_music

no_music:
  movs r0,0
  bl BSP_AUDIO_OUT_Play_Sample
  add r5,#1
  cmp r5,r7
  beq branch_to_loop
  b no_music


.size main, .-main
