-------------------------------------------------------------------------------
--
-- Author: Marco Stundner
--
-- Filename: io_ctrl.vhd
--
-- Date: 17.05.2023
--
-- Design Unit: IO Control Unit 
--
-- Description: The IO Control unit is part of the calculator project.
-- It manages the interface to the 7-segment displays,
-- the LEDs, the push buttons and the switches of the
-- Digilent Basys3 FPGA board.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity io_ctrl is

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

end io_ctrl;

architecture rtl of io_ctrl is

    constant ENCOUNTVAL : integer:= 100000;
    constant C_ENCOUNTVAL : std_logic_vector(16 downto 0):= "11000011010100000";


    signal s_tick : std_logic_vector(16 downto 0);

    signal s_enctr  : integer := 0;
    signal s_1khzen : std_logic;
    signal swsync   : std_logic_vector(15 downto 0);
    signal pbsync   : std_logic_vector(3 downto 0);
    signal s_ss_sel : std_logic_vector(3 downto 0);
    signal s_ss     : std_logic_vector(7 downto 0);

begin

    -------------------------------------
    -- Generate 1 kHz enable signal
    -------------------------------------
    p_slowen: process (clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_1khzen <= '0';
            s_enctr <= 0;
        elsif clk_i'event and clk_i = '1' then
            if s_enctr = ENCOUNTVAL then
                s_1khzen <= '1';
                s_enctr <= 0;
            else
                s_enctr <= s_enctr + 1;
                s_1khzen <= '0';
            end if;
        end if;
    end process p_slowen;

    -------------------------------------
    -- Debounce buttons and switches
    -------------------------------------
    p_debounce: process (clk_i, reset_i)
    begin
        if reset_i = '1' then
            s_tick <= "00000000000000000";
        elsif clk_i'event and clk_i = '1' then
            if pb_i(0) = '1' then                                               -- if button pushed counter starts
                s_tick <= std_logic_vector(unsigned(s_tick)+1);
                if s_tick = C_ENCOUNTVAL and pb_i(0) = '1' then                  -- if button is still pushed safe input signal
                    pbsync(0) <= pb_i(0);
                    s_tick <= "00000000000000000";
                elsif s_tick = C_ENCOUNTVAL and pb_i(0) = '0' then               -- if not reset counter
                    s_tick <= "00000000000000000";
                end if;
                    
            elsif pb_i(1) = '1' then
                s_tick <= std_logic_vector(unsigned(s_tick)+1);
                if s_tick = C_ENCOUNTVAL and pb_i(1) = '1' then
                    pbsync(1) <= pb_i(1);
                    s_tick <= "00000000000000000";
                elsif s_tick = C_ENCOUNTVAL and pb_i(1) = '0' then
                    s_tick <= "00000000000000000";
                end if;

            elsif pb_i(2) = '1' then
                s_tick <= std_logic_vector(unsigned(s_tick)+1);
                if s_tick = C_ENCOUNTVAL and pb_i(2) = '1' then
                    pbsync(2) <= pb_i(2);
                    s_tick <= "00000000000000000";
                elsif s_tick = C_ENCOUNTVAL and pb_i(2) = '0' then
                    s_tick <= "00000000000000000";
                end if;

            elsif pb_i(3) = '1' then
                s_tick <= std_logic_vector(unsigned(s_tick)+1);
                if s_tick = C_ENCOUNTVAL and pb_i(3) = '1' then
                    pbsync(3) <= pb_i(3);
                    s_tick <= "00000000000000000";
                elsif s_tick = C_ENCOUNTVAL and pb_i(3) = '0' then
                    s_tick <= "00000000000000000";
                end if;

            end if;
        end if;
    end process p_debounce; 

    swsync_o <= swsync;
    pbsync_o <= pbsync;
            
    ------------------------------------------------
    -- Display controller for the 7-segment display
    ------------------------------------------------
    p_display_ctrl: process (s_1khzen, reset_i)
    begin
        if reset_i = '1' then
            s_ss_sel <= "0000";
            elsif s_1khzen'event and s_1khzen = '1' then
                if s_ss_sel = "0000" then
                    s_ss <= dig0_i;
                    s_ss_sel <= "0010";
                elsif s_ss_sel = "0010" then
                    s_ss <= dig1_i;
                    s_ss_sel <= "0011";
                elsif s_ss_sel = "0011" then
                    s_ss <= dig2_i;
                    s_ss_sel <= "0100";
                elsif s_ss_sel = "0100" then
                    s_ss <= dig3_i;
                    s_ss_sel <= "0000";
                end if;                
        end if;
    end process p_display_ctrl;

    ss_o <= s_ss;
    ss_sel_o <= s_ss_sel;

    ------------------------------------------------
    -- Handle LEDs
    ------------------------------------------------
    led_o <= led_i;

end rtl;

    
        

