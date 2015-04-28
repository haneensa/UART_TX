library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY memory_tb IS
END memory_tb;
 
ARCHITECTURE behavior OF memory_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memory
    PORT(
         clka : IN  std_logic;
			ena : IN  std_logic;
         wea : IN  std_logic_vector(0 downto 0);
         addra : IN  std_logic_vector(9 downto 0);
         dina : IN  std_logic_vector(15 downto 0);
         douta : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clka : std_logic := '0';
	signal ena : std_logic := '0';
   signal wea : std_logic_vector(0 downto 0) := (others => '0');
   signal addra : std_logic_vector(9 downto 0) := (others => '0');
   signal dina : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal douta : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clka_period : time := 10 ns;
 
BEGIN
  

	-- Instantiate the Unit Under Test (UUT)
   uut: memory PORT MAP (
          clka => clka,   --clock for writing data to RAM.
			 ena => ena,   --Enable signal.
          wea => wea,  --Write enable signal for Port A.
          addra => addra, --4 bit address for the RAM.
          dina => dina, --8 bit data input to the RAM.
          douta => douta  --8 bit data output from the RAM.
        );

   -- Clock process definitions
   clka_process :process
   begin
		clka <= '0';
		wait for clka_period/2;
		clka <= '1';
		wait for clka_period/2;
   end process;
 
 
 
--Simulation process.
process
begin
   wait for clka_period;
    addra <= "0000000000";  --reset the address value for reading from memory location "0"
    --reading all the 16 memory locations in the BRAM.
    for i in 0 to 1023 loop
        ena <= '1';  --Enable RAM always.
        wea <= "0";
		  wait for 2*clka_period;
        addra <= addra + "1";
    end loop;
    wait;
end process;   
 
 

END;
