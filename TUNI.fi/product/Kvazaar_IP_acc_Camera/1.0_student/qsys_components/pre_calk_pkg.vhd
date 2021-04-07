library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package pre_calc_pkg is

function log2(A: integer) return integer;

end pre_calc_pkg;

package body pre_calc_pkg is

function log2(A: integer) return integer is
begin
  for i in 1 to 30 loop
    if(2**i > A) then return(i-1);  end if;
  end loop;
end log2;

end pre_calc_pkg;