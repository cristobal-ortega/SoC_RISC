LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;  --Esta libreria sera necesaria si usais conversiones

ENTITY regfile IS 
	PORT (	clk		: IN	STD_LOGIC;
			wrd		: IN	STD_LOGIC;
			d 		: IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			a		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			b		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0));
END regfile;


ARCHITECTURE Structure OF regfile IS

	TYPE BLOQUE_REGISTROS IS ARRAY (7 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
	signal br		: BLOQUE_REGISTROS;
	
BEGIN
	
	a <= br(to_integer(unsigned(addr_a)));
	b <= br(to_integer(unsigned(addr_b)));
	
	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk) and wrd = '1') THEN
				br(to_integer(unsigned(addr_d))) <= d;		
		END IF;
	END PROCESS;
		
END Structure;