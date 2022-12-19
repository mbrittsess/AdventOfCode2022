with Cave; use Cave;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day14Part2 is
   Sand_Count : Natural := 0;
begin
   Add_Floor;
   Run_Sand_Simulation;
   for Y in Y_Coord loop
      for X in X_Coord loop
         if Cave.Cave(X,Y) = Sand then
            Sand_Count := Sand_Count + 1;
         end if;
      end loop;
   end loop;
   Put_Line( Sand_Count'Image );
end Day14Part2;
