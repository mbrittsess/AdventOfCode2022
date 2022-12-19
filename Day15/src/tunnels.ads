with Positions; use Positions;
with Sensors; use Sensors;

package Tunnels is
   
   pragma Elaborate_Body;

   type Content is ( Empty, Sensor, Beacon );
   
   function Get_Content ( Pos : Position ) return Content;
   function Get_Content ( X, Y : Integer ) return Content is (Get_Content(Position'(X,Y)));
   
   function Definitely_Not_Beacon ( Pos : Position ) return Boolean;
   function Definitely_Not_Beacon ( X, Y : Integer ) return Boolean is (Definitely_Not_Beacon(Position'(X,Y)));

end Tunnels;
