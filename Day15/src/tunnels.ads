with Positions; use Positions;
with Sensors; use Sensors;

package Tunnels is
   
   pragma Elaborate_Body;

   type Content is ( Empty, Sensor, Beacon );
   
   function Get_Content ( X, Y : Integer ) return Content;
   function Get_Content ( P : Position ) return Content is (Get_Content(P.X,P.Y));
   
   function Definitely_Not_Beacon ( X, Y : Integer ) return Boolean;
   function Definitely_Not_Beacon ( P : Position ) return Boolean is (Definitely_Not_Beacon(P.X,P.Y));
   
private
   
   Area : array ( Min_Pos.X .. Max_Pos.X, Min_Pos.Y .. Max_Pos.Y ) of Content := ( others => ( others => Empty ) );
   Beacon_Status : array ( Area'Range(1), Area'Range(2) ) of Boolean := ( others => ( others => False ) );

end Tunnels;
