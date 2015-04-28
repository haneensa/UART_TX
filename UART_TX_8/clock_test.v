
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity clock_test is
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



   --Inputs
   signal CLK_IN1 : std_logic;
   signal RESET : std_logic;

 	--Outputs
   signal CLK_OUT1 : std_logic;
   signal LOCKED : std_logic;
 
 
begin


U0 : clock66M
  port map
   (-- Clock in ports
    CLK_IN1 => CLK_IN1,
    -- Clock out ports
    CLK_OUT1 => CLK_OUT1,
    -- Status and control signals
    RESET  => RESET,
    LOCKED => LOCKED);

end Behavioral;

