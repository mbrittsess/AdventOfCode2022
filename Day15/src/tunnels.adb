with Ada.Text_IO; use Ada.Text_IO;

package body Tunnels is
   
   function Get_Content ( X, Y : Integer ) return Content is (Area(X,Y));
   
   function Definitely_Not_Beacon ( X, Y : Integer ) return Boolean is (Beacon_Status(X,Y));

begin
   
   --Put_Line( Beacon_Status'First(1)'Image & "," & Beacon_Status'Last(1)'Image & " .. " & Beacon_Status'First(2)'Image & "," & Beacon_Status'Last(2)'Image );
   
   for Info of All_Sensors loop
      Area( Info.Sensor.X, Info.Sensor.Y ) := Sensor;
      Area( Info.Beacon.X, Info.Beacon.Y ) := Beacon;
   end loop;
   
   for Info of All_Sensors loop
      declare
         Sens : Position := Info.Sensor;
         Beac : Position := Info.Beacon;
         Diff : Position := Sens-Beac;
         Delt_X : Integer := abs Diff.X;
         Delt_Y : Integer := abs Diff.Y;
         Dist : Integer := abs Diff;
      begin
         Area(Sens.X,Sens.Y) := Sensor;
         Area(Beac.X,Beac.Y) := Beacon;
         --Put_Line( "  " & To_String(Sens) & ", " & To_String(Beac) & " --> " & Dist'Image );
         for Y in Sens.Y-Dist .. Sens.Y+Dist loop
            for X in Sens.X-Dist .. Sens.X+Dist loop
               declare
                  Pos : Position := ( X, Y );
                  Pos_Diff : Position := Pos-Sens;
                  Pos_Diff_Dist : Integer := abs Pos_Diff;
               begin
                  --Put_Line( To_String(Pos) & "-" & To_String(Sens) & " = " & To_String(Pos_Diff) & " (" & Pos_Diff_Dist'Image & ")" );
                  if Area( X, Y ) /= Beacon and then (abs (Pos - Sens)) <= Dist then
                     Beacon_Status(X,Y) := True;
                  end if;
               end;
            end loop;
         end loop;
      end;
   end loop;

end Tunnels;
