with Resources; use Resources;
with Blueprints; use Blueprints;
with Simulations; use Simulations;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day19 is
   Min_Obsid : Positive := Positive'Last;
   Min_Obsid_Id : Positive := Positive'Last;
   All_Blp : Blueprint_Sequence := Blueprints.Blueprints;
   Total_Quality : Natural := 0;
begin
   for Idx in All_Blp'Range loop
      declare
         Amt_Geodes : Natural := Get_Max_Geodes( All_Blp(Idx), 24 );
         Quality : Natural := Idx * Amt_Geodes;
      begin
         Put_Line( "Blueprint #" & Idx'Image & " gets " & Amt_Geodes'Image & " geodes." );
         Put_Line( " Quality is " & Quality'Image );
         Total_Quality := Total_Quality + Quality;
      end;
   end loop;
   Put_Line( " Total Quality: " & Total_Quality'Image );
end Day19;
