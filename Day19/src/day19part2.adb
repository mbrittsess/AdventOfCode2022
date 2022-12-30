with Resources; use Resources;
with Blueprints; use Blueprints;
with Simulations; use Simulations;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day19Part2 is
   All_Blp : Blueprint_Sequence := Blueprints.Blueprints;
   Mul_Geodes : Long_Long_Integer := 1;
begin
   for Idx in 1 .. 3 loop
      declare
         Amt_Geodes : Natural := Get_Max_Geodes( All_Blp(Idx), 32 );
      begin
         Put_Line( "Blueprint #" & Idx'Image & " gets " & Amt_Geodes'Image & " geodes." );
         Mul_Geodes := Mul_Geodes * Long_Long_Integer(Amt_Geodes);
      end;
   end loop;
   Put_Line( "All multiplied together: " & Mul_Geodes'Image );
end Day19Part2;
