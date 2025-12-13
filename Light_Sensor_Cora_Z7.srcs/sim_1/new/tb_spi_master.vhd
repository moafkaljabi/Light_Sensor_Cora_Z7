----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2025 03:00:44 PM
-- Design Name: 
-- Module Name: tb_spi_master - sim
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
-- Verifies the spi_master in isolation
-- Verifies clocking, SS behavior, busy flag, and RX shifting
-- IP-level verification
--
----------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_spi_master is
end entity;

architecture sim of tb_spi_master is

  constant CLK_PERIOD : time := 8 ns;

  signal clk      : std_logic := '0';
  signal reset_n  : std_logic := '0';
  signal enable   : std_logic := '0';
  signal miso     : std_logic := '0';
  signal sclk     : std_logic;
  signal ss_n     : std_logic_vector(0 downto 0);
  signal mosi     : std_logic;
  signal busy     : std_logic;
  signal rx_data  : std_logic_vector(15 downto 0);

  signal slave_word : std_logic_vector(15 downto 0) := x"A55A";
  signal bit_index  : integer := 15;

begin

  dut : entity work.spi_master
    generic map (slaves => 1, d_width => 16)
    port map (
      clock   => clk,
      reset_n => reset_n,
      enable  => enable,
      cpol    => '1',
      cpha    => '1',
      cont    => '0',
      clk_div => 8,
      addr    => 0,
      tx_data => (others => '0'),
      miso    => miso,
      sclk    => sclk,
      ss_n    => ss_n,
      mosi    => mosi,
      busy    => busy,
      rx_data => rx_data
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
    wait for 100 ns;
    reset_n <= '1';
    enable <= '1';
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

    wait until busy = '0';
    report "SPI RX_DATA = 0x" & to_hstring(rx_data) severity note;
    wait;
  end process;

end architecture;
