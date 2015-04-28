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
					CLK	: IN  STD_LOGIC;
				   RESET 	: IN STD_LOGIC;
				   TX_EN		: IN STD_LOGIC;
			      Din		: IN STD_LOGIC_VECTOR(15 downto 0);
				   ADDRout		: OUT STD_LOGIC_VECTOR(9 downto 0);
					Tx 		: OUT STD_LOGIC;
					LED		: OUT STD_LOGIC_VECTOR(1 downto 0)
		);
END UART_TOP;

architecture Behavioral of UART_TOP is

-- -------------------------------------
-- Components declaration
-- -------------------------------------

COMPONENT BASIC_UART
	PORT(
		  CLK 				: IN STD_LOGIC;
		  RESET 				: IN STD_LOGIC;
		  TX_DATA 			: IN STD_LOGIC_VECTOR(7 downto 0);
		  TX_ENABLE 		: IN STD_LOGIC;         
		  Tx  				: OUT STD_LOGIC;
		  READY 				: OUT STD_LOGIC;
		  ADDRout			: out std_logic_vector(9 downto 0);
		  FFLAG				: out std_logic
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

begin
-- -------------------------------------
-- Components Instintiation
-- -------------------------------------

U1: basic_uart PORT MAP(
		clk => CLK,	
		reset => RESET,
		tx_data => tx_data ,
		tx_enable => tx_en,
		tx => Tx,
		ready => ready,
		addrout => addrout,
		fflag => fflag
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
			tx_data <=  Din(7 downto 0);  --- send first frame
		else
			tx_data <=  Din(15 downto 8); --- send second frame
		end if;
	end if;
end process;	
end Behavioral;