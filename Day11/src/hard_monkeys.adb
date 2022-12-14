with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings;
with Ada.Strings.Maps;
with Ada.IO_Exceptions;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Operations, Items;
use Operations, Items;
with Ada.Containers.Generic_Constrained_Array_Sort;

package body Hard_Monkeys is
   
   Digits_Set : Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set( Ada.Strings.Maps.Character_Range'( Low => '0', High => '9' ) );
   
   procedure Counts_Sort is new Ada.Containers.Generic_Constrained_Array_Sort
     (
      Index_Type => Monkey_Index,
      Element_Type => Natural,
      Array_Type => Inspection_Counts,
      "<" => ">" --We want to sort descending
     );
   
   procedure Read_Monkey is
      LnId, LnItems, LnOp, LnTest, LnDestTrue, LnDestFalse : String := Get_Line;
      Index : Monkey_Index := Monkey_Index'Value( LnId( 8 .. LnId'Last-1 ) );
      OpChar : Op_Character := LnOp(24);
      OperandStr : String := LnOp( 26 .. LnOp'Last );
      Op : Operation := (if OpChar = '+' then New_Add( Integer'Value(OperandStr) ) elsif OperandStr = "old" then New_Square else New_Mul( Integer'Value(OperandStr) ));
      Divisor : Integer := Positive'Value( LnTest( 22 .. LnTest'Last ) );
      Destinations : Test_Destinations :=
        (
         False => Monkey_Index'Value( LnDestFalse( 31 .. LnDestFalse'Last ) ),
         True => Monkey_Index'Value( LnDestTrue( 30 .. LnDestTrue'Last ) )
        );
      Num_Items : Positive := Ada.Strings.Fixed.Count( LnItems, "," ) + 1;
      
      Ret : Monkey_Access := new Monkey'(
         ID => Index,
         OwnOp => Op,
         Divisor => Divisor,
         Destinations => Destinations,
         others => <>
        );
   begin
      declare
      begin
         Skip_Line; -- Skips blank line
      exception
         when Ada.IO_Exceptions.End_Error => null;
      end;
      
      declare
         First, Last : Natural := 0;
      begin
         for I in 1 .. Num_Items loop
            Find_Token( LnItems, Digits_Set, Last+1, Ada.Strings.Inside, First, Last ); -- in, in, in, in, out, out
            Ret.Items.Append( New_Item( Integer'Value( LnItems( First .. Last ) ) ) );
         end loop;
      end;
      
      Monkeys( Index ) := Ret;
   end Read_Monkey;
   
   function Get_Inspection_Counts return Inspection_Counts is
      Ret : Inspection_Counts;
   begin
      for M of Monkeys loop
         Ret( M.ID ) := M.Inspection_Count;
      end loop;
      Counts_Sort( Ret );
      return Ret;
   end Get_Inspection_Counts;
   
   procedure Do_Turn ( This : access Monkey ) is
      function Strip_Item ( IV : in out Item_Vectors.Vector ) return Item is
         Ret : Item := IV.First_Element;
      begin
         IV.Delete_First;
         return Ret;
      end Strip_Item;
   begin
      while not This.Items.Is_Empty loop
         declare
            Itm : Item := Strip_Item( This.Items );
            IC : Natural := This.Inspection_Count;
         begin
            Itm.Append_Op( This.OwnOp );
            Monkeys( This.Destinations( Evaluate( Itm, This.Divisor ) = 0 ) ).Items.Append( Itm );
            This.Inspection_Count := IC+1;
         end;
      end loop;
   end Do_Turn;
  
   procedure Do_Round is
   begin
      for M of Monkeys loop
         Do_Turn( M );
      end loop;
   end Do_Round;

begin
   for MI in Monkey_Index loop
      Read_Monkey;
   end loop;
end Hard_Monkeys;
