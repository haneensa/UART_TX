library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;

entity baud_generator is
  port (
    clkin: in std_logic;                         -- 66MHz clock
    clkout: out std_logic;                       -- 9600Hz clock
	 reset : IN  std_logic
  );
end baud_generator;

architecture Behavioral of baud_generator is

-- Counter that keeps track of the number of clock cycles 
signal Counter: std_logic_vector(12 downto 0):=(others => '0');
-- combinatorial logic that goes high when counter == 27M/9600
signal temp: std_logic:='0';

-- ------------------------------
-- Baud Generator
-- ------------------------------
begin 
Prescaler: process(clkin, reset)
	begin
		if reset = '1' then
			temp <= '0';
			Counter <= (others => '0');
		elsif rising_edge(clkin) then
				temp <= '0';
			if Counter = "1101011011011" then
				temp <= '1';
				Counter <= (others => '0');
			else
				Counter <= Counter + 1;
			end if;
		end if;
	end process Prescaler;
	
	clkout <= temp;
	
end Behavioral;