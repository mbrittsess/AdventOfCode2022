with Ada.Text_IO; use Ada.Text_IO;

package body Tunnels is
   
   function Get_Content ( Pos : Position ) return Content is (if (for some Info of All_Sensors => Pos = Info.Sensor) then Sensor elsif (for some Info of All_Sensors => Pos = Info.Beacon) then Beacon else Empty);
   
   function Definitely_Not_Beacon ( Pos : Position ) return Boolean is (Get_Content(Pos) /= Beacon and then (for some Info of All_Sensors => (abs (Pos-Info.Sensor)) <= (abs (Info.Beacon-Info.Sensor))));

end Tunnels;
