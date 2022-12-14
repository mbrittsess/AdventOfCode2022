package Positions is
   
   type X_Coord is range 0 .. 131;
   type Y_Coord is range 0 .. 40;

   type Position is
      record
         X : X_Coord := 0;
         Y : Y_Coord := 0;
      end record;
   
   type Adjacent_Positions is array ( Positive range <> ) of Position;
   
   function Get_Adjacent_Positions ( P : Position ) return Adjacent_Positions;

end Positions;
