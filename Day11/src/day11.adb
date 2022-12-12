with Ada.Text_IO; use Ada.Text_IO;
with Monkeys;

procedure Day11 is

begin
   for I in 1 .. 20 loop
      Monkeys.Do_Round;
   end loop;
   Put_Line( Monkeys.Monkey_Business'Image );
end Day11;
