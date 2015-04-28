library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
PORT(
		USR_CLK : IN std_logic;  --pin   
		RESET : IN std_logic;  --pin   
		TX_EN : IN std_logic;       --pin   
		Tx : OUT std_logic  -- pin
		);
end TOP;

architecture Behavioral of TOP is

COMPONENT CLOCK66M
	PORT(
		  CLK_IN1         : IN STD_LOGIC;
		  CLK_OUT1        : OUT STD_LOGIC;
		  RESET           : IN STD_LOGIC;
		  LOCKED          : OUT STD_LOGIC
		);
END COMPONENT;

COMPONENT UART_TOP
	PORT(
		CLK : IN std_logic;
		RESET : IN std_logic;
		TX_EN : IN std_logic;
		Din : IN std_logic_vector(15 downto 0); 
	   ADDRout		: OUT STD_LOGIC_VECTOR(9 downto 0);		
		Tx : OUT std_logic;
		LED : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

COMPONENT MEMORY
    PORT(
			clka 				: IN  STD_LOGIC;
			ena 				: IN  STD_LOGIC;
         wea 				: IN  STD_LOGIC_VECTOR(0 downto 0);
         addra 			: IN  STD_LOGIC_VECTOR(9 downto 0);
         dina 				: IN  STD_LOGIC_VECTOR(15 downto 0);
         douta				: OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    END COMPONENT;

-- Memory signal Inputs
signal ena 					: std_logic := '1';
signal wea 					: std_logic_vector(0 downto 0) := (others => '0');
signal addrout 			: std_logic_vector(9 downto 0);
signal dina 				: std_logic_vector(15 downto 0) := (others => '0');

-- Memory signal Outputs
signal douta 				: std_logic_vector(15 downto 0);
signal led 				: std_logic_vector(1 downto 0);

-- clock66M signal Outputs
signal CLK_OUT1 			: std_logic;
signal LOCKED				: std_logic;

begin

U0 : clock66M
  port map
   ( 
    CLK_IN1 => usr_clk,
    CLK_OUT1 => CLK_OUT1,
    RESET  => RESET,
    LOCKED => LOCKED
	 );
	
U1: UART_TOP PORT MAP(
		CLK => CLK_OUT1,
		RESET => RESET,
		TX_EN => TX_EN,
		Din => douta,
		ADDRout => addrout,
		Tx => Tx,
		LED => led
	);
	
U2: memory PORT MAP (
      clka => CLK_OUT1,   --clock for writing data to RAM.
		ena => ena,   --Enable signal.
      wea => wea,  --Write enable signal for Port A.
      addra => ADDRout, --4 bit address for the RAM.
      dina => dina, --8 bit data input to the RAM.
      douta => douta  --8 bit data output from the RAM.
    );
	 
end Behavioral;