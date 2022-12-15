with Ada.Text_IO; use Ada.Text_IO;

package body Packets is
   function Read_Pair return Pair is
      Init_Line : String := Get_Line;
      Line1 : String := (if Init_Line = "" then Get_Line else Init_Line);
      Line2 : String := Get_Line;
      Part1 : Data_Elements.Data_Element_Access := Data_Elements.New_Data( Line1 );
      Part2 : Data_Elements.Data_Element_Access := Data_Elements.New_Data( Line2 );
   begin
      return ( Part1, Part2 );
   end Read_Pair;
   
   function Read_All ( Accum : Pair_Sequence ) return Pair_Sequence is
   begin
      if End_Of_File then
         return Accum;
      else
         return Read_All( Accum & Read_Pair );
      end if;
   end Read_All;
   
   function Read_All return Pair_Sequence is
      Start : Pair_Sequence( 1 .. 1 ) := ( 1 => Read_Pair );
   begin
      return Read_All( Start );
   end Read_All;
   
   All_Packets_Var : Pair_Sequence := Read_All;
   
   function All_Packets return Pair_Sequence is (All_Packets_Var);
   
begin
   null;
end Packets;
