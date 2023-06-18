-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: top.vhd
--
-- Date: 02.06.2023
--
-- Design Unit: Top-level Design of Calculator
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

entity TOP is

    port (
        clk_i      : in std_logic;
        reset_i    : in std_logic;
        sw_i       : in std_logic_vector(15 downto 0);
        pb_i       : in std_logic_vector(3 downto 0);
        ss_o       : out std_logic_vector(7 downto 0);
        ss_sel_o   : out std_logic_vector(3 downto 0);
        led_o      : out std_logic_vector(15 downto 0)
        );

end TOP;

architecture struct of TOP is

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

    component calc_ctrl
        port(
            clk_i      : in std_logic;
            reset_i    : in std_logic;
            swsync_i   : in std_logic_vector(15 downto 0);
            pbsync_i   : in std_logic_vector(3 downto 0);   
            finished_i : in std_logic;
            result_i   : in std_logic_vector(15 downto 0);
            sign_i     : in std_logic;
            overflow_i : in std_logic;
            error_i    : in std_logic;
            op1_o      : out std_logic_vector(11 downto 0);
            op2_o      : out std_logic_vector(11 downto 0);
            optyp_o    : out std_logic_vector(3 downto 0);
            start_o    : out std_logic;
            dig0_o     : out std_logic_vector(7 downto 0);
            dig1_o     : out std_logic_vector(7 downto 0);
            dig2_o     : out std_logic_vector(7 downto 0);
            dig3_o     : out std_logic_vector(7 downto 0);
            led_o      : out std_logic_vector(15 downto 0)
            );
    end component;

    component ALU
        port(
            clk_i      : in std_logic;
            reset_i    : in std_logic;
            op1_i      : in std_logic_vector(11 downto 0);
            op2_i      : in std_logic_vector(11 downto 0);
            optyp_i    : in std_logic_vector(3 downto 0);
            start_i    : in std_logic;
            finished_o : out std_logic;
            result_o   : out std_logic_vector(15 downto 0);
            sign_o     : out std_logic;
            overflow_o : out std_logic;
            error_o    : out std_logic
            );
    end component;

    -- io_ctrl
    signal pbsync : std_logic_vector(3 downto 0);
    signal led, swsync : std_logic_vector(15 downto 0);
    signal dig0, dig1, dig2, dig3 : std_logic_vector(7 downto 0);

    -- calc_ctrl
    signal op1, op2 : std_logic_vector(11 downto 0);
    signal optyp : std_logic_vector(3 downto 0);
    signal result : std_logic_vector(15 downto 0);
    signal start, finished, sign, overflow, error : std_logic;
    
begin


    i_io_ctrl : io_ctrl                     -- instantiate IO control unit
    port map(
            clk_i      => clk_i,
            reset_i    => reset_i,
            dig0_i     => dig0,
            dig1_i     => dig1,
            dig2_i     => dig2,
            dig3_i     => dig3,
            led_i      => led,
            sw_i       => sw_i,
            pb_i       => pb_i,
            ss_o       => ss_o,
            ss_sel_o   => ss_sel_o,
            led_o      => led_o,
            swsync_o   => swsync,
            pbsync_o   => pbsync           
            );

    i_calc_ctrl : calc_ctrl                 -- instantiate calculator control unit
    port map(
            clk_i      => clk_i,
            reset_i    => reset_i,
            swsync_i   => swsync,
            pbsync_i   => pbsync,
            finished_i => finished,
            result_i   => result,
            sign_i     => sign,
            overflow_i => overflow,
            error_i    => error,
            op1_o      => op1,
            op2_o      => op2,
            optyp_o    => optyp,
            start_o    => start,
            dig0_o     => dig0,
            dig1_o     => dig1,
            dig2_o     => dig2,
            dig3_o     => dig3,
            led_o      => led 
            );

    i_alu : alu                             -- instantiate ALU
    port map(
            clk_i      => clk_i,
            reset_i    => reset_i,
            op1_i      => op1,
            op2_i      => op2,
            optyp_i    => optyp,
            start_i    => start,
            finished_o => finished,
            result_o   => result,
            sign_o     => sign,
            overflow_o => overflow,
            error_o    => error            
            );
end struct;