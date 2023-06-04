-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: alu.vhd
--
-- Date: 30.05.2023
--
-- Design Unit: Arithmetic Logic Unit
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
use ieee.numeric_std.all;


entity ALU is

    port (
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

end ALU;

architecture rtl of ALU is

signal s_result                  : std_logic_vector(15 downto 0);
signal s_optyp                   : std_logic_vector(3 downto 0);
signal s_finished                : std_logic;
signal counter                   : std_logic_vector(11 downto 0);


begin

    p_alu : process (clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_result   <= (others => '0');
            sign_o     <= '0';
            overflow_o <= '0';
            error_o    <= '0';
            s_finished <= '0';
            s_result   <= (others => '0');
            counter <= (others => '0');


        elsif clk_i'event and clk_i = '1' then
            
            if start_i = '1' then

                if s_optyp = "0000" then            -- Add
                    s_result(12 downto 0)    <=  std_logic_vector(("0" & unsigned(op1_i)) + ("0" & unsigned(op2_i)));
                    error_o     <= '0';
                    overflow_o  <= '0';
                    sign_o      <= '0';
                    s_finished  <= '1';

                elsif s_optyp = "0010" then         -- Multiply 
                        if counter = op2_i then
                            counter <= (others => '0');
                            sign_o     <= '0';
                            error_o    <= '0';
                            overflow_o <= '0';
                            s_finished <= '1';
                        else
                            if( s_result = "0001111111111110" and counter < op2_i) then
                                counter <= (others => '0');
                                overflow_o <= '1';
                                sign_o     <= '0';
                                error_o    <= '0';
                                s_finished <= '1';
                            else
                                s_result   <= std_logic_vector(unsigned(s_result) + ("0000" & unsigned(op1_i)));
                                counter   <= std_logic_vector(unsigned(counter) + 1);

                            end if;
                        end if;   

                elsif s_optyp = "1000" then         -- NOT
                    s_result   <= ("0000" & NOT(op1_i));
                    sign_o     <= '1';
                    error_o    <= '0';
                    overflow_o <= '0';
                    s_finished <= '1';

                elsif s_optyp = "1011" then         -- XOR
                    s_result   <= ("0000" & op1_i) XOR ("0000" & op2_i);
                    sign_o     <= '0';
                    error_o    <= '0';
                    overflow_o <= '0';
                    s_finished <= '1';

                else
                    sign_o     <= '0';
                    overflow_o <= '0';
                    error_o    <= '1';
                    s_finished <= '1';

                end if;
            else 
                s_finished <= '0';
            end if;
        end if;
    end process;

    s_optyp <= optyp_i;
    finished_o <= s_finished;
    result_o <= s_result;

end rtl;