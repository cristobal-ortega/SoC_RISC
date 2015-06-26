LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;



ENTITY controladores_IO IS
	PORT (boot : IN STD_LOGIC;
		CLOCK_50 : IN std_logic;
		addr_io : IN std_logic_vector(7 downto 0);
		wr_io : in std_logic_vector(15 downto 0);
		rd_io : out std_logic_vector(15 downto 0);
		wr_out : in std_logic;
		rd_in : in std_logic;
		switch		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		pulsadores : IN std_logic_vector(3 downto 0);
		hexa0			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hexa1			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hexa2			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		hexa3			: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);	
		led_verdes : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		led_rojos : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END controladores_IO; 


ARCHITECTURE Structure OF controladores_IO IS

	COMPONENT segmentos7 IS 
	PORT (	control : IN STD_LOGIC;
			number : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			hexa : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		  );
	END COMPONENT;


	TYPE BLOQUE_IO IS ARRAY (255 DOWNTO 0) of std_logic_vector(15 DOWNTO 0);
	signal mem		: BLOQUE_IO;
	SIGNAL control_wr : STD_LOGIC;

	
BEGIN
	
	control_wr <= '0' WHEN addr_io = X"0007" ELSE
					  '0' WHEN addr_io = X"0008" ELSE
					  '1';
	
	led_verdes <= mem(5)(7 DOWNTO 0);
	led_rojos <= mem(6)(7 DOWNTO 0);
	

	
	PROCESS (CLOCK_50)
	BEGIN
		IF(rising_edge(CLOCK_50)) THEN 
			IF (boot = '1') THEN 
				mem(5) <= X"0000";
				mem(6) <= X"0000";
				mem(7) <= X"0000";
				mem(8) <= X"0000";
				mem(9) <= X"0000";
				mem(10) <= X"0000";
			END IF;
			IF (wr_out = '1' and control_wr = '1') THEN
				mem(to_integer(unsigned(addr_io))) <= wr_io;		
			END IF;
			IF (rd_in = '1') THEN
				rd_io <= mem(to_integer(unsigned(addr_io)));
			END IF;
			
			mem(7)(3 DOWNTO 0) <= pulsadores;
			mem(8)(7 DOWNTO 0) <= switch;
			
			
		END IF;
	END PROCESS;
	
	seg0 : segmentos7
		Port Map( 	control => mem(9)(0),
						number => mem(10)(3 DOWNTO 0),
						hexa => hexa0
					);
					
	seg1 : segmentos7
		Port Map( 	control => mem(9)(1),
						number => mem(10)(7 DOWNTO 4),
						hexa => hexa1
					);
					
	seg2 : segmentos7
		Port Map( 	control => mem(9)(2),
						number => mem(10)(11 DOWNTO 8),
						hexa => hexa2
					);
	
	seg3 : segmentos7
		Port Map( 	control => mem(9)(3),
						number => mem(10)(15 DOWNTO 12),
						hexa => hexa3
					);
		
END Structure;