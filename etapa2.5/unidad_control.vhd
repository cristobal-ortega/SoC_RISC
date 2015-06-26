LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;

ENTITY unidad_control IS 
	PORT (boot	: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			z			: IN STD_LOGIC;
			w		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			op		: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
			wrd		: OUT	STD_LOGIC;
			addr_a	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			immed	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			ins_dad	: OUT STD_LOGIC;
			in_d 	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			rd_in : OUT STD_LOGIC;
			wr_out : OUT STD_LOGIC;
			mux_io : OUT STD_LOGIC;
			immed_x2	: OUT STD_LOGIC;
			wr_m 	: OUT STD_LOGIC;
			word_byte	: OUT STD_LOGIC;
			Rb_N : OUT STD_LOGIC;
			f : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
			);
END unidad_control;

ARCHITECTURE Structure OF unidad_control IS

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades
	-- Aqui iria la definicion del program counter
	
	COMPONENT control_l IS
		PORT (ir		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		   z : IN STD_LOGIC;
			op		: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
			ldpc	: OUT	STD_LOGIC;
			wrd		: OUT	STD_LOGIC;
			addr_a	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_io	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
			immed	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m : OUT STD_LOGIC;
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
	END COMPONENT;
	
	COMPONENT multi IS
	PORT(clk : IN STD_LOGIC;
			boot : IN STD_LOGIC;
			ldpc_l : IN STD_LOGIC;
			wrd_l : IN STD_LOGIC;
			wr_m_l : IN STD_LOGIC;
			w_b	: IN STD_LOGIC;
			ldpc 	: OUT STD_LOGIC;
			wrd	: OUT STD_LOGIC;
			wr_m	: OUT STD_LOGIC;
			ldir	: OUT STD_LOGIC;
			ins_dad : OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
	END COMPONENT;

	SIGNAL ldpc_bus : STD_LOGIC;
	SIGNAL ldpc : STD_LOGIC;
	SIGNAL new_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ir	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL wr_m_bus : STD_LOGIC;
	SIGNAL word_byte_bus : STD_LOGIC;
	SIGNAL wrd_bus : STD_LOGIC;
	SIGNAL ldir : STD_LOGIC;
	SIGNAL br_bus : STD_LOGIC_VECTOR(15 DOWNTO 0); --SALTOS BZ, BNZ
	SIGNAL tknbr_bus : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL regPC : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL aluout : STD_LOGIC_VECTOR(15 DOWNTO 0);
	

	
BEGIN
		
	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia de la logica de control le hemos llamado c0
	
	-- Aqui iria la definicion del comportamiento de la unidad de control y la gestion del PC

	PROCESS(clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF boot = '1' THEN
				regPC <= "1100000000000000";
				ir <= "0000000000000000";
			ELSE
				IF(ldpc = '1') THEN
					regPC <= new_pc;

				END IF;
			END IF;
			IF ldir = '1' THEN
				ir <= datard_m;
			END IF;
		END IF;
	END PROCESS;
	

	aluout <= w;
	
	WITH tknbr_bus SELECT
		new_pc <= regPC + 2 WHEN "00",
					  br_bus + 2  WHEN "01",
					  aluout WHEN "10",
					  X"0000" WHEN others;
	
	
	PC <= regPC;
	
	
		br_bus <= std_logic_vector(resize(signed(ir(6 DOWNTO 0) & '0'),br_bus'length)) + regPC;
		
		--WHEN z = not ir(8) ELSE
					--regPC;
		

		--aluout <= w WHEN ir(2 DOWNTO 0) = "000" and z = '0' ELSE
		--			 w WHEN ir(2 DOWNTO 0) = "001" and z = '1' ELSE
		--			 w WHEN ir(2 DOWNTO 0) = "011" ELSE
		--			 w WHEN ir(2 DOWNTO 0) = "100" ELSE
		--			 regPC + 2;
	

	control_l0 : control_l
	Port Map( 	ir => ir,
					op => op,
					ldpc => ldpc_bus,
					wrd => wrd_bus,
					addr_a => addr_a,
					addr_b => addr_b,
					addr_d => addr_d,
					addr_io => addr_io,
					immed => immed,
					wr_m => wr_m_bus,
					tknbr => tknbr_bus,
					in_d => in_d,
					rd_in => rd_in,
					wr_out => wr_out,
					mux_io => mux_io,
					immed_x2 => immed_x2,
					word_byte => word_byte_bus,
					Rb_N => Rb_N,
					f => f,
					z => z
				);
				
				

			
	multi0 : multi
	Port Map( 	clk => clk,
					boot => boot,
					ldpc_l => ldpc_bus,
					wrd_l => wrd_bus,
					wr_m_l => wr_m_bus,
					w_b => word_byte_bus,
					ldpc => ldpc,
					wrd => wrd,
					wr_m => wr_m,
					ldir => ldir,
					ins_dad => ins_dad,
					word_byte => word_byte
				);
	

	
END Structure;