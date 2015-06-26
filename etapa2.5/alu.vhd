LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


ENTITY alu IS 
	PORT (x 			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			y 			: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			f			: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			w			: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			z			: OUT	STD_LOGIC);
END alu;


ARCHITECTURE Structure OF alu IS

	SIGNAL aritmeticas : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL comparaciones : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL mdiv : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL mul : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mulU : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mov : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL sum : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--SIGNAL shl : STD_LOGIC_VECTOR(15 DOWNTO 0);
	--SIGNAL sha : STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN

	--WITH op SELECT
		--w <= 	y WHEN "0000",
			--	(y(7 DOWNTO 0) & x(7 DOWNTO 0)) WHEN "0001",
			--	y + x WHEN others; --es la '10'
			
	WITH op SELECT
		w <= aritmeticas WHEN "0000",
			  comparaciones WHEN "0001",
			  sum WHEN "0010",
			  sum WHEN "0011",
			  sum WHEN "0100",
			  mov WHEN "0101",
			  mdiv WHEN "1000",
			  sum WHEN "1101",
			  sum WHEN "1110",
			  x WHEN "1010", --JZ, JNZ, JMP, JAL
			  X"0000" WHEN others;
			
	--Suma
	sum <= x + y;
	
	--OP elige el grupo, f elige operacion
	--OP = 0000, aritmeticas
	WITH f SELECT
		aritmeticas <= x and y WHEN "000",
							x or y WHEN "001",
							x xor y WHEN "010",
							NOT x WHEN "011",
							x + y WHEN "100",
							x - y WHEN "101",
							to_stdlogicvector( to_bitvector(x) sla to_integer(signed(y)) ) WHEN "110", --no se si funciona
							std_logic_vector( (unsigned(x)) sll to_integer(signed(y)) ) WHEN "111",
							X"0000" WHEN others;
							
		--Desplazamientos, shl, sha
	
	--SHA <= to_stdlogicvector( to_bitvector(x) sla to_integer(signed(y)) ) WHEN Y(15) = '0',
	--		 to_stdlogicvector( to_bitvector(x) sra to_integer(signed(y)) ) WHEN Y(15) = '1',
	
	--OP = 0001, comparaciones
	--WITH f SELECT
		--comparaciones <=	aritmeticas WHEN "000" and (x < y ), --Less than
				--				aritmeticas WHEN "001", --less or equal
				--				aritmeticas WHEN "011", --equal
				--				aritmeticas WHEN "100", --less than unsigned
				--				aritmeticas WHEN "101"; --less equal unsigned
				
		comparaciones <= X"0001" WHEN f = "000" and ( signed(x) < signed(y) ) ELSE			--Less than
							  X"0001" WHEN f = "001" and ( signed(x) <= signed(y) ) ELSE		--less or equal
							  X"0001" WHEN f = "011" and ( signed(x) = signed(y) ) ELSE 		--equal
							  X"0001" WHEN f = "100" and ( unsigned(x) < unsigned(y) ) ELSE	--less than unsigned
							  X"0001" WHEN f = "101" and ( unsigned(x) <= unsigned(y) ) ELSE	--less equal unsigned
							  X"0000";
	--OP = 0010, ADDI
		--directo
	--OP = 1000 MULS, DIVS
	mul <= std_logic_vector( signed(x) * signed(y) );
	mulU <= std_logic_vector( unsigned(x) * unsigned(y) ); 
	
		WITH f SELECT
			mdiv <= mul(15 DOWNTO 0) WHEN "000",
					  mul(31 DOWNTO 16) WHEN "001",
					  mulU(31 DOWNTO 16)WHEN "010",
					  STD_LOGIC_VECTOR( signed(x) / signed(y) )WHEN "100",
					  STD_LOGIC_VECTOR( unsigned(x) / unsigned(y) )WHEN "101",
					  X"0000" WHEN others;
		
	--OP = 0011 LD
		--directo
	--OP = 0100 ST
		--directo
	--OP = 0101 MOVI, MOVHI
		WITH f SELECT
			mov <= y WHEN "000",
					 (y(7 DOWNTO 0) & x(7 DOWNTO 0)) WHEN "001",
					 X"0000" WHEN others;
	
	-- OP = 1101 LDB
		--directo
	-- OP = 1110 STB
		--directo
	
	--salida z
	z <= '1' WHEN unsigned(y) = "0000" ELSE
		  '0';
	
END Structure;