library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;


ENTITY clock_test_tb IS
END clock_test_tb;
 
ARCHITECTURE behavior OF clock_test_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_test
    PORT(
         clkin : IN  std_logic;
         clkout : OUT  std_logic;
         reset : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clkin : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal clkout : std_logic;
	
   -- Clock period definitions
   constant clkin_period : time := 37 ns; --27MHz
BEGIN
 
	-- Instantiate 
   uut: clock_test PORT MAP (
          clkin => clkin,
          clkout => clkout,
          reset => reset
        );

   -- Clock process definitions
   clkin_process :process
   begin
		clkin <= '0';
		wait for clkin_period/2;
		clkin <= '1';
		wait for clkin_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      wait;
   end process;

END;
