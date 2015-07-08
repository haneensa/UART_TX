----------------------------------------------------------------------------------
-- Engineer: Haneen Mohammed
-- Module Name:    clock_test - Behavioral 
-- Project Name: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;

 
entity clock_test is
port (
    clkin: in std_logic;                         -- 27MHz clock
    clkout: out std_logic;                        -- 9600Hz clock
	 reset: in std_logic
  );
end clock_test;

architecture Behavioral of clock_test is

component clock66M
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end component;

  
 	--Outputs
   signal CLK_OUT1 : std_logic;
   signal LOCKED : std_logic;
 
 
 COMPONENT baud_generator
	PORT(
		clkin : IN std_logic;          
		clkout : OUT std_logic;
		reset : IN  std_logic
		);
	END COMPONENT;
	
	 
begin

U0 : clock66M
  port map
   (-- Clock in ports
    CLK_IN1 => clkin,
    -- Clock out ports
    CLK_OUT1 => CLK_OUT1,
    -- Status and control signals
    RESET  => reset,
    LOCKED => LOCKED);
	 
U1: baud_generator PORT MAP(
		clkin => CLK_OUT1,
		clkout => clkout,
		reset => reset
	); 

end Behavioral;
