with Positions; use Positions;

package Heightmap is
   
   pragma Elaborate_Body;

   subtype Height is Natural;
   
   function Field_Height ( X : X_Coord; Y : Y_Coord ) return Height;
   function Field_Height ( P : Position ) return Height is (Field_Height(P.X,P.Y));
   
   Start, Goal : Position;
   
   Initialization_Error : exception;

end Heightmap;
