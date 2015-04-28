

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY UART_tb IS
END UART_tb;
 
ARCHITECTURE behavior OF UART_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_TOP
    PORT(
         usr_clk : IN  std_logic;
         reset : IN  std_logic;
         tx_en : IN  std_logic;
         Din : IN  std_logic_vector(7 downto 0);
         Tx : OUT  std_logic;
         LED : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal usr_clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tx_en : std_logic := '0';
   signal Din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Tx : std_logic;
   signal LED : std_logic_vector(1 downto 0);

   -- Clock period definitions 27MHz
   constant usr_clk_period : time := 37 ns; 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_TOP PORT MAP (
          usr_clk => usr_clk,
          reset => reset,
          tx_en => tx_en,
          Din => Din,
          Tx => Tx,
          LED => LED
        );

   -- Clock process definitions
   usr_clk_process :process
   begin
		usr_clk <= '0';
		wait for usr_clk_period/2;
		usr_clk <= '1';
		wait for usr_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
       wait for 300 ns;	
		 tx_en <= '1';
		 wait for usr_clk_period*50000;
		 tx_en <= '1';
		 wait for usr_clk_period*10;
		 tx_en <= '0';
		 wait for usr_clk_period*50000;
		 tx_en <= '1';
		 wait for usr_clk_period*10;
		 tx_en <= '0';
		 wait for usr_clk_period*50000;
		 tx_en <= '1';
		 wait for usr_clk_period*10;
		 tx_en <= '0';
		 wait for usr_clk_period*50000;
		 tx_en <= '1';
		 wait for usr_clk_period*10;
		 tx_en <= '0';
      wait;
   end process;

END;
