----------------------------------------------------------------------------------
-- Company: Astraspecs
-- Engineer: Moafk Aljabi
--
-- 
-- Create Date: 12/13/2025 01:37:26 PM
-- Design Name: 
-- Module Name: tb_ambient_light_sensor - Behavioral
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
----------------------------------------------------------------------------------




LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_ambient_light_sensor IS
END tb_ambient_light_sensor;

ARCHITECTURE sim OF tb_ambient_light_sensor IS

    --------------------------------------------------------------------------
    -- Constants
    --------------------------------------------------------------------------
    CONSTANT CLK_PERIOD : TIME := 8 ns;   -- 125 MHz system clock

    --------------------------------------------------------------------------
    -- DUT Signals
    --------------------------------------------------------------------------
    SIGNAL clk       : STD_LOGIC := '0';
    SIGNAL reset_n   : STD_LOGIC := '0';
    SIGNAL miso      : STD_LOGIC := '0';
    SIGNAL sclk      : STD_LOGIC;
    SIGNAL ss_n      : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL als_data  : STD_LOGIC_VECTOR(7 DOWNTO 0);

    --------------------------------------------------------------------------
    -- SPI Slave Model Signals
    --------------------------------------------------------------------------
    SIGNAL spi_slave_data : STD_LOGIC_VECTOR(15 DOWNTO 0)
                            := x"5A3C";   -- example sensor data
    SIGNAL bit_index      : INTEGER RANGE 0 TO 15 := 15;

BEGIN

    --------------------------------------------------------------------------
    -- DUT Instantiation
    --------------------------------------------------------------------------
    DUT : ENTITY work.ambient_light_sensor
        PORT MAP (
            clk      => clk,
            reset_n  => reset_n,
            miso     => miso,
            sclk     => sclk,
            ss_n     => ss_n,
            als_data => als_data
        );

    --------------------------------------------------------------------------
    -- Clock Generator (125 MHz)
    --------------------------------------------------------------------------
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR CLK_PERIOD / 2;
            clk <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
    END PROCESS;

    --------------------------------------------------------------------------
    -- Reset Sequence
    --------------------------------------------------------------------------
    reset_process : PROCESS
    BEGIN
        reset_n <= '0';
        WAIT FOR 100 ns;
        reset_n <= '1';
        WAIT;
    END PROCESS;

    --------------------------------------------------------------------------
    -- SPI Slave Emulation (MISO Driver)
    --
    -- SPI Mode: CPOL=1, CPHA=1
    -- Data is driven on falling edge of SCLK
    --------------------------------------------------------------------------
    spi_slave_process : PROCESS
    BEGIN
        WAIT UNTIL reset_n = '1';

        -- Wait for chip select to assert
        WAIT UNTIL ss_n(0) = '0';

        bit_index <= 15;

        WHILE ss_n(0) = '0' LOOP
            -- Wait for falling edge of SPI clock
            WAIT UNTIL falling_edge(sclk);

            miso <= spi_slave_data(bit_index);

            IF bit_index = 0 THEN
                bit_index <= 15;
            ELSE
                bit_index <= bit_index - 1;
            END IF;
        END LOOP;

        miso <= '0';
        WAIT;
    END PROCESS;

    --------------------------------------------------------------------------
    -- Monitor Process 
    --------------------------------------------------------------------------
    monitor_process : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(clk);

        IF ss_n(0) = '1' THEN
            REPORT "ALS Data Output = " &
                   INTEGER'image(to_integer(unsigned(als_data)))
                   SEVERITY NOTE;
        END IF;
    END PROCESS;

END sim;

