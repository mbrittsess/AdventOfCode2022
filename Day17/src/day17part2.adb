with Field; use Field;
with Jets;
with Ada.Text_IO; use Ada.Text_IO;

procedure Day17Part2 is
   Trillion : constant := 1e12;
   
   procedure Do_Cycle is
   begin
      for I in 1 .. 1 loop
         Place_Rock;
      end loop;
      declare
         Start_Idx : Natural := Jets.Get_Cur_Index;
      begin
         Place_Rock;
         while Start_Idx < Jets.Get_Cur_Index loop
            Place_Rock;
         end loop;
      end;
   end Do_Cycle;
begin
   Do_Cycle;
   declare
      Height_Base : Long_Long_Integer := Long_Long_Integer( Highest_Level );
      Rocks_Base : Long_Long_Integer := Long_Long_Integer( Get_Num_Rocks_Spawned );
   begin
      Do_Cycle;
      declare
         Height_Delta : Long_Long_Integer := Long_Long_Integer( Highest_Level ) - Height_Base;
         Rocks_Delta : Long_Long_Integer := Long_Long_Integer( Get_Num_Rocks_Spawned ) - Rocks_Base;
         Addl_Cycles : Long_Long_Integer := ((Trillion-Rocks_Base)/Rocks_Delta)-1;
         Addl_Height : Long_Long_Integer := Addl_Cycles*Height_Delta;
         Addl_Rocks : Long_Long_Integer := Addl_Cycles*Rocks_Delta;
      begin
         while (Long_Long_Integer(Get_Num_Rocks_Spawned)+Addl_Rocks) < Trillion loop
            Place_Rock;
         end loop;
         Put_Line( Long_Long_Integer'Image( Long_Long_Integer(Highest_Level) + Addl_Height ) );
      end;
   end;
end Day17Part2;
