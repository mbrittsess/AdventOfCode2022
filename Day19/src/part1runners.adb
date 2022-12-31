with Blueprints; use Blueprints;
with Simulations; use Simulations;
with Ada.Text_IO; use Ada.Text_IO;

package body Part1Runners is
   
   All_Blp : Blueprint_Sequence := Blueprints.Blueprints;

   protected body Coordinator is
      procedure Get_Blueprint ( Available : out Boolean; Index : out Positive ) is
      begin
         if All_Blp'Length < Next_Index then
            Available := False;
            Index := Positive'Last;
         else
            Available := True;
            Index := Next_Index;
            Next_Index := Next_Index + 1;
         end if;
      end Get_Blueprint;
      
      procedure Update_Results ( Index : in Positive; Geodes : in Natural ) is
         Quality : Natural := Index * Geodes;
      begin
         Put_Line( "Blueprint #" & Index'Image & " gets " & Geodes'Image & " geodes, for quality of " & Quality'Image );
         Total_Quality := Total_Quality + Quality;
      end Update_Results;
      
      function Final_Result return Natural is (Total_Quality);
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
               Coordinator.Update_Results( Blp_Index, Get_Max_Geodes( All_Blp(Blp_Index), 24 ) );
            else
               exit;
            end if;
         end;
      end loop;
   end Runner;
   
end Part1Runners;
