-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: tb_io_ctrl_rtl.vhd
--
-- Date: 17.05.2023
--
-- Design Unit: IO Control Unit Testbench
--
-- Description: The IO Control unit is part of the calculator project.
-- It manages the interface to the 7-segment displays,
-- the LEDs, the push buttons and the switches of the
-- Digilent Basys3 FPGA board.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_io_ctrl is
end tb_io_ctrl;

architecture sim of tb_io_ctrl is

    component io_ctrl
        port(
            clk_i      : in std_logic;
            reset_i    : in std_logic;
            dig0_i     : in std_logic_vector(7 downto 0);
            dig1_i     : in std_logic_vector(7 downto 0);
            dig2_i     : in std_logic_vector(7 downto 0);
            dig3_i     : in std_logic_vector(7 downto 0);
            led_i      : in std_logic_vector(15 downto 0);
            sw_i       : in std_logic_vector(15 downto 0);
            pb_i       : in std_logic_vector(3 downto 0);
            ss_o       : out std_logic_vector(7 downto 0);
            ss_sel_o   : out std_logic_vector(3 downto 0);
            led_o      : out std_logic_vector(15 downto 0);
            swsync_o   : out std_logic_vector(15 downto 0);
            pbsync_o   : out std_logic_vector(3 downto 0)
            );
    end component;

    signal clk_i, reset_i                         : std_logic := '0';
    signal dig0_i, dig1_i, dig2_i, dig3_i, ss_o   : std_logic_vector(7 downto 0);
    signal led_i, sw_i, led_o, swsync_o           : std_logic_vector(15 downto 0);
    signal pb_i, pbsync_o, ss_sel_o               : std_logic_vector(3 downto 0);

begin

    tb_io_ctrl_p : io_ctrl
    port map(
            clk_i    => clk_i,
            reset_i  => reset_i,
            dig0_i   => dig0_i,
            dig1_i   => dig1_i,
            dig2_i   => dig2_i,
            dig3_i   => dig3_i,
            ss_o     => ss_o,
            led_i    => led_i,
            sw_i     => sw_i,
            ss_sel_o => ss_sel_o,
            led_o    => led_o,
            swsync_o => swsync_o,
            pb_i     => pb_i,
            pbsync_o => pbsync_o
            );
    
    CLK_p : process                     -- 100 Mhz
        begin
            clk_i <= '0';
            wait for 5 us;
            clk_i <= '1';
            wait for 5 us;
    end process;

    R_p : process
        begin
            reset_i <= '1';
            wait for 15 us;
            reset_i <= '0';
            wait;
    end process;

    PB_p :  process
        begin
            pb_i(0) <= '1';
            wait;
           -- pb_i(1) <= '1';

           -- pb_i(2) <= '1';

           -- pb_i(3) <= '1';

    end process;

    SS_p : process
        begin
            dig0_i <= "00000000";
            dig1_i <= "01100000";
            dig2_i <= "11011010";
            dig3_i <= "11110010";

            sw_i  <= "0000000000001011";
            led_i <= "1000000000000000";
            wait;
    end process;
end sim;