with Positions; use Positions;
with Fields;

package Cave is
   pragma Elaborate_Body;
   
   Cant_Happen : exception;

   subtype X_Coord is Integer range 0 .. 999;
   subtype Y_Coord is Integer range 0 .. 199;
   
   type Content is ( Air, Rock, Sand );
   
   package Cave_Field is new Fields( Content, X_Coord, Y_Coord );
   
   function Cave ( P : Position ) return Cave_Field.Accessor renames Cave_Field.Field;
   function Cave ( X : X_Coord; Y : Y_Coord ) return Cave_Field.Accessor renames Cave_Field.Field;
   
   procedure Add_Floor;
   
   procedure Run_Sand_Simulation;

end Cave;
