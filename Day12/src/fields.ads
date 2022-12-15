with Ada.Text_IO; use Ada.Text_IO;
with Positions; use Positions;

generic
   type Element_Type is private;
package Fields is

   type Accessor ( Element : not null access Element_Type ) is limited private
     with Implicit_Dereference => Element;
   
   function Field ( X : X_Coord; Y : Y_Coord ) return Accessor;
   function Field ( P : Position ) return Accessor is (Field( P.X, P.Y ));
   
   procedure Fill_All ( V : Element_Type );
   
private
   
   type Accessor ( Element : not null access Element_Type ) is limited null record;

end Fields;
