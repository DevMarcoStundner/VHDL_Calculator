-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: tb_top.vhd
--
-- Date: 02.06.2023
--
-- Design Unit: Top-level Design of Calculator Testbench
--
-- Directory: cd C:/Users/marco/Desktop/FH/CHIP1/Calculator/sim
--
-- Description: This is the top-level design of the calculator project.
-- It interconnects the sub-units 'IO control unit', 'calculator
-- control unit' and 'arithmetic logic unit' and interfaces to
-- the circuitry of the Digilent Basys3 FPGA board.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_alu is
    end tb_alu;

architecture sim of tb_top is

    component TOP
        port (
            clk_i      : in std_logic;
            reset_i    : in std_logic;
            sw_i       : in std_logic_vector(15 downto 0);
            pb_i       : in std_logic_vector(3 downto 0);
            ss_o       : out std_logic_vector(7 downto 0);
            ss_sel_o   : out std_logic_vector(3 downto 0);
            led_o      : out std_logic_vector(15 downto 0)
            );
    end component;

    signal clk_i, reset_i : std_logic := '0'; 
    signal sw_i, led_o    : std_logic_vector(15 downto 0);
    signal pb_i, ss_sel_o : std_logic_vector(3 downto 0);
    signal  ss_o          : std_logic_vector(7 downto 0);
    
begin

    tb_top_p : TOP
    port map(
        clk_i      => clk_i,
        reset_i    => reset_i,
        sw_i       => sw_i,
        led_o      => led_o,
        pb_i       => pb_i,
        ss_sel_o   => ss_sel_o,
        ss_o       => ss_o
        );

    CLK_p : process                     -- 100 Mhz
    begin
        clk_i <= '0';
        wait for 5 ns;
        clk_i <= '1';
        wait for 5 ns;
    end process;
    
    R_p : process
        begin
            reset_i <= '1';
            wait for 15 ns;
            reset_i <= '0';
            wait;
    end process;    
