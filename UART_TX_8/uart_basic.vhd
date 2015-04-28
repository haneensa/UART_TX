library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;
              				
ENTITY BASIC_UART is
  PORT(
		  CLK 				: IN STD_LOGIC;
		  -- High-Active Asynchronous Reset
		  RESET 				: IN STD_LOGIC;
		  -- byte to send
		  TX_DATA 			: IN STD_LOGIC_VECTOR(7 downto 0);
		  -- validates byte to send if tx_ready is '1'
		  TX_ENABLE 		: IN std_logic; 
		  -- Physical interface        
		  Tx  				: OUT std_logic;
		  READY 				: OUT std_logic;
		  ADDRout			: out std_logic_vector(3 downto 0);
		  FFLAG				: out std_logic
		);
END BASIC_UART;

ARCHITECTURE Behavioral OF basic_uart IS

COMPONENT BAUD_GENERATOR 
	PORT(
		CLKIN : IN std_logic;          
		CLKOUT : OUT std_logic;
		RESET : IN  std_logic
		);
END COMPONENT;
	 
----------------------------------------------------------------------------
-- Transmitter Signals
----------------------------------------------------------------------------
type    uart_tx_states is ( idle,
                            wait_for_tick,
                            send_start_bit,
                            transmit_data,
                            send_stop_bit);

signal  uart_tx_state       : uart_tx_states := idle;

signal  uart_tx_data_block  : std_logic_vector(7 downto 0) := (others => '0');
signal  uart_tx_data        : std_logic := '1';
signal  uart_tx_count       : std_logic_vector(3 downto 0) := (others => '0');

 
signal  addrBuff       : std_logic_vector(3 downto 0) := (others => '0');
signal  baudtick : std_logic := '0';

-- Counter For Two frames
signal  Fcounter       :  std_logic := '0';

----------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------
pure function shift_right_by_one (        -- Shift right by 1, fill with new bit
      constant shift : in std_logic_vector(7 downto 0);  -- Signal to shift
      constant fill  : in std_ulogic)                    -- New bit 7
      return std_logic_vector is
      variable ret : std_logic_vector(7 downto 0);
		begin  -- function shift_right_by_one
      ret(7) := fill;
      ret(6 downto 0) := shift (7 downto 1);
      return ret;
end function shift_right_by_one;

-- Begin Body
begin

U0: BAUD_GENERATOR 
PORT MAP(
			CLKIN => clk,
			CLKOUT => baudtick,
			RESET => reset); 
	 
----------------------------------------------------------------------------
-- Transmitter Part: Sending Data
----------------------------------------------------------------------------
TX                  <= uart_tx_data;

-- Get data from TX_DATA and send it one bit at a time
-- upon each BAUD tick. LSB first.
-- Wait 1 tick, Send Start Bit (0), Send Data 0-7, Send Stop Bit (1)
UART_SEND_DATA :    process(clk, RESET)
begin
	if RESET = '1' then
		READY <= '1';
		Fcounter <= '0';
		uart_tx_data            <= '1';
		uart_tx_data_block      <= (others => '0');
		uart_tx_count           <= (others => '0');
		uart_tx_state           <= idle;
		addrBuff                 <= (others => '0');
	elsif rising_edge(clk) then
		case uart_tx_state is
			when idle =>
				if TX_ENABLE = '1' then
					READY <= '0';
					uart_tx_data_block  <=  tx_data;
					uart_tx_state       <= wait_for_tick;
				end if;
			when wait_for_tick =>
				if baudtick = '1' then
					uart_tx_state   <= send_start_bit;
				end if;
			when send_start_bit =>
				if baudtick = '1' then
					uart_tx_data    <= '0';
					uart_tx_state   <= transmit_data;
				end if;
			when transmit_data =>
				if baudtick = '1' then
					-- Send next bit
					uart_tx_data    <=  uart_tx_data_block(0);
					-- Shift for next transmit bit, filling with don't care
					-- Xilinx ISE does not know srl? So just build it ourself, hehe
					-- uart_tx_data_block <=  uart_tx_data_block srl 1;
					uart_tx_data_block <= shift_right_by_one(uart_tx_data_block, '-');
					if uart_tx_count = 7 then  -- binary 111
						-- We're done, move to next state
						uart_tx_state   <= send_stop_bit;
					else
						-- Stay in current state
						uart_tx_state   <= transmit_data;
					end if;
					-- Always increment here, will go to zero if we're out
					uart_tx_count   <= uart_tx_count + 1;
				end if;
			when send_stop_bit =>
				if baudtick = '1' then
					READY <= '1';
					uart_tx_data <= '1';
					uart_tx_state <= idle;
					if (Fcounter = '1') then
						FFLAG <= '1';
						addrBuff <= addrBuff + '1';
						Fcounter <= '0';
					else
						FFLAG <= '0';
						Fcounter <= '1';
					end if;
				end if;
			when others =>
				READY <= '1';
				uart_tx_data <= '1';
				uart_tx_state <= idle;
			end case;
		end if;
end process UART_SEND_DATA;
	
ADDRout <= addrBuff;

end Behavioral;