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
#include "includes.h"
//#include "altera_avalon_pio_regs.h"

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    task1_stk[TASK_STACKSIZE];
OS_STK    task2_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK1_PRIORITY      1
#define TASK2_PRIORITY      2

/* Message Queue */
//INT16U QMESSAGE_SIZE = 50;
#define QMESSAGE_SIZE 20
OS_EVENT* qsemMsg;
void *qMessages[QMESSAGE_SIZE];

void task1(void* pdata) {
	FILE* fp_uart;
	fp_uart = fopen(UART_0_NAME, "r");
	INT8U err;
	int* msg;
	while (1) {
		msg = (int*) malloc(sizeof(int));
		*msg = fgetc(fp_uart);
		if (*msg != 254) {
			err = OSQPost(qsemMsg, (void*) msg);
			if (err == OS_Q_FULL)
				printf("Q Full\n");
		}
		OSTimeDlyHMSM(0, 0, 0, 5);
	}
}

void task2(void* pdata) {
	FILE* fp_lcd;
	fp_lcd = fopen(CHAR_LCD_NAME, "w");
	INT8U err;
	INT8U* msg;
	INT8U* msg2;
	INT8U* msg3;
	int hi4, lo4;

	INT32U* note_0 = (INT32U*) NOTE_0_BASE;
	INT32U blah = 0;

	while (1) {
		//Clear the messages
		hi4 =0;
		lo4 = 0;
//		*msg = *msg2 = *msg3 = 0;

		msg = (int*) OSQPend(qsemMsg, 0, &err);
		if (err == OS_TIMEOUT)
			printf("Q Timeout\n");
		else if (err == OS_ERR_PEND_ISR)
			printf("Q Pend in ISR\n");

//		printf("%i\n", *msg);
		lo4 = *msg & 15;
		hi4 = *msg >> 4;
		switch(hi4) {
			case 9:
//				printf("Note On, Channel %i ", lo4);
				msg2 = (INT8U*) OSQPend(qsemMsg, 0, &err);
//				printf(" Note: %i ", *msg2);
				msg3 = (INT8U*) OSQPend(qsemMsg, 0, &err);
//				printf(" Velocity: %i\n", *msg3);
				blah = (*msg3 << 12) | *msg2;
				*note_0 = blah;
//				printf("%X", blah);
//				printf("%X", *note_0);
				break;
			case 8:
//				printf("Note Off, Channel %i ", lo4);
				msg2 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Note: %i ", *msg2);
				msg3 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Velocity: %i\n", *msg3);
				break;
			case 10:
//				printf("After Touch, Channel %i ", lo4);
				msg2 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Note: %i ", *msg2);
				msg3 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Pressure: %i\n", *msg3);
				break;
			case 11:
//				printf("Control Change, Channel %i", lo4);
				msg2 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Controller: %i ", *msg2);
				msg3 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Value: %i\n", *msg3);
				break;
			case 13:
//				printf("After-Touch, Channel %i", lo4);
				msg2 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Pressure: %i\n", *msg2);
				break;
			case 15:
//				printf("Channel Mode Message, Channel %i", lo4);
				msg2 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Controller: %i ", *msg2);
				msg3 = (int*) OSQPend(qsemMsg, 0, &err);
//				printf(" Value: %i\n", *msg3);
				break;
			default:
				break;
		}

		free(msg);
		free(msg2);
		free(msg3);
  }
}

int alt_irq_register(alt_u32 id, void * context, void (*isr)(void *, alt_u32) );

/* The main function creates two task and starts multi-tasking */
int main(void) {
	OSInit();
	// Create the message queue to hold incoming MIDI msg
	qsemMsg = OSQCreate((void*)&qMessages, QMESSAGE_SIZE);
  
	//Task for storing incoming MIDI messages
	OSTaskCreateExt(task1,
				  NULL,
				  (void *)&task1_stk[TASK_STACKSIZE-1],
				  TASK1_PRIORITY,
				  TASK1_PRIORITY,
				  task1_stk,
				  TASK_STACKSIZE,
				  NULL,
				  0);


	//Task for decoding MIDI messages.
	OSTaskCreateExt(task2,
				  NULL,
				  (void *)&task2_stk[TASK_STACKSIZE-1],
				  TASK2_PRIORITY,
				  TASK2_PRIORITY,
				  task2_stk,
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
