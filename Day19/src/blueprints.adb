with Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Strings;

package body Blueprints is
   
   function "&" ( L : Blueprint_Sequence; R : Blueprint ) return Blueprint_Sequence is
   begin
      return Ret : Blueprint_Sequence( 1 .. L'Length+1 ) do
         Ret( 1 .. Ret'Last-1 ) := L;
         Ret( Ret'Last ) := R;
      end return;
   end "&";

   function Read_Blueprint return Blueprint is
      use Ada.Text_IO;
      use Ada.Strings.Fixed;
      use Ada.Strings.Maps;
      use Ada.Strings;
      
      Digit_Set : Character_Set := To_Set( Character_Range'( Low => '0', High => '9' ) );
      Numbers : array ( 1 .. 7 ) of Positive;
      Line : String := Get_Line;
      Next_Token_Start : Positive := 1;
   begin
      for I in Numbers'Range loop
         declare
            First, Last : Positive;
         begin
            Find_Token( Line, Digit_Set, Next_Token_Start, Inside, First, Last ); --in, in, in, in, out, out
              Numbers(I) := Integer'Value( Line( First .. Last ) );
            Next_Token_Start := Last+1;
         end;
      end loop;
      return
        (
         Ore => ( Ore => Numbers(2), others => 0 ),
         Clay => ( Ore => Numbers(3), others => 0 ),
         Obsidian => ( Ore => Numbers(4), Clay => Numbers(5), others => 0 ),
         Geode => ( Ore => Numbers(6), Obsidian => Numbers(7), others => 0 )
        );
   end Read_Blueprint;
   
   function Read_All_Blueprints return Blueprint_Sequence is
      function Recurse ( Accum : Blueprint_Sequence ) return Blueprint_Sequence is
         use Ada.Text_IO;
      begin
         if End_Of_File then
            return Accum;
         else
            return Recurse( Accum & Read_Blueprint );
         end if;
      end Recurse;
      Start : Blueprint_Sequence( 1 .. 0 );
   begin
      return Recurse( Start );
   end Read_All_Blueprints;
   
   All_Blueprints : Blueprint_Sequence := Read_All_Blueprints;
   
   function Blueprints return Blueprint_Sequence is (All_Blueprints);

end Blueprints;
