/*************************************************************************
* Copyright (c) 2004 Altera Corporation, San Jose, California, USA.      *
* All rights reserved. All use of this software and documentation is     *
* subject to the License Agreement located at the end of this file below.*
**************************************************************************
* Description:                                                           *
* The following is a simple hello world program running MicroC/OS-II.The * 
* purpose of the design is to be a very simple application that just     *
* demonstrates MicroC/OS-II running on NIOS II.The design doesn't account*
* for issues such as checking system call return codes. etc.             *
*                                                                        *
* Requirements:                                                          *
*   -Supported Example Hardware Platforms                                *
*     Standard                                                           *
*     Full Featured                                                      *
*     Low Cost                                                           *
*   -Supported Development Boards                                        *
*     Nios II Development Board, Stratix II Edition                      *
*     Nios Development Board, Stratix Professional Edition               *
*     Nios Development Board, Stratix Edition                            *
*     Nios Development Board, Cyclone Edition                            *
*   -System Library Settings                                             *
*     RTOS Type - MicroC/OS-II                                           *
*     Periodic System Timer                                              *
*   -Know Issues                                                         *
*     If this design is run on the ISS, terminal output will take several*
*     minutes per iteration.                                             *
**************************************************************************/


#include <stdio.h>
#include <malloc.h>
#include <sys/alt_irq.h>
#include "includes.h"

#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart.h"
#include "altera_avalon_uart_regs.h"

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    midi_stk[TASK_STACKSIZE];
OS_STK    song_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define MIDI_PRIORITY      2
#define SONG_PRIORITY      3

#define TOP_LINE    "[1;0H"
#define BOTTOM_LINE "[2;0H"
#define LCD_CLR "[2J"
static unsigned char esc = 0x1b;

/* Message Queue */
//INT16U QMESSAGE_SIZE = 50;
#define QMESSAGE_SIZE 20
OS_EVENT* qsemMsg;
OS_EVENT* songSem;
FILE * lcd;

void *qMessages[QMESSAGE_SIZE];


INT32U* note_table[] = {(INT32U*) NOTE_0_BASE,
                        (INT32U*) NOTE_1_BASE,
                        (INT32U*) NOTE_2_BASE,
                        (INT32U*) NOTE_3_BASE,
                        (INT32U*) NOTE_4_BASE,
                        (INT32U*) NOTE_5_BASE};

#define NOTE_MASK 255
#define VELOCITY_MASK 1048320

static void serial_irq_0(void* context, alt_u32 id)
{
    unsigned int stat;
    INT8U chr;

    //get serial status
    stat = IORD_ALTERA_AVALON_UART_STATUS(UART_0_BASE);

    //character Rx
    if (stat & ALTERA_AVALON_UART_STATUS_RRDY_MSK) {
        chr = IORD_ALTERA_AVALON_UART_RXDATA(UART_0_BASE);
        IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE, 0);
        if (chr != 254) {
            OSQPost(qsemMsg, (void*) chr);
        }
    }
    IOWR_ALTERA_AVALON_UART_STATUS(UART_0_BASE, 0);
}

void serial_init(unsigned int baud)
{
    //inhibit all UART IRQ sources
    IOWR(UART_0_BASE, 3, 0x00);
    
    //set Baud rate
    IOWR(UART_0_BASE, 4, baud);
    
    //flush any characters sitting in the holding register
    IORD(UART_0_BASE, 0);
    IORD(UART_0_BASE, 0);
    //reset most of the status register bits
    IOWR(UART_0_BASE, 2, 0x00);
    //install IRQ service routine
    alt_irq_register(UART_0_IRQ, 0, serial_irq_0);
    alt_irq_enable(UART_0_IRQ);
    //enable irq for Rx.
    IOWR(UART_0_BASE, 3, 0x0080);
}

void midiDecode(void* pdata) {

    INT8U err;
    INT8U msg;
    INT8U msg2;
    INT8U msg3;
    int hi4, lo4;

    while (1) {
        //Clear the messages
        hi4 =0;
        lo4 = 0;
//      *msg = *msg2 = *msg3 = 0;

        msg = (INT8U) OSQPend(qsemMsg, 0, &err);
        if (err == OS_TIMEOUT)
            printf("Q Timeout\n");
        else if (err == OS_ERR_PEND_ISR)
            printf("Q Pend in ISR\n");

        //printf("%i\n", msg);
        lo4 = msg & 15;
        hi4 = msg >> 4;
        switch(hi4) {
            case 9:
                while(1){
                    //printf("Note On, Channel %i ", lo4);
                    msg2 = (INT8U) OSQPend(qsemMsg, 0, &err);
                    //printf("Note %i On with ", msg2);
                    if (msg2 > 127){
                        OSQPostFront(qsemMsg, (void*) msg2);
                        break;
                    }
                    msg3 = (INT8U) OSQPend(qsemMsg, 0, &err);
                    //printf(" Velocity = %i\n", msg3);
              
                    if (msg3 == 0){
                        int i;
                        for (i = 0; i < 6; i++){
                            if ((*note_table[i] & NOTE_MASK) == msg2){
                                *note_table[i] = *note_table[i] & NOTE_MASK;
                                //printf("%d\n", *note_table[i]);
                            }
                        }
                    }else{
                        int i;
                        for (i = 0; i < 6; i++){
                            // printf("%X\n", *note_table[i]);
                            if ((*note_table[i] & VELOCITY_MASK) == 0){
                                *note_table[i] = (msg3 << 12) | msg2;
                                break;
                            }
                        } 
                    }
                }
                break;
            case 8:
                //printf("Note Off, Channel %i ", lo4);
                msg2 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Note: %i ", msg2);
                msg3 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Velocity: %i\n", msg3);
                break;
            case 10:
              //printf("After Touch, Channel %i ", lo4);
                msg2 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Note: %i ", msg2);
                msg3 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Pressure: %i\n", msg3);
                break;
            case 11:
              //printf("Control Change, Channel %i", lo4);
                msg2 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Controller: %i ", msg2);
                msg3 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Value: %i\n", msg3);
                if(msg2 == 123){
                    int i;
                    for (i=0;i<6;i++){
                        *note_table[i] = 0;
                    }   
                }
                break;
            case 13:
              //printf("After-Touch, Channel %i", lo4);
                msg2 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Pressure: %i\n", msg2);
                break;
            case 15:
              //printf("Channel Mode Message, Channel %i", lo4);
                msg2 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Controller: %i ", msg2);
                msg3 = (INT8U) OSQPend(qsemMsg, 0, &err);
              //printf(" Value: %i\n", msg3);
                break;
            default:
                break;
        }
  }
}

void playSong(void* pdata)
{
    
    fprintf(lcd, "%c%s", esc, LCD_CLR);
    fprintf(lcd, "%c%s%s\n", esc, TOP_LINE, "KEYBOARD MODE");
    fprintf(lcd, "%c%s%s\n", esc, BOTTOM_LINE, "KEYBOARD MODE");
    
    while (1)
    {
    INT8U err;
    OSSemPend(songSem,0,&err);
    fprintf(lcd, "%c%s", esc, LCD_CLR);
    fprintf(lcd, "%c%s%s\n", esc, TOP_LINE, "NOW PLAYING TETRIS THEME A");
    fprintf(lcd, "%c%s%s\n", esc, BOTTOM_LINE, "NOW PLAYING TETRIS THEME A");
    
    INT8U value = IORD_ALTERA_AVALON_PIO_DATA(SWITCHES_BASE);
    
    if (value & 1)
    {
    if (err==OS_ERR_PEVENT_NULL){
        printf("PEVENT NULL");
    }
    if (err==OS_ERR_EVENT_TYPE){
        printf("EVENT TYPE");
    }
    if (err) printf("%d, %d", err, OS_NO_ERR);
    int note0[] = { 71,-1,68,69,71,-1,69,67,
                    64,-1,64,69,72,-1,71,69,
                    68,-1,-1,69,71,-1,72,-1,
                    69,-1,64,-1,64,-1,-1,-1,
                    0,65,-1,69,72,-1,71,69,
                    67,-1,-1,64,67,-1,65,64,
                    68,-1,-1,69,71,-1,72,-1,
                    69,-1,64,-1,64,-1,0,0   };   
    int note1[] = { 76,-1,76,72,74,-1,72,71,
                    69,-1,69,72,76,-1,74,72,
                    71,-1,-1,72,74,-1,76,-1,
                    72,-1,69,-1,69,-1,-1,-1,
                    0,74,-1,77,81,-1,79,77,
                    76,-1,-1,72,76,-1,74,72,
                    71,-1,-1,72,74,-1,76,-1,
                    72,-1,69,-1,69,-1,0,0};  
    int i;
    for (i=0;i<64;i++){
        if (note0[i] == -1){
            //do nothing
        }else if (note0[i] == 0){
            *note_table[0] = 0;   
        }else{
            *note_table[0] = (120 << 12) | (INT8U) note0[i];
        }
        if (note1[i] == -1){
            //do nothing
        }else if (note1[i] == 0){
            *note_table[1] = 0;   
        }else{
            *note_table[1] = (120 << 12) | (INT8U) note1[i];
        }
        OSTimeDlyHMSM(0, 0, 0, 250);
    }
    for (i=0;i<64;i++){
        if (note0[i] == -1){
            //do nothing
        }else if (note0[i] == 0){
            *note_table[0] = 0;   
        }else{
            *note_table[0] = (120 << 12) | (INT8U) note0[i];
        }
        if (note1[i] == -1){
            //do nothing
        }else if (note1[i] == 0){
            *note_table[1] = 0;   
        }else{
            *note_table[1] = (120 << 12) | (INT8U) note1[i];
        }
        OSTimeDlyHMSM(0, 0, 0, 250);
    }
    }
    
    fprintf(lcd, "%c%s", esc, LCD_CLR);
    fprintf(lcd, "%c%s%s\n", esc, TOP_LINE, "KEYBOARD MODE");
    fprintf(lcd, "%c%s%s\n", esc, BOTTOM_LINE, "KEYBOARD MODE");
    
    OSSemPend(songSem,0,&err);
    fprintf(lcd, "%c%s%s\n", esc, TOP_LINE, "NOW PLAYING STAIRWAY TO HEAVEN");
    fprintf(lcd, "%c%s%s\n", esc, BOTTOM_LINE, "NOW PLAYING STAIRWAY TO HEAVEN");
    
    if (value & 1)
    {
    if (err==OS_ERR_PEVENT_NULL){
        printf("PEVENT NULL");
    }
    if (err==OS_ERR_EVENT_TYPE){
        printf("EVENT TYPE");
    }
    if (err) printf("%d, %d", err, OS_NO_ERR);
    int note0[] = {0,60,64,69,71,64,60,71,
                    72,64,60,72,66,62,57,66,
                    64,60,57,60,-1,64,60,57,
                    55,57,57,-1,-1,-1,0,0,
                    0,60,64,69,71,64,60,71,
                    72,64,60,72,66,62,57,66,
                    64,60,57,60,-1,64,60,57,
                    55,57,57,-1,-1,-1,0,0,
                    -1,52,55,64,66,62,57,65,
                    64,60,57,64,62,60,-1,-1,
                    60,55,52,60,67,59,55,67,
                    57,57,57,-1,-1,-1,0,0};   
    int note1[] = {57,-1,-1,-1,56,-1,-1,-1,
                    55,-1,-1,-1,54,-1,-1,-1,
                    53,-1,-1,-1,-1,-1,-1,-1,
                    47,45,45,-1,-1,45,53,52,
                    45,-1,-1,-1,56,-1,-1,-1,
                    55,-1,-1,-1,54,-1,-1,-1,
                    53,-1,-1,-1,-1,-1,-1,-1,
                    47,45,45,-1,-1,-1,45,47,
                    48,-1,-1,-1,50,-1,-1,-1,
                    53,-1,-1,-1,45,-1,45,47,
                    48,-1,-1,-1,43,-1,-1,-1,
                    50,50,50,-1,-1,-1,0,0};  
    int i;
    for (i=0;i<96;i++){
        if (note0[i] == -1){
            //do nothing
        }else if (note0[i] == 0){
            *note_table[0] = 0;   
        }else{
            *note_table[0] = (120 << 12) | (INT8U) note0[i];
        }
        if (note1[i] == -1){
            //do nothing
        }else if (note1[i] == 0){
            *note_table[1] = 0;   
        }else{
            *note_table[1] = (120 << 12) | (INT8U) note1[i];
        }
        OSTimeDlyHMSM(0, 0, 0, 600);
    }
    }
    fprintf(lcd, "%c%s", esc, LCD_CLR);
    fprintf(lcd, "%c%s%s\n", esc, TOP_LINE, "KEYBOARD MODE");
    fprintf(lcd, "%c%s%s\n", esc, BOTTOM_LINE, "KEYBOARD MODE");
    }
}

static void switches_isr(void* context, alt_u32 id){
    INT8U value = IORD_ALTERA_AVALON_PIO_DATA(SWITCHES_BASE);
    if (value & 1){
        OSSemPost(songSem);
    }
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(SWITCHES_BASE, 0);
}

/* The main function creates two task and starts multi-tasking */
int main(void) {
    OSInit();
    
    // Create the message queue to hold incoming MIDI msg
    qsemMsg = OSQCreate((void*)&qMessages, QMESSAGE_SIZE);
    songSem = OSSemCreate(0);
    lcd = fopen("/dev/char_lcd", "w");
    

    //Task for decoding MIDI messages.
    OSTaskCreateExt(midiDecode,
                  NULL,
                  (void *)&midi_stk[TASK_STACKSIZE-1],
                  MIDI_PRIORITY,
                  MIDI_PRIORITY,
                  midi_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);
    serial_init(31250);
    /* Enable all 8 switch interrupts. */
    IOWR_ALTERA_AVALON_PIO_IRQ_MASK(SWITCHES_BASE, 0xff);
    /* Reset the edge capture register. */
    IOWR_ALTERA_AVALON_PIO_EDGE_CAP(SWITCHES_BASE, 0x0);
    /* Register the interrupt handler. */
    alt_irq_register(SWITCHES_IRQ, 0, switches_isr);
    alt_irq_enable(SWITCHES_IRQ);

    OSTaskCreateExt(playSong,
                  NULL,
                  (void *)&song_stk[TASK_STACKSIZE-1],
                  SONG_PRIORITY,
                  SONG_PRIORITY,
                  song_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);           

                  
  OSStart();
  return 0;
}

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2004 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/
