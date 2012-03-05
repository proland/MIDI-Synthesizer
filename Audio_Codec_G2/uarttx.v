//---------------------------------------------------------------------------------
// Uart Transmit Module
//
// Created March 6, 2005
// Author:James Patchell
// Copyleft (c) 2005 by James Patchell
// This code may be used freely in anyway you see fit...
// This is open source.
//
// This is a module that implements the transmit portion of an 8 bit uart.
// This is a very simple minded implementation in that that is all it does.
// There is no provision for any other word size, or the addition of parity,
// since in general I have absolutely no use for any of that.
//
// parameter:
//  din............8 bit bus of data that is to be sent out
//  load...........This signal write the data to a holding register and
//                 sets a Ready flag to let the transmitter know that
//                 there is data ready to go out.
//  clock..........system clock
//  reset..........system reset, returns uart to an idle stat and clears ready
//  shift..........signal to let the system know when it is time to shift a bit
//                 (this is the baud rate).
//  txd............transmit data output
//  ready..........status: 0 indicates no data in holding register
//                 status: 1 indicates holding register is full
//------------------------------------------------------------------------------
// Revision History:
// Rev 1.01
//  April 17, 2005
//  Changed the shift register to shift the LSB out first
//----------------------------------------------------------------------------------

module uarttx(din,load,clock,reset,shift,txd,ready,CS);
  input [7:0] din;       // data to be transmitted
  input load;            // loads the transmit register
  input clock;           // 1x transmit clock
  input reset;           // resets the registers
  input shift;           // this is when the shift register is supposed to shift
  output txd;            // output data
  output ready;          // indicates ready to receive char to transmit
  output [3:0]CS;        // state output

  reg ready;             // ready status bit
  reg txd;               // transmit bit

  reg [8:0] INT;         // nine bit shift register
  reg [7:0] Hold;        // holding register for the data
  reg doshift;           // tells the shift register to shift its data
  reg doload;            // tells the shift register to load its data
  reg clearready;        // tells the ready bit to clear
  reg setready;          // tells the ready bit to set
      
always @(posedge clock)
begin
  if(load)
  begin
    Hold <= din;         // load data into holding register
  end
end

always @(load)
  if(load)
    setready <= 1;
  else
    setready <= 0;

//-----------------------------------------------------------------
// Uart State machine
//
// it should be noted, the LSB is the first bit to
// be transmitted...the states would seem to imply
// that we start at BIT7...well, that is wrong
// SRG: this is because the txd output comes from INT[0] and the 
//   shift operation is a right shift.
//-----------------------------------------------------------------

parameter [3:0]          // synopsys enum STATE_TYPE
  UART_IDLE = 4'b0000,
  UART_STARTBIT = 4'b0001,
  UART_BIT7 = 4'b0010,
  UART_BIT6 = 4'b0011,
  UART_BIT5 = 4'b0100,
  UART_BIT4 = 4'b0101,
  UART_BIT3 = 4'b0110,
  UART_BIT2 = 4'b0111,
  UART_BIT1 = 4'b1000,
  UART_BIT0 = 4'b1001,
  UART_STOPBIT = 4'b1010;
 
// Declare current state and next state variables

reg [3:0] /* synopsys enum STATE_TYPE */ CS;
reg [3:0] /* synopsys enum STATE_TYPE */ NS;


 
// synopsys state_vector CS
 
  always @ (posedge clock or posedge reset)
  begin
    if (reset) CS <= UART_IDLE;
    else CS <= NS;
  end
 
  always @ (CS or ready or shift)
  begin 
    case (CS)                  // synopsys full_case
      UART_IDLE: begin
        if (ready && shift) 
        begin
          NS <= UART_STARTBIT;
          doshift = 0;
          doload = 1;          // load data into shift register
          clearready = 1;      // clear ready bit
        end
        else begin
          NS <= UART_IDLE;
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end 
      UART_STARTBIT: begin
        if(shift) begin
          NS <= UART_BIT7;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_STARTBIT; // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT7: begin
        if(shift) begin
          NS <= UART_BIT6;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT7;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT6: begin
        if(shift) begin
          NS <= UART_BIT5;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT6;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT5: begin
        if(shift) begin
          NS <= UART_BIT4;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT5;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT4: begin
        if(shift) begin
          NS <= UART_BIT3;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT4;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT3: begin
        if(shift)  begin
          NS <= UART_BIT2;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else  begin
          NS <= UART_BIT3;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT2: begin
        if(shift) begin
          NS <= UART_BIT1;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT2;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT1: begin
        if(shift) begin
          NS <= UART_BIT0;     // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT1;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_BIT0: begin
        if(shift) begin
          NS <= UART_STOPBIT;  // go to next state
          doshift = 1;         // shift data out register
          doload = 0;
          clearready = 0;
        end
        else begin
          NS <= UART_BIT0;     // hold this state
          doshift = 0;
          doload = 0;
          clearready = 0;
        end
      end
      UART_STOPBIT: begin
        if(shift && !ready) begin
          NS <= UART_IDLE;     // nothing more to do, so idle
          doshift = 0;      
          doload = 0;
          clearready = 0;
        end
        else if (shift && ready) begin
          NS <= UART_STARTBIT; // another byte waiting, go do it
          doshift = 0;      
          doload = 1;          // load data into shift register
          clearready = 1;      // clear ready bit
        end
        else begin
          NS <= UART_STOPBIT;  // hold this state
          doshift = 0;      
          doload = 0;
          clearready = 0;
        end
      end
      default: begin
        doshift = 0;      
        doload = 0;
        clearready = 0;
        NS <= UART_IDLE;
      end 
    endcase
  end 

//---------------------------------------------------------------
// shift register
//
// shift register can do a load, and do a shift
//---------------------------------------------------------------

always @(posedge clock or posedge reset)
begin
  if(reset) begin
    INT <= 9'b111111111;         // reset transmit register to all 1's
  end
  else begin
    if(doload) begin
      INT <= {Hold,1'b0};        // load data and set start bit to 0
      txd <= INT[0];
    end
    else if (doshift) begin     
      INT <= {1'b1,INT[8:1]};    // shift data, shift in 1's
      txd <= INT[0];
    end
    else  begin
      INT <= INT;                // hold data
      txd <= INT[0];
    end    
  end
end

//---------------------------------------------------------------
// ready status bit
// when status == 1, this indicates that there is data waiting
//        in the data holding register ready to be
//        transmitted.
// when status == 0, data holding register is empty
//---------------------------------------------------------------

always @ (posedge clock or posedge reset)
begin
  if(reset)
    ready <= 0;                  // always not ready at reset
  else begin
    if(setready)
      ready <= 1;
    else if(clearready)
      ready <= 0;
    else
      ready <= ready;            // hold ready
  end
end

endmodule

