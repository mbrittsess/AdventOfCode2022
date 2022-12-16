with Positions; use Positions;

generic
   type Element_Type is private;
   type X_Coord is range <>;
   type Y_Coord is range <>;
package Fields is

   type Accessor ( Element : not null access Element_Type ) is limited private
     with Implicit_Dereference => Element;
   
   function Field ( X : X_Coord; Y : Y_Coord ) return Accessor;
   function Field ( P : Position ) return Accessor
     with Pre => (P.X in Integer(X_Coord'First) .. Integer(X_Coord'Last)) and (P.Y in Integer(Y_Coord'First) .. Integer(Y_Coord'Last));
   
   procedure Fill_All ( V : Element_Type );
 
private
   
   type Accessor ( Element : not null access Element_Type ) is limited null record;

end Fields;
