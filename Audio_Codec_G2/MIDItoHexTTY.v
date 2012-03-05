`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Chaos
// Author: Scott Gravenhorst
// 
// Create Date:    18:01:54 07/07/2006 
// Module Name:    MIDI to Hex TTY
// Project Name:   MIDItoHexTTY
// Target Devices: Spartan-3E
// Description:    MIDI data in, hex data TTY output using PicoBlaze.
//                 Program code transmits two hex bytes and a space for each received MIDI byte
// Dependencies:   Jim Patchell's UART modules
//
// Revision: 1.00
//
// CONSTANT txreadybit, 01                  ; bit mask used to sense for tx ready for new data
// CONSTANT rxreadybit, 02                  ; bit mask used to sense for rx data available
//
// input ports:                
// CONSTANT UARTstatus, 00                  ; port number for rx and tx status
// CONSTANT rxdataport, 01                  ; port number for rx data register
//
// output ports 
// CONSTANT txdataport, 00                  ; port number for tx data register
// CONSTANT LEDport, 01                     ; port number for LEDs
//
//
//////////////////////////////////////////////////////////////////////////////////

module MIDItoHexTTY( clk50MHz, led, RS232_DCE_TXD, Raw_MIDI_In );
  input clk50MHz;
  output [7:0] led;
  output RS232_DCE_TXD;
  input Raw_MIDI_In;               // MIDI input from IO12.  (E8)
  
  wire MIDI_In;
  assign MIDI_In = Raw_MIDI_In;   // Don't invert the MIDI serial stream for 6N138
  // assign MIDI_In = ~Raw_MIDI_In;   // Invert the MIDI serial stream
  
  reg shiftreg;                    // one bit shift register to delay txload by one clock cycle.
                                                                                           
  wire clk50MHz;
  wire interrupt;
  wire interrupt_ack;
  wire [7:0] led;
  wire [9:0] address;              // wires to connect address lines from uC to ROM
  wire [17:0] instruction;         // uC data lines, need connection between uC and ROM
  wire [7:0] out_port;             // wires to connect uC output port to txdata
  wire [7:0] in_port;              // wires to connect uC input port to
  wire [7:0] port_id;
  wire read_strobe;
  wire write_strobe;

// UART all
  wire resetsignal;

// transmitter
  wire txready;
  wire [7:0] txdata;
  wire txclock;  
  wire [3:0] txCS;

// receiver
  wire [7:0] rxdata;
  wire rxready_pulse;
  wire rxready;                 // status flip flop for receive data ready
  wire rxbusy;
  wire rxbclk;  
  wire [3:0] rxCS;

  reg [7:0] txdata_reg;

  reg [7:0] XLED;

  reg [7:0] in_port_reg;
  assign in_port = in_port_reg;

// TTY transmitter.  115,200 Baud
  txbaudclock txbitclock1x( clk50MHz, txclock );
  uarttx UARTtx( txdata_reg, txload, clk50MHz, resetsignal, txclock, RS232_DCE_TXD, txready, txCS );

// MIDI receiver.  31,250 Baud
  rx16xclock rxbitclock16x( clk50MHz, rxbclk );
  uartrx UARTrx( rxdata, clk50MHz, rxbclk, resetsignal, MIDI_In, frame, overrun, rxready_pulse, rxbusy, rxCS );

  kcpsm3 MCU( address, instruction, port_id, write_strobe, out_port, read_strobe, in_port, interrupt, interrupt_ack, reset, clk50MHz );
  midihex PSM_ROM( address, instruction, proc_reset, clk50MHz );

  RSflipflop RSrxready( rxready, rxready_pulse, reset_rxready, resetsignal );
  RSflipflop IntFF( interrupt, rxready_pulse, interrupt_ack, resetsignal );
  
  assign reset = 0;
  assign proc_reset = 0;
    
  assign resetsignal = write_strobe & port_id[7];    // When port_id high bit goes high with write strobe, reset the UART

  assign led[7:0] = XLED;
   
// delay the start_txload signal (derived from the write_strobe AND decode port 00)
// applying the delayed output to txload.
  assign start_txload = write_strobe & (port_id == 8'b00000000 ); 

  always @ ( posedge clk50MHz ) shiftreg <= start_txload;
    
  assign txload = shiftreg;                          // apply delayed load signal to txload

// decode read port 01, send pulse to reset rxready flop
  assign reset_rxready = (read_strobe == 1'b1) & (port_id == 8'b00000001);


  always @ ( posedge clk50MHz )     
  begin
	 XLED[0] <= ~MIDI_In;
	 case ( port_id[0] )                 // decode and transfer data to in_port_reg
    0: in_port_reg <= {6'b000000,rxready,txready};
    1: in_port_reg <= rxdata;
    endcase

// multiplex out_port from the mcu to service 2 registers
//     
      if ( write_strobe == 1'b1 ) 
      begin
        case ( port_id[0] )             // decode and transfer data on write_strobe:
        0: txdata_reg <= out_port;
        endcase
      end
  end

endmodule

// Clock for TTY Data output
module txbaudclock( clk, pulse );       // 1x baud rate clock derived from 50MHz system clock
  input clk;
  output pulse;
  
  integer baudcounter;
  wire clk;
  reg pulse;

  always @ ( posedge clk )
  begin
    if ( baudcounter <= 0 ) 
      begin
       // 166667 for 300 baud
       // 2604   for 19200 baud
       // 1600   for 31250 baud
       // 434    for 115200 baud
        baudcounter <= 434;													 
        pulse <= 1'b1;
      end
    else
      begin
        baudcounter <= baudcounter - 1; // decrement each system clock
        pulse <= 1'b0;
      end
  end
endmodule

// Clock for MIDI data input
module rx16xclock( clk, pulse );        // 16x baud rate clock derived from 50MHz system clock
  input clk;
  output pulse;
  
  integer baudcounter;
  wire clk;
  reg pulse;

  always @ ( posedge clk )
  begin
    if ( baudcounter <= 0 ) 
      begin
      // 10417 for 300 baud (10416.6666...)
      // 163 for 19200 baud (162.760416666...)
      // 100 for 31250 baud (100.0)
      // 27 for 115200 baud (27.126736111...)
        baudcounter <= 100;													 
        pulse <= 1'b1;
      end
    else
      begin
        baudcounter <= baudcounter - 1; // decrement each system clock
        pulse <= 1'b0;
      end
  end
endmodule

module RSflipflop( yo, s, r, c );       // RS flip flop to hold state of rx ready.  rxready signal is a pulse.
  output yo;                            // inputs are s=set, r=reset, c=clear.
  input s;
  input r;
  input c;

  nor nor1(xo,s,yo);                    // cross coupled NOR gates
  nor nor2(yo,a,xo);
  or or1(a, r, c );                     // OR reset and clear inputs
endmodule
