with Ada.Strings;
with Ada.Strings.Maps;
with Ada.Text_IO;
with Ada.IO_Exceptions;

package body Unchained_Monkeys is
   
   procedure Log ( S : String ) is
   begin
      if ( False ) then Ada.Text_IO.Put_Line( S ); end if;
   end Log;

   function Worry_Add ( W, Op_Amt : Worry ) return Worry is ( W + Op_Amt );
   function Worry_Mul ( W, Op_Amt : Worry ) return Worry is ( W * Op_Amt );

   subtype Op_Char is Character with Static_Predicate => Op_Char in '*'|'+';

   Digits_Set : Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set( Ada.Strings.Maps.Character_Range'( Low => '0', High => '9' ) );

   function Read_Monkey return Monkey is
      LnId, LnItems, LnOp, LnTest, LnDestTrue, LnDestFalse : String := Get_Line;
      ID : Monkey_Index := Monkey_Index'Value( LnId( 8 .. LnId'Last-1 ) );
      Items : Worry_Vectors.Vector := Worry_Vectors.Empty_Vector;
      OpChar : Op_Char := LnOp(24);
      OperandStr : String := LnOp( 26 .. LnOp'Last );
      OpAmt : Worry := (if OperandStr = "old" then Worry'First else Worry'Value(OperandStr));
      Divisor : Worry := Worry'Value( LnTest( 22 .. LnTest'Last ) );
      Destinations : Test_Targets :=
        (
         False => Monkey_Index'Value( LnDestFalse( 31 .. LnDestFalse'Last ) ),
         True => Monkey_Index'Value( LnDestTrue( 30 .. LnDestTrue'Last ) )
        );
      NumItems : Natural := Ada.Strings.Fixed.Count( LnItems, "," ) + 1;
      WorryOp : Worry_Operation := (case OpChar is when '+' => Worry_Add'Access, when '*' => Worry_Mul'Access);
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
         for I in 1 .. NumItems loop
            Find_Token( LnItems, Digits_Set, Last+1, Ada.Strings.Inside, First, Last ); -- in, in, in, in, out, out
            Items.Append( Worry'Value( LnItems( First .. Last ) ) );
         end loop;
      end;

      return
        (
         ID => ID,
         Items => Items,
         Inspection_Count => 0,
         Operation => WorryOp,
         Operation_Char => OpChar,
         Operand_Old => OperandStr = "old",
         Operation_Amt => OpAmt,
         Test_Divisor => Divisor,
         Test_Target => Destinations
        );
   end Read_Monkey;
   
   type Monkey_Set is array ( Monkey_Index ) of Monkey;
   
   Monkeys : Monkey_Set := ( others => Read_Monkey );
   
   function Monkey_Business return Long_Long_Integer is
      Highest, Second_Highest : Natural := 0;
      Highest_Index, Second_Highest_Index : Monkey_Index;
   begin
      for I in Monkey_Index loop
         if Monkeys(I).Inspection_Count > Highest then
            Highest := Monkeys(I).Inspection_Count;
            Highest_Index := I;
         end if;
      end loop;
      for I in Monkey_Index loop
         if I /= Highest_Index and then Monkeys(I).Inspection_Count > Second_Highest then
            Second_Highest := Monkeys(I).Inspection_Count;
            Second_Highest_Index := I;
         end if;
      end loop;
      return Long_Long_Integer(Highest)*Long_Long_Integer(Second_Highest);
   end Monkey_Business;
   
   procedure Do_Monkey_Turn ( Monkeys : in out Monkey_Set; MI : Monkey_Index ) is
      This : Monkey renames Monkeys(MI);
   begin
      Log( " Monkey " & This.ID'Image & ":" );
      Log( "  Inspection Times: " & This.Inspection_Count'Image & "." );
      while not This.Items.Is_Empty loop
         declare
            Start : Worry := This.Items.First_Element;
            Op_Amt : Worry := (if This.Operand_Old then Start else This.Operation_Amt);
            Altered : Worry := This.Operation( Start, Op_Amt );
            Test : Boolean := (Altered mod This.Test_Divisor) = 0;
            Throw_To : Monkey_Index := This.Test_Target(Test);
         begin
            Log( "  Monkey inspects an item with a worry level of " & Start'Image & "." );
            Log( "   Worry level is " & This.Operation_Char & "= " & Op_Amt'Image & " to become " & Altered'Image & "." );
            Log( "   Current worry is " & (if Test then "" else "not ") & "divisible by " & This.Operation_Amt'Image & "." );
            Log( "   Item with worry level " & Altered'Image & " is thrown to monkey " & Throw_To'Image & "." );
            
            This.Inspection_Count := This.Inspection_Count + 1;
            This.Items.Delete( This.Items.First_Index );
            Monkeys(Throw_To).Items.Append( Altered );
         end;
      end loop;
      Log( "  Inspection Times: " & This.Inspection_Count'Image & "." );
   end Do_Monkey_Turn;
   
   Turn_Number : Integer := 0;
   procedure Do_Round is
   begin
      Log( "Round " & Turn_Number'Image & ":" );
      Turn_Number := Turn_Number + 1;
      for MI in Monkey_Index loop
         Do_Monkey_Turn( Monkeys, MI );
      end loop;
      Log( " Monkey Business: " & Monkey_Business'Image & "." );
   end Do_Round;
      
begin
   --for I in Monkey_Index loop
   --   Monkeys(I) := Read_Monkey;
   --end loop;
   null;
end Unchained_Monkeys;
