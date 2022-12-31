with Blueprints; use Blueprints;
with Simulations; use Simulations;
with Ada.Text_IO; use Ada.Text_IO;

package body Part2Runners is
   
   All_Blp : Blueprint_Sequence := Blueprints.Blueprints;

   protected body Coordinator is
      procedure Get_Blueprint ( Available : out Boolean; Index : out Positive ) is
      begin
         if 3 < Next_Index then
            Available := False;
            Index := Positive'Last;
         else
            Available := True;
            Index := Next_Index;
            Next_Index := Next_Index + 1;
         end if;
      end Get_Blueprint;
      
      procedure Update_Results ( Index : in Positive; Geodes : in Natural ) is
      begin
         Put_Line( "Blueprint #" & Index'Image & " gets " & Geodes'Image & " geodes" );
         Geodes_Mul := Geodes_Mul * Long_Long_Integer(Geodes);
      end Update_Results;
      
      function Final_Result return Long_Long_Integer is (Geodes_Mul);
   end Coordinator;
   
   task body Runner is
   begin
      loop
         declare
            Blp_Available : Boolean;
            Blp_Index : Positive;
         begin
            Coordinator.Get_Blueprint( Blp_Available, Blp_Index ); --out, out
            if Blp_Available then
               Coordinator.Update_Results( Blp_Index, Get_Max_Geodes( All_Blp(Blp_Index), 32 ) );
            else
               exit;
            end if;
         end;
      end loop;
   end Runner;
   
end Part2Runners;
