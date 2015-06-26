LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY proc IS 
	PORT (	boot		: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			datard_m	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr_m	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			wr_m	: OUT STD_LOGIC;
			word_byte : OUT STD_LOGIC);
END proc;


ARCHITECTURE Structure OF proc IS

	-- Aqui iria la declaracion de las entidades que vamos a usar 
	-- Usaremos la palabra reservada COMPONENT ...
	-- Tambien crearemos los cables/buses (signals) necesarios para unir las entidades

	COMPONENT datapath IS
	PORT (clk		: IN	STD_LOGIC;
			op		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd		: IN	STD_LOGIC;
			addr_a	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			immed_x2 : IN STD_LOGIC;
			datard_m : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			ins_dad  : IN STD_LOGIC;
			pc			: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			in_d		: IN STD_LOGIC;
			addr_m	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			data_wr	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT unidad_control IS
	PORT (boot	: IN	STD_LOGIC;
			clk		: IN	STD_LOGIC;
			datard_m	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			op		: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
			wrd		: OUT	STD_LOGIC;
			addr_a	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_b	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			addr_d	: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			immed	: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
			ins_dad	: OUT STD_LOGIC;
			in_d 	: OUT STD_LOGIC;
			immed_x2	: OUT STD_LOGIC;
			wr_m 	: OUT STD_LOGIC;
			word_byte	: OUT STD_LOGIC
			
			);
	END COMPONENT;
	
	SIGNAL op_bus : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL wrd_bus : STD_LOGIC;
	SIGNAL addr_a_bus	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL addr_b_bus	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL addr_d_bus	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL immed_bus	: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL immed_x2_bus	: STD_LOGIC;
	SIGNAL in_d_bus : STD_LOGIC;
	SIGNAL ins_dad_bus : STD_LOGIC;
	SIGNAL pc_bus : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	
BEGIN

	-- Aqui iria la declaracion del "mapeo" (PORT MAP) de los nombres de las entradas/salidas de los componentes
	-- En los esquemas de la documentacion a la instancia del DATAPATH le hemos llamado e0 y a la de la unidad de control le hemos llamado c0
	
	
	
	
	
	c0 : unidad_control
	Port Map( 	boot => boot,
					clk => clk,
					datard_m => datard_m,
					op => op_bus,
					wrd => wrd_bus,
					addr_a => addr_a_bus,
					addr_b => addr_b_bus,
					addr_d => addr_d_bus,
					immed => immed_bus,
					pc => pc_bus,
					ins_dad => ins_dad_bus,
					in_d => in_d_bus,
					immed_x2 => immed_x2_bus,
					wr_m => wr_m,
					word_byte => word_byte
				);
	
	
	
	e0 : datapath
	Port Map( 	clk => clk,
					op => op_bus,
					wrd => wrd_bus,
					addr_a => addr_a_bus,
					addr_b => addr_b_bus,
					addr_d => addr_d_bus,
					immed => immed_bus,
					immed_x2 => immed_x2_bus,
					datard_m => datard_m,
					ins_dad => ins_dad_bus,
					pc => pc_bus,
					in_d => in_d_bus,
					addr_m => addr_m,
					data_wr => data_wr
				);
		
			
END Structure;