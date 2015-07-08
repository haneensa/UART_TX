----------------------------------------------------------------------------------
-- Module Name:    UART_TOP 
-- Project Name: 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 
 
ENTITY UART_TOP IS
		PORT ( 
					USR_CLK	: IN  STD_LOGIC;
				   RESET 	: IN STD_LOGIC;
				   TX_EN		: IN STD_LOGIC;
			      Din		: IN STD_LOGIC_VECTOR(7 downto 0);
					Tx 		: OUT STD_LOGIC;
					LED		: OUT STD_LOGIC_VECTOR(1 downto 0)
		);
END UART_TOP;

architecture Behavioral of UART_TOP is

-- -------------------------------------
-- Components declaration
-- -------------------------------------
COMPONENT CLOCK66M
	PORT(
		  CLK_IN1         : IN STD_LOGIC;
		  CLK_OUT1        : OUT STD_LOGIC;
		  RESET           : IN STD_LOGIC;
		  LOCKED          : OUT STD_LOGIC
		);
END COMPONENT;

COMPONENT BASIC_UART
	PORT(
		  CLK 				: IN STD_LOGIC;
		  RESET 				: IN STD_LOGIC;
		  TX_DATA 			: IN STD_LOGIC_VECTOR(7 downto 0);
		  TX_ENABLE 		: IN STD_LOGIC;         
		  Tx  				: OUT STD_LOGIC;
		  READY 				: OUT STD_LOGIC;
		  ADDRout			: out STD_LOGIC_VECTOR(3 downto 0);
		  FFLAG				: out STD_LOGIC
		);
END COMPONENT;	

COMPONENT MEMORY
    PORT(
			clka 				: IN  STD_LOGIC;
			ena 				: IN  STD_LOGIC;
         wea 				: IN  STD_LOGIC_VECTOR(0 downto 0);
         addra 			: IN  STD_LOGIC_VECTOR(3 downto 0);
         dina 				: IN  STD_LOGIC_VECTOR(15 downto 0);
         douta				: OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    END COMPONENT;

-- -------------------------------------
-- Signals declaration
-- -------------------------------------

-- BASIC_UART signal Inputs
signal tx_data 			: std_logic_vector(7 downto 0):= (others => '0');  
signal tx_enable 			: std_logic:= '0';         
-- BASIC_UART signal Outputs         
signal ready 				: std_logic; 
signal fflag 				: std_logic; 

-- clock66M signal Outputs
signal CLK_OUT1 			: std_logic;
signal LOCKED				: std_logic;

-- Memory signal Inputs
signal clka 				: std_logic := '0';
signal ena 					: std_logic := '1';
signal wea 					: std_logic_vector(0 downto 0) := (others => '0');
signal addrout 			: std_logic_vector(3 downto 0);
signal dina 				: std_logic_vector(15 downto 0) := (others => '0');

-- Memory signal Outputs
signal douta 				: std_logic_vector(15 downto 0);

  
begin
-- -------------------------------------
-- Components Instintiation
-- -------------------------------------
U0 : clock66M
  port map
   ( 
    CLK_IN1 => usr_clk,
    CLK_OUT1 => CLK_OUT1,
    RESET  => reset,
    LOCKED => LOCKED
	 );
	
U1: basic_uart PORT MAP(
		clk => CLK_OUT1,	
		reset => reset,
		tx_data => tx_data ,
		tx_enable => tx_en,
		tx => Tx,
		ready => ready,
		addrout => addrout,
		fflag => fflag
	);
	
U3: memory PORT MAP (
      clka => CLK_OUT1,   --clock for writing data to RAM.
		ena => ena,   --Enable signal.
      wea => wea,  --Write enable signal for Port A.
      addra => addrout, --4 bit address for the RAM.
      dina => dina, --8 bit data input to the RAM.
      douta => douta  --8 bit data output from the RAM.
    );
	 
-- -------------------------------------
-- Processes
-- ------------------------------------
	
process (reset, tx_en, ready)
begin
	LED(1)<= tx_en;
   LED(0)<= reset;	
	if (reset='1') then
		LED(0)<= reset;
	elsif (tx_en='1') and (ready = '1')   then
		LED(1)<= tx_en;
		if (fflag = '0') then 
			tx_data <=  douta(7 downto 0);  --- send first frame
		else
			tx_data <=  douta(15 downto 8); --- send second frame
		end if;
	end if;
end process;	
end Behavioral;