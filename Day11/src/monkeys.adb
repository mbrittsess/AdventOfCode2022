with Ada.Strings;
with Ada.Strings.Maps;

package body Monkeys is

   function Worry_Add ( W, Op_Amt : Worry ) return Worry is ( W + Op_Amt );
   function Worry_Mul ( W, Op_Amt : Worry ) return Worry is ( W * Op_Amt );

   subtype Op_Char is Character with Static_Predicate => Op_Char in '*'|'+';

   Digits_Set : Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set( Ada.Strings.Maps.Character_Range'( Low => '0', High => '9' ) );

   function Read_Monkey return Monkey is
      LnId, LnItems, LnOp, LnTest, LnDestTrue, LnDestFalse : String := Get_Line;
      ID : Monkey_Index := Monkey_Index'Value( LnId( 8 .. LnId'Last-1 ) );
      Items : Worry_Vectors.Vector := Worry_Vectors.Empty_Vector;
      OpChar : Op_Char := LnOp(24);
      OpAmt : Worry := Worry'Value( LnOp( 26 .. LnOp'Last ) );
      Divisor : Worry := Worry'Value( LnTest( 22 .. LnTest'Last ) );
      Destinations : Test_Targets :=
        (
         False => Monkey_Index'Value( LnDestFalse( 31 .. LnDestFalse'Last ) ),
         True => Monkey_Index'Value( LnDestTrue( 30 .. LnDestTrue'Last ) )
        );
      NumItems : Natural := Ada.Strings.Fixed.Count( LnItems, "," ) + 1;
      WorryOp : Worry_Operation := (case OpChar is when '+' => Worry_Add'Access, when '*' => Worry_Mul'Access);
   begin
      Skip_Line; -- Skips blank line

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
         Operation => WorryOp,
         Test_Divisor => Divisor,
         Test_Target => Destinations
        );
   end Read_Monkey;
begin
   null;
end Monkeys;
