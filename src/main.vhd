library ieee;
use ieee.std_logic_1164.all;

-- arithmetic functions with Signed or Unsigned values
--use ieee.numeric_std.all;

-- instantiating any Xilinx leaf cells
--library unisim;
--use unisim.vcomponents.all;

-- definitions that allow std_logic_vector types to be used with the + operator
-- to instantiate a counter
--use ieee.std_logic_unsigned.all;

entity main is
    Port
    (
        sysclk: in std_logic;
        led0_b: out std_logic
    );
end main;

architecture rtl of main is
    signal counter: integer range 0 to 11_999_999 := 0;
    signal equal:   std_logic                     := '0';
    signal dff:     std_logic                     := '0';
begin
    -- Description of counter
    process(sysclk)
    begin
        if(rising_edge(sysclk)) then
            if(counter = 11_999_999) then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    -- Description of comparison logic
    equal <= '1' when (counter = 11_999_999) else '0';
    
    -- Description of D-trigger
    process(sysclk)
    begin
        if(rising_edge(sysclk)) then
            if(equal = '1') then
                dff <= not dff;
            end if;
        end if;
    end process;
    led0_b <= dff;
end architecture;
