# VHDL_Calculator

- A simple calculator shall be implemented using the Digilent Basys3 FPGA development board.

- The FPGA contained on the board is a Xilinx Artix-7 FPGA (XC7A35T-1CPG236C) device.

- Two unsigned 12-bit integer values OP1 and OP2 as well as an arithmetic/logic operation (sum,
multiplication, logical AND, square root ...) are defined by the user via the switches and push
buttons of the Basys3 board. The calculator performs the selected operation and displays the
result on the 7-segment displays (DISP1). 

- The design shall operate fully synchronous using with the 100 MHz clock from the board’s
oscillator.

- An asynchronous high-active reset shall be used to initialize the design (BTNU button on the
Basys3 board).