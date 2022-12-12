with Ada.Text_IO; use Ada.Text_IO;
with Unchained_Monkeys;

procedure Day11Part2 is

begin
   for I in 1 .. 20 loop
      Unchained_Monkeys.Do_Round;
   end loop;
   Put_Line( Unchained_Monkeys.Monkey_Business'Image );
end Day11Part2;
