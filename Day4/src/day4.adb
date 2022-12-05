with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Day4 is
   type Section_ID is new Positive;
   package SIDIO is new Integer_IO(Section_ID);

   Unexpected_Character : exception;

   procedure Expect_Dash is
      C : Character;
   begin
      Get( C ); --out
      if C /= '-' then
         raise Unexpected_Character with "Expected dash, got '" & C & "'";
      end if;
   end Expect_Dash;

    procedure Expect_Comma is
      C : Character;
   begin
      Get( C ); --out
      if C /= ',' then
         raise Unexpected_Character with "Expected comma, got '" & C & "'";
      end if;
   end Expect_Comma;

   Fully_Contained : Natural := 0;
begin
   EOF_Loop: while not End_Of_File loop
      declare
         Range_1_Lo, Range_1_Hi, Range_2_Lo, Range_2_Hi : Section_ID;
      begin
         SIDIO.Get( Range_1_Lo ); --out
         Expect_Dash;
         SIDIO.Get( Range_1_Hi ); --out
         Expect_Comma;
         SIDIO.Get( Range_2_Lo ); --out
         Expect_Dash;
         SIDIO.Get( Range_2_Hi ); --out

         if ((Range_1_Lo <= Range_2_Lo) and then (Range_2_Hi <= Range_1_Hi))
           or else ((Range_2_Lo <= Range_1_Lo) and then (Range_1_Hi <= Range_2_Hi)) then
            Fully_Contained := Fully_Contained + 1;
         end if;
      exception
         when End_Error => exit EOF_Loop;
         when others => raise;
      end;
   end loop EOF_Loop;

   Ada.Integer_Text_IO.Put( Fully_Contained );
end Day4;
