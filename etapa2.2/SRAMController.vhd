library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
	
entity SRAMController is 
	port (clk			: in  std_logic;  
			SRAM_ADDR 	: out std_logic_vector(17 downto 0);
			SRAM_DQ 		: inout std_logic_vector(15 downto 0);
			SRAM_UB_N 	: out std_logic;
			SRAM_LB_N 	: out std_logic;
			SRAM_CE_N 	: out std_logic := '1';
			SRAM_OE_N 	: out std_logic := '1';
			SRAM_WE_N 	: out std_logic := '1';
		
			address		: in  std_logic_vector(15 downto 0) := "0000000000000000";
			dataReaded	: out std_logic_vector(15 downto 0);
			dataToWrite	: in  std_logic_vector(15 downto 0);
			WR				: in  std_logic;
			byte_m		: in  std_logic := '0'
			);
end SRAMController;

architecture comportament of SRAMController is
	type state_type is(RD,WR0,WR1);
	
	SIGNAL estado : state_type := RD;
	SIGNAL valor : std_logic_vector(15 downto 0);

begin
   --0xFFFF nuestra mem
	--0x0FFFF -- tamaño SRAM
	
	SRAM_ADDR <=  "000" & address(15 DOWNTO 1);
	
	PROCESS(clk)
	BEGIN 
		IF rising_edge(clk) THEN
			IF estado = WR0 THEN
				estado <= WR1;
			ELSIF WR = '1' THEN
				estado <= WR0;
			ELSE 
				estado <= RD;
			END IF;
			
		END IF;
	END PROCESS;
	
	SRAM_CE_N 	<= '0';
	SRAM_OE_N 	<= '0';
	
	
	--READ
	SRAM_UB_N 	<= '0' WHEN estado = RD ELSE
						'1' WHEN estado = WR0 and address(0) = '0' and byte_m = '1' ELSE
						'0' WHEN estado = WR0 and address(0) = '1' and byte_m = '1' ELSE
						'1' WHEN estado = WR1 and address(0) = '0' and byte_m = '1' ELSE
						'0' WHEN estado = WR1 and address(0) = '1' and byte_m = '1' ELSE
						'0';
						
	SRAM_LB_N <= '0' WHEN estado = RD ELSE
					 '0' WHEN estado = WR0 and address(0) = '0' and byte_m = '1' ELSE
					 '1' WHEN estado = WR0 and address(0) = '1' and byte_m = '1' ELSE
					 '0' WHEN estado = WR1 and address(0) = '0' and byte_m = '1' ELSE
					 '1' WHEN estado = WR1 and address(0) = '1' and byte_m = '1' ELSE
					 '0';

	SRAM_WE_N 	<= '1' WHEN estado = RD ELSE
						'0' WHEN estado = WR0 ELSE
						'1' WHEN estado = WR1 ELSE
						'1';
	
	dataReaded <= std_logic_vector(resize(signed(SRAM_DQ(7 DOWNTO 0)),dataReaded'length)) WHEN estado = RD and byte_m = '1' and address(0) = '0' ELSE
						std_logic_vector(resize(signed(SRAM_DQ(15 DOWNTO 8)),dataReaded'length)) WHEN estado = RD and byte_m = '1' and address(0) = '1' ELSE
						SRAM_DQ	 WHEN estado = RD;
	

	
	--SRAM_DQ <= dataToWrite WHEN estado = WR0;
	SRAM_DQ <= "ZZZZZZZZZZZZZZZZ" WHEN estado = RD ELSE
					dataToWrite(7 DOWNTO 0) & X"00" WHEN estado = WR0 and address(0) = '1' and byte_m = '1' ELSE
					X"00" & dataToWrite(7 DOWNTO 0) WHEN estado = WR0 and address(0) = '0' and byte_m = '1' ELSE
					dataToWrite(7 DOWNTO 0) & X"00" WHEN estado = WR1 and address(0) = '1' and byte_m = '1' ELSE
					X"00" & dataToWrite(7 DOWNTO 0) WHEN estado = WR1 and address(0) = '0' and byte_m = '1' ELSE
					dataToWrite WHEN estado = WR0 ELSE
					dataToWrite WHEN estado = WR1 ELSE
					"ZZZZZZZZZZZZZZZZ";

	
	
end comportament;
