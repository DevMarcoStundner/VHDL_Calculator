-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: tb_calc_ctrl.vhd
--
-- Date: 22.05.2023
--
-- Design Unit: Calculator Control Unit Testbench
--
-- Description: The Calculator Control Unit is part of the calculator project.
-- It provides two operands as well as the type of operation to the ALU
-- The results from the ALU as well as any special conditions will be evaluated by
-- the calculator control unit and forwarded to the IO control unit.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.LUT.all;

entity tb_calc_ctrl is
end tb_calc_ctrl;

architecture sim of tb_calc_ctrl is

    component calc_ctrl
        port(
            clk_i      : in std_logic;
            reset_i    : in std_logic;
            swsync_i   : in std_logic_vector(15 downto 0);
            pbsync_i   : in std_logic_vector(3 downto 0);   -- BTNL, BTNC, BTNR, BTND
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

    signal clk_i, reset_i                                   : std_logic := '0';    
    signal result_i, led_o, swsync_i                        : std_logic_vector(15 downto 0);
    signal dig0_o, dig1_o, dig2_o, dig3_o                   : std_logic_vector(7 downto 0);
    signal pbsync_i, optyp_o                                : std_logic_vector(3 downto 0);
    signal op1_o, op2_o                                     : std_logic_vector(11 downto 0);
    signal finished_i, sign_i, overflow_i, error_i, start_o : std_logic := '0';

begin

    tb_calc_ctrl_p : calc_ctrl
    port map(
            clk_i      => clk_i,
            reset_i    => reset_i,
            dig0_o     => dig0_o,
            dig1_o     => dig1_o,
            dig2_o     => dig2_o,
            dig3_o     => dig3_o,
            led_o      => led_o,
            swsync_i   => swsync_i,
            result_i   => result_i,
            pbsync_i   => pbsync_i,
            optyp_o    => optyp_o,
            op1_o      => op1_o,
            op2_o      => op2_o,
            finished_i => finished_i,
            sign_i     => sign_i,
            overflow_i => overflow_i,
            error_i    => error_i,
            start_o    => start_o
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

    FSM_p : process
        begin
            wait for 20 ns;
            pbsync_i <= (others => '0');

            pbsync_i(BTNL) <= '1';
            wait for 1 us;
            pbsync_i(BTNL) <= '0';
            wait for 50 ns;

            pbsync_i(BTNC) <= '1';
            wait for 1 us;
            pbsync_i(BTNC) <= '0';
            wait for 50 ns;

            pbsync_i(BTNR) <= '1';
            wait for 1 us;
            pbsync_i(BTNR) <= '0';
            wait for 50 ns;

    end process;

    SW_P : process
        begin
            swsync_i(11 downto 0)  <= "000000001111";      -- F 
            swsync_i(15 downto 12) <= "1000"; -- NOT
            wait;
    end process;

end sim;