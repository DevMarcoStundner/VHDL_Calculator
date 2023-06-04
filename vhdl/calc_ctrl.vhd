-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: calc_ctrl.vhd
--
-- Date: 22.05.2023
--
-- Design Unit: Calculator Control Unit
--
-- Directory: cd C:/Users/marco/Desktop/FH/CHIP1/Calculator
--
-- Description: The Calculator Control Unit is part of the calculator project.
-- It provides two operands as well as the type of operation to the ALU
-- The results from the ALU as well as any special conditions will be evaluated by
-- the calculator control unit and forwarded to the IO control unit.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.LUT.all;

entity calc_ctrl is

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

end calc_ctrl;

architecture rtl of calc_ctrl is 

type calc_state is (OP1, OP2, OPTYPE, CALC, RESULT);
signal s_states : calc_state;
signal s_op1, s_op2  : std_logic_vector(11 downto 0);
signal s_optyp    : std_logic_vector(3 downto 0);

begin
    p_fsm_calc : process (clk_i, reset_i)
    begin
        if reset_i = '1' then   

        led_o(15) <= '1';                                     -- LED 15 should be on
        s_op1       <= (others => '0');                       -- OP1 and OP2 are zero and add shall be the type
        s_op1       <= (others => '0');
        s_optyp     <= (others => '0');
        -- Calc muss auch durchgeführt werden 
        if pbsync_i(BTNL) = '1' then
            s_states <= OP1;
        end if;

        elsif clk_i'event and clk_i = '1' then
            case s_states is

                when OP1 =>      -- Displays changes of SW0-SW11

                    led_o <= (others => '0');
                    dig3_o <= ss_symbols(21);                                                -- 1.
                    dig0_o <= ss_symbols(to_integer(unsigned(swsync_i(3 downto 0))));          -- SW0-SW3
                    dig1_o <= ss_symbols(to_integer(unsigned(swsync_i(7 downto 4))));          -- SW4-SW7  
                    dig2_o <= ss_symbols(to_integer(unsigned(swsync_i(11 downto 8))));         -- SW8-SW11

                    s_op1 <= swsync_i(11 downto 0);

                    if pbsync_i(BTNL) = '1' then
                        s_states <= OP1;

                    elsif pbsync_i(BTNC) = '1' then
                        s_states <= OP2;

                    elsif pbsync_i(BTNR) = '1' then
                        s_states <= OPTYPE;

                    end if;

                when OP2 =>      -- Displays changes of SW0-SW11

                    led_o <= (others => '0');
                    dig3_o <= ss_symbols(22);                                                -- 2.
                    dig0_o <= ss_symbols(to_integer(unsigned(swsync_i(3 downto 0))));          -- SW0-SW3
                    dig1_o <= ss_symbols(to_integer(unsigned(swsync_i(7 downto 4))));          -- SW4-SW7  
                    dig2_o <= ss_symbols(to_integer(unsigned(swsync_i(11 downto 8))));         -- SW8-SW11

                    s_op2 <= swsync_i(11 downto 0);

                    if pbsync_i(BTNL) = '1' then
                        s_states <= OP1;

                    elsif pbsync_i(BTNC) = '1' then
                        s_states <= OP2;

                    elsif pbsync_i(BTNR) = '1' then
                        s_states <= OPTYPE;

                    end if;

                when OPTYPE =>                  -- Displays changes of SW12-SW15

                    led_o <= (others => '0');
                    dig3_o <= ss_symbols(16);

                    if swsync_i(15 downto 12) = "0000" then         -- Add
                        dig2_o <= ss_symbols(10);
                        dig1_o <= ss_symbols(13);
                        dig0_o <= ss_symbols(13);

                    elsif swsync_i(15 downto 12) = "0010" then      -- Multiply
                        dig2_o <= ss_symbols(20);
                        dig1_o <= ss_symbols(23);
                        dig0_o <= ss_symbols(23);

                    elsif swsync_i(15 downto 12) = "1000" then      -- Logical NOT
                        dig2_o <= ss_symbols(17);
                        dig1_o <= ss_symbols(24);
                        dig0_o <= ss_symbols(23);

                    elsif swsync_i(15 downto 12) = "1011" then      -- Logical Ex-OR
                        dig2_o <= ss_symbols(14);
                        dig1_o <= ss_symbols(24);
                        dig0_o <= ss_symbols(19);

                    else                                            -- if OPTYPE not supported SS is dark
                        dig2_o <= ss_symbols(23);
                        dig1_o <= ss_symbols(23);
                        dig0_o <= ss_symbols(23);
                    
                    end if;

                    s_optyp <= swsync_i(15 downto 12);

                    if pbsync_i(BTNL) = '1' then
                        s_states <= OP1;

                    elsif pbsync_i(BTNC) = '1' then
                        s_states <= OP2;

                    elsif pbsync_i(BTNR) = '1' then
                        s_states <= OPTYPE;

                    elsif pbsync_i(BTND) = '1' then
                        start_o <= '1';
                        s_states <= CALC;

                    end if; 

                when CALC =>                    -- Calc should start if BNTD is pressed
                    start_o    <= '0';
                    op1_o      <= s_op1;
                    op2_o      <= s_op2;
                    optyp_o    <= s_optyp;
                    s_states   <= RESULT;

                when RESULT =>

                    if finished_i = '1' then

                        if error_i = '0' and overflow_i = '0' and sign_i = '0' then         -- Calc is valid
                            dig3_o <= ss_symbols(to_integer(unsigned(result_i(15 downto 12))));
                            dig2_o <= ss_symbols(to_integer(unsigned(result_i(11 downto 8))));
                            dig1_o <= ss_symbols(to_integer(unsigned(result_i(7 downto 4))));
                            dig0_o <= ss_symbols(to_integer(unsigned(result_i(3 downto 0))));
                            
                        elsif error_i = '0' and overflow_i = '0' and sign_i = '1' then      -- Calc is negativ
                            dig3_o <= ss_symbols(25);
                            dig2_o <= ss_symbols(to_integer(unsigned(result_i(11 downto 8))));
                            dig1_o <= ss_symbols(to_integer(unsigned(result_i(7 downto 4))));
                            dig0_o <= ss_symbols(to_integer(unsigned(result_i(3 downto 0))));
                            
                        elsif error_i = '0' and overflow_i = '1' then                       -- Overflow
                            dig3_o <= ss_symbols(24);
                            dig2_o <= ss_symbols(24);
                            dig1_o <= ss_symbols(24);
                            dig0_o <= ss_symbols(24);
                            
                        elsif error_i = '1' then                                            -- Calc error
                            dig3_o <= ss_symbols(14);
                            dig2_o <= ss_symbols(19);
                            dig1_o <= ss_symbols(19);
                            dig0_o <= ss_symbols(23);         

                        end if ;

                    end if;
                    if pbsync_i(BTNL) = '1' then
                        s_states <= OP1;
                    end if;
            end case;
        end if;
    end process;

end rtl;