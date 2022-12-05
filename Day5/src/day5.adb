with Ada.Text_IO; use Ada.Text_IO;
with Stacks; use Stacks;

procedure Day5 is
   Stacks : array( Positive range 1 .. Number_of_Stacks ) of Stack;

   procedure Skip_Characters ( N : Positive ) is
      C : Character;
   begin
      for I in 1 .. N loop
         Get( C );
      end loop;
   end Skip_Characters;

   package PIO is new Integer_IO( Positive );
   package SHIO is new Integer_IO( Stack_Height );
begin
   -- Parse the portion describing the initial state of the stacks
   for Init_Line in 1 .. Tallest_Start loop
      declare
         Line : String := Get_Line;

         function Is_Crate_At ( Col : Positive ) return Boolean is
         begin
            return Line( -2 + Col*4 ) /= ' ';
         end Is_Crate_At;

         function Get_Crate_At ( Col : Positive ) return Crate_ID is
         begin
            return Crate_ID(Line( -2 + Col*4 ));
         end Get_Crate_At;
      begin
         for Col in Stacks'Range loop
            if Is_Crate_At(Col) then
               Slip_Under( Stacks(Col), Get_Crate_At(Col) );
            end if;
         end loop;
      end;
   end loop;
   Skip_Line; Skip_Line;

   -- Perform the move operations
   while not End_Of_File loop
      declare
         Height : Stack_Height;
         From, To : Positive;
         Move_Str : constant String := "move ";
         From_Str : constant String := " from ";
         To_Str : constant String := " to ";
      begin
         Skip_Characters( Move_Str'Length );
         SHIO.Get( Height ); --out
         Skip_Characters( From_Str'Length );
         PIO.Get( From ); --out
         Skip_Characters( To_Str'Length );
         PIO.Get( To ); --out
         Move_From_To( Stacks(From), Height, Stacks(To) );
         Skip_Line;
      end;
   end loop;

   -- Output the crates which are on the top of the stacks in their final state
   declare
      Out_String : String( Stacks'Range );
   begin
      for I in Out_String'Range loop
         Out_String(I) := Character( Peek_At_Top( Stacks(I) ) );
      end loop;
      Put_Line( Out_String );
   end;
end Day5;
