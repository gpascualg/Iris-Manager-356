/*
 * payload_sky.S -- Adds system call 36 and 8 code on custom firmware
 * 
 * It contains hermes, pl3 and psgroove parts of code
 */

#include "firmware_symbols.h"

#define BASE        0xEF40
#define PATHSTR_LEN    0x9
#define ABS(target) ((target) - (BASE) - .)

// Dynamic macros to load a label into a register
#define MEM_BASE(dest) \
    li dest, 1; \
    rldicr dest, dest, 63, 0;
#define LOAD_LABEL(base, dest, source, address) \
    oris    dest, source, ((base) + (address))@h; \
    ori    dest, dest, ((base) + (address))@l;
#define LOAD_LABEL2(dest, source, address) \
    LOAD_LABEL(BASE, dest, source, address)
#define LOADI_LABEL2(dest, address) \
    LOAD_LABEL2(dest, dest, address)

.org 0

save_our_souls:
    rldicl  %r6, %r3, 1,63
    .long 0x4BFFFFB8
return1_h4:
    li      %r3, 1
    blr
.org 0x10
    .byte 'S', 'K', '1','0'

.org 0x30
syscall36_map_dvd:
    stdu    %sp, -0xD0(%sp)
    mflr    %r0
    std    %r0, 0xE0(%sp)
    std    %r31, 0xC8(%sp)
    addi    %r4, %sp, 0x70
    bl    ABS(pathdup_from_user) // strdup %r3 from userspace and store the new pointer into %r1[0x70]
    MEM_BASE(%r31)
    LOADI_LABEL2(%r31, buffer)
    ld    %r3, 0(%r31)
    cmpdi    %r3, 0 // if game_path != NULL: free(game_path)
    beq    l_game_path_null
    li    %r4, 0x27
    bl    ABS(free)

l_game_path_null:
    li    %r4, 0x27
    li    %r3, 0x800
    bl    ABS(alloc)    // alloc (2048)
    std    %r3, 0(%r31)
    ld    %r4, 0x70(%sp)
    bl    ABS(strcpy)
    ld    %r3, 0x70(%sp)
    li    %r4, 0x27
    bl    ABS(free)
    ld    %r3, 0(%r31)
    bl    ABS(strlen)
    ld    %r4, 0(%r31)
    add    %r3, %r4, %r3
    std    %r3, 8(%r31)
    li    %r3, 0    // return 0
    ld    %r31, 0xC8(%sp)
    ld    %r0, 0xE0(%sp)
    addi    %sp, %sp, 0xD0
    mtlr    %r0
    blr

buffer:
.org 0xD0
    .long 0x80000000
    .long BASE + syscall36_map_dvd

.org 0x28C    
    nop
    nop
    nop
.org 0x298 # If you change that you also need to change the jump in patch.txt
open_hook:
#if 0
    stdu    %sp, -0xA0(%sp)
    mflr    %r0
    std    %r28, 0x80(%sp)
    std    %r29, 0x88(%sp)
    std    %r31, 0x98(%sp)
    std    %r26, 0x70(%sp)
    std    %r27, 0x78(%sp)
    std    %r0, 0xB0(%sp)
    mr    %r28, %r4
#endif
//overwriten by the jump :D
    mr    %r29, %r3

check_path_dvd:
//start new code
    MEM_BASE(%r31)
    LOAD_LABEL2(%r4, %r31, aDev_bdvd)
    li    %r5, PATHSTR_LEN
    bl    ABS(strncmp)
    cmpldi    %r3, 0
    //b return_org_open_func //exit now test 2
    bne    check_path_app //if not bdvd check app_home
    LOADI_LABEL2(%r31, buffer)

    ld    %r3, 0(%r31)
    cmpldi    %r3, 0
    beq    return_org_open_func //if null exit
    ld    %r3, 8(%r31)  //buffer + 1? save len?
    addi    %r4, %r29, PATHSTR_LEN
    bl    ABS(strcpy)
    ld    %r29, 0(%r31)
    b     return_org_open_func //process finished ok, go out now :D

check_path_app:
    mr    %r3, %r29
    MEM_BASE(%r31)
    LOAD_LABEL2(%r4, %r31, aApp_home)
    li    %r5, PATHSTR_LEN
    bl    ABS(strncmp)
    cmpldi    %r3, 0
    bne    return_org_open_func
    LOADI_LABEL2(%r31, buffer)

    ld    %r3, 0(%r31)
    cmpldi    %r3, 0
    beq    return_org_open_func //if null exit
    ld    %r3, 8(%r31)  //buffer + 1? save len?
    addi    %r4, %r29, PATHSTR_LEN
    bl    ABS(strcpy)
    ld    %r29, 0(%r31)

return_org_open_func:
    mr    %r3, %r29
    b    ABS(memory_patch_func)

aDev_bdvd:    .string    "/dev_bdvd"
aApp_home:    .string    "/app_home"

.org 0x5B8
// next lv2 code
//    stdu    %sp, -0x80(%sp)