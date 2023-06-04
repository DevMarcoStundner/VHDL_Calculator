-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: LUT_pkg.vhd
--
-- Date: 24.05.2023
--
-- Description: LookUp-Table for the Seven-Segment
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package LUT is
type symbols is array(0 to 25) of std_logic_vector(7 downto 0);

constant ss_symbols : symbols := (
                                  0  => "00000011",   -- 0
                                  1  => "10011111",   -- 1
                                  2  => "00100101",   -- 2
                                  3  => "00001101",   -- 3
                                  4  => "10011001",   -- 4
                                  5  => "01001001",   -- 5
                                  6  => "01000001",   -- 6
                                  7  => "00011111",   -- 7
                                  8  => "00000001",   -- 8
                                  9  => "00011001",   -- 9
                                  10 => "00010001",   -- A
                                  11 => "11000001",   -- b
                                  12 => "01100011",   -- C
                                  13 => "10000101",   -- d
                                  14 => "01100001",   -- E
                                  15 => "01110001",   -- F
                                  16 => "11000100",   -- o.
                                  17 => "11010101",   -- n
                                  18 => "11111110",   -- .
                                  19 => "11110101",   -- r
                                  20 => "10010001",   -- H  
                                  21 => "10011110",   -- 1.
                                  22 => "00100100",   -- 2.
                                  23 =>  "11111111",  -- Dark
                                  24 =>  "11000101",  -- o
                                  25 =>  "11111101"   -- -
                                  );
                                  
constant BTNL : integer:= 0;
constant BTNC : integer:= 1;
constant BTNR : integer:= 2;
constant BTND : integer:= 3;

signal counter : std_logic_vector(11 downto 0);

end package LUT;