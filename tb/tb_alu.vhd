-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: alu.vhd
--
-- Date: 30.05.2023
--
-- Design Unit: Arithmetic Logic Unit Tesbench
--
-- Directory: cd C:/Users/marco/Desktop/FH/CHIP1/Calculator/sim
--
-- Description: The Arithmetic Logic Unit is part of the calculator project.
-- The ALU performs the selected operation and sends back the result 
-- as well as any special conditions (calculation, error, overflow ...) 
-- to the calculator control unit.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.LUT.all;

entity tb_alu is
    end tb_alu;

architecture sim of tb_alu is

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

    signal clk_i, reset_i, start_i                  : std_logic := '0';    
    signal op1_i, op2_i                             : std_logic_vector(11 downto 0) := (others => '0');
    signal optyp_i                                  : std_logic_vector(3 downto 0);
    signal result_o                                 : std_logic_vector(15 downto 0);
    signal finished_o, sign_o, overflow_o, error_o  : std_logic;

begin

    tb_alu_p : ALU
    port map(
            clk_i      => clk_i,
            reset_i    => reset_i,
            op1_i      => op1_i,
            op2_i      => op2_i,
            optyp_i    => optyp_i,
            start_i    => start_i,
            finished_o => finished_o,
            result_o   => result_o,
            sign_o     => sign_o,
            overflow_o => overflow_o,
            error_o    => error_o
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

    optyp_p : process
    begin
        op1_i <= "111111111111";
        op2_i <= "111111111111";

         -- optyp_i <= "0000";
        -- wait for 50 ns;

        optyp_i <= "0010";
        wait for 50 ns;

        --optyp_i <= "1000";
        --wait for 50 ns;

        --optyp_i <= "1011";
        --wait for 50 ns;
        wait;
    end process;

    start_p : process
    begin
        start_i <= '1';
        wait for 10 ns;

        start_i <= '0';
        wait for 50 ns;

    end process;


end sim;