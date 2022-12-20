with Tunnels; use Tunnels;
with Sensors;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day15Print is
   Output_Char : array ( Tunnels.Content ) of Character :=
     (
      Tunnels.Empty => '.',
      Tunnels.Sensor => 'S',
      Tunnels.Beacon => 'B'
     );
   
begin
   for Y in Sensors.Min_Pos.Y .. Sensors.Max_Pos.Y loop
      Put( Y'Image & ": " );
      for X in Sensors.Min_Pos.X .. Sensors.Max_Pos.Y loop
         declare
            Content : Tunnels.Content := Tunnels.Get_Content(X,Y);
         begin
            if Content = Tunnels.Empty and then Tunnels.Definitely_Not_Beacon(X,Y) then
               Put( '#' );
            elsif Content = Tunnels.Empty and then X = 0 then
               Put( '|' );
            else
               Put( Output_Char( Content ) );
            end if;
         end;
      end loop;
      New_Line;
   end loop;
   
end Day15Print;
