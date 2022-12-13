with Operations, Items;
use type Items.Item;
with Ada.Containers.Vectors;

package Hard_Monkeys is

   type Monkey_Index is range 0 .. 7;
   
   procedure Do_Round;
   
   type Inspection_Counts is array ( Monkey_Index ) of Natural;
   
   function Get_Inspection_Counts return Inspection_Counts;
   
private
   
   type Item_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Items.Item );
   
   subtype Op_Character is Character with Static_Predicate => Op_Character in '+'|'*';
   type Test_Destinations is array ( Boolean ) of Monkey_Index;
   
   type Monkey is tagged
      record
         ID : Monkey_Index;
         Items : Item_Vectors.Vector := Item_Vectors.Empty_Vector;
         OpChar : Op_Character;
         OperandStr : String;
         Divisor : Positive;
         Destinations : Test_Destinations;
      end record;
   
   

end Hard_Monkeys;
