with Valves; use Valves;
with Visiting;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day16 is
   Start_Name : Valve_Name := ( 'A', 'A' );
   Max_Pressure : Natural := Visiting.Max_Pressure_Released( Get_Valve(Start_Name).Index );
begin
   Put_Line( "Max pressure released: " & Max_Pressure'Image );
end Day16;
