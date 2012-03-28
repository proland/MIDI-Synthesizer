/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'cpu_0' in SOPC Builder design 'SOPC_File'
 * SOPC Builder design path: C:/Users/Kyle/Desktop/MIDI-Synth/Audio_Codec_G2/SOPC_File.sopcinfo
 *
 * Generated: Mon Mar 26 17:42:57 MDT 2012
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x1004820
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x0
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x19
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x1002020
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x19
#define ALT_CPU_NAME "cpu_0"
#define ALT_CPU_RESET_ADDR 0x1002000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x1004820
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x0
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x19
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x1002020
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x19
#define NIOS2_RESET_ADDR 0x1002000


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_LCD_16207
#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2
#define __ALTPLL


/*
 * LEDG configuration
 *
 */

#define ALT_MODULE_CLASS_LEDG altera_avalon_pio
#define LEDG_BASE 0x1005060
#define LEDG_BIT_CLEARING_EDGE_REGISTER 0
#define LEDG_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LEDG_CAPTURE 0
#define LEDG_DATA_WIDTH 8
#define LEDG_DO_TEST_BENCH_WIRING 0
#define LEDG_DRIVEN_SIM_VALUE 0x0
#define LEDG_EDGE_TYPE "NONE"
#define LEDG_FREQ 50000000u
#define LEDG_HAS_IN 0
#define LEDG_HAS_OUT 1
#define LEDG_HAS_TRI 0
#define LEDG_IRQ -1
#define LEDG_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LEDG_IRQ_TYPE "NONE"
#define LEDG_NAME "/dev/LEDG"
#define LEDG_RESET_VALUE 0x0
#define LEDG_SPAN 16
#define LEDG_TYPE "altera_avalon_pio"


/*
 * LEDR configuration
 *
 */

#define ALT_MODULE_CLASS_LEDR altera_avalon_pio
#define LEDR_BASE 0x1005070
#define LEDR_BIT_CLEARING_EDGE_REGISTER 0
#define LEDR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LEDR_CAPTURE 0
#define LEDR_DATA_WIDTH 18
#define LEDR_DO_TEST_BENCH_WIRING 0
#define LEDR_DRIVEN_SIM_VALUE 0x0
#define LEDR_EDGE_TYPE "NONE"
#define LEDR_FREQ 50000000u
#define LEDR_HAS_IN 0
#define LEDR_HAS_OUT 1
#define LEDR_HAS_TRI 0
#define LEDR_IRQ -1
#define LEDR_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LEDR_IRQ_TYPE "NONE"
#define LEDR_NAME "/dev/LEDR"
#define LEDR_RESET_VALUE 0x0
#define LEDR_SPAN 16
#define LEDR_TYPE "altera_avalon_pio"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "CYCLONEII"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_BASE 0x1005108
#define ALT_STDERR_DEV jtag_uart_0
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_BASE 0x1005108
#define ALT_STDIN_DEV jtag_uart_0
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_BASE 0x1005108
#define ALT_STDOUT_DEV jtag_uart_0
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "SOPC_File"


/*
 * altpll_0 configuration
 *
 */

#define ALTPLL_0_BASE 0x1005050
#define ALTPLL_0_IRQ -1
#define ALTPLL_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ALTPLL_0_NAME "/dev/altpll_0"
#define ALTPLL_0_SPAN 16
#define ALTPLL_0_TYPE "altpll"
#define ALT_MODULE_CLASS_altpll_0 altpll


/*
 * char_lcd configuration
 *
 */

#define ALT_MODULE_CLASS_char_lcd altera_avalon_lcd_16207
#define CHAR_LCD_BASE 0x1005040
#define CHAR_LCD_IRQ -1
#define CHAR_LCD_IRQ_INTERRUPT_CONTROLLER_ID -1
#define CHAR_LCD_NAME "/dev/char_lcd"
#define CHAR_LCD_SPAN 16
#define CHAR_LCD_TYPE "altera_avalon_lcd_16207"


/*
 * hal configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK UC_TIMER
#define ALT_TIMESTAMP_CLK none


/*
 * jtag_uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_jtag_uart_0 altera_avalon_jtag_uart
#define JTAG_UART_0_BASE 0x1005108
#define JTAG_UART_0_IRQ 1
#define JTAG_UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8


/*
 * note_0 configuration
 *
 */

#define ALT_MODULE_CLASS_note_0 altera_avalon_pio
#define NOTE_0_BASE 0x1005080
#define NOTE_0_BIT_CLEARING_EDGE_REGISTER 0
#define NOTE_0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define NOTE_0_CAPTURE 0
#define NOTE_0_DATA_WIDTH 20
#define NOTE_0_DO_TEST_BENCH_WIRING 0
#define NOTE_0_DRIVEN_SIM_VALUE 0x0
#define NOTE_0_EDGE_TYPE "NONE"
#define NOTE_0_FREQ 50000000u
#define NOTE_0_HAS_IN 0
#define NOTE_0_HAS_OUT 1
#define NOTE_0_HAS_TRI 0
#define NOTE_0_IRQ -1
#define NOTE_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NOTE_0_IRQ_TYPE "NONE"
#define NOTE_0_NAME "/dev/note_0"
#define NOTE_0_RESET_VALUE 0x0
#define NOTE_0_SPAN 16
#define NOTE_0_TYPE "altera_avalon_pio"


/*
 * note_1 configuration
 *
 */

#define ALT_MODULE_CLASS_note_1 altera_avalon_pio
#define NOTE_1_BASE 0x1005090
#define NOTE_1_BIT_CLEARING_EDGE_REGISTER 0
#define NOTE_1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define NOTE_1_CAPTURE 0
#define NOTE_1_DATA_WIDTH 20
#define NOTE_1_DO_TEST_BENCH_WIRING 0
#define NOTE_1_DRIVEN_SIM_VALUE 0x0
#define NOTE_1_EDGE_TYPE "NONE"
#define NOTE_1_FREQ 50000000u
#define NOTE_1_HAS_IN 0
#define NOTE_1_HAS_OUT 1
#define NOTE_1_HAS_TRI 0
#define NOTE_1_IRQ -1
#define NOTE_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NOTE_1_IRQ_TYPE "NONE"
#define NOTE_1_NAME "/dev/note_1"
#define NOTE_1_RESET_VALUE 0x0
#define NOTE_1_SPAN 16
#define NOTE_1_TYPE "altera_avalon_pio"


/*
 * note_2 configuration
 *
 */

#define ALT_MODULE_CLASS_note_2 altera_avalon_pio
#define NOTE_2_BASE 0x10050a0
#define NOTE_2_BIT_CLEARING_EDGE_REGISTER 0
#define NOTE_2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define NOTE_2_CAPTURE 0
#define NOTE_2_DATA_WIDTH 20
#define NOTE_2_DO_TEST_BENCH_WIRING 0
#define NOTE_2_DRIVEN_SIM_VALUE 0x0
#define NOTE_2_EDGE_TYPE "NONE"
#define NOTE_2_FREQ 50000000u
#define NOTE_2_HAS_IN 0
#define NOTE_2_HAS_OUT 1
#define NOTE_2_HAS_TRI 0
#define NOTE_2_IRQ -1
#define NOTE_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NOTE_2_IRQ_TYPE "NONE"
#define NOTE_2_NAME "/dev/note_2"
#define NOTE_2_RESET_VALUE 0x0
#define NOTE_2_SPAN 16
#define NOTE_2_TYPE "altera_avalon_pio"


/*
 * note_3 configuration
 *
 */

#define ALT_MODULE_CLASS_note_3 altera_avalon_pio
#define NOTE_3_BASE 0x10050b0
#define NOTE_3_BIT_CLEARING_EDGE_REGISTER 0
#define NOTE_3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define NOTE_3_CAPTURE 0
#define NOTE_3_DATA_WIDTH 20
#define NOTE_3_DO_TEST_BENCH_WIRING 0
#define NOTE_3_DRIVEN_SIM_VALUE 0x0
#define NOTE_3_EDGE_TYPE "NONE"
#define NOTE_3_FREQ 50000000u
#define NOTE_3_HAS_IN 0
#define NOTE_3_HAS_OUT 1
#define NOTE_3_HAS_TRI 0
#define NOTE_3_IRQ -1
#define NOTE_3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NOTE_3_IRQ_TYPE "NONE"
#define NOTE_3_NAME "/dev/note_3"
#define NOTE_3_RESET_VALUE 0x0
#define NOTE_3_SPAN 16
#define NOTE_3_TYPE "altera_avalon_pio"


/*
 * note_4 configuration
 *
 */

#define ALT_MODULE_CLASS_note_4 altera_avalon_pio
#define NOTE_4_BASE 0x10050c0
#define NOTE_4_BIT_CLEARING_EDGE_REGISTER 0
#define NOTE_4_BIT_MODIFYING_OUTPUT_REGISTER 0
#define NOTE_4_CAPTURE 0
#define NOTE_4_DATA_WIDTH 20
#define NOTE_4_DO_TEST_BENCH_WIRING 0
#define NOTE_4_DRIVEN_SIM_VALUE 0x0
#define NOTE_4_EDGE_TYPE "NONE"
#define NOTE_4_FREQ 50000000u
#define NOTE_4_HAS_IN 0
#define NOTE_4_HAS_OUT 1
#define NOTE_4_HAS_TRI 0
#define NOTE_4_IRQ -1
#define NOTE_4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NOTE_4_IRQ_TYPE "NONE"
#define NOTE_4_NAME "/dev/note_4"
#define NOTE_4_RESET_VALUE 0x0
#define NOTE_4_SPAN 16
#define NOTE_4_TYPE "altera_avalon_pio"


/*
 * note_5 configuration
 *
 */

#define ALT_MODULE_CLASS_note_5 altera_avalon_pio
#define NOTE_5_BASE 0x10050d0
#define NOTE_5_BIT_CLEARING_EDGE_REGISTER 0
#define NOTE_5_BIT_MODIFYING_OUTPUT_REGISTER 0
#define NOTE_5_CAPTURE 0
#define NOTE_5_DATA_WIDTH 20
#define NOTE_5_DO_TEST_BENCH_WIRING 0
#define NOTE_5_DRIVEN_SIM_VALUE 0x0
#define NOTE_5_EDGE_TYPE "NONE"
#define NOTE_5_FREQ 50000000u
#define NOTE_5_HAS_IN 0
#define NOTE_5_HAS_OUT 1
#define NOTE_5_HAS_TRI 0
#define NOTE_5_IRQ -1
#define NOTE_5_IRQ_INTERRUPT_CONTROLLER_ID -1
#define NOTE_5_IRQ_TYPE "NONE"
#define NOTE_5_NAME "/dev/note_5"
#define NOTE_5_RESET_VALUE 0x0
#define NOTE_5_SPAN 16
#define NOTE_5_TYPE "altera_avalon_pio"


/*
 * onchip_memory2_0 configuration
 *
 */

#define ALT_MODULE_CLASS_onchip_memory2_0 altera_avalon_onchip_memory2
#define ONCHIP_MEMORY2_0_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define ONCHIP_MEMORY2_0_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define ONCHIP_MEMORY2_0_BASE 0x1002000
#define ONCHIP_MEMORY2_0_CONTENTS_INFO ""
#define ONCHIP_MEMORY2_0_DUAL_PORT 0
#define ONCHIP_MEMORY2_0_GUI_RAM_BLOCK_TYPE "Automatic"
#define ONCHIP_MEMORY2_0_INIT_CONTENTS_FILE "onchip_memory2_0"
#define ONCHIP_MEMORY2_0_INIT_MEM_CONTENT 1
#define ONCHIP_MEMORY2_0_INSTANCE_ID "NONE"
#define ONCHIP_MEMORY2_0_IRQ -1
#define ONCHIP_MEMORY2_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ONCHIP_MEMORY2_0_NAME "/dev/onchip_memory2_0"
#define ONCHIP_MEMORY2_0_NON_DEFAULT_INIT_FILE_ENABLED 0
#define ONCHIP_MEMORY2_0_RAM_BLOCK_TYPE "Auto"
#define ONCHIP_MEMORY2_0_READ_DURING_WRITE_MODE "DONT_CARE"
#define ONCHIP_MEMORY2_0_SIZE_MULTIPLE 1
#define ONCHIP_MEMORY2_0_SIZE_VALUE 8192u
#define ONCHIP_MEMORY2_0_SPAN 8192
#define ONCHIP_MEMORY2_0_TYPE "altera_avalon_onchip_memory2"
#define ONCHIP_MEMORY2_0_WRITABLE 1


/*
 * sdram_0 configuration
 *
 */

#define ALT_MODULE_CLASS_sdram_0 altera_avalon_new_sdram_controller
#define SDRAM_0_BASE 0x800000
#define SDRAM_0_CAS_LATENCY 3
#define SDRAM_0_CONTENTS_INFO ""
#define SDRAM_0_INIT_NOP_DELAY 0.0
#define SDRAM_0_INIT_REFRESH_COMMANDS 2
#define SDRAM_0_IRQ -1
#define SDRAM_0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SDRAM_0_IS_INITIALIZED 1
#define SDRAM_0_NAME "/dev/sdram_0"
#define SDRAM_0_POWERUP_DELAY 100.0
#define SDRAM_0_REFRESH_PERIOD 15.625
#define SDRAM_0_REGISTER_DATA_IN 1
#define SDRAM_0_SDRAM_ADDR_WIDTH 0x16
#define SDRAM_0_SDRAM_BANK_WIDTH 2
#define SDRAM_0_SDRAM_COL_WIDTH 8
#define SDRAM_0_SDRAM_DATA_WIDTH 16
#define SDRAM_0_SDRAM_NUM_BANKS 4
#define SDRAM_0_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_0_SDRAM_ROW_WIDTH 12
#define SDRAM_0_SHARED_DATA 0
#define SDRAM_0_SIM_MODEL_BASE 0
#define SDRAM_0_SPAN 8388608
#define SDRAM_0_STARVATION_INDICATOR 0
#define SDRAM_0_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_0_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_0_T_AC 5.5
#define SDRAM_0_T_MRD 3
#define SDRAM_0_T_RCD 20.0
#define SDRAM_0_T_RFC 70.0
#define SDRAM_0_T_RP 20.0
#define SDRAM_0_T_WR 14.0


/*
 * sysid configuration
 *
 */

#define ALT_MODULE_CLASS_sysid altera_avalon_sysid
#define SYSID_BASE 0x1005100
#define SYSID_ID 0u
#define SYSID_IRQ -1
#define SYSID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SYSID_NAME "/dev/sysid"
#define SYSID_SPAN 8
#define SYSID_TIMESTAMP 1332794990u
#define SYSID_TYPE "altera_avalon_sysid"


/*
 * uC_timer configuration
 *
 */

#define ALT_MODULE_CLASS_uC_timer altera_avalon_timer
#define UC_TIMER_ALWAYS_RUN 0
#define UC_TIMER_BASE 0x1005000
#define UC_TIMER_COUNTER_SIZE 32
#define UC_TIMER_FIXED_PERIOD 0
#define UC_TIMER_FREQ 50000000u
#define UC_TIMER_IRQ 0
#define UC_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UC_TIMER_LOAD_VALUE 49999ull
#define UC_TIMER_MULT 0.0010
#define UC_TIMER_NAME "/dev/uC_timer"
#define UC_TIMER_PERIOD 1
#define UC_TIMER_PERIOD_UNITS "ms"
#define UC_TIMER_RESET_OUTPUT 0
#define UC_TIMER_SNAPSHOT 1
#define UC_TIMER_SPAN 32
#define UC_TIMER_TICKS_PER_SEC 1000u
#define UC_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define UC_TIMER_TYPE "altera_avalon_timer"


/*
 * uart_0 configuration
 *
 */

#define ALT_MODULE_CLASS_uart_0 altera_avalon_uart
#define UART_0_BASE 0x1005020
#define UART_0_BAUD 31250
#define UART_0_DATA_BITS 8
#define UART_0_FIXED_BAUD 1
#define UART_0_FREQ 50000000u
#define UART_0_IRQ 2
#define UART_0_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART_0_NAME "/dev/uart_0"
#define UART_0_PARITY 'N'
#define UART_0_SIM_CHAR_STREAM ""
#define UART_0_SIM_TRUE_BAUD 1
#define UART_0_SPAN 32
#define UART_0_STOP_BITS 1
#define UART_0_SYNC_REG_DEPTH 2
#define UART_0_TYPE "altera_avalon_uart"
#define UART_0_USE_CTS_RTS 0
#define UART_0_USE_EOP_REGISTER 0


/*
 * ucosii configuration
 *
 */

#define OS_ARG_CHK_EN 1
#define OS_CPU_HOOKS_EN 1
#define OS_DEBUG_EN 1
#define OS_EVENT_NAME_SIZE 32
#define OS_FLAGS_NBITS 16
#define OS_FLAG_ACCEPT_EN 1
#define OS_FLAG_DEL_EN 1
#define OS_FLAG_EN 1
#define OS_FLAG_NAME_SIZE 32
#define OS_FLAG_QUERY_EN 1
#define OS_FLAG_WAIT_CLR_EN 1
#define OS_LOWEST_PRIO 20
#define OS_MAX_EVENTS 60
#define OS_MAX_FLAGS 20
#define OS_MAX_MEM_PART 60
#define OS_MAX_QS 20
#define OS_MAX_TASKS 10
#define OS_MBOX_ACCEPT_EN 1
#define OS_MBOX_DEL_EN 1
#define OS_MBOX_EN 1
#define OS_MBOX_POST_EN 1
#define OS_MBOX_POST_OPT_EN 1
#define OS_MBOX_QUERY_EN 1
#define OS_MEM_EN 1
#define OS_MEM_NAME_SIZE 32
#define OS_MEM_QUERY_EN 1
#define OS_MUTEX_ACCEPT_EN 1
#define OS_MUTEX_DEL_EN 1
#define OS_MUTEX_EN 1
#define OS_MUTEX_QUERY_EN 1
#define OS_Q_ACCEPT_EN 1
#define OS_Q_DEL_EN 1
#define OS_Q_EN 1
#define OS_Q_FLUSH_EN 1
#define OS_Q_POST_EN 1
#define OS_Q_POST_FRONT_EN 1
#define OS_Q_POST_OPT_EN 1
#define OS_Q_QUERY_EN 1
#define OS_SCHED_LOCK_EN 1
#define OS_SEM_ACCEPT_EN 1
#define OS_SEM_DEL_EN 1
#define OS_SEM_EN 1
#define OS_SEM_QUERY_EN 1
#define OS_SEM_SET_EN 1
#define OS_TASK_CHANGE_PRIO_EN 1
#define OS_TASK_CREATE_EN 1
#define OS_TASK_CREATE_EXT_EN 1
#define OS_TASK_DEL_EN 1
#define OS_TASK_IDLE_STK_SIZE 512
#define OS_TASK_NAME_SIZE 32
#define OS_TASK_PROFILE_EN 1
#define OS_TASK_QUERY_EN 1
#define OS_TASK_STAT_EN 1
#define OS_TASK_STAT_STK_CHK_EN 1
#define OS_TASK_STAT_STK_SIZE 512
#define OS_TASK_SUSPEND_EN 1
#define OS_TASK_SW_HOOK_EN 1
#define OS_TASK_TMR_PRIO 0
#define OS_TASK_TMR_STK_SIZE 512
#define OS_THREAD_SAFE_NEWLIB 1
#define OS_TICKS_PER_SEC UC_TIMER_TICKS_PER_SEC
#define OS_TICK_STEP_EN 1
#define OS_TIME_DLY_HMSM_EN 1
#define OS_TIME_DLY_RESUME_EN 1
#define OS_TIME_GET_SET_EN 1
#define OS_TIME_TICK_HOOK_EN 1
#define OS_TMR_CFG_MAX 16
#define OS_TMR_CFG_NAME_SIZE 16
#define OS_TMR_CFG_TICKS_PER_SEC 10
#define OS_TMR_CFG_WHEEL_SIZE 2
#define OS_TMR_EN 0

#endif /* __SYSTEM_H_ */
