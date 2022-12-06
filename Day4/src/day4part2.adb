with Ada.Text_IO; use Ada.Text_IO;

procedure Day4Part2 is
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
   
   type SID_Range is
      record
         Lo, Hi : Section_ID;
      end record;
   
   function Is_Overlap ( R1, R2 : SID_Range ) return Boolean is
   begin
      return (R1.Lo in R2.Lo .. R2.Hi )
        or else ( R1.Hi in R2.Lo .. R2.Hi )
        or else ( R1.Lo <= R2.Lo and then R2.Hi <= R1.Hi );
   end Is_Overlap;
   
   procedure Get_Ranges ( R1, R2 : out SID_Range ) is
      R1_Lo, R1_Hi, R2_Lo, R2_Hi : Section_ID;
   begin
      SIDIO.Get( R1_Lo ); --out
      Expect_Dash;
      SIDIO.Get( R1_Hi ); --out
      Expect_Comma;
      SIDIO.Get( R2_Lo ); --out
      Expect_Dash;
      SIDIO.Get( R2_Hi ); --out
      R1 := ( R1_Lo, R1_Hi );
      R2 := ( R2_Lo, R2_Hi );
   end Get_Ranges;
   
   Num_Overlaps : Natural := 0;
   package NIO is new Integer_IO( Natural );
begin
   Read_Loop: while not End_Of_File loop
      declare
         R1, R2 : SID_Range;
      begin
         Get_Ranges( R1, R2 ); --out, out
         if Is_Overlap( R1, R2 ) then
            Num_Overlaps := Num_Overlaps + 1;
         end if;
      exception
         when End_Error => exit Read_Loop;
      end;
   end loop Read_Loop;
   
   NIO.Put( Num_Overlaps );
end Day4Part2;
