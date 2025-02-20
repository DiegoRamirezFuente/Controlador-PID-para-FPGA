library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PID_TOPSENSOR is
  Generic ( SIZE :  integer := 20);
  Port ( 
  CLK:      in std_logic;
  RESET:    in std_logic;
  A:        in std_logic;
  B:        in std_logic;
  C:        in std_logic;
  Count:    out std_logic_vector(SIZE-1 downto 0);
  ERROR:    out std_logic
  );
end PID_TOPSENSOR;

architecture Behavioral of PID_TOPSENSOR is
signal STEP_s: std_logic;

COMPONENT pulse_counter
  Generic (
    SIZE : INTEGER := 20;
    SAMPLES : INTEGER := 5; -- n�mero de muestras que se toman para hacer la media
    FREC : INTEGER range 0 to 1e9 := 100000000 -- frecuencia de conteo entre 10MHz y 1GHz
  );
  Port ( 
    CLK   : in std_logic;
    RESET : in std_logic;
    PULSE : in std_logic; -- pulso entrante procedente del sensor hall
    RPM : out std_logic_vector(SIZE-1 downto 0) 
  );
END COMPONENT;

COMPONENT PID_HALLFSM
Port(
	RESET      : in std_logic;
    A          : in std_logic;
    B          : in std_logic;
    C          : in std_logic;
    CLK        : in std_logic;
    STEP       : out std_logic;
    ERROR      : out std_logic
);
END COMPONENT;

begin

uut_PIDFSM: PID_HALLFSM PORT MAP(
	RESET  =>RESET,
    A      =>A,
    B      =>B,        
    C      =>C,  
    CLK    =>CLK,
    STEP   =>STEP_s,
    ERROR  =>ERROR

);

uut_PID_TIME: pulse_counter 
GENERIC MAP(
    SIZE => SIZE,
    FREC => 100000000,
    SAMPLES => 100
)
PORT MAP(
  CLK       =>CLK,
  RESET     =>RESET,
  PULSE     =>STEP_s,
  RPM     => Count
);
end Behavioral;