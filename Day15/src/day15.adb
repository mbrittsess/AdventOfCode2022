with Tunnels;
with Sensors;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day15 is
   Count : Natural := 0;

begin
   --for Y in Sensors.Min_Pos.Y .. Sensors.Max_Pos.Y loop
      for X in Sensors.Min_Pos.X .. Sensors.Max_Pos.Y loop
         if Tunnels.Definitely_Not_Beacon(X,2_000_000) then
            Count := Count + 1;
         end if;
      end loop;
   --end loop;
   Put_Line(Count'Image);

end Day15;
