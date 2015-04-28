library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
 
entity adress_manager is
  port (
    flag: in std_logic;   
    baudtick: in std_logic;  	 
    addr: out std_logic;                    
	 reset : IN  std_logic
  );
end adress_manager;

architecture Behavioral of adress_manager is

 signal Counter: std_logic_vector(12 downto 0):=(others => '0');
 signal temp: std_logic:='0';
 
begin 
Prescaler: process(clkin, reset)
	begin
		if reset = '1' then
			Counter <= (others => '0');
		elsif rising_edge(clkin) then
			if Counter = "1101011011011" then
				Counter <= (others => '0');
			else
				Counter <= Counter + 1;
			end if;
		end if;
	end process Prescaler;
	
clkout <= temp;

end Behavioral;