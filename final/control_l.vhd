LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY control_l IS 
	PORT (ir		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			z 		: IN STD_LOGIC;
			op		: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
			ldpc	: OUT	STD_LOGIC;
			wrd		: OUT	STD_LOGIC;
			addr_a	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			immed	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m : OUT STD_LOGIC :='0' ;
			tknbr : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			in_d : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			rd_in : OUT STD_LOGIC;
			wr_out : OUT STD_LOGIC;
			mux_io : OUT STD_LOGIC;
			immed_x2 : OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC;
			Rb_N : OUT STD_LOGIC;
			f : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
			);
END control_l;


ARCHITECTURE Structure OF control_l IS
BEGIN
		-- Aqui iria la generacion de las senales de control del datapath

		
		WITH ir(15 DOWNTO 12) SELECT
		Rb_N <= '0' WHEN "0000",
					'0' WHEN "0001",
					'0' WHEN "1000",
					'0' WHEN "0110",
					'0' WHEN "1010", --realmente hace falta? JNZ, JZ
					'0' WHEN "0111",
					'1' WHEN others;

		WITH ir(15 DOWNTO 12) SELECT
		f <= ir(5 DOWNTO 3) WHEN "0000",
				ir(5 DOWNTO 3) WHEN "0001",
				ir(5 DOWNTO 3) WHEN "1000",
				ir(2 DOWNTO 0) WHEN "1010",
				--CUIDAITO AQUI
				"00" & ir(8) WHEN "0101",
				"010" WHEN "0011",
				"010" WHEN "0100",
				"010" WHEN "1101",
				"000" WHEN others;
				
		WITH ir SELECT
			ldpc <= '0' WHEN "1111111111111111",
			        '1' WHEN others;

		op <= ir(15 DOWNTO 12);

		
		wrd <= '1' WHEN ir(15 DOWNTO 12) = "0000" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "0001" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "0010" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "0101" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "0011" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "1000" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "1101" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "1010" and ir(2 DOWNTO 0) = "100" ELSE
				 '1' WHEN ir(15 DOWNTO 12) = "0111" and ir(8) = '0' ELSE
				 '0';
		
		
		WITH ir(15 DOWNTO 12) SELECT
			wr_m <= '1' WHEN "0100",
					  '1' WHEN "1110",
					  '0' WHEN others;
					  
		--ra
		WITH ir(15 DOWNTO 12) SELECT
			addr_a <= ir(8 DOWNTO 6) WHEN "0000",
						 ir(8 DOWNTO 6) WHEN "0001",
						 ir(8 DOWNTO 6) WHEN "0010",
						 ir(8 DOWNTO 6) WHEN "0011",
						 ir(8 DOWNTO 6) WHEN "0100",
			          ir(11 DOWNTO 9) WHEN "0101",
						 ir(8 DOWNTO 6) WHEN "1101",
						 ir(8 DOWNTO 6) WHEN "1110",
						 ir(8 DOWNTO 6) WHEN "1010",
						 ir(8 DOWNTO 6) WHEN others;
 						
			
		--rb
		WITH ir(15 DOWNTO 12) SELECT
			addr_b <= ir(2 DOWNTO 0) WHEN "0000",
						 ir(2 DOWNTO 0) WHEN "0001",
						 ir(11 DOWNTO 9) WHEN "0100",
						 ir(2 DOWNTO 0) WHEN "1000",
						 ir(11 DOWNTO 9) WHEN "1110", 
						 ir(11 DOWNTO 9) WHEN "0110",
						 ir(11 DOWNTO 9) WHEN "1010",
						 ir(11 DOWNTO 9) WHEN "0111",
						 ir(11 DOWNTO 9) WHEN others;
		
		--rd Cambiar por ir(11 downto 9) para siempre?
		WITH ir(15 DOWNTO 12) SELECT
			addr_d <= ir(11 DOWNTO 9) WHEN "0000",	
						 ir(11 DOWNTO 9) WHEN "0001",
						 ir(11 DOWNTO 9) WHEN "0010",
						 ir(11 DOWNTO 9) WHEN "0011",
						 ir(11 DOWNTO 9) WHEN "0101",			 				 
						 ir(11 DOWNTO 9) WHEN "1000",	
						 ir(11 DOWNTO 9) WHEN "1010",
						 ir(11 DOWNTO 9) WHEN "1101",
						 ir(11 DOWNTO 9) WHEN "0111",
						 ir(11 DOWNTO 9) WHEN others;
						 
		--immediato
		WITH ir(15 DOWNTO 12) SELECT
			immed <= std_logic_vector(resize(signed(ir(5 DOWNTO 0)),immed'length)) WHEN "0010",
						std_logic_vector(resize(signed(ir(7 DOWNTO 0)),immed'length)) WHEN "0110", --BZ,BNZ
						std_logic_vector(resize(signed(ir(7 DOWNTO 0)),immed'length)) WHEN "0101",
						std_logic_vector(resize(signed(ir(5 DOWNTO 0)),immed'length)) WHEN others; --LOAD, STORE, LOADB, STOREB
						
						
		--SALTOS
		--WITH ir(15 DOWNTO 12) SELECT
			--tknbr <= "01" WHEN "0110",
				--		"10" WHEN "1010",
					--	"00" WHEN others;
		
			tknbr <= "01" WHEN ir(15 DOWNTO 12) = "0110" and z = not ir(8) ELSE
					   "10" WHEN ir(15 DOWNTO 12) = "1010" and ir(2 DOWNTO 0) = "000" and z = '1' ELSE
						"10" WHEN ir(15 DOWNTO 12) = "1010" and ir(2 DOWNTO 0) = "001" and z = '0' ELSE
						"10" WHEN ir(15 DOWNTO 12) = "1010" and ir(2 DOWNTO 0) = "011" ELSE
						"10" WHEN ir(15 DOWNTO 12) = "1010" and ir(2 DOWNTO 0) = "100" ELSE
						"00";
					
		
		--in_d, destino a guardar en registro
		WITH ir(15 DOWNTO 12) SELECT
			in_d <= "00" WHEN "0000",
					  "00" WHEN "0001",
					  "00" WHEN "0010",
					  "01" WHEN "0011",
					  "00" WHEN "0101",
					  "00" WHEN "1000",
					  "01" WHEN "1101",
					  "10" WHEN "1010",
					  "00" WHEN others;
					  
		--immed_x2
		WITH ir(15 DOWNTO 12) SELECT
			immed_x2 <= '1' WHEN "0011",
							'1' WHEN "0100",
							'1' WHEN "0110", --BZ,BNZ
							'0' WHEN others;
							
		--word_byte
		--negar immed_x2?
		WITH ir(15 DOWNTO 12) SELECT
			word_byte <= '1' WHEN "1101",
							 '1' WHEN "1110",
							 '0' WHEN others;
							 			 
		addr_io	<= ir(7 DOWNTO 0 ); --WHEN "0111";
			
		WITH ir(15 DOWNTO 12) SELECT
			rd_in <= '1' WHEN "0111",
						'0' WHEN others;
						
	 
		wr_out <= '1' WHEN ir(15 DOWNTO 12) = "0111" and ir(8) = '1' ELSE
					 '0';
		WITH ir(15 DOWNTO 12) SELECT
			mux_io <= '1' WHEN "0111",
						 '0' WHEN others;
		
END Structure;