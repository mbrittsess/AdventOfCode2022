with Ada.Containers.Vectors;
with Operations; use type Operations.Operation;

package Items is

   type Item is tagged private;
   
   function New_Item ( Initial_Value : Integer ) return Item;
   procedure Append_Op ( This : in out Item; Op : Operations.Operation );
   function Evaluate ( This : Item; Divisor : Integer ) return Integer;
   
private
   
   package Op_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Operations.Operation );
   
   type Item is tagged
      record
         Initial_Value : Integer;
         Own_Operations : Op_Vectors.Vector := Op_Vectors.Empty_Vector;
      end record;

end Items;
