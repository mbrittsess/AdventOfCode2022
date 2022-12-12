with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

package Unchained_Monkeys is

   Parse_Error : Exception;

   procedure Do_Round;
   function Monkey_Business return Long_Long_Integer;

private

   type Monkey_Index is range 0 .. 7;
   subtype Worry is Long_Long_Integer range 0 .. Long_Long_Integer'Last;
   package Worry_Vectors is new Ada.Containers.Vectors( Index_Type => Positive, Element_Type => Worry );
   type Worry_Operation is not null access function ( I, Amt : Worry ) return Worry;
   type Test_Targets is array ( Boolean ) of Monkey_Index;

   type Monkey is tagged
      record
         ID : Monkey_Index;
         Items : Worry_Vectors.Vector;
         Inspection_Count : Natural;
         Operation : Worry_Operation;
         Operation_Char : Character;
         Operand_Old : Boolean;
         Operation_Amt : Worry;
         Test_Divisor : Worry;
         Test_Target : Test_Targets;
      end record;

   function Read_Monkey return Monkey;

end Unchained_Monkeys;
