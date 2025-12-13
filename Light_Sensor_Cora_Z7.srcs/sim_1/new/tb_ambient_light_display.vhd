----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2025 02:45:35 PM
-- Design Name: 
-- Module Name: tb_ambient_light_display - sim
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-- ambient_light_display_tb.vhd
-- Full system test: SPI => sensor => scaling => 7-segment display.
-- Final TB of the system
--
----------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ambient_light_display_tb is
end entity;

architecture sim of ambient_light_display_tb is

  constant CLK_PERIOD : time := 10 ns;

  signal clk       : std_logic := '0';
  signal reset_n   : std_logic := '0';
  signal miso      : std_logic := '0';
  signal sclk      : std_logic;
  signal ss_n      : std_logic_vector(0 downto 0);
  signal seg_out   : std_logic_vector(6 downto 0);
  signal digit_sel : std_logic_vector(1 downto 0);

  signal slave_word : std_logic_vector(15 downto 0) := x"0B40";
  signal bit_index  : integer := 15;

begin

  dut : entity work.ambient_light_display
    port map (
      clk       => clk,
      reset_n   => reset_n,
      miso      => miso,
      sclk      => sclk,
      ss_n      => ss_n,
      seg_out   => seg_out,
      digit_sel => digit_sel
    );

  clk_gen : process
  begin
    while true loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
  end process;

  reset_proc : process
  begin
    reset_n <= '0';
    wait for 200 ns;
    reset_n <= '1';
    wait;
  end process;

  spi_slave : process
  begin
    wait until ss_n(0) = '0';
    bit_index <= 15;

    while ss_n(0) = '0' loop
      wait until falling_edge(sclk);
      miso <= slave_word(bit_index);
      bit_index <= bit_index - 1;
    end loop;

    wait;
  end process;

end architecture;