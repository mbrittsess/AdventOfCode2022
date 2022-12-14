with Operations, Items;
use type Items.Item;
with Ada.Containers.Vectors;

package Hard_Monkeys is
   pragma Elaborate_Body;

   type Monkey_Index is range 0 .. 7;
   
   procedure Do_Round;
   
   type Inspection_Counts is array ( Monkey_Index ) of Natural;
   
   function Get_Inspection_Counts return Inspection_Counts;
   
private
   
   package Item_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Items.Item );
   
   subtype Op_Character is Character with Static_Predicate => Op_Character in '+'|'*';
   type Test_Destinations is array ( Boolean ) of Monkey_Index;
   
   type Monkey is tagged
      record
         ID : Monkey_Index;
         Items : Item_Vectors.Vector := Item_Vectors.Empty_Vector;
         OwnOp : Operations.Operation;
         Divisor : Positive;
         Destinations : Test_Destinations;
         Inspection_Count : Natural := 0;
      end record;
   
   type Monkey_Access is access Monkey;
   
   Monkeys : array ( Monkey_Index ) of Monkey_Access;

end Hard_Monkeys;
