with Field; use Field;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day17 is

begin
   for Round in 1 .. 2022 loop
      Place_Rock;
   end loop;
   Put_Line( Natural'Image( Highest_Level ) );
end Day17;
