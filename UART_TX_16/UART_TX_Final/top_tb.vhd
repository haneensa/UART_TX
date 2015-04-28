
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    COMPONENT TOP
    PORT(
         USR_CLK : IN  std_logic;
         RESET : IN  std_logic;
         TX_EN : IN  std_logic;
         Tx : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal USR_CLK : std_logic := '0';
   signal RESET : std_logic := '0';
   signal TX_EN : std_logic := '0';

 	--Outputs
   signal Tx : std_logic;

   -- Clock period definitions
   constant USR_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TOP PORT MAP (
          USR_CLK => USR_CLK,
          RESET => RESET,
          TX_EN => TX_EN,
          Tx => Tx
        );

   -- Clock process definitions
   USR_CLK_process :process
   begin
		USR_CLK <= '0';
		wait for USR_CLK_period/2;
		USR_CLK <= '1';
		wait for USR_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
       wait for 300 ns;	
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
		 wait for usr_clk_period*50000;
		 tx_en <= '1';
		 wait for usr_clk_period*10;
		 tx_en <= '0';
      wait;
   end process;

END;
