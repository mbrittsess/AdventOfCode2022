with Positions; use Positions;

package body Fields is

   Data : array ( X_Coord, Y_Coord ) of aliased Element_Type;
   
   function Field ( X : X_Coord; Y : Y_Coord ) return Accessor is
   begin
      return ( Element => Data(X,Y)'Access );
   end Field;
   
   procedure Fill_All ( V : Element_Type ) is
   begin
      Data := ( others => ( others => V ) );
   end Fill_All;

end Fields;
